{-----------------------------------------------------------------------------
 Unit Name: unit_graphviz
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   create a dot file
-----------------------------------------------------------------------------}

library out_graphviz;

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
  FastShareMem in '..\FastShareMem.pas',
  SysUtils,
  Classes,
  unit_uclasses in '..\unit_uclasses.pas',
  unit_outputdefs in '..\unit_outputdefs.pas',
  unit_selector in 'unit_selector.pas' {frm_GraphViz},
  unit_deplist in 'unit_deplist.pas';

const
  VERSION = '009 Beta';

{$R *.res}

// return true if succesfull
function UCX_Details(var Info: TUCXOutputDetails): boolean; stdcall
begin
  Info.AName := 'GraphViz';
  Info.ADescription := 'Create a DOT file to be used with GraphViz (version '+VERSION+')';
  Info.ASingleClass := false;
  result := true;
end;

// return true if succesfull
function UCX_Output(var Info: TUCXOutputInfo): boolean; stdcall
begin
  frm_GraphViz := Tfrm_GraphViz.Create(nil);
  frm_GraphViz.GInfo := info;
  frm_GraphViz.Init;
  frm_GraphViz.ShowModal;
  frm_GraphViz.Free;
  Info.WaitForTerminate := false;
  result := false;
end;

exports
  UCX_Output,
  UCX_Details;

begin
end.
 