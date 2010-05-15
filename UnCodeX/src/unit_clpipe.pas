{*******************************************************************************
  Name:
    unit_clpipe.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    I\O Pipe for capturing commandline applications

  $Id: unit_clpipe.pas,v 1.11 2004/12/08 09:25:37 elmuerte Exp $
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
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.   See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA   02111-1307  USA
}

unit unit_clpipe;

{$I defines.inc}

interface

uses
  SysUtils, Classes
  {$IFDEF MSWINDOWS}
  , Windows
  {$ENDIF};

type
  TCLPipe = class(TObject)
  private
    CommandLine: string;
    buffer: array[0..1024] of char;
    c: char;
    {$IFDEF MSWINDOWS}
    StartupInfo:TStartupInfo;
    ProcessInfo:TProcessInformation;
    {$ENDIF}
    InRead,InWrite,OutRead,OutWrite,ErrOutR,ErrOutW:THandle;
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

{$IFDEF MSWINDOWS}
function TCLPipe.Open: boolean;
var
  TempHandle: THandle;
  sa: TSECURITYATTRIBUTES;
  sd: TSECURITYDESCRIPTOR;
begin
  result := true;
  FillChar(StartupInfo,SizeOf(StartupInfo), 0);
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := true;
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
    InitializeSecurityDescriptor(@sd, SECURITY_DESCRIPTOR_REVISION);
    SetSecurityDescriptorDacl(@sd, true, nil, false);
    sa.lpSecurityDescriptor := @sd;
  end
  else sa.lpSecurityDescriptor := nil;
  try
    if not CreatePipe(InRead, InWrite, @sa, 1) then RaiseLastOSError;
    if not CreatePipe(OutRead, OutWrite, @sa, 1) then RaiseLastOSError;
    if not CreatePipe(ErrOutR, ErrOutW, @sa, 1) then RaiseLastOSError;

    if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
      if not SetHandleInformation(OutRead, HANDLE_FLAG_INHERIT, 0) then RaiseLastOSError;
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
    StartupInfo.hStdError := ErrOutR;
    StartupInfo.wShowWindow := SW_HIDE;

    if not CreateProcess(nil, pchar(CommandLine), nil, nil, true, CREATE_NEW_CONSOLE, nil, nil, StartupInfo, ProcessInfo) then begin
      CloseHandle(InWrite);
      CloseHandle(InRead);
      CloseHandle(OutWrite);
      CloseHandle(OutRead);
      CloseHandle(ErrOutR);
      CloseHandle(ErrOutW);
      result := false;
    end else
    begin
      OutStream := THandleStream.Create(OutRead);
      InStream := THandleStream.Create(InWrite);
      CloseHandle(InRead);
      CloseHandle(OutWrite);
      CloseHandle(ErrOutR);
      CloseHandle(ErrOutW);
      CloseHandle(ProcessInfo.hThread);
      isOpen := true;
    end;
  except
    result := false;
  end;
end;
{$ENDIF}

{$IFDEF LINUX}
function TCLPipe.Open: boolean;
begin
{$MESSAGE Warn 'TODO: implement TCLPipe'}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
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
{$ENDIF}

{$IFDEF LINUX}
function TCLPipe.Close: boolean;
begin
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function TCLPipe.Pipe(input: string): string;
var
  i: Cardinal;
begin
  if (not isOpen) then begin
    result := input;
    exit;
  end;
  try
    FillChar(buffer, sizeof(buffer), 0);
    while (Length(input) >= sizeof(buffer)) do begin
      StrPCopy(buffer, Copy(input, 1, sizeof(buffer)));
      Delete(input, 1, sizeof(buffer));
      InStream.Write(buffer, sizeof(buffer));
    end;
    StrPCopy(buffer, input);
    buffer[Length(input)] := #4;
    InStream.Write(buffer, Length(input)+1);
    result := '';
    c := #0;
    while (c <> #4) do begin
      i := OutStream.Read(c, 1);
      if ((c <> #4) and (i > 0)) then result := result+c;
    end;
  except
  end;
end;
{$ENDIF}

{$IFDEF LINUX}
function TCLPipe.Pipe(input: string): string;
begin
end;
{$ENDIF}

end.

