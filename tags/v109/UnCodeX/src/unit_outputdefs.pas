{-----------------------------------------------------------------------------
 Unit Name: unit_outputdefs
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Definitions used from custom output modules
 $Id: unit_outputdefs.pas,v 1.6 2003-06-10 12:00:22 elmuerte Exp $
-----------------------------------------------------------------------------}

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
