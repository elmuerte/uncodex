{-----------------------------------------------------------------------------
 Unit Name: unit_rtfhilight
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   UScript to RTF
 $Id: unit_rtfhilight.pas,v 1.19 2004-02-23 12:20:47 elmuerte Exp $
-----------------------------------------------------------------------------}
{
    UnCodeX - UnrealScript source browser & documenter
    Copyright (C) 2003, 2004  Michiel Hendriks

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
  procedure RTFHilightUPackage(output: TStream; package: TUPackage);

var
  textfont: TFont; // default font
  tabs: integer;
  ClassesHash: Hashes.TStringHash;
  // fonts
  fntKeyword1: TFont;
  fntKeyword2: TFont;
  fntString: TFont;
  fntNumber: TFont;
  fntMacro: TFont;
  fntComment: TFont;
  fntName: TFont;
  fntClassLink: TFont;

implementation

uses
  unit_sourceparser, unit_definitions;

const
  RTFHeader: string = '{\rtf1\ansi\ansicpg1252\deff0\deflang1033';

var
  colorTable: string;
  ctEntries: integer;
  rfKeyword1: string;
  rfKeyword2: string;
  rfString: string;
  rfNumber: string;
  rfMacro: string;
  rfComment: string;
  rfName: string;
  rfClassLink: string;

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

function CreateRTFFontString(fnt: TFont): string;
begin
  ctEntries := ctEntries+1;
  colorTable := colorTable+ColorToRTF(fnt.Color);
  result := '{\cf'+IntToStr(ctEntries);
  if (fsBold in fnt.Style) then result := result+'\b';
  if (fsUnderline in fnt.Style) then result := result+'\ul';
  if (fsStrikeout in fnt.Style) then result := result+'\strike';
  if (fsItalic in fnt.Style) then result := result+'\i';
  result := result+' ';
end;

procedure RTFHilightUScript(input, output: TStream; uclass: TUClass);
var
  p: TSourceParser;
  replacement, tmp: string;
begin
  // create font strings
  colorTable  := '{\colortbl;'+ColorToRTF(textfont.Color);
  ctEntries   := 1;
  rfKeyword1  := CreateRTFFontString(fntKeyword1);
  rfKeyword2  := CreateRTFFontString(fntKeyword2);
  rfString    := CreateRTFFontString(fntString);
  rfNumber    := CreateRTFFontString(fntNumber);
  rfMacro     := CreateRTFFontString(fntMacro);
  rfComment   := CreateRTFFontString(fntComment);
  rfName      := CreateRTFFontString(fntName);
  rfClassLink := CreateRTFFontString(fntClassLink);
  colorTable  := colorTable+'}';
  // must be absolute first to prevent reading the first char
  replacement := RTFHeader+
    '\deftab'+IntToStr(textfont.size*(15*tabs)-(30*tabs))+ // set tab size
    '{\fonttbl\f0\fmodren '+textfont.name+';}'+ // set default font
    colorTable+ // add color table
    '{\f0\fs'+IntToStr(textfont.Size*2)+'\cf1 '; // set default fontsize/color
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
        replacement := rfString+replacement+'}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toComment) then begin
        replacement := p.TokenString;
        replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
        replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
        replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
        replacement := StringReplace(replacement, #10, '\par ', [rfReplaceAll]);
        replacement := rfComment+replacement+'}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toMCommentBegin) then begin
        replacement := p.TokenString;
        replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
        replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
        replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
        replacement := StringReplace(replacement, #10, '\par ', [rfReplaceAll]);
        replacement := rfComment+replacement;
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
        replacement := rfNumber+p.TokenString+'}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toFloat) then begin
        replacement := rfNumber+p.TokenString+'}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toName) then begin
        replacement := rfName+p.TokenString+'}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toMacro) then begin
        replacement := p.TokenString;
        replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
        replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
        replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
        replacement := rfMacro+replacement+'}\par ';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toSymbol) then begin
        tmp := LowerCase(p.TokenString);
        replacement := p.TokenString;
        if (Keywords1.Exists(tmp)) then begin
          replacement := rfKeyword1+replacement+'}';
        end
        else if (Keywords2.Exists(tmp)) then begin
          replacement := rfKeyword2+replacement+'}';
        end
        else if (ClassesHash.Exists(tmp)) then begin
          replacement := '{\protected'+rfClassLink+replacement+'}}';
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

procedure RTFHilightUPackage(output: TStream; package: TUPackage);
var
  replacement: string;
  i: integer;
begin
  // create font strings
  colorTable  := '{\colortbl;'+ColorToRTF(textfont.Color);
  ctEntries   := 1;
  rfKeyword1  := CreateRTFFontString(fntKeyword1);
  rfKeyword2  := CreateRTFFontString(fntKeyword2);
  rfString    := CreateRTFFontString(fntString);
  rfNumber    := CreateRTFFontString(fntNumber);
  rfMacro     := CreateRTFFontString(fntMacro);
  rfComment   := CreateRTFFontString(fntComment);
  rfName      := CreateRTFFontString(fntName);
  rfClassLink := CreateRTFFontString(fntClassLink);
  colorTable  := colorTable+'}';
  // must be absolute first to prevent reading the first char
  replacement := RTFHeader+
    '\deftab'+IntToStr(textfont.size*(15*tabs)-(30*tabs))+ // set tab size
    '{\fonttbl\f0\fswiss Arial;}'+ // set default font
    colorTable+ // add color table
    '{\f0\fs18\cf1 '; // set default fontsize/color
  Output.WriteBuffer(PChar(replacement)^, Length(replacement));

	replacement := '{\ul\fs24\b '+package.name+'}';
  Output.WriteBuffer(PChar(replacement)^, Length(replacement));

  replacement := '\par '+package.comment;
  Output.WriteBuffer(PChar(replacement)^, Length(replacement));
  replacement := '\par\par {\ul\b Classes:}\par';
	Output.WriteBuffer(PChar(replacement)^, Length(replacement));
	replacement := '';
  package.classes.Sort;
  for i := 0 to package.classes.Count-1 do begin
    if (replacement <> '') then replacement := replacement + ', ';
    replacement := replacement+'{\protected'+rfClassLink+package.classes[i].name+'}}';
  end;
  Output.WriteBuffer(PChar(replacement)^, Length(replacement));

  replacement := '}{\info'+
      '{\author '+APPTITLE+' '+APPVERSION+'}';
  if (package <> nil) then replacement := replacement+'{\title '+package.name+'}';
  replacement := replacement+'}';
  if (package <> nil) then replacement := replacement+'{\header '+package.name+'}';
  replacement := replacement+
    '{\footer '+APPTITLE+' '+APPVERSION+'}'+
    '}';
  Output.WriteBuffer(PChar(replacement)^, Length(replacement));
end;

initialization
  textfont := TFont.Create;
  textfont.Name := 'Courier New';
  textfont.Size := 9;
  textfont.Color := $00000000;
  tabs := 4;
  // create fonts
  fntKeyword1 := TFont.Create;
  fntKeyword1.Color := $00000000;
  fntKeyword1.Style := [fsBold];
  fntKeyword2 := TFont.Create;
  fntKeyword2.Color := $00555555;
  fntKeyword2.Style := [fsBold];
  fntString := TFont.Create;
  fntString.Color := $00FF0000;
  fntString.Style := [];
  fntNumber := TFont.Create;
  fntNumber.Color := $00FF0000;
  fntNumber.Style := [];
  fntMacro := TFont.Create;
  fntMacro.Color := $000000CC;
  fntMacro.Style := [];
  fntComment := TFont.Create;
  fntComment.Color := $00339900;
  fntComment.Style := [fsItalic];
  fntName := TFont.Create;
  fntName.Color := $00000066;
  fntName.Style := [];
  fntClassLink := TFont.Create;
  fntClassLink.Color := $00990000;
  fntClassLink.Style := [fsUnderline];
  ClassesHash := TStringHash.Create;
finalization
  ClassesHash.Clear;
  textfont.Free;
  fntKeyword1.Free;
  fntKeyword2.Free;
  fntString.Free;
  fntNumber.Free;
  fntMacro.Free;
  fntComment.Free;
  fntName.Free;
  fntClassLink.Free;
end.
