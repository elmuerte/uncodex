{*******************************************************************************
  Name:
    unit_preprocessor
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Main code for the preprocessor

  $Id: unit_preprocessor.pas,v 1.18 2005-08-02 09:45:51 elmuerte Exp $
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

type
  EEOF = class(Exception);

  procedure PreProcessFile(filename: string);
  procedure PreProcessIncludeFile(filename: string; const global: boolean = false);
  procedure PreProcessDirectory(dir: string);
  procedure LoadConfiguration();

  // protected functions
  procedure _ppMacro(p: TSourceParser);
  function _reparseFuncDef(input: string): string;
  procedure _ppIdentifier(p: TSourceParser);
  procedure internalPP(p: TSourceParser);
  function _ExternalDefine(token: string; var output: string): boolean;

const
  UCPP_VERSION        = '102';
  UCPP_VERSION_PRINT  = '1.2';
  UCPP_HOMEPAGE       = 'http://wiki.beyondunreal.com/wiki/UCPP';
  UCPP_COPYRIGHT      = 'Copyright (C) 2005 Michiel Hendriks';
  UCPP_STRIP_MSG      = '// UCPP: code stripped';

// config stuff
var
  cfgBase: string;
  cfgMod: string;
  cfgFile: string;
  cfgStripMessage: string = UCPP_STRIP_MSG;
  BaseDefs: TDefinitionList;
  supportIf: boolean = true;
  supportDefine: boolean = true;
  supportPreDefine: boolean = true;
  stripCode: boolean = false;
  includeFiles: TStringList;
  verbosity: integer = 1;

implementation

uses unit_pputils, unit_ucxinifiles;

resourcestring
  END_OF_FILE_EXCEPTION_IF = 'Unexpected end of file. Missing #endif.';
  END_OF_FILE_EXCEPTION = 'Unexpected end of file.';

var
  ucfile, pucfile: string;
  globalP: TSourceParser;
  CurDefs: TDefinitionList;
  stackDepth: integer;
  filestack: TStringList; 

const
  UCPP_COMMENT = '// ';
  NL: string = #13#10;

var
  macroIfCnt: integer = 0;
  macroLastIf: boolean = false;

var
  hadNewLine: boolean;

// note: when a macro has been processed, exit from the function
procedure _ppMacro(p: TSourceParser);
var
  orig: string;
  cmd, args, rep: string;

  procedure CommentMacro();
  begin
    if (stripCode) then rep := cfgStripMessage+NL
    else rep := UCPP_COMMENT+orig+NL;
    p.OutputString(rep);
    p.SkipToken(not stripCode);
    if (hadNewLine and (macroIfCnt > 0)) then begin
      if (stripCode) then p.OutputString(cfgStripMessage+NL)
      else p.OutputString(UCPP_COMMENT);
      hadNewLine := (p.Token = toEOL) or (p.token = toComment);
    end;
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

begin
  hadNewLine := true;
  orig := trim(p.TokenString);
  args := orig;
  cmd := GetToken(args, [' ', #9]);
  DebugMessage('Macro "'+cmd+'" @ '+IntToStr(p.SourceLine-1));
  if (SameText(cmd, '#if') and supportIf) then begin
    StripComment;
    if (macroIfCnt > 0) then begin
      CommentMacro;
      Inc(macroIfCnt);
    end
    else begin
      try
        macroLastIf := CurDefs.Eval(args);
        DebugMessage('Eval('+args+') = '+BoolToStr(macroLastIf, true));
      except
        on e:Exception do begin
          WarningMessage(Format('%s(%d) : evaluation error of "%s"  (defaulting to false): %s', [filestack[0], p.SourceLine-1, args, e.Message]));
          macroLastIf := false;
        end;
      end;
      if (not macroLastIf) then begin
        macroIfCnt := 1;
        CommentMacro;
        while (macroIfCnt > 0) do begin
          if (p.Token = toEOF) then raise EEOF.Create(END_OF_FILE_EXCEPTION_IF);
          if (hadNewLine) then begin
            if (stripCode) then p.OutputString(cfgStripMessage+NL)
            else p.OutputString(UCPP_COMMENT);
            hadNewLine := false;
          end;
          if (not stripCode) then p.CopyTokenToOutput;
          hadNewLine := (p.Token = toEOL) or (p.token = toComment);
          p.SkipToken(not stripCode);
        end;
      end
      else CommentMacro;
    end; // do eval
    exit;
  end
  else if ((SameText(cmd, '#ifdef') or (SameText(cmd, '#ifndef'))) and supportIf) then begin
    StripComment;
    if (macroIfCnt > 0) then begin
      Inc(macroIfCnt);
      CommentMacro;
    end
    else begin
      macroLastIf := SameText(cmd, '#ifdef');
      if (CurDefs.IsRealDefined(args) <> macroLastIf) then begin
        macroLastIf := false;
        macroIfCnt := 1;
        CommentMacro;
        while (macroIfCnt > 0) do begin
          if (p.Token = toEOF) then raise EEOF.Create(END_OF_FILE_EXCEPTION_IF);
          if (hadNewLine) then begin
            if (stripCode) then p.OutputString(cfgStripMessage+NL)
            else p.OutputString(UCPP_COMMENT);
            hadNewLine := false;
          end;
          if (not stripCode) then p.CopyTokenToOutput;
          hadNewLine := (p.Token = toEOL) or (p.token = toComment);
          p.SkipToken(true);
        end;
      end
      else begin
        CommentMacro;
        macroLastIf := true;
      end;
    end;
    exit;
  end
  else if (SameText(cmd, '#elif') and supportIf) then begin
    // the else part of something we want
    if ((macroIfCnt = 1) and not macroLastIf) then begin
      macroIfCnt := 0;
      try
        macroLastIf := CurDefs.Eval(args);
        DebugMessage('Eval('+args+') = '+BoolToStr(macroLastIf, true));
      except
        on e:Exception do begin
          WarningMessage(Format('%s(%d) : evaluation error of "%s"  (defaulting to false): %s', [filestack[0], p.SourceLine-1, args, e.Message]));
          macroLastIf := false;
        end;
      end;
      if (not macroLastIf) then begin
        macroIfCnt := 1;
        CommentMacro;
        while (macroIfCnt > 0) do begin
          if (p.Token = toEOF) then raise EEOF.Create(END_OF_FILE_EXCEPTION_IF);
          if (hadNewLine) then begin
            if (stripCode) then p.OutputString(cfgStripMessage+NL)
            else p.OutputString(UCPP_COMMENT);
            hadNewLine := false;
          end;
          if (not stripCode) then p.CopyTokenToOutput;
          hadNewLine := (p.Token = toEOL) or (p.token = toComment);
          p.SkipToken(not stripCode);
        end;
      end
      else CommentMacro;
    end
    // last IF was true, so ignore
    else if (macroLastIf) then begin
      macroIfCnt := 1;
      CommentMacro;
      while (macroIfCnt > 0) do begin
        if (p.Token = toEOF) then raise EEOF.Create(END_OF_FILE_EXCEPTION_IF);
        if (hadNewLine) then begin
          if (stripCode) then p.OutputString(cfgStripMessage+NL)
          else p.OutputString(UCPP_COMMENT);
          hadNewLine := false;
        end;
        if (not stripCode) then p.CopyTokenToOutput;
        hadNewLine := (p.Token = toEOL) or (p.token = toComment);
        p.SkipToken(true);
      end;
    end
    else begin
      if (macroIfCnt > 1) then Inc(macroIfCnt);
      CommentMacro;
    end;
    // else we don't care
    exit;
  end
  else if (SameText(cmd, '#else') and supportIf) then begin
    // the else part of something we want
    if ((macroIfCnt = 1) and not macroLastIf) then begin
      Dec(macroIfCnt);
      CommentMacro;
    end
    // last IF was true, so ignore
    else if (macroLastIf) then begin
      macroIfCnt := 1;
      CommentMacro;
      while (macroIfCnt > 0) do begin
        if (p.Token = toEOF) then raise EEOF.Create(END_OF_FILE_EXCEPTION_IF);
        if (hadNewLine) then begin
          if (stripCode) then p.OutputString(cfgStripMessage+NL)
          else p.OutputString(UCPP_COMMENT);
          hadNewLine := false;
        end;
        if (not stripCode) then p.CopyTokenToOutput;
        hadNewLine := (p.Token = toEOL) or (p.token = toComment);
        p.SkipToken(true);
      end;
    end
    else CommentMacro;
    // else we don't care
    exit;
  end
  else if (SameText(cmd, '#endif') and supportIf) then begin
    if (macroIfCnt > 0) then begin
      Dec(macroIfCnt);
    end;
    CommentMacro;
    exit;
  end
  else if (SameText(cmd, '#define') and supportDefine) then begin
    if (macroIfCnt = 0) then begin
      CommentMacro;  // don't strip comment, everything is included
      cmd := GetToken(args, [' ', #9]);
      try
        CurDefs.define(cmd, args);
      except
        on e:ERedefinition do begin
          //TODO: implicit undefine?
          WarningMessage(Format(e.Message+' The first definition will be used. Near line #%d.', [p.SourceLine-1]));
        end;
      end;
      DebugMessage(cmd+' = '+args);
    end
    else CommentMacro;  // don't strip comment, everything is included
    exit;
  end
  else if (SameText(cmd, '#undef') and supportDefine) then begin
    CommentMacro;
    StripComment;
    if (macroIfCnt = 0) then begin
      cmd := GetToken(args, [' ', #9]);
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
    if (macroIfCnt > 0) then begin
      CommentMacro;
      exit;
    end;

    cmd := GetToken(args, [' ', #9]);
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
      StripComment;
      if (macroIfCnt = 0) then begin
        args := trim(args);
        args := ExpandFileName(ExtractFilePath(filestack[0])+args); // expand the filename
        PreProcessIncludeFile(args);
      end;
      CommentMacro;
      exit;
    end
    else if (SameText(cmd, 'error')) then begin
      ErrorMessage(Format('%s(%d): %s', [filestack[0] , p.SourceLine-1, args]));
    end
    else if (SameText(cmd, 'warning')) then begin
      WarningMessage(Format('%s(%d): %s', [filestack[0] , p.SourceLine-1, args]));
    end;

    // unknown ucpp macro
    CommentMacro;
    exit;
  end;
  // not one of our macros
  p.CopyTokenToOutput;
  p.SkipToken(true);
end;

var
  reparseStack: TStringList;

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

function _ExternalDefine(token: string; var output: string): boolean;
begin
  result := false;
  if (SameText(token, '__FILE__')) then begin
    output := '"'+StringReplace(ucfile, '\', '\\', [rfReplaceAll])+'"';
    result := true;
  end
  else if (SameText(token, '__BASE_FILE__')) then begin
    output := '"'+StringReplace(ExtractFileName(ucfile), '\', '\\', [rfReplaceAll])+'"';
    result := true;
  end
  else if (SameText(token, '__CLASS__')) then begin
    output := ChangeFileExt(ExtractFileName(ucfile), '');
    result := true;
  end
  else if (SameText(token, '__LINE__')) then begin
    output := IntToStr(globalP.SourceLine);
    result := true;
  end
  else if (SameText(token, '__DATE__')) then begin
    output := '"'+FormatDateTime('dddddd', now())+'"';
    result := true;
  end
  else if (SameText(token, '__TIME__')) then begin
    output := '"'+FormatDateTime('tt', now())+'"';
    result := true;
  end
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
  tstr, tmp: string;
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
      hasrepl := _ExternalDefine(tstr, repl);
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
          if (p.Token = toEOF) then raise EEOF.Create(END_OF_FILE_EXCEPTION);
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
        tmp := tstr+'/'+IntToStr(High(args)+1);
        if (CurDefs.IsRealDefined(tmp)) then begin
          if (reparseStack.IndexOf(tmp) > -1) then begin
            raise Exception.CreateFmt('Recursive function define encountered "%s" at line #%d:%d; call stack = "%s".', [tmp, globalp.SourceLine, globalp.linePos, reparseStack.commaText]);
          end;
          reparseStack.Add(tmp);
          repl := _reparseFuncDef(CurDefs.CallDefine(tstr, args));
          reparseStack.Delete(reparseStack.count-1);
          tstr := tmp; // for nicer debug output
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
  i,n,x: integer;
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
    i := p.LinePos;
    while (p.Token <> toEof) do begin
      act := aaNone;
      if (p.Token = '#') then begin
        act := aaQuote;
        n := p.LinePos-length(p.TokenString); // safe temp pos to respect spaces for quotes
        p.SkipToken(false);
        if (p.Token = '#') then begin // leading concat: foo ## arg
          act := aaConcat;
          p.SkipToken(false);
        end
        else i := n;
      end;
      if (p.Token = toSymbol) then begin
        x := p.LinePos-length(p.TokenString); // real start offset for normal arguments
        n := sl.IndexOf(p.TokenString);
        if (n > -1) then begin
          if (act <> aaNone) then begin
            if (act = aaConcat) then p.SkipToken(false);
            def.AddOffset(n, i, p.LinePos-i, act);
            if (act = aaQuote) then begin
              i := p.LinePos;
              p.SkipToken(false);
            end;
            continue;
          end
          else begin
            p.SkipToken(false);
            p.PushState;
            if (p.Token = '#') then begin
              p.SkipToken(false);
              if (p.Token = '#') then begin // trailing concat: arg ## foo
                act := aaConcat;
                p.SkipToken(false);
                def.AddOffset(n, i, p.LinePos-length(p.tokenstring)-i, act);                
                p.DiscardState;
                i := p.LinePos-length(p.tokenstring);
                continue;
              end
              else p.PopState; // quote is only leading
            end;
            def.AddOffset(n, x);
            continue;
          end;
        end;
      end;
      i := p.LinePos;
      p.SkipToken(false);
    end;
  finally
    sl.Free;
    ss.Free;
    dummy.Free;
  end;
end;

var
  includeStack: TStringList;

// to be used for #ucpp include filename or -imacros
procedure PreProcessIncludeFile(filename: string; const global: boolean = false);
var
  fsin: TFileStream;
  dummy: TMemoryStream;
  p: TSourceParser;
  defsback: TDefinitionList;
  idx: integer;
begin
  if (includeStack.IndexOf(filename) > -1) then begin
    WarningMessage('Recursive include, "'+filename+'" was already included, include file stack: "'+includeStack.CommaText+'"');
    exit;
  end;
  try
    fsin := TFileStream.Create(filename, fmOpenRead	or fmShareDenyWrite);
  except
    ErrorMessage('Could not open file "'+filename+'" for reading.');
    exit;
  end;
  defsback := nil;
  if (global) then begin
    defsback := CurDefs;
    CurDefs := BaseDefs;
  end;
  dummy := TMemoryStream.Create;
  idx := includeStack.Add(filename);
  Inc(stackDepth);
  try
    filestack.Insert(0, filename);
    p := TSourceParser.Create(fsin, dummy);
    p.ProcessMacro := _ppMacro;
    p.MacroCallBack := true;
    if (verbosity > 0) then Writeln(StrRepeat('>', stackDepth)+' Processing include file "'+filename+'"');
    internalPP(p);
  finally;
    filestack.Delete(0);
    FreeAndNil(fsin);
    FreeAndNil(dummy);
    if (global) then begin
      CurDefs := defsback;
    end;
    if (verbosity > 0) then Writeln(StrRepeat('<', stackDepth)+' Finished processing include file "'+filename+'"');
    Dec(stackDepth);
    includeStack.Delete(idx);
  end;
end;

procedure PreProcessFile(filename: string);
var
  fsin, fsout: TFileStream;
  i: integer;
begin
  if (not SameText(ExtractFileExt(filename), '.puc')) then begin
    ErrorMessage('The .puc extention is required.');
  end;
  try
    fsin := TFileStream.Create(filename, fmOpenRead	or fmShareDenyWrite);
  except
    ErrorMessage('Could not open file "'+filename+'" for reading.');
    exit;
  end;
  CurDefs := TDefinitionList.Create(BaseDefs);
  CurDefs.OnParseDefinition := ParseDef;
  CurDefs.OnExternalDefine := _ExternalDefine;
  CurDefs.define('CLASS_'+ChangeFileExt(ExtractFileName(filename), ''), '');
  pucfile := filename;
  ucfile := ChangeFileExt(filename, '.uc');
  stackDepth := 1;
  try
    try
      fsout := TFileStream.Create(ucfile, fmCreate or fmShareExclusive);
    except
      ErrorMessage('Could not open file "'+ucfile+'" for writing.');
      exit;
    end;
    if (verbosity > 0) then Writeln('> Processing "'+pucfile+'" -> "'+ucfile+'"');
    for i := 0 to includeFiles.Count-1 do begin
      try
        if (includeFiles[i] <> '') then
          PreProcessIncludeFile(includeFiles[i]);
      except
        on e:Exception do begin
          ErrorMessage(e.Message+' This include file will be excluded from future processing.');
          includeFiles[i] := '';
        end;
      end;
    end;
    filestack.Insert(0, filename);
    globalP := TSourceParser.Create(fsin, fsout);
    globalP.ProcessMacro := _ppMacro;
    globalP.MacroCallBack := true;
    try
      internalPP(globalP);
    except
      on e:Exception do ErrorMessage(e.Message+' The resulting file will mostlikely be broken.');
    end;
  finally;
    filestack.Delete(0);
    FreeandNil(globalP);
    FreeAndNil(fsout);
    FreeAndNil(fsin);
    FreeAndNil(CurDefs);
    if (verbosity > 0) then begin
      Writeln('< Finished processing "'+pucfile+'" -> "'+ucfile+'"');
      writeln('');
    end;
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
    supportIf := ini.ReadBool('Options', 'supportIf', supportIf);
    supportDefine := ini.ReadBool('Options', 'supportDefine', supportDefine);
    cfgStripMessage := ini.ReadString('Options', 'stripMessage', cfgStripMessage);
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
  reparseStack := TStringList.Create;
  includeFiles := TStringList.Create;
  includeStack := TStringList.Create;
  filestack := TStringList.Create;
finalization
  FreeAndNil(BaseDefs);
  FreeAndNil(reparseStack);
  FreeAndNil(includeFiles);
  FreeAndNil(includeStack);
  FreeAndNil(filestack);
end.