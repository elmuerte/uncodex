{*******************************************************************************
  Name:
    unit_ucxcumain.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Main code for the commandline utility

  $Id: unit_ucxcumain.pas,v 1.22 2005-04-06 10:11:03 elmuerte Exp $
*******************************************************************************}
{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003-2005  Michiel Hendriks

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

unit unit_ucxcumain;

{$I ../defines.inc}

interface

uses
  Classes, SysUtils, IniFiles, unit_uclasses, unit_config;

  {$IFDEF LINUX}
  procedure SigProc(signum: integer); cdecl;
  {$ENDIF}
  procedure LoadConfig;
  procedure ProcessCommandline;
  procedure Main;
  procedure FatalError(msg: string; errorcode: integer = -1);
  procedure Warning(msg: string);
  procedure StatusReport(msg: string; progress: byte = 255);

var
  Verbose: byte = 1;
  ConfigFile: string;
  Config: TUCXConfig;
  //sourcepaths, packagepriority, ignorepackages: TStringList;
  {PackageDescFile, ExtCommentFile,} UEini: string;
  // HTML output config:
  //HTMLOutputDir, TemplateDir, HTMLTargetExt, CPPApp: string;
  //TabsToSpaces: integer;
  // HTML Help config:
  //HHCPath, HTMLHelpFile, HHTitle: string;

implementation

uses
  {$IFDEF LINUX}
  Libc,
  {$ENDIF}
  unit_packages, unit_ascii, unit_definitions, unit_analyse, unit_htmlout,
  unit_ucxinifiles;

var
  {PackageList: TUPackageList;
  ClassList: TUClassList;}
  PhaseLabel, StatusFormat: string;
  LogFile: TextFile;
  Logging: boolean = false;
  ActiveThread: TThread;
  {$IFDEF FPC}
  ErrOutput : TextFile;
  {$ENDIF}

{$IFDEF LINUX}
procedure SigProc(signum: integer);
begin
  case (signum) of
    SIGINT, SIGABRT:
      begin
        if (ActiveThread <> nil) then begin
          ActiveThread.Terminate;
          ActiveThread.WaitFor;
        end;
        writeln('');
        writeln(#9'process aborted (signal: '+IntToStr(signum)+')');
        Halt(signum);
      end;
  end;
end;
{$ENDIF}

procedure LoadConfig;
{var
  ini: TMemIniFile;
  tmp, tmp2: string;
  i: integer;
  sl: TStringList;}
begin
  (*
  ini := TMemIniFile.Create(ConfigFile);
  sl := TStringList.Create;
  try
    HTMLOutputDir := ini.ReadString('Config', 'HTMLOutputDir', HTMLOutputDir);
    TemplateDir := ini.ReadString('Config', 'TemplateDir', TemplateDir);
    HTMLTargetExt := ini.ReadString('Config', 'HTMLTargetExt', '');
    TabsToSpaces := ini.ReadInteger('Config', 'TabsToSpaces', 0);
    CPPApp := ini.ReadString('Config', 'CPP', '');
    HHCPath := ini.ReadString('Config', 'HHCPath', '');
    HTMLHelpFile := ini.ReadString('Config', 'HTMLHelpFile', HTMLHelpFile);
    HHTitle := ini.ReadString('Config', 'HHTitle', '');

    PackageDescFile := ini.ReadString('Config', 'PackageDescriptionFile', PackageDescFile);
    ExtCommentFile := ini.ReadString('Config', 'ExternalCommentFile', ExtCommentFile);

    { Unreal Packages }
    ini.ReadSectionValues('PackagePriority', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      tmp2 := Copy(tmp, 1, Pos('=', tmp));
      Delete(tmp, 1, Pos('=', tmp));
      if (LowerCase(tmp2) = 'packages=') then begin
        Log('Config: Package = '+tmp);
        PackagePriority.Add(LowerCase(tmp));
      end;
    end;
    ini.ReadSectionValues('IgnorePackages', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Config: Ignore = '+tmp);
      IgnorePackages.Add(LowerCase(tmp));
    end;
    { Unreal Packages -- END }
    { Source paths }
    ini.ReadSectionValues('SourcePaths', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Config: Path = '+tmp);
      if (iFindDir(tmp, tmp)) then SourcePaths.Add(tmp);
    end;
  finally
    sl.free;
    ini.Free;
  end;*)
end;

procedure ProcessCommandline;
var
  tmp: string;
  lst: TStringList;
  i: integer;
  ini: TUCXIniFile;
begin
  if (CmdOption('l', tmp)) then begin
    if (DirectoryExists(ExtractFilePath(tmp)) or (ExtractFilePath(tmp) = '')) then begin
      Assign(LogFile, tmp);
      if (FileExists(tmp)) then Append(LogFile)
      else Rewrite(LogFile);
      WriteLn(LogFile, #13#10);
      WriteLn(LogFile, '--- Log started on: '+DateTimeToStr(Now()));
      Flush(LogFile);
      Logging := true;
    end;
  end;

  tmp := '';
  if (not HasCmdOption('uc')) then begin
    // check if the current directory is a engine dir
    if (FileExists(GetCurrentDir()+PathDelim+'System'+PathDelim+'Default.ini')) then
      tmp := GetCurrentDir()+PathDelim+'System'+PathDelim+'Default.ini'
    else if (FileExists(GetCurrentDir()+PathDelim+'Default.ini')) then
      tmp := GetCurrentDir()+PathDelim+'Default.ini';
  end;
  if (CmdOption('uc', tmp) or (tmp <> '')) then begin
    UEini := ExpandFileName(tmp);
    if (FileExists(UEini)) then begin
      ini := TUCXIniFile.Create(UEini);
      lst := TStringList.Create;
      try
        ini.ReadStringArray('Editor.EditorEngine', 'EditPackages', lst);
        for i := 0 to lst.Count-1 do begin
          Log('Unreal Config: EditPackages = '+lst[i]);
          config.PackagesPriority.Add(LowerCase(lst[i]));
        end;
      finally
        ini.Free;
        lst.Free;
      end;
    end
    else begin
      Warning('Unreal System Config file does not exist: '+UEini);
      UEini := '';
    end;
  end;

  CmdOption('o', config.HTMLOutput.Outputdir);
  config.HTMLOutput.Outputdir := ExpandFileName(config.HTMLOutput.Outputdir);

  if (CmdOption('p', tmp)) then begin
    lst := TStringList.Create;
    try
      {$IFNDEF FPC}
      lst.Delimiter := ',';
      lst.QuoteChar := '"';
      lst.DelimitedText := tmp;
      {$ELSE}
      {$MESSAGE warn 'FIX'}
      {$ENDIF}
      config.PackagesPriority.Clear;
      config.PackagesPriority.Assign(lst);
    finally
      lst.Free;
    end;
  end;
  if (CmdOption('pa', tmp)) then begin
    lst := TStringList.Create;
    try
      {$IFNDEF FPC}
      lst.Delimiter := ',';
      lst.QuoteChar := '"';
      lst.DelimitedText := tmp;
      {$ELSE}
      {$MESSAGE warn 'FIX'}
      {$ENDIF}
      config.PackagesPriority.AddStrings(lst);
    finally
      lst.Free;
    end;
  end;
  if (CmdOption('pi', tmp)) then begin
    lst := TStringList.Create;
    try
      {$IFNDEF FPC}
      lst.Delimiter := ',';
      lst.QuoteChar := '"';
      lst.DelimitedText := tmp;
      {$ELSE}
      {$MESSAGE warn 'FIX'}
      {$ENDIF}
      config.ignorepackages.AddStrings(lst);
    finally
      lst.Free;
    end;
  end;
  i := 0;
  while (CmdOption('s', tmp, i)) do begin
    config.sourcepaths.Add(ExcludeTrailingPathDelimiter(ExpandFileName(tmp)));
    i := i+1;
  end;
  // add current dir
  if (config.sourcepaths.Count = 0) then begin
    if (UEini <> '') then config.sourcepaths.Add(ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(UEini))))
  end;

  CmdOption('t', config.HTMLoutput.TemplateDir);
  if (not DirectoryExists(config.HTMLoutput.TemplateDir)) then begin
	  FatalError('Template directory does not exist: '+config.HTMLoutput.TemplateDir);
  end;
  CmdOption('d', config.Comments.Packages);
  CmdOption('e', config.Comments.Declarations);

  // html help
  CmdOption('mc', config.HTMLHelp.Compiler);
  CmdOption('mo', config.HTMLHelp.OutputFile);

  SetExtCommentFile(config.Comments.Declarations);
end;

procedure Main;
var
  prec: TPackageScannerConfig;
  ps: TPackageScanner;
  ca: TClassAnalyser;
  ho: THTMLOutput;
begin
  if (config.sourcepaths.Count <= 0) then begin
    FatalError('No source paths defined');
  end;

  if (Verbose = 1) then StatusFormat := '%2d) %-20s : '
  else if (Verbose = 2) then StatusFormat := 'Phase %d)';

  PhaseLabel := format(StatusFormat, [1, 'Scanning packages']);

  prec.paths := config.sourcepaths;
  prec.status := statusreport;
  prec.packagelist := config.PackageList;
  prec.classlist := config.ClassList;
  prec.PackagePriority := config.packagespriority;
  prec.IgnorePackages := config.ignorepackages;
  prec.PDFile := config.Comments.Packages;
  prec.CHash := nil;

  ps := TPackageScanner.Create(prec);
  ActiveThread := ps;
  try
    ps.FreeOnTerminate := false;
    ps.Resume;
    ps.WaitFor;
  finally
    ps.Free;
  end;
  if (Verbose > 0) then writeln('');

  if (config.ClassList.Count <= 0) then begin
    FatalError('No classes found');
  end;

  PhaseLabel := format(StatusFormat, [2, 'Analyzing classes']);
  ca := TClassAnalyser.Create(config.ClassList, statusreport);
  ActiveThread := ca;
  try
    ca.FreeOnTerminate := false;
    ca.Resume;
    ca.WaitFor;
  finally
    ca.Free;
  end;
  if (Verbose > 0) then writeln('');

  PhaseLabel := format(StatusFormat, [3, 'Creating HTML files']);
  ho := THTMLOutput.Create(config.HTMLOutput, statusreport);
  ActiveThread := ho;
  try
    ho.FreeOnTerminate := false;
    ho.Resume;
    ho.WaitFor;
  finally
    ho.Free;
  end;
  if (Verbose > 0) then writeln('');

  if (config.HTMLHelp.OutputFile <> '') then begin
    PhaseLabel := format(StatusFormat, [4, 'Compiling MS HTML Help']);
    Warning('Not implemented'); //TODO: implement
  end;

  if (HasCmdOption('me')) then begin
    PhaseLabel := format(StatusFormat, [5, 'Clean up HTML files']);
    RecurseDelete(config.HTMLOutput.OutputDir);
  end;
end;

procedure FatalError(msg: string; errorcode: integer = -1);
begin
  Flush(Output);
  writeln(ErrOutput, '');
  writeln(ErrOutput, 'Fatal error:');
  writeln(ErrOutput, #9+msg);
  Flush(ErrOutput);
  Halt(errorcode);
end;

procedure Warning(msg: string);
begin
  Flush(Output);
  writeln(ErrOutput, '');
  writeln(ErrOutput, 'Warning:');
  writeln(ErrOutput, #9+msg);
  Flush(ErrOutput);
end;

procedure StatusReport(msg: string; progress: byte = 255);
begin
  if (Verbose = 1) then DrawProgressBar(progress, 30, true, PhaseLabel)
  else if (Verbose = 2) then begin
    if (progress = 255) then Writeln(PhaseLabel+format(' ....', [progress])+' | '+msg)
    else Writeln(PhaseLabel+format(' %3d%%', [progress])+' | '+msg);
  end;
end;


procedure Log(msg : string; mt: TLogType = ltInfo; obj: TObject = nil);
const
   LogLabel: array[TLogType] of string = ('INFO', 'WARN', 'ERR', 'SRC');
begin 
  if (Logging) then begin
    WriteLn(LogFile, '['+LogLabel[mt]+'] '+msg);
    if (IsA(obj, TLogEntry)) then begin
      if (TLogEntry(obj).filename <> '') then
        WriteLn(LogFile, #9'File: '+TLogEntry(obj).filename+' #'+IntToStr(TLogEntry(obj).line)+','+IntToStr(TLogEntry(obj).pos));
    end;
  end;
  if (mt = ltError) then begin
    writeln(ErrOutput, '');
    writeln(ErrOutput, '[ERROR] '+msg);
    flush(ErrOutput);
  end;
end;

initialization
  unit_definitions.Log := Log;
  unit_analyse.GetExternalComment := unit_definitions.RetExternalComment;
  {$IFDEF FPC}
  ErrOutput := stderr;
  {$ENDIF}
finalization
  if (Logging) then begin
    Flush(LogFile);
    WriteLn(LogFile, '--- Log closed on: '+DateTimeToStr(Now()));
    CloseFile(logfile);
  end;
end.
