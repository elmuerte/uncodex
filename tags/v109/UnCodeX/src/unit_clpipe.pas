{-----------------------------------------------------------------------------
 Unit Name: unit_clpipe
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Create a pipe with a commandline application
 $Id: unit_clpipe.pas,v 1.2 2003-06-10 12:00:18 elmuerte Exp $
-----------------------------------------------------------------------------}

unit unit_clpipe;

interface

uses
  SysUtils, Classes, Windows;

type
  TCLPipe = class(TObject)
  private
    CommandLine: string;
    buffer: array[0..1024] of char;
    c: char;

    StartupInfo:TStartupInfo;
    ProcessInfo:TProcessInformation;
    InRead,InWrite,OutRead,OutWrite:THandle;
    InStream: THandleStream;
    OutStream: THandleStream;
  public
    isOpen: boolean;
    constructor Create(inCommandLine: string);
    destructor Destroy; override;
    function Open: boolean;
    function Close: boolean;
    function Pipe(input: string): string;
  end;

implementation

constructor TCLPipe.Create(inCommandLine: string);
begin
  inherited Create;
  CommandLine := inCommandLine;
end;

destructor TCLPipe.Destroy;
begin
  if (isOpen) then Close;
  inherited Destroy;
end;

function TCLPipe.Open: boolean;
var
  TempHandle: THandle;
  sa: TSECURITYATTRIBUTES; 
begin
  result := true;
  FillChar(StartupInfo,SizeOf(StartupInfo), 0);
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := true;
  sa.lpSecurityDescriptor := nil;
  try
    if not CreatePipe(InRead, InWrite, @sa, 0) then RaiseLastOSError;
    if not CreatePipe(OutRead, OutWrite, @sa, 0) then RaiseLastOSError;

    if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
      if not SetHandleInformation(OutWrite, HANDLE_FLAG_INHERIT, 0) then RaiseLastOSError
    end
    else begin
      if not DuplicateHandle(GetCurrentProcess, OutRead, GetCurrentProcess, @TempHandle, 0, True, DUPLICATE_SAME_ACCESS) then RaiseLastOSError;
      CloseHandle(OutRead);
      OutRead := TempHandle;
    end;

    StartupInfo.cb := sizeof(tstartupinfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    StartupInfo.hStdInput := InRead;
    StartupInfo.hStdOutput := OutWrite;
    StartupInfo.wShowWindow := SW_HIDE;

    if not CreateProcess(nil, pchar(CommandLine), nil, nil, false, 0, nil, nil, StartupInfo, ProcessInfo) then begin
      CloseHandle(InWrite);
      CloseHandle(InRead);
      CloseHandle(OutWrite);
      CloseHandle(OutRead);
      result := false;
    end else
    begin
      OutStream := THandleStream.Create(OutRead);
      InStream := THandleStream.Create(InWrite);
      CloseHandle(InRead);
      CloseHandle(OutWrite);
      CloseHandle(ProcessInfo.hThread);
      isOpen := true;
    end;
  except
    result := false;
  end;
end;

function TCLPipe.Close: boolean;
begin
  result := true;
  if (isOpen) then begin
    try
      buffer := #26;
      InStream.Write(buffer, 1);
      InStream.Free;
      OutStream.Free;
      CloseHandle(OutRead);
      CloseHandle(InWrite);
      TerminateProcess(ProcessInfo.hProcess, 0);
      CloseHandle(ProcessInfo.hProcess);
      isOpen := false;
    except
      result := false;
    end;
  end;
end;

function TCLPipe.Pipe(input: string): string;
var
  i: Cardinal;
begin
  if (not isOpen) then begin
    result := input;
    exit;
  end;
  try
    while (Length(input) >= sizeof(buffer)) do begin
      StrPCopy(buffer, Copy(input, 1, sizeof(buffer)));
      Delete(input, 1, sizeof(buffer));
      InStream.Write(buffer, sizeof(buffer));
    end;
    StrPCopy(buffer, input);
    buffer[Length(input)] := #4;
    i := InStream.Write(buffer, Length(input)+1);
    result := '';
    while ((c <> #4) and (i > 0)) do begin
      i := OutStream.Read(c, 1);
      if ((c <> #4) and (i > 0)) then result := result+c;
    end;
  except
  end;
end;


end.
