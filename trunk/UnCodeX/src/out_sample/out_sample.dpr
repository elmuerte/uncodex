{-----------------------------------------------------------------------------
 Unit Name: out_sample
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Custom output sample
-----------------------------------------------------------------------------}

library out_sample;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  SysUtils,
  Classes,
  Windows,
  unit_uclasses in '..\unit_uclasses.pas',
  unit_outputdefs in '..\unit_outputdefs.pas',
  unit_sample in 'unit_sample.pas' {frm_OutputSample};

{$R *.res}

// return true if succesfull
function UCX_Details(var Info: TUCXOutputDetails): boolean; stdcall
begin
  Info.AName := 'Sample output';
  Info.ADescription := 'A sample output module';
  Info.ASingleClass := false;
  result := true;
end;

// return true if succesfull
function UCX_Output(var Info: TUCXOutputInfo): boolean; stdcall
var
  i: integer;
begin
  frm_OutputSample := Tfrm_OutputSample.Create(nil);
  with frm_OutputSample do begin
    for i := 0 to info.APackageList.Count-1 do begin
      lb_Packages.Items.Add(info.APackageList[i].name);
    end;
    for i := 0 to info.AClassList.Count-1 do begin
      lb_Classes.Items.Add(info.AClassList[i].name);
    end;
    frm_OutputSample.ShowModal;
    frm_OutputSample.Free;
  end;
  Info.WaitForTerminate := false;
  result := false;
end;

exports
  UCX_Output,
  UCX_Details;

begin
end.
