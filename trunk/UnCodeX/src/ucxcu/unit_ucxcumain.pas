unit unit_ucxcumain;

interface

uses
  SysUtils, IniFiles;

  procedure LoadConfig;
  procedure ProcessCommandline;
  procedure Main;
  procedure FatalError(msg: string; errorcode: integer = -1);

var
  Verbose: byte = 1;
  ConfigFile: string;

implementation

procedure LoadConfig;
var
  ini: TMemIniFile;
begin
  if (not FileExists(ConfigFile)) then FatalError('Config file does not exist: '+ConfigFile);
  ini := TMemIniFile.Create(ConfigFile);
  try

  finally
    ini.Free;
  end;
end;

procedure ProcessCommandline;
begin

end;

procedure Main;
begin

end;

procedure FatalError(msg: string; errorcode: integer = -1);
begin
  writeln('');
  writeln('Fatal error:');
  writeln(#9+msg);
  Halt(errorcode);
end;

end.
