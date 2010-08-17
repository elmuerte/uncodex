{*******************************************************************************
  Name:
    unit_outputdefs.dpr
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Definitions shared between the main application and custom output
    modules.

  $Id: unit_outputdefs.pas,v 1.17 2005/04/23 20:24:27 elmuerte Exp $
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

unit unit_outputdefs;

{$I defines.inc}

interface

uses
  Classes, unit_uclasses;

type
  TStatusReport = procedure(msg: string; progress: byte = 255);
  TStatusReportMethod = procedure(msg: string; progress: byte = 255) of object;

  TUCXOutputInfo = record
    // input
    AClassList: TUClassList;
    ASelectedClass: TUClass; // only used if ASingleClass = true
    APackageList: TUPackageList;
    AStatusReport: TStatusReportMethod;
    AThreadTerminated: TNotifyEvent;
    ABatching: boolean; // true when the module is called from a batch
    ASingleClass: boolean; // true when it's called from a single class
    // output
    AThread: TThread;
    WaitForTerminate: boolean; // use AThreadTerminated to signal an end
  end;

  TUCXOutputDetails = record
    AName: string;
    ADescription: string;
    ASingleClass: boolean; // selected class only output
    AMultipleClass: boolean; // for multiple
  end;

  TUCX_Output = function(var Info: TUCXOutputInfo): boolean; stdcall;
  TUCX_Details = function(var Info: TUCXOutputDetails): boolean; stdcall;

  // return the UCLASSES_REV value as compile
  // no need to implement this function
  TUCX_UClassesRev = function(): LongInt; stdcall;

implementation

function UCX_UClassesRev(): LongInt; stdcall;
begin
  result := unit_uclasses.UCLASSES_REV;
end;

{$IFNDEF NO_EXPORT}
exports
  UCX_UClassesRev;
{$ENDIF}
end.
