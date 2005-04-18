{*******************************************************************************
  Name:
    unit_ucxcumain.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Main code for the commandline utility

  $Id: unit_ucxcumain.pas,v 1.24 2005-04-18 15:48:56 elmuerte Exp $
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
  procedure ProcessCommandline;
  procedure Main;
  procedure FatalError(msg: string; errorcode: integer = -1);
  procedure Warning(msg: string);
  procedure StatusReport(msg: string; progress: byte = 255);

var
  Verbose: byte = 1;
  ConfigFile: string;
  Config: TUCXConfig;
  UEini: string;

implementation

uses
  {$IFDEF LINUX}
  Libc,
  {$ENDIF}
  unit_packages, unit_ascii, unit_definitions, unit_analyse, unit_htmlout,
  unit_ucxinifiles, unit_ucxthread;

var
  {PackageList: TUPackageList;
  ClassList: TUClassList;}
  PhaseLabel, StatusFormat: string;
  LogFile: TextFile;
  Logging: boolean = false;
  ActiveThread: TUCXThread;
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
          {$IFNDEF NO_THREADS}
          ActiveThread.WaitFor;
          {$ENDIF}
        end;
        writeln('');
        writeln(#9'process aborted (signal: '+IntToStr(signum)+')');
        Halt(signum);
      end;
  end;
end;
{$ENDIF}

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

  ActiveThread := TPackageScanner.Create(prec);
  try
    ActiveThread.FreeOnTerminate := false;
    ActiveThread.Resume;
    {$IFNDEF NO_THREADS}
    ActiveThread.WaitFor;
    {$ENDIF}
  finally
    ActiveThread.Free;
  end;
  if (Verbose > 0) then writeln('');

  if (config.ClassList.Count <= 0) then begin
    FatalError('No classes found');
  end;

  PhaseLabel := format(StatusFormat, [2, 'Analyzing classes']);
  ActiveThread := TClassAnalyser.Create(config.ClassList, statusreport);
  try
    ActiveThread.FreeOnTerminate := false;
    ActiveThread.Resume;
    {$IFNDEF NO_THREADS}
    ActiveThread.WaitFor;
    {$ENDIF}
  finally
    ActiveThread.Free;
  end;
  if (Verbose > 0) then writeln('');

  PhaseLabel := format(StatusFormat, [3, 'Creating HTML files']);
  ActiveThread := THTMLOutput.Create(config.HTMLOutput, statusreport);
  try
    ActiveThread.FreeOnTerminate := false;
    ActiveThread.Resume;
    {$IFNDEF NO_THREADS}
    ActiveThread.WaitFor;
    {$ENDIF}
  finally
    ActiveThread.Free;
  end;
  if (Verbose > 0) then writeln('');

  if (config.HTMLHelp.OutputFile <> '') then begin
    PhaseLabel := format(StatusFormat, [4, 'Compiling MS HTML Help']);
    Warning('Compiling MS HTML Help not implemented'); //TODO: implement
  end;

  if (HasCmdOption('me')) then begin
    PhaseLabel := format(StatusFormat, [5, 'Clean up HTML files']);
    RecurseDelete(config.HTMLOutput.OutputDir);
  end;
end;

var
  PendingNL: boolean;

procedure FatalError(msg: string; errorcode: integer = -1);
begin
  if (PendingNL) then begin
    writeln('');
    PendingNL := false;
    Flush(Output);
  end;
  writeln(ErrOutput, 'Fatal error:');
  writeln(ErrOutput, #9+msg);
  Flush(ErrOutput);
  Halt(errorcode);
end;

procedure Warning(msg: string);
begin
  if (PendingNL) then begin
    writeln('');
    PendingNL := false;
    Flush(Output);
  end;
  writeln(ErrOutput, 'Warning:');
  writeln(ErrOutput, #9+msg);
  Flush(ErrOutput);
end;

procedure StatusReport(msg: string; progress: byte = 255);
begin
  if (Verbose = 1) then begin
    DrawProgressBar(progress, 30, true, PhaseLabel);
    PendingNL := true;
  end
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
    if (PendingNL) then begin
      writeln('');
      PendingNL := false;
      Flush(Output);
    end;
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
  if (config <> nil) then FreeAndNil(config);
  if (Logging) then begin
    Flush(LogFile);
    WriteLn(LogFile, '--- Log closed on: '+DateTimeToStr(Now()));
    CloseFile(logfile);
  end;
end.
