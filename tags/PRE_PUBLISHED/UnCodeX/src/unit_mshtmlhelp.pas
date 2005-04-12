{*******************************************************************************
  Name:
    unit_mshtmlhelp.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Creates an MS HTML Help project and compiles it.

  $Id: unit_mshtmlhelp.pas,v 1.20 2005-04-05 07:58:08 elmuerte Exp $
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

unit unit_mshtmlhelp;

{$I defines.inc}

interface

uses
  Windows, SysUtils, Classes, unit_definitions, unit_uclasses, unit_outputdefs;

type
  TMSHTMLHelp = class(TThread)
    HCCPath: string;
    OutputPath: string;
    ResultFile: string;
    MainTitle: string;
    hhp: TStringList;
    PackageList: TUPackageList;
    ClassList: TUClassList;
    status: TStatusReport;
    procedure CreateHHPFile;
    procedure CreateHHCFile;
    procedure RunHHCompiler;
    function ExecConsoleApp(const Commandline: String): Cardinal;
    procedure ListDir(basedir, offset: string);
    procedure HHCClassTree(uclass: TUClass; hhc: TStringList);
  public
    constructor Create(hccpath, outputpath, resultfile, title: string; PackageList: TUPackageList; ClassList: TUClassList; status: TStatusReport);
    procedure Execute; override;
    destructor Destroy; override;
  end;

implementation

uses
  unit_htmlout;

var
  nFiles: integer;

constructor TMSHTMLHelp.Create(hccpath, outputpath, resultfile, title: string; PackageList: TUPackageList; ClassList: TUClassList; status: TStatusReport);
begin
  hhp := TStringList.Create;
  Self.HCCPath := hccpath;
  Self.OutputPath := outputpath;
  Self.ResultFile := resultfile;
  Self.PackageList := PackageList;
  Self.ClassList := ClassList;
  Self.status := status;
  Self.MainTitle := title;
  if (MainTitle = '') then MainTitle := APPTITLE+' - '+APPVERSION;
  inherited Create(true);
  FreeOnTerminate := true;
end;

destructor TMSHTMLHelp.Destroy;
begin
  hhp.Free;
end;

procedure TMSHTMLHelp.Execute;
var
  stime: Cardinal;
begin
  try
    Status('Creating HTML Help file ...', 0);
    stime := GetTickCount();
    CreateHHPFile();
    CreateHHCFile();
    RunHHCompiler();
    if (FileExists(outputpath+PATHDELIM+'_htmlhelp.hhp')) then DeleteFile(outputpath+PATHDELIM+'_htmlhelp.hhp');
    if (FileExists(outputpath+PATHDELIM+'_htmlhelp.hhc')) then DeleteFile(outputpath+PATHDELIM+'_htmlhelp.hhc');
    Status('Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds');
  except
    on E: Exception do Log('Unhandled exception: '+E.Message);
  end;
end;

procedure TMSHTMLHelp.CreateHHPFile;
begin
  Status('Creating HTML Help project file');
  hhp.Add('[OPTIONS]');
  hhp.Add('Compatibility=1.1 or later');
  hhp.Add('Compiled file='+ResultFile);
  hhp.Add('Contents file=_htmlhelp.hhc');
  hhp.Add('Default Window=Main');
  hhp.Add('Default topic=index.html');
  hhp.Add('Display compile progress=Yes');
  hhp.Add('Full-text search=Yes');
  hhp.Add('Language=0x409 English (United States)');
  hhp.Add('Title='+MainTitle);
  hhp.Add('');
  hhp.Add('[WINDOWS]');
  hhp.Add('Main="'+MainTitle+'","_htmlhelp.hhc",,"index.html","index.html",,,,,0x62520,,0x104e,[0,0,800,600],,,,1,,,0');
  hhp.Add('');
  hhp.Add('[FILES]');
  nFiles := 0;
  ListDir(outputpath+PATHDELIM, '');
  hhp.SaveToFile(outputpath+PATHDELIM+'_htmlhelp.hhp');
  Inc(nFiles,7); // 7 extra status lines
end;

procedure TMSHTMLHelp.ListDir(basedir, offset: string);
var
  sr: TSearchRec;
begin
  if FindFirst(basedir+WILDCARD, faAnyFile, sr) = 0 then begin
    repeat
      if ((sr.Name <> '.') and (sr.Name <> '..')) then begin
        if (sr.Attr and faDirectory <> 0) then begin
          ListDir(basedir+sr.Name+PATHDELIM, offset+sr.Name+PATHDELIM);
        end
        else begin
          Inc(nFiles);
          hhp.Add(offset+sr.Name);
          // dynamically find target ext
          if ((offset = '') and (sr.Name = 'index'+extractfileext(sr.Name))) then begin
            unit_htmlout.TargetExtention := Copy(extractfileext(sr.Name), 2, MaxInt);
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMSHTMLHelp.CreateHHCFile;
var
  hhc: TStringList;
  i, j: integer;
begin
  Status('Creating HTML Help topic file');
  hhc := TStringList.Create;
  try
    hhc.Add('<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">');
    hhc.Add('<HTML>');
    hhc.Add('<HEAD>');
    hhc.Add('<!-- Sitemap 1.0 -->');
    hhc.Add('</HEAD><BODY>');
    hhc.Add('<OBJECT type="text/site properties">');
    hhc.Add('   <param name="FrameName" value="view">');
    hhc.Add('   <param name="WindowName" value="Main">');
    hhc.Add('</OBJECT>');
    hhc.Add('<ul>');
    hhc.Add(' <li><object type="text/sitemap"><param name="name" value="Classes"></object>');
    hhc.Add(' <ul>');
    for i := 0 to   ClassList.Count-1 do begin
      if (ClassList[i].parent = nil) then begin
        hhc.Add('    <li><object type="text/sitemap"><param name="name" value="'+ClassList[i].name+'"><param name="Local" value="'+ClassLink(ClassList[i])+'"></object>');
        if (ClassList[i].children.Count > 0) then HHCClassTree(ClassList[i], hhc);
        hhc.Add('    </li>');
      end;
    end;
    hhc.Add(' </ul>');
    hhc.Add('</ul>');
    hhc.Add('<ul>');
    hhc.Add(' <li><object type="text/sitemap"><param name="name" value="Packages"></object>');
    hhc.Add(' <ul>');
    for i := 0 to PackageList.Count-1 do begin
      hhc.Add('  <li><object type="text/sitemap"><param name="name" value="'+PackageList[i].name+'"><param name="Local" value="'+PackageLink(PackageList[i])+'"></object>');
      hhc.Add('  <ul>');
      for j := 0 to PackageList[i].classes.Count-1 do begin
        hhc.Add('    <li><object type="text/sitemap"><param name="name" value="'+PackageList[i].classes[j].name+'"><param name="Local" value="'+ClassLink(PackageList[i].classes[j])+'"></object>');
      end;
      hhc.Add('  </ul>');
      hhc.Add('  </li>');
    end;
    hhc.Add(' </ul>');
    hhc.Add('</ul>');
    hhc.Add('</BODY></HTML>');
    hhc.SaveToFile(outputpath+PATHDELIM+'_htmlhelp.hhc');
  finally
    hhc.Free;
  end;
end;

procedure TMSHTMLHelp.HHCClassTree(uclass: TUClass; hhc: TStringList);
var
  i: integer;
begin
  hhc.Add('<ul>');
  for i := 0 to uclass.children.Count-1 do begin
    hhc.Add('    <li><object type="text/sitemap"><param name="name" value="'+uclass.children[i].name+'"><param name="Local" value="'+ClassLink(uclass.children[i])+'"></object>');
    if (uclass.children[i].children.Count > 0) then HHCClassTree(uclass.children[i], hhc);
    hhc.Add('    </li>');
  end;
  hhc.Add('</ul>');
end;

procedure TMSHTMLHelp.RunHHCompiler;
begin
  Status('Running HTML Help compiler ...');
  try
    Log('exec: '+HCCPath+PATHDELIM+COMPILER+' _htmlhelp.hhp ...');
    ExecConsoleApp(HCCPath+PATHDELIM+COMPILER+' _htmlhelp.hhp');
  except
  end;
end;

function TMSHTMLHelp.ExecConsoleApp(const Commandline: String): Cardinal;
const
  CR          = #$0D;
  LF          = #$0A;
  TerminationWaitTime = 5000;

var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecurityAttributes: TSecurityAttributes;
  TempHandle, WriteHandle, ReadHandle: THandle;
  c: Char;
  LineBuf: array[0..$100] of char;
  LineBufPtr, i, Lines: Integer;
  ReadStream: THandleStream;

  procedure OutputLine;
  begin
    LineBuf[LineBufPtr]:= #0;
    Status('Running HTML Help compiler ...', round(Lines/nFiles*100));
    log(LineBuf);
    LineBufPtr:= 0;
  end;

begin
  FillChar(StartupInfo,SizeOf(StartupInfo), 0);
  FillChar(SecurityAttributes, SizeOf(SecurityAttributes), 0);
  LineBufPtr:= 0;
  Lines:=0;
  with SecurityAttributes do begin
    nLength:= Sizeof(SecurityAttributes);
    bInheritHandle:= true
  end;
  if not CreatePipe(ReadHandle, WriteHandle, @SecurityAttributes, 1) then
    RaiseLastOSError;
  try
    if Win32Platform = VER_PLATFORM_WIN32_NT then begin
      if not SetHandleInformation(ReadHandle, HANDLE_FLAG_INHERIT, 0) then
        RaiseLastOSError
    end
    else begin
      if not DuplicateHandle(GetCurrentProcess, ReadHandle,
        GetCurrentProcess, @TempHandle, 0, True, DUPLICATE_SAME_ACCESS) then
        RaiseLastOSError;
      CloseHandle(ReadHandle);
      ReadHandle:= TempHandle;
    end;

    with StartupInfo do begin
      cb:= SizeOf(StartupInfo);
      dwFlags:= STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      wShowWindow:= SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE);
      hStdOutput := WriteHandle;
    end;

    if not CreateProcess(nil, PChar(CommandLine),
       nil, nil,
       true,
       CREATE_NEW_PROCESS_GROUP,
       nil,
       PChar(OutputPath),
       StartupInfo,
       ProcessInfo) then RaiseLastOSError;

    CloseHandle(ProcessInfo.hThread);
    CloseHandle(WriteHandle);
    ReadStream := THandleStream.Create(ReadHandle);
    try
      i := 0;
      while (ReadStream.Read(c, 1) > 0) do begin
        if (Terminated) then begin
          GenerateConsoleCtrlEvent(CTRL_C_EVENT, ProcessInfo.dwProcessId);
          GenerateConsoleCtrlEvent(CTRL_BREAK_EVENT, ProcessInfo.dwProcessId);
          Inc(i);
          if (i > 50) then begin
            TerminateProcess(ProcessInfo.hProcess, 1); // fail safe
            Log('HTML HELP Compiler terminated');
          end;
        end;
        if (c = #9) then c := ' ';
        if (c = LF) then begin
          Inc(Lines);
        end
        else if (c = CR) then begin
          OutputLine;
        end
        else begin
          LineBuf[LineBufPtr]:= c;
          Inc(LineBufPtr);
          if LineBufPtr >= (SizeOf(LineBuf) - 1) then begin
            OutputLine;
          end
        end
      end;
      WaitForSingleObject(ProcessInfo.hProcess, TerminationWaitTime);
      GetExitCodeProcess(ProcessInfo.hProcess, Result);
      OutputLine;
    finally
      ReadStream.Free;
      CloseHandle(ProcessInfo.hProcess)
    end
  finally
    CloseHandle(ReadHandle)
  end
end;


end.
