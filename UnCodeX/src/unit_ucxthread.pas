{*******************************************************************************
  Name:
    unit_ucxthread.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Base class for all threads used in uncodex, used for more thread safety

  $Id: unit_ucxthread.pas,v 1.2 2005-04-18 15:48:56 elmuerte Exp $
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
unit unit_ucxthread;

{$I defines.inc}

interface

uses
  Classes, unit_uclasses, unit_definitions;

type
  {$IFDEF NO_THREADS}
  TBaseUCXThread = class
  protected
    FCreateSuspended: Boolean;
    FTerminated: Boolean;
    FReturnValue: Integer;
    FOnTerminate: TNotifyEvent;
    FFreeOnTerminate: Boolean;
    procedure Execute; virtual; abstract;
    property ReturnValue: Integer read FReturnValue write FReturnValue;
    property Terminated: Boolean read FTerminated;
  public
    constructor Create(CreateSuspended: Boolean);
    procedure AfterConstruction; override;
    procedure Resume;
    procedure Terminate;
    property OnTerminate: TNotifyEvent read FOnTerminate write FOnTerminate;
    // has no effect
    property FreeOnTerminate: boolean read FFreeOnTerminate write FFreeOnTerminate;
  end;
  {$ELSE}
  TBaseUCXThread = class(TThread)
  end;
  {$ENDIF}

  TUCXThread = class(TBaseUCXThread)
  protected
    GuardStack: TStringList;
    FLog: TLogProcEX;
    procedure guard(s: string);
    procedure unguard;
    procedure resetguard();
    procedure printguard(uclass: TUClass = nil);
    procedure InternalLog(msg: string; mt: TLogType = ltInfo; obj: TObject = nil);
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    property Log: TLogProcEX read FLog write FLog;
  end;

implementation

uses
  SysUtils;

{ TBaseUCXThread }
{$IFDEF NO_THREADS}
constructor TBaseUCXThread.Create(CreateSuspended: Boolean);
begin
  inherited Create;
  FCreateSuspended := CreateSuspended;
end;

procedure TBaseUCXThread.AfterConstruction;
begin
  if not FCreateSuspended then Resume;
end;

procedure TBaseUCXThread.Resume;
begin
  Execute;
  if Assigned(FOnTerminate) then FOnTerminate(Self);
end;

procedure TBaseUCXThread.Terminate;
begin
  FTerminated := True;
end;
{$ENDIF}

{ TUCXThread }

constructor TUCXThread.Create(CreateSuspended: Boolean);
begin
  GuardStack := TStringList.Create;
  GuardStack.Sorted := false;
  GuardStack.Duplicates := dupIgnore;
  Log := unit_definitions.Log; // set default
  inherited Create(CreateSuspended);
end;

destructor TUCXThread.Destroy;
begin
  FreeAndNil(GuardStack);
  inherited Destroy;
end;

procedure TUCXThread.InternalLog(msg: string; mt: TLogType = ltInfo; obj: TObject = nil);
begin
  if (Assigned(FLog)) then FLog(msg, mt, obj);
end;

procedure TUCXThread.guard(s: string);
begin
  GuardStack.Append(s);
end;

procedure TUCXThread.unguard;
begin
  GuardStack.Delete(GuardStack.Count-1);
end;

procedure TUCXThread.resetguard();
begin
  GuardStack.Clear;
end;

procedure TUCXThread.printguard(uclass: TUClass = nil);
var
  j: integer;
begin
  InternalLog('History:', ltError);
  for j := 0 to GuardStack.Count-1 do begin
    if (uclass = nil) then InternalLog('  '+GuardStack[j], ltError)
    else InternalLog('  '+GuardStack[j], ltError, CreateLogEntry(uclass));
  end;
end;

end.
