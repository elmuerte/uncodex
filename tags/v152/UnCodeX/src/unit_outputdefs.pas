{-----------------------------------------------------------------------------
 Unit Name: unit_outputdefs
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Definitions used from custom output modules
 $Id: unit_outputdefs.pas,v 1.7 2003-11-04 19:35:27 elmuerte Exp $
-----------------------------------------------------------------------------}
{
    UnCodeX - UnrealScript source browser & documenter
    Copyright (C) 2003  Michiel Hendriks

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

interface

uses
  Classes, unit_uclasses;

type
  TStatusReport = procedure(msg: string; progress: byte = 255);

  TUCXOutputInfo = record
    // input
    AClassList: TUClassList;
    ASelectedClass: TUClass; // only used if ASingleClass = true
    APackageList: TUPackageList;
    AStatusReport: TStatusReport;
    AThreadTerminated: TNotifyEvent;
    // output
    AThread: TThread;
    WaitForTerminate: boolean; // use AThreadTerminated to signal an end
  end;

  TUCXOutputDetails = record
    AName: string;
    ADescription: string;
    ASingleClass: boolean; // selected class only output
  end;

  TUCX_Output = function(var Info: TUCXOutputInfo): boolean; stdcall;
  TUCX_Details = function(var Info: TUCXOutputDetails): boolean; stdcall;

implementation

end.