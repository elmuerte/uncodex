{-----------------------------------------------------------------------------
 Unit Name: unit_rtfhilight
 Author:    elmuerte
 Purpose:   UScript to RTF
 History:
-----------------------------------------------------------------------------}

unit unit_rtfhilight;

interface

uses
  Classes, Graphics, SysUtils, unit_uclasses;

  procedure RTFHilightUScript(input, output: TStream; uclass: TUClass);

var
  cf1,cf2,cf3,cf4,cf5,cf6: TColor;
  textfont: TFont;
  tabs: integer;

implementation

uses
  unit_sourceparser, unit_definitions;

const
  RTFHeader: string = '{\rtf1\ansi\ansicpg1252\deff0\deflang1033';

function ColorToRTF(col: TColor): string;
var
  L: longint;
begin
  L := ColorToRGB(col);
  result := '\blue'+IntToStr(L div 65536);
  result := result+'\green'+IntToStr((L mod 65536) div 256);
  result := result+'\red'+IntToStr((L mod 65536) mod 256);
  result := result+';'
end;

procedure RTFHilightUScript(input, output: TStream; uclass: TUClass);
var
  p: TSourceParser;
  replacement, tmp: string;
begin
  // must be absolute first to prevent reading the first char
  replacement := RTFHeader+
    '\deftab'+IntToStr(textfont.size*(15*tabs)-(30*tabs))+ 
    '{\fonttbl\f0\fmodren '+textfont.name+';}'+
    '{\colortbl;'+ColorToRTF(cf1)+ColorToRTF(cf2)+ColorToRTF(cf3)+ColorToRTF(cf4)+ColorToRTF(cf5)+ColorToRTF(cf6)+'}'+
    '{\f0\fs'+IntToStr(textfont.Size*2)+'\cf6 ';
  Output.WriteBuffer(PChar(replacement)^, Length(replacement));
  p := TSourceParser.Create(input, output);
  try
    while (p.Token <> toEOF) do begin
      if (p.Token = '{') then begin
        replacement := '\{';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = '}') then begin
        replacement := '\}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = '\') then begin
        replacement := '\\';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toString) then begin
        replacement := '{\cf1'+p.TokenString+'}'; // cf1 = string
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toComment) then begin
        replacement := p.TokenString;
        replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
        replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
        replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
        replacement := StringReplace(replacement, #10, '\par ', [rfReplaceAll]);
        replacement := '{\cf2 '+replacement+'}'; // cf2 = comment
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toMCommentBegin) then begin
        replacement := p.TokenString;
        replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
        replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
        replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
        replacement := StringReplace(replacement, #10, '\par ', [rfReplaceAll]);
        replacement := '{\cf2 '+replacement; // cf2 = comment
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
        while (p.Token <> toMCommentEnd) do begin
          p.SkipToken(true);
          replacement := p.TokenString;
          replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
          replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
          replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
          replacement := StringReplace(replacement, #10, '\par ', [rfReplaceAll]);
          p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
        end;
        replacement := '}'; // close it
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toInteger) then begin
        replacement := '{\cf1 '+p.TokenString+'}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toFloat) then begin
        replacement := '{\cf1 '+p.TokenString+'}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toName) then begin
        replacement := '{\cf4 '+p.TokenString+'}'; // cf4 = name
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toMacro) then begin
        replacement := p.TokenString;
        replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
        replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
        replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
        replacement := '{\cf3 '+replacement+'}\par '; // cf3 = macro
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toSymbol) then begin
        tmp := LowerCase(p.TokenString);
        replacement := p.TokenString;
        if (Keywords.Exists(tmp)) then begin
          replacement := '{\b '+replacement+'}'; // bold
        end;
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toEOL) then begin
        replacement := p.TokenString+'\par ';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else p.CopyTokenToOutput;
      p.SkipToken(true);
    end;
    replacement := '}{\info'+
      '{\author '+APPTITLE+' '+APPVERSION+'}';
    if (uclass <> nil) then replacement := replacement+'{\title '+uclass.package.name+'.'+uclass.name+'}';
    replacement := replacement+'}';
    if (uclass <> nil) then replacement := replacement+'{\header '+uclass.package.name+'.'+uclass.name+'}';
    replacement := replacement+
      '{\footer '+APPTITLE+' '+APPVERSION+'}'+
      '}';
    p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
  finally
    p.Free;
  end;
end;

initialization
  cf1 := $00FF0000;
  cf2 := $00339900;
  cf3 := $000000CC;
  cf4 := $00000066;
  cf5 := $00990000;
  cf6 := $00000000;
  textfont := TFont.Create;
  textfont.Name := 'Courier New';
  textfont.Size := 9;
  tabs := 4;
finalization
  Keywords.Clear;
  textfont.Free;
end.
