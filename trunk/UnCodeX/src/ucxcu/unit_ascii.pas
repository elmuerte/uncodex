unit unit_ascii;

interface

uses
  SysUtils;

  procedure DrawProgressBar(progress: integer; size: integer = 20; showvalue: boolean = true; text: string = '');
  procedure PrintBanner;
  procedure PrintVersion;
  procedure PrintHelp;

  function HasCmdOption(opt: string): boolean;
  function CmdOption(opt: string; var output: string; offset: integer = 0): boolean;

implementation

uses unit_definitions;

const
  PB_BEGIN = '[';
  PB_END = ']';
  PB_DONE = #219; // full bock
  PB_TODO = #176; // 25% block
  PB_NONE = ' ';
  VERSION = '005 Alpha';

var
  lastsp: integer;

procedure DrawProgressBar(progress: integer; size: integer = 20; showvalue: boolean = true; text: string = '');
var
  sp: integer;
begin
  if (showvalue) then size := size - 5;
  if ((progress < 0) or (progress > 100)) then exit;
  sp := round(progress / (100 / size));
  if (sp = lastsp) then exit;
  write(#13+text);
  write(PB_BEGIN);
  write(StrRepeat(PB_DONE, sp));
  write(StrRepeat(PB_TODO, size - sp));
  write(PB_END);
  if (showvalue) then write(format(' %3d%%', [progress]));
end;

procedure PrintBanner;
begin
  writeln('------------------------------------------------------------');
  writeln(' UnCodeX Commandline Utility (ucxcu) version '+VERSION);
  writeln(' (c) 2003 Michiel ''El Muerte'' Hendriks');
  writeln(' http://wiki.beyondunreal.com/wiki/UnCodeX');
  writeln('------------------------------------------------------------');
  writeln('');
end;

procedure PrintVersion;
begin
  writeln('ucxcu version '+VERSION);
end;

procedure PrintHelp;
begin
  writeln('Accepted commandline switches:');
  writeln(#9'-c <filename>'   +#9'Set configuration file (uncodex.ini used by default)');
  writeln(#9'-h'#9            +#9'This message');
  writeln(#9'-m'#9			      +#9'Create MS HTML Help file');
  writeln(#9'-mc <path>'      +#9'Path to the MS HTML Help compiler');
  writeln(#9'-me'#9           +#9'Delete HTML output directory after the MS HTML Help');
  writeln(#9#9                +#9'has been created');
  writeln(#9'-mo <filename>'  +#9'MS HTML Help output filename. If this is not set');
  writeln(#9#9                +#9'no MS HTML HELP file will be generated');
  writeln(#9'-nc'#9           +#9'Don''t read the configuration file');
  writeln(#9'-o <path>'       +#9'Output directory for the HTML files');
  writeln(#9'-p <...>'        +#9'Comma seperated list of package names (exclusive)');
  writeln(#9'-pa <...>'       +#9'Comma seperated list of package names (additional)');
  writeln(#9'-s <path>'       +#9'Source path (multiple allowed)');
  writeln(#9'-t <path>'       +#9'Path to the template directory');
  writeln(#9'-uc <filename>'  +#9'UnrealEngine system ini file');
  writeln(#9'-v'#9            +#9'Be verbose (default)');
  writeln(#9'-vv'#9           +#9'Be very verbose');
  writeln(#9'-V'#9            +#9'Print version and quit');
  writeln(#9'-q'#9            +#9'Be quite');

  writeln('');
  writeln('Commandline switches will override settings defined in the');
  writeln('configuration file, unless noted otherwise.');
end;

function HasCmdOption(opt: string): boolean;
begin
  result := FindCmdLineSwitch(opt, ['-'], false);
end;

function CmdOption(opt: string; var output: string; offset: integer = 0): boolean;
var
  i: integer;
begin
  i := 1;
  while (i < ParamCount) do begin
    if (ParamStr(i) = '-'+opt) then begin
      Inc(i);
      if (offset > 0) then begin
        Dec(offset);
      end
      else begin
        output := ParamStr(i);
        result := true;
        exit;
      end;
    end;
    Inc(i);
  end;
  result := false;
end;

end.
