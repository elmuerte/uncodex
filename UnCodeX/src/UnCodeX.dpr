program UnCodeX;

uses
  Forms,
  unit_main in 'unit_main.pas' {frm_UnCodeX},
  unit_packages in 'unit_packages.pas',
  unit_parser in 'unit_parser.pas',
  unit_htmlout in 'unit_htmlout.pas',
  unit_uclasses in 'unit_uclasses.pas',
  unit_settings in 'unit_settings.pas' {frm_Settings},
  unit_definitions in 'unit_definitions.pas',
  unit_analyse in 'unit_analyse.pas',
  unit_copyparser in 'unit_copyparser.pas',
  Hashes in 'Hashes.pas',
  unit_treestate in 'unit_treestate.pas',
  unit_about in 'unit_about.pas' {frm_About},
  unit_mshtmlhelp in 'unit_mshtmlhelp.pas',
  unit_fulltextsearch in 'unit_fulltextsearch.pas',
  RegExpr in 'RegExpr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'UnCodeX';
  Application.CreateForm(Tfrm_UnCodeX, frm_UnCodeX);
  Application.CreateForm(Tfrm_About, frm_About);
  Application.Run;
end.
