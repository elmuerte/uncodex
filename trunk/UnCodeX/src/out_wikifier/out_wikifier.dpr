library out_wikifier;

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
  unit_uclasses in '..\unit_uclasses.pas',
  unit_outputdefs in '..\unit_outputdefs.pas',
  unit_wiki in 'unit_wiki.pas' {frm_Wikifier};

{$R *.res}

// return true if succesfull
function UCX_Details(var Info: TUCXOutputDetails): boolean; stdcall
begin
  Info.AName := 'Class Wikifier';
  Info.ADescription := 'Converts the class details to UnrealWiki source';
  Info.ASingleClass := true;
  result := true;
end;

// return true if succesfull
function UCX_Output(var Info: TUCXOutputInfo): boolean; stdcall
begin
  if (info.ASelectedClass <> nil) then begin
    frm_Wikifier := Tfrm_Wikifier.Create(nil);
    frm_Wikifier.Wikify(info.ASelectedClass);
    frm_Wikifier.ShowModal;
    frm_Wikifier.Free;
  end;
  info.WaitForTerminate := false;
  result := true;
end;

exports
  UCX_Output,
  UCX_Details;

begin
end.
 