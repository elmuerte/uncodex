unit unit_mshtmlhelp;

interface

uses
  Windows, SysUtils, Variants, Classes, unit_definitions, ComCtrls, unit_uclasses,
  unit_outputdefs;

type
  TMSHTMLHelp = class(TThread)
    HCCPath: string;
    OutputPath: string;
    ResultFile: string;
    MainTitle: string;
    hhp: TStringList;
    PackageList: TUPackageList;
    ClassTree: TTreeView;
    status: TStatusReport;
    procedure CreateHHPFile;
    procedure CreateHHCFile;
    procedure RunHHCompiler;
    function ExecConsoleApp(const Commandline: String): Cardinal;
  public
    constructor Create(hccpath, outputpath, resultfile, title: string; PackageList: TUPackageList; ClassTree: TTreeView; status: TStatusReport);
    procedure Execute; override;
    destructor Destroy; override;
  end;

const
  COMPILER = 'HHC.EXE';

implementation

{-----------------------------------------------------------------------------
 Unit Name: unit_mshtmlhelp
 Author:    elmuerte
 Purpose:   creates the HTML Help project file and runs the compiler
 History:
-----------------------------------------------------------------------------}

uses unit_htmlout, unit_main;

var
  nFiles: integer;

constructor TMSHTMLHelp.Create(hccpath, outputpath, resultfile, title: string; PackageList: TUPackageList; ClassTree: TTreeView; status: TStatusReport);
begin
  hhp := TStringList.Create;
  Self.HCCPath := hccpath;
  Self.OutputPath := outputpath;
  Self.ResultFile := resultfile;
  Self.PackageList := PackageList;
  Self.ClassTree := ClassTree;
  Self.status := status;
  Self.MainTitle := title;
  if (MainTitle = '') then MainTitle := APPTITLE+' - '+APPVERSION;
  inherited Create(true);
end;

destructor TMSHTMLHelp.Destroy;
begin
  hhp.Free;
end;

procedure TMSHTMLHelp.Execute;
var
  stime: Cardinal;
begin
  Status('Creating HTML Help file ...', 0);
  stime := GetTickCount();
  CreateHHPFile();
  CreateHHCFile();
  RunHHCompiler();
  if (FileExists(outputpath+PATHDELIM+'_htmlhelp.hhp')) then DeleteFile(outputpath+PATHDELIM+'_htmlhelp.hhp');
  if (FileExists(outputpath+PATHDELIM+'_htmlhelp.hhc')) then DeleteFile(outputpath+PATHDELIM+'_htmlhelp.hhc');
  Status('Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds');
end;

procedure TMSHTMLHelp.CreateHHPFile;
var
  sr: TSearchRec;
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
  if FindFirst(outputpath+PATHDELIM+WILDCARD, faDirectory, sr) = 0 then begin
    repeat
      if ((sr.Name <> '.') and (sr.Name <> '..')) then begin
        Inc(nFiles);
        hhp.Add(sr.Name);
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  hhp.SaveToFile(outputpath+PATHDELIM+'_htmlhelp.hhp');
  Inc(nFiles,7); // 7 extra status lines
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
    hhc.Add('	<param name="FrameName" value="view">');
    hhc.Add('	<param name="WindowName" value="Main">');
    hhc.Add('</OBJECT>');
    hhc.Add('<ul>');
    hhc.Add(' <li><object type="text/sitemap"><param name="name" value="Classes"></object>');
    hhc.Add(' <ul>');
    j := 0;
    for i := 0 to ClassTree.Items.Count-1 do begin
      hhc.Add(StrRepeat('<ul>', ClassTree.Items[i].Level-J));
      hhc.Add(StrRepeat('</ul>', J-ClassTree.Items[i].Level));
      hhc.Add('     <li><object type="text/sitemap"><param name="name" value="'+ClassTree.Items[i].Text+'"><param name="Local" value="'+ClassLink(TUClass(ClassTree.Items[i].Data))+'"></object>');
      j := ClassTree.Items[i].Level;
    end;
    hhc.Add(StrRepeat('</ul>', J));
    hhc.Add(' </ul>');
    hhc.Add('</ul>');
    hhc.Add('<ul>');
    hhc.Add(' <li><object type="text/sitemap"><param name="name" value="Packages"></object>');
    hhc.Add(' <ul>');
    for i := 0 to PackageList.Count-1 do begin
      hhc.Add('   <li><object type="text/sitemap"><param name="name" value="'+PackageList[i].name+'"><param name="Local" value="package_'+PackageList[i].name+'.html"></object>');
      hhc.Add('   <ul>');
      for j := 0 to PackageList[i].classes.Count-1 do begin
        hhc.Add('     <li><object type="text/sitemap"><param name="name" value="'+PackageList[i].classes[j].name+'"><param name="Local" value="'+ClassLink(PackageList[i].classes[j])+'"></object>');
      end;
      hhc.Add('   </ul>');
    end;
    hhc.Add(' </ul>');
    hhc.Add('</ul>');
    hhc.Add('</BODY></HTML>');
    hhc.SaveToFile(outputpath+PATHDELIM+'_htmlhelp.hhc');
  finally
    hhc.Free;
  end;
end;

procedure TMSHTMLHelp.RunHHCompiler;
begin
  Status('Running HTML Help compiler ...');
  try
    ExecConsoleApp(HCCPath+PATHDELIM+COMPILER+' _htmlhelp.hhp');
  except
  end;
end;

function TMSHTMLHelp.ExecConsoleApp(const Commandline: String): Cardinal;
const
  CR = #$0D;
  LF = #$0A;
  TerminationWaitTime = 5000;

var
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
  SecurityAttributes: TSecurityAttributes;
  TempHandle, WriteHandle, ReadHandle: THandle;
  ReadBuf, LineBuf: array[0..$100] of Char;
  BytesRead: Cardinal;
  LineBufPtr, i, Lines: Integer;

  procedure OutputLine;
  begin
    LineBuf[LineBufPtr]:= #0;
    Status('Running HTML Help compiler ...', round(Lines/nFiles*100));
    log(LineBuf);
    LineBufPtr:= 0;
  end;

begin
  FillChar(StartupInfo,SizeOf(StartupInfo), 0);
  FillChar(ReadBuf, SizeOf(ReadBuf), 0);
  FillChar(SecurityAttributes, SizeOf(SecurityAttributes), 0);
  LineBufPtr:= 0;
  Lines:=0;
  with SecurityAttributes do begin
    nLength:= Sizeof(SecurityAttributes);
    bInheritHandle:= true
  end;
  if not CreatePipe(ReadHandle, WriteHandle, @SecurityAttributes, 0) then
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
      hStdOutput:= WriteHandle;
    end;

    if not CreateProcess(nil, PChar(CommandLine),
       nil, nil,
       true,
       CREATE_NO_WINDOW,
       nil,
       PChar(OutputPath),
       StartupInfo,
       ProcessInfo) then RaiseLastOSError;

    CloseHandle(ProcessInfo.hThread);
    CloseHandle(WriteHandle);
    try                                   
      while ReadFile(ReadHandle, ReadBuf, SizeOf(ReadBuf), BytesRead, nil) do begin
        for i:= 0 to BytesRead - 1 do begin
          if (ReadBuf[i] = LF) then begin
            Inc(Lines);
          end
          else if (ReadBuf[i] = #9) then begin
            LineBuf[LineBufPtr]:= ' ';
            Inc(LineBufPtr);
          end
          else if (ReadBuf[i] = CR) then begin
            OutputLine;
          end
          else begin
            LineBuf[LineBufPtr]:= ReadBuf[i];
            Inc(LineBufPtr);
            if LineBufPtr >= (SizeOf(LineBuf) - 1) then begin
              OutputLine;
            end
          end
        end
      end;
      WaitForSingleObject(ProcessInfo.hProcess, TerminationWaitTime);
      GetExitCodeProcess(ProcessInfo.hProcess, Result);
      OutputLine;
    finally
      CloseHandle(ProcessInfo.hProcess)
    end
  finally
    CloseHandle(ReadHandle)
  end
end;


end.
