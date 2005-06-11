{*******************************************************************************
  Name:
    unit_preprocessor
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Main code for the preprocessor

  $Id: unit_preprocessor.pas,v 1.2 2005-06-11 10:40:24 elmuerte Exp $
*******************************************************************************}

{
  UCPP - UnrealScript Code PreProcessor
  Copyright (C) 2005  Michiel Hendriks
  
  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit unit_preprocessor;

{$I ../defines.inc}

interface

uses
  Classes, SysUtils, unit_uclasses;

  procedure PreProcessFile(filename: string);
  procedure PreProcessDirectory(dir: string);
  procedure LoadConfiguration();

// config stuff
var
  cfgBase: string;
  cfgMod: string;
  cfgFile: string;
  BaseClass: TUClass;
  supportIf: boolean = true;
  supportDefine: boolean = true;

const
  UCPP_VERSION = '004';
  UCPP_HOMEPAGE = 'http://wiki.beyondunreal.com/wiki/UCPP';
  UCPP_COPYRIGHT = 'Copyright (C) 2005 Michiel Hendriks';

implementation

uses unit_sourceparser, unit_pputils, unit_ucxinifiles;

var
  curfile: string;
  CurClass: TUClass;

const
  UCPP_COMMENT = '// ';
  NL: string = #13#10;

var
  macroIfCnt: integer = 0;

procedure _ppMacro(p: TSourceParser);
var
  cmd, args, rep: string;

  procedure CommentMacro();
  begin
    rep := UCPP_COMMENT+cmd+' '+args+NL;
    p.OutputString(rep);
    p.SkipToken(true);
  end;

var
  hadNewLine: boolean;
begin
  hadNewLine := true;
  args := trim(p.TokenString);
  cmd := GetToken(args, ' ');
  writeln('Macro "'+cmd+'" @ '+IntToStr(p.SourceLine-1));
  if (SameText(cmd, '#if') and supportIf) then begin
    CommentMacro;
    if (macroIfCnt > 0) then Inc(macroIfCnt);
    begin
      try
        if (not CurClass.defs.Eval(args)) then begin
          macroIfCnt := 1;
          while (macroIfCnt > 0) do begin
            if (hadNewLine) then begin
              p.OutputString(UCPP_COMMENT);
              hadNewLine := false;
            end;
            p.CopyTokenToOutput;
            if (p.Token = #10) then hadNewLine := true;
            p.SkipToken(true);
          end;
        end;
      except
        ErrorMessage('Unexpected EOF');
      end;
    end; // do eval
  end
  else if (SameText(cmd, '#ifdef') and supportIf) then begin
    CommentMacro;
    if (macroIfCnt > 0) then Inc(macroIfCnt)
    else begin
      if (not CurClass.defs.IsDefined(args)) then begin
        macroIfCnt := 1;
        while (macroIfCnt > 0) do begin
          if (hadNewLine) then begin
            p.OutputString(UCPP_COMMENT);
            hadNewLine := false;
          end;
          p.CopyTokenToOutput;
          if (p.Token = #10) then hadNewLine := true;
          p.SkipToken(true);
        end;
      end;
    end; // do eval
  end
  else if (SameText(cmd, '#else') and supportIf) then begin
    CommentMacro;
    // the else part of something we want
    if (macroIfCnt = 1) then Dec(macroIfCnt)
    // last IF was true, so ignore
    else if (macroIfCnt = 0) then begin
      macroIfCnt := 1;
      while (macroIfCnt > 0) do begin
        if (hadNewLine) then begin
          p.OutputString(UCPP_COMMENT);
          hadNewLine := false;
        end;
        p.CopyTokenToOutput;
        if (p.Token = #10) then hadNewLine := true;
        p.SkipToken(true);
      end;
    end;
    // else we don't care
  end
  else if (SameText(cmd, '#endif') and supportIf) then begin
    if (macroIfCnt > 0) then begin
      Dec(macroIfCnt);
    end;
    CommentMacro;
  end
  else if (SameText(cmd, '#define') and supportDefine) then begin
    CommentMacro;
    if (macroIfCnt = 0) then begin
      cmd := GetToken(args, ' ');
      CurClass.defs.define(cmd, args);
    end;
    exit;
  end
  {else if (SameText(cmd, '#undefine') and supportDefine) then begin
    CommentMacro;
    if (macroIfCnt = 0) then begin
      cmd := GetToken(args, ' ');
      CurClass.defs.define(cmd, args);
    end;
    exit;
  end}
  // UsUnit support macro - should become a CHECK(%1, %2)
  else if (SameText(cmd, '#check')) then begin
    // for macro's the line is always one more than actual
    rep := 'check( '+args+', "'+StringReplace(args, '"', '\"', [rfReplaceAll])+'"$chr(3)$"'+curfile+':'+IntToStr(p.SourceLine-1)+'");'+NL;
    p.OutputString(rep);
    p.SkipToken(true);
    exit;
  end


  // do this last
  else if (SameText(cmd, '#ucpp')) then begin
    cmd := GetToken(args, ' ');
    if (SameText(cmd, 'notice')) then begin
      p.OutputString('// NOTICE: This file was automatically generated by UCPP; do not edit this file manualy.'+NL);
      p.SkipToken(true);
      exit;
    end
    else if (SameText(cmd, 'version')) then begin
      p.OutputString('// UCPP Version '+UCPP_VERSION+'; '+UCPP_HOMEPAGE+NL);
      p.SkipToken(true);
      exit;
    end
    else if (SameText(cmd, 'include')) then begin
      // TODO: process include file for defines and stuff
      CommentMacro;
      exit;
    end;

    // unknown ucpp macro
    CommentMacro;
    exit;
  end;
  // not one of our macros
  p.CopyTokenToOutput;
  p.SkipToken(true);
end;

procedure _ppIdentifier(p: TSourceParser);
var
  tstr: string;
  repl: string;
begin
  tstr := p.TokenString;
  if (UpperCase(tstr) = tstr) then begin
    // first check internal consts
    if (SameText(tstr, '__FILE__')) then begin
      repl := '"'+curfile+'"';
    end
    else if (SameText(tstr, '__BASE_FILE__')) then begin
      repl := '"'+ExtractFileName(curfile)+'"';
    end
    else if (SameText(tstr, '__LINE__')) then begin
      repl := IntToStr(p.SourceLine);
    end
    // check declaration list
    else if (CurClass.defs.IsDefined(tstr)) then begin
      repl := CurClass.defs.GetDefine(tstr);
    end;

    if (repl <> '') then begin
      p.OutputString(repl);
      p.SkipToken(true);
      exit;
    end;
  end;
  p.CopyTokenToOutput;
  p.SkipToken(true);
end;

procedure internalPP(p: TSourceParser);
begin
  while (p.Token <> toEof) do begin
    if (p.Token = toSymbol) then begin
      _ppIdentifier(p);
    end
    else begin
      p.CopyTokenToOutput;
      p.SkipToken(true);
    end;
  end;
end;

procedure PreProcessFile(filename: string);
var
  parser: TSourceParser;
  fsin, fsout: TFileStream;
begin
  CurClass := TUClass.Create;
  CurClass.parent := BaseClass;
  if (not SameText(ExtractFileExt(filename), '.puc')) then begin
    ErrorMessage('The .puc extention is required.');
  end;
  try
    fsin := TFileStream.Create(filename, fmOpenRead	or fmShareDenyWrite);
  except
    ErrorMessage('Could not open file "'+filename+'" for reading.');
    exit;
  end;
  curfile := ChangeFileExt(filename, '.uc');
  try
    try
      fsout := TFileStream.Create(curfile, fmCreate or fmShareExclusive);
    except
      ErrorMessage('Could not open file "'+curfile+'" for writing.');
      exit;
    end;
    parser := TSourceParser.Create(fsin, fsout);
    parser.ProcessMacro := _ppMacro;
    parser.MacroCallBack := true;
    Writeln('Processing "'+filename+'" -> "'+curfile+'"');
    internalPP(parser);
  finally;
    FreeAndNil(fsout);
    FreeAndNil(fsin);
    FreeAndNil(CurClass);
  end;
end;

procedure PreProcessDirectory(dir: string);
var
  sr: TSearchRec;
begin
  dir := cfgBase+PathDelim+dir+PathDelim+'Classes'+PathDelim;
  {$WARN SYMBOL_PLATFORM OFF}
  if FindFirst(dir+'*.puc', faAnyFile - faDirectory	- faVolumeID, sr) = 0 then begin
  {$WARN SYMBOL_PLATFORM ON}
    repeat
      PreProcessFile(dir+sr.Name);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure LoadConfiguration();
var
  ini: TUCXIniFile;
  sl: TStringList;
  i: integer;
begin
  if (cfgFile = '') then cfgFile := ChangeFileExt(ParamStr(0), '.ini');
  ini := TUCXIniFile.Create(cfgFile);
  sl := TStringList.Create;
  try
    ini.ReadBool('Options', 'supportIf', supportIf);
    ini.ReadBool('Options', 'supportDefine', supportDefine);
    ini.ReadSection('Defines', sl);
    for i := 0 to sl.count-1 do begin
      // doesn't override commandline definitions
      if (not BaseClass.defs.IsDefined(sl[i])) then
        BaseClass.defs.define(sl[i], ini.ReadString('Defines', sl[i], ''));
    end;
  finally
    sl.Free;
    ini.Free;
  end;
end;

initialization
  BaseClass := TUClass.Create;
  BaseClass.defs.define('UCPP_VERSION', UCPP_VERSION);
  BaseClass.defs.define('UCPP_HOMEPAGE', '"'+UCPP_HOMEPAGE+'"');
finalization
  FreeAndNil(BaseClass);  
end.
