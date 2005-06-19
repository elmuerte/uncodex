{*******************************************************************************
  Name:
    unit_preprocessor
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Main code for the preprocessor

  $Id: unit_preprocessor.pas,v 1.8 2005-06-19 22:07:54 elmuerte Exp $
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
  Classes, SysUtils, unit_definitionlist, unit_sourceparser;

  procedure PreProcessFile(filename: string);
  procedure PreProcessDirectory(dir: string);
  procedure LoadConfiguration();

  // protected functions
  procedure _ppMacro(p: TSourceParser);
  function _reparseFuncDef(input: string): string;
  procedure _ppIdentifier(p: TSourceParser);
  procedure internalPP(p: TSourceParser);

// config stuff
var
  cfgBase: string;
  cfgMod: string;
  cfgFile: string;
  BaseDefs: TDefinitionList;
  supportIf: boolean = true;
  supportDefine: boolean = true;
  supportPreDefine: boolean = true;

const
  UCPP_VERSION = '006';
  UCPP_HOMEPAGE = 'http://wiki.beyondunreal.com/wiki/UCPP';
  UCPP_COPYRIGHT = 'Copyright (C) 2005 Michiel Hendriks';

implementation

uses unit_pputils, unit_ucxinifiles;

var
  ucfile, pucfile: string;
  globalP: TSourceParser;
  CurDefs: TDefinitionList;

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

  // removes comments from the macro line; not always used
  procedure StripComment;
  var
    i: integer;
  begin
    i := pos('//', args);
    if (i > 0) then Delete(args, i, Length(args));
    i := pos('/*', args);
    if (i > 0) then Delete(args, i, Length(args));
  end;

var
  hadNewLine, evalval: boolean;
begin
  hadNewLine := true;
  args := trim(p.TokenString);
  cmd := GetToken(args, ' ');
  DebugMessage('Macro "'+cmd+'" @ '+IntToStr(p.SourceLine-1));
  if (SameText(cmd, '#if') and supportIf) then begin
    CommentMacro;
    StripComment;
    if (macroIfCnt > 0) then Inc(macroIfCnt);
    begin
      try
        evalval := CurDefs.Eval(args);
        DebugMessage('Eval('+args+') = '+BoolToStr(evalval, true));
      except
        on e:Exception do begin
          ErrorMessage(pucfile+' #'+IntToStr(p.SourceLine-1)+': evaluation error of "'+args+'" (defaulting to false): '+e.Message);
          evalval := false;
        end;
      end;
      if (not evalval) then begin
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
  else if ((SameText(cmd, '#ifdef') or (SameText(cmd, '#ifndef'))) and supportIf) then begin
    CommentMacro;
    StripComment;
    if (macroIfCnt > 0) then Inc(macroIfCnt)
    else begin
      evalval := SameText(cmd, '#ifdef');
      if (CurDefs.IsRealDefined(args) <> evalval) then begin
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
    CommentMacro;  // don't strip comment, everything is included
    if (macroIfCnt = 0) then begin
      cmd := GetToken(args, ' ');
      CurDefs.define(cmd, args);
      DebugMessage(cmd+' = '+args);
    end;
    exit;
  end
  else if (SameText(cmd, '#undef') and supportDefine) then begin
    CommentMacro;
    StripComment;
    if (macroIfCnt = 0) then begin
      cmd := GetToken(args, ' ');
      CurDefs.undefine(cmd);
      DebugMessage('Undefined '+cmd);
    end;
    exit;
  end
  // UsUnit support macro - should become a CHECK(expr,msg), CHECK(expr)
  {else if (SameText(cmd, '#check')) then begin
    // for macro's the line is always one more than actual
    rep := 'check( '+args+', "'+StringReplace(args, '"', '\"', [rfReplaceAll])+'"$chr(3)$"'+ucfile+':'+IntToStr(p.SourceLine-1)+'");'+NL;
    p.OutputString(rep);
    p.SkipToken(true);
    exit;
  end}


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

// reparse the result of a function define
function _reparseFuncDef(input: string): string;
var
  sin: TStringStream;
  sou: TStringStream;
  sp: TSourceParser;
begin
  sin := TStringStream.Create(input);
  sou := TStringStream.Create('');
  sp := TSourceParser.Create(sin, sou);
  try
    internalPP(sp);
    result := sou.DataString;
  finally
    sin.Free;
    sou.Free;
  end;
end;

procedure _ppIdentifier(p: TSourceParser);

  // used by define function parsing to match brackets
  procedure _pBrackets(p: TSourceParser);
  var
    bcount: integer;
  begin
    bcount := 0;
    if (p.Token = '(') then begin
      Inc(bcount);
      p.SkipToken(false);
      while ((bcount > 0) and (p.Token <> toEOF)) do begin
        case (p.Token) of
          '(': Inc(bcount);
          ')': Dec(bcount);
        end;
        if (bcount = 0) then exit;
        p.SkipToken(false);
      end;
    end;
  end;

var
  tstr: string;
  repl: string;
  hasrepl: boolean;
  args: array of string;
begin
  tstr := p.TokenString;
  hasrepl := false;
  SetLength(args, 0);
  if (UpperCase(tstr) = tstr) then begin
    // first check internal consts
    if (supportPreDefine) then begin
      if (SameText(tstr, '__FILE__')) then begin
        repl := '"'+ucfile+'"';
        hasrepl := true;
      end
      else if (SameText(tstr, '__BASE_FILE__')) then begin
        repl := '"'+ExtractFileName(ucfile)+'"';
        hasrepl := true;
      end
      else if (SameText(tstr, '__CLASS__')) then begin
        repl := ChangeFileExt(ExtractFileName(ucfile), '');
        hasrepl := true;
      end
      else if (SameText(tstr, '__LINE__')) then begin
        repl := IntToStr(globalP.SourceLine);
        hasrepl := true;
      end
      else if (SameText(tstr, '__DATE__')) then begin
        repl := '"'+FormatDateTime('dddddd', now())+'"';
        hasrepl := true;
      end
      else if (SameText(tstr, '__TIME__')) then begin
        repl := '"'+FormatDateTime('tt', now())+'"';
        hasrepl := true;
      end
    end;
    // check declaration list
    if (not hasrepl) then begin
      p.PushState;
      p.SkipToken(false);
      if (p.Token = '(') then begin
        p.FullCopy := true;
        p.GetCopyData(true);
        p.SkipToken(false);
        while (p.Token <> ')') do begin
          if (p.Token = ',') then begin
            SetLength(args, High(args)+2);
            repl := p.GetCopyData(true);
            Delete(repl, Length(repl), MaxInt);
            args[High(args)] := trim(repl); // get buffer
          end;
          _pBrackets(p);
          p.SkipToken(false);
        end;
        p.FullCopy := false;
        SetLength(args, High(args)+2);
        repl := p.GetCopyData(true);
        Delete(repl, Length(repl), MaxInt);
        args[High(args)] := trim(repl); // get buffer
        repl := '';
        if (CurDefs.IsRealDefined(tstr+'/'+IntToStr(High(args)+1))) then begin
          repl := _reparseFuncDef(CurDefs.CallDefine(tstr, args));
          tstr := tstr+'/'+IntToStr(High(args)+1); // for nicer debug output
          hasrepl := true;
          p.DiscardState;
        end
        else begin
          p.PopState;
        end;
      end
      else begin
        p.PopState;
      end;
    end;

    if ((not hasrepl) and CurDefs.IsRealDefined(tstr)) then begin
      repl := CurDefs.GetDefine(tstr);
      hasrepl := true;
    end;

    if (hasrepl) then begin
      DebugMessage('Replaced '+tstr+' with: '+repl);
      p.OutputString(repl);
      p.SkipToken(true);
      exit;
    end;
  end;
  p.CopyTokenToOutput;
  p.SkipToken(true);
end;

// main processing function
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

// parse a definition entry
procedure ParseDef(def: TDefinitionEntry);
var
  p: TSourceParser;
  ss, dummy: TStringStream;
  sl: TStringList;
  i,n: integer;
  act: TArgumentAction;
begin
  ss := TStringStream.Create(def.Value);
  dummy := TStringstream.Create('');
  p := TSourceParser.Create(ss, dummy);
  sl := TStringList.Create;
  try
    p.DoMacro := false;
    for i := 0 to def.ArgCount-1 do begin
      sl.Add(def.ArgList[i]);
    end;
    while (p.Token <> toEof) do begin
      act := aaNone;
      i := p.LinePos-Length(p.TokenString);
      if (p.Token = '#') then begin
        act := aaQuote;
        p.SkipToken(false);
        if (p.Token = '#') then begin
          act := aaConcat;
          p.SkipToken(false);
        end;
      end;
      if (p.Token = toSymbol) then begin
        n := sl.IndexOf(p.TokenString);
        if (n > -1) then begin
          if (act <> aaNone) then begin
            if (act = aaConcat) then p.SkipToken(false);
            def.AddOffset(n, i, p.LinePos-i, act);
            if (act = aaQuote) then p.SkipToken(false);
            continue;
          end
          else def.AddOffset(n, i);
        end;
      end;
      p.SkipToken(false);
    end;
  finally
    sl.Free;
    ss.Free;
    dummy.Free;
  end;
end;

procedure PreProcessFile(filename: string);
var
  fsin, fsout: TFileStream;
begin
  CurDefs := TDefinitionList.Create(BaseDefs);
  CurDefs.OnParseDefinition := ParseDef;
  if (not SameText(ExtractFileExt(filename), '.puc')) then begin
    ErrorMessage('The .puc extention is required.');
  end;
  try
    fsin := TFileStream.Create(filename, fmOpenRead	or fmShareDenyWrite);
  except
    ErrorMessage('Could not open file "'+filename+'" for reading.');
    exit;
  end;
  pucfile := filename;
  ucfile := ChangeFileExt(filename, '.uc');
  try
    try
      fsout := TFileStream.Create(ucfile, fmCreate or fmShareExclusive);
    except
      ErrorMessage('Could not open file "'+ucfile+'" for writing.');
      exit;
    end;
    globalP := TSourceParser.Create(fsin, fsout);
    globalP.ProcessMacro := _ppMacro;
    globalP.MacroCallBack := true;
    Writeln('Processing "'+pucfile+'" -> "'+ucfile+'"');
    internalPP(globalP);
  finally;
    FreeandNil(globalP);
    FreeAndNil(fsout);
    FreeAndNil(fsin);
    FreeAndNil(CurDefs);
  end;
end;

procedure PreProcessDirectory(dir: string);
var
  sr: TSearchRec;
begin
  dir := cfgBase+PathDelim+dir+PathDelim+'Classes'+PathDelim;
  {$IFNDEF FPC}{$WARN SYMBOL_PLATFORM OFF}{$ENDIF}
  if FindFirst(dir+'*.puc', faAnyFile - faDirectory - faVolumeID, sr) = 0 then begin
  {$IFNDEF FPC}{$WARN SYMBOL_PLATFORM ON}{$ENDIF}
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
      if (not BaseDefs.IsRealDefined(sl[i])) then
        BaseDefs.define(sl[i], ini.ReadString('Defines', sl[i], ''));
    end;
  finally
    sl.Free;
    ini.Free;
  end;
end;

initialization
  BaseDefs := TDefinitionList.Create(nil);
  BaseDefs.OnParseDefinition := ParseDef;
  if (not FindCmdLineSwitch('undef', ['-'], false)) then begin
    BaseDefs.define('UCPP_VERSION', UCPP_VERSION);
    BaseDefs.define('UCPP_HOMEPAGE', '"'+UCPP_HOMEPAGE+'"');
  end
  else supportPreDefine := false;
finalization
  FreeAndNil(BaseDefs);
end.
