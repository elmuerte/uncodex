{-----------------------------------------------------------------------------
 Unit Name: unit_rtfhilight
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   UScript to RTF
 $Id: unit_rtfhilight.pas,v 1.14 2003-11-04 19:35:27 elmuerte Exp $
-----------------------------------------------------------------------------}
{
    UnCodeX - UnrealScript source browser & documenter
    Copyright (C) 2003  Michiel Hendriks

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit unit_rtfhilight;

interface

uses
  Classes, Graphics, SysUtils, unit_uclasses, Hashes;

  procedure RTFHilightUScript(input, output: TStream; uclass: TUClass);

var
  cf1,cf2,cf3,cf4,cf5,cf6: TColor;
  textfont: TFont;
  tabs: integer;
  ClassesHash: TStringHash;

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
        replacement := p.TokenString;
        replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
        replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
        replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
        replacement := '{\cf1'+replacement+'}'; // cf1 = string
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
        end
        else if (ClassesHash.Exists(tmp)) then begin
          replacement := '{\protected\cf5 '+replacement+'}'; // cf5
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
  ClassesHash := TStringHash.Create;
finalization
  ClassesHash.Clear;
  textfont.Free;
end.
