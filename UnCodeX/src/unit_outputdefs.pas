unit unit_outputdefs;

interface

uses
  Classes, unit_uclasses;

type
  TStatusReport = procedure(msg: string; progress: byte = 255) of Object;

  TUCXOutputInfo = record
    // input
    AClassList: TUClassList;
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
  end;

  TUCX_Output = function(var Info: TUCXOutputInfo): boolean; stdcall;
  TUCX_Details = function(var Info: TUCXOutputDetails): boolean; stdcall;

implementation

end.
