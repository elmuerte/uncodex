{*******************************************************************************
	Name:
        unit_ucxcumain.pas
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        Main code for the commandline utility

    $Id: unit_ucxcumain.pas,v 1.12 2004-10-18 15:36:11 elmuerte Exp $
*******************************************************************************}
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

unit unit_ucxcumain;

{$I ../defines.inc}

interface

uses
	Classes, SysUtils, IniFiles, unit_uclasses;

	{$IFDEF LINUX}
	procedure SigProc(signum: integer); cdecl;
	{$ENDIF}
	procedure LoadConfig;
	procedure ProcessCommandline;
	procedure Main;
	procedure FatalError(msg: string; errorcode: integer = -1);
	procedure Warning(msg: string);
	procedure StatusReport(msg: string; progress: byte = 255);
	procedure Log(msg: string);
	procedure LogClass(msg: string; uclass: TUClass = nil);

var
	Verbose: byte = 1;
	ConfigFile: string;
	sourcepaths, packagepriority, ignorepackages: TStringList;
	PackageDescFile, ExtCommentFile: string;
	// HTML output config:
	HTMLOutputDir, TemplateDir, HTMLTargetExt, CPPApp: string;
	TabsToSpaces: integer;
	// HTML Help config:
	HHCPath, HTMLHelpFile, HHTitle: string;

implementation

uses
	{$IFDEF LINUX}
	Libc,
	{$ENDIF}
	unit_packages, unit_ascii, unit_definitions, unit_analyse, unit_htmlout;

var
	PackageList: TUPackageList;
	ClassList: TUClassList;
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
				if (ActiveThread <> nil) then ActiveThread.Terminate;
				writeln('');
				writeln(#9'process aborted (signal: '+IntToStr(signum)+')');
				Halt(signum);
			end;
	end;
end;
{$ENDIF}

procedure LoadConfig;
var
	ini: 	TMemIniFile;
	tmp,
    tmp2: 	string;
	i: 		integer;
	sl: 	TStringList;
begin
	if (not FileExists(ConfigFile)) then begin
		Warning('Config file does not exist: '+ConfigFile);
		exit;
	end;
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
		// must be after Package= listing
		for i := 0 to sl.Count-1 do begin
			tmp := sl[i];
			tmp2 := Copy(tmp, 1, Pos('=', tmp));
			Delete(tmp, 1, Pos('=', tmp));
			if (LowerCase(tmp2) = 'tag=') then begin
				Log('Config: Tagged package = '+tmp);
				PackagePriority.Objects[PackagePriority.IndexOf(LowerCase(tmp))] := PackagePriority;
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
	end;
end;

procedure ProcessCommandline;
var
	tmp,
    tmp2: 	string;
	lst: 	TStringList;
	i: 		integer;
	ini: 	TMemIniFile;
begin
	SetExtCommentFile(ExtCommentFile);
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
	if (CmdOption('uc', tmp)) then begin
		tmp := ExpandFileName(tmp);
		if (FileExists(tmp)) then begin
			ini := TMemIniFile.Create(tmp);
			lst := TStringList.Create;
			try
				ini.ReadSectionValues('Editor.EditorEngine', lst);
				for i := 0 to lst.Count-1 do begin
					tmp := lst[i];
					tmp2 := Copy(tmp, 1, Pos('=', tmp));
					Delete(tmp, 1, Pos('=', tmp));
					if (LowerCase(tmp2) = 'editpackages=') then begin
						Log('Unreal Config: EditPackages = '+tmp);
						PackagePriority.Add(LowerCase(tmp));
					end;
				end;
			finally
				ini.Free;
				lst.Free;
			end;
		end
		else Warning('Unreal System Config file does not exist: '+tmp);
	end;
	CmdOption('o', HTMLOutputDir);
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
			packagepriority.Clear;
			packagepriority.Assign(lst);
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
			packagepriority.AddStrings(lst);
		finally
			lst.Free;
		end;
	end;
	i := 0;
	while (CmdOption('s', tmp, i)) do begin
		sourcepaths.Add(ExcludeTrailingPathDelimiter(ExpandFileName(tmp)));
		i := i+1;
	end;
	CmdOption('t', TemplateDir);
	CmdOption('d', PackageDescFile);
	CmdOption('e', ExtCommentFile);

	// html help
	CmdOption('mc', HHCPath);
	CmdOption('mo', HTMLHelpFile);
end;

procedure Main;
var
	ps: 	TPackageScanner;
	ca: 	TClassAnalyser;
	ho: 	THTMLOutput;
	hoc: 	THTMLoutConfig;
begin
	if (sourcepaths.Count <= 0) then begin
		FatalError('No source paths defined');
	end;

	if (Verbose = 1) then StatusFormat := '%2d) %-20s : '
	else if (Verbose = 2) then StatusFormat := 'Phase %d)';

	PhaseLabel := format(StatusFormat, [1, 'Scanning packages']);
	ps := TPackageScanner.Create(sourcepaths, statusreport, PackageList, ClassList, packagepriority, ignorepackages, nil, PackageDescFile);
	ActiveThread := ps;
	try
		ps.FreeOnTerminate := false;
		ps.Resume;
		ps.WaitFor;
	finally
		ps.Free;
	end;
	if (Verbose > 0) then writeln('');

	if (ClassList.Count <= 0) then begin
		FatalError('No classes found');
	end;

	PhaseLabel := format(StatusFormat, [2, 'Analyzing classes']);
	ca := TClassAnalyser.Create(ClassList, statusreport);
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
	hoc.PackageList := PackageList;
	hoc.ClassList := ClassList;
	hoc.outputdir := HTMLOutputDir;
	hoc.TemplateDir := TemplateDir;
	hoc.TabsToSpaces := TabsToSpaces;
	hoc.TargetExtention := TargetExtention;
	hoc.CPP := CPPApp;
	hoc.CreateSource := true;
	ho := THTMLOutput.Create(hoc, statusreport);
	ActiveThread := ho;
	try
		ho.FreeOnTerminate := false;
		ho.Resume;
		ho.WaitFor;
	finally
		ho.Free;
	end;
	if (Verbose > 0) then writeln('');



	if (HasCmdOption('me')) then begin
		PhaseLabel := format(StatusFormat, [5, 'Clean up HTML files']);
		RecurseDelete(HTMLOutputDir);
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

procedure Log(msg: string);
begin
	if (Logging) then WriteLn(LogFile, msg);
end;

procedure LogClass(msg: string; uclass: TUClass = nil);
begin
	if (Logging) then WriteLn(LogFile, msg);
end;

initialization
	sourcepaths := TStringList.Create;
	packagepriority := TStringList.Create;
	ignorepackages := TStringList.Create;
	PackageList := TUPackageList.Create(true);
	ClassList := TUClassList.Create(true);
	unit_definitions.Log := Log;
	unit_definitions.LogClass := LogClass;
	unit_analyse.GetExternalComment := unit_definitions.RetExternalComment;
	{$IFDEF FPC}
	ErrOutput := stderr;
	{$ENDIF}
finalization
	sourcepaths.Free;
	packagepriority.Free;
	ignorepackages.Free;
	ClassList.Free;
	PackageList.Free;
	if (Logging) then begin
		Flush(LogFile);
		WriteLn(LogFile, '--- Log closed on: '+DateTimeToStr(Now()));
		CloseFile(logfile);
	end;
end.
