{*******************************************************************************
  Name:
    ucpp
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    UC PreProcessor

  $Id: ucpp.dpr,v 1.7 2005-06-19 22:07:54 elmuerte Exp $
*******************************************************************************}

{
  UCPP - UnrealScript Code PreProcessor
  Copyright (C) 2005  Michiel Hendriks

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
program ucpp;

{$IFNDEF FPC}
{$APPTYPE CONSOLE}
{$ENDIF}

{$I ..\defines.inc}

uses
  SysUtils,
  Classes,
  unit_sourceparser in '..\unit_sourceparser.pas',
  unit_preprocessor in 'unit_preprocessor.pas',
  unit_pputils in 'unit_pputils.pas',
  unit_ucxinifiles in '..\unit_ucxinifiles.pas',
  unit_definitionlist in '..\unit_definitionlist.pas';

procedure printVersion();
begin
  writeln('UCPP Version '+UCPP_VERSION);
  writeln(UCPP_COPYRIGHT);
  writeln(UCPP_HOMEPAGE);
end;

procedure printLicense();
begin
  printVersion();
  writeln('');
  writeln('This program is free software; you can redistribute it and/or');
  writeln('modify it under the terms of the GNU Lesser General Public');
  writeln('License as published by the Free Software Foundation; either');
  writeln('version 2.1 of the License, or (at your option) any later version.');
  writeln('');
  writeln('This program is distributed in the hope that it will be useful,');
  writeln('but WITHOUT ANY WARRANTY; without even the implied warranty of');
  writeln('MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU');
  writeln('Lesser General Public License for more details.');
  writeln('');
  writeln('You should have received a copy of the GNU Lesser General Public');
  writeln('License along with this library; if not, write to the Free Software');
  writeln('Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA');
end;

procedure printHelp();
begin
  writeln('Usage:');
  writeln('  '+ParamStr(0)+' [switches] [settings] <name> <name> ... ');
  writeln('');
  writeln('  <name> is the name of a file or package, depeding on the mode.');
  writeln('');
  writeln('Switches (case sensitive):');
  writeln('  -?'#9'This message');
  writeln('  -D<name>=<value>'+#13#10+
                #9'Define a <name> with a <value>. This overrides the standards as'#13#10+
                #9'defined in the configuration file.');
  writeln('  -L'#9'Print the program''s license');
  writeln('  -undef'+#13#10+
                #9'Do not use predefinitions (like __FILE__).');
  writeln('  -P'#9'Enable package mode. The provided names are package names.'#13#10+
                #9'In package mode the base directory must be defined using'#13#10+
                #9'either the SYSTEM or BASE setting');
  writeln('  -U<name>'+#13#10+
                #9'Undefine <name>. Note: this has a lower precedence than'+#13#10+
                #9'definitions made in the file.');
  writeln('  -V'#9'Show the program version');
  writeln('  -wait'#9'Pause at the end of executiong when there where errors.');
  writeln('  -WAIT'#9'Always pause at the end of processing');
  writeln('');
  writeln('Settings are always in the format "<Key>=<Value>". The following');
  writeln('keys are accepted:');
  writeln('  BASE'#9#9'The base directory of the game. Required in'#13#10#9#9'Package Mode, unless SYSTEM is already given.');
  writeln('  CONFIG'#9'Alternate configuration file to use.');
  writeln('  MOD'#9#9'The mod name, as used in the enhanced mod'#13#10#9#9'architecture.');
  writeln('  SYSTEM'#9'The "System" directory of the game. Required in'#13#10#9#9'Package Mode, unless BASE is already given.');
end;

var
  i: integer;
  s1, s2: string;
  sl: TStringList;
  usePackages: boolean;
begin
  debug_mode := FindCmdLineSwitch('debug', ['-'], false);
  if (FindCmdLineSwitch('V', ['-'], false)) then begin
    printVersion();
    exit;
  end;
  if (FindCmdLineSwitch('L', ['-'], false)) then begin
    printLicense();
    exit;
  end;
  if (FindCmdLineSwitch('?', ['-'], false) or (ParamCount = 0)) then begin
    printHelp();
    exit;
  end;
  usePackages := FindCmdLineSwitch('P', ['-'], false);
  if (usePackages) then writeln('Package mode enabled');
  sl := TStringList.Create;
  try
    for i := 1 to ParamCount do begin
      s2 := ParamStr(i);
      if (Pos('-', s2) = 1) then begin
        if (Copy(s2, 1, 2) = '-D') then begin
          Delete(s2, 1, 2);
          s1 := GetToken(s2, '=');
          if (s1 <> '') then BaseDefs.define(s1, s2);
        end
        else if (Copy(s2, 1, 2) = '-U') then begin
          Delete(s2, 1, 2);
          if (s2 <> '') then BaseDefs.undefine(s2);
        end;
        continue; // is a switch
      end;
      if (Pos('=', s2) > 0) then begin
        s1 := GetToken(s2, '=');
        if (SameText(s1, 'SYSTEM')) then
          cfgBase := ExcludeTrailingPathDelimiter(ExtractFilePath(ExcludeTrailingPathDelimiter(s2)))
        else if (SameText(s1, 'MOD')) then cfgMod := s2
        else if (SameText(s1, 'BASE')) then cfgBase := ExcludeTrailingPathDelimiter(s2)
        else if (SameText(s1, 'CONFIG')) then cfgFile := ExpandFileName(s2);
      end
      else begin
        if (not usePackages) then begin
          s2 := ExpandFileName(s2);
          if (not FileExists(s2)) then begin
            ErrorMessage('File "'+s2+'" does not exist.');
            continue;
          end;
        end;
        sl.Add(s2)
      end;
    end;
    LoadConfiguration();

    if (cfgMod <> '') then cfgBase := cfgBase+PathDelim+cfgMod+PathDelim;
    if (sl.Count = 0) then begin
      ErrorMessage('No input files or packages');
    end;
    for i := 0 to sl.Count-1 do begin
      if (usePackages) then PreProcessDirectory(sl[i])
      else PreProcessFile(sl[i]);
    end;
  finally
    sl.Free;
  end;
  if (FindCmdLineSwitch('WAIT', ['-'], false) or
    (FindCmdLineSwitch('wait', ['-'], false) and (ErrorCount > 0))) then begin
    writeln('');
    writeln('--- done - press enter to continue ---');
    Readln(Input);
  end;
  if (ErrorCount > 0) then Halt(1); // maybe more error codes
end.
