program ucxc;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  unit_uclasses in '..\unit_uclasses.pas',
  unit_analyse in '..\unit_analyse.pas',
  unit_copyparser in '..\unit_copyparser.pas',
  unit_definitions in '..\unit_definitions.pas',
  unit_htmlout in '..\unit_htmlout.pas',
  unit_outputdefs in '..\unit_outputdefs.pas',
  unit_packages in '..\unit_packages.pas',
  unit_parser in '..\unit_parser.pas',
  unit_sourceparser in '..\unit_sourceparser.pas',
  Hashes in '..\Hashes.pas';

const
  UCXC_VERSION = '001 Beta';

// Display --help / -?
procedure optHelp();
begin
  writeln(' -help             this message');
  writeln(' -id <path>        use <path> as an input dir');
  writeln(' -ini <filename>   use <filename> as configuration');
  writeln(' -od <path>        set the output path to <path>');
  writeln(' -?                this message');
end;

begin
  writeln('-------------------------------------------------');
  writeln('  UnCodeX Commandline Edition version '+UCXC_VERSION);
  writeln('  (c) 2003 Michiel ''El Muerte'' Hendriks ');
  writeln('  http://wiki.beyondunreal.com/wiki/UnCodeX ');
  writeln('-------------------------------------------------');
  writeln('');
  if (FindCmdLineSwitch('help', ['-'], true) or
      FindCmdLineSwitch('?', ['-'], true)) then optHelp()
  else if (ParamCount = 0) then
    writeln(' Use '''+ExtractFilename(ParamStr(0))+' -help'' for help')
  else begin

  end;
end.
