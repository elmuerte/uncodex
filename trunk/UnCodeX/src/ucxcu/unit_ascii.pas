{*******************************************************************************
	Name:
        unit_ascii.pas
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        General commandline routines

    $Id: unit_ascii.pas,v 1.12 2004-10-18 15:36:10 elmuerte Exp $
*******************************************************************************}
{
    UnCodeX - UnrealScript source browser & documenter
    Copyright (C) 2003, 2004  Michiel Hendriks

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit unit_ascii;

{$I ../defines.inc}

interface

uses
	SysUtils;

	procedure DrawProgressBar(progress: integer; size: integer = 20; showvalue: boolean = true; text: string = '');
	procedure PrintBanner;
	procedure PrintVersion;
	procedure PrintHelp;

	function HasCmdOption(opt: string): boolean;
	function CmdOption(opt: string; var output: string; offset: integer = 0): boolean;

	procedure RecurseDelete(dirname: string);

implementation

uses unit_definitions;

const
	PB_BEGIN 	= '[';
	PB_END 		= ']';
	{$IFDEF MSWINDOWS}
	PB_RESET 	= #13;
	PB_DONE 	= #219; // full bock
	PB_HALF 	= #178; // 50% block
	PB_TODO 	= #176; // 25% block
	{$ENDIF}
	{$IFDEF LINUX}
	PB_RESET 	= #13;
	PB_DONE 	= '='; // full bock
	PB_HALF 	= '-'; // 50% block
	PB_TODO 	= '.'; // 25% block
	{$ENDIF}
	PB_NONE 	= ' ';
	VERSION 	= '012 Beta';

var
	lastsp: integer = -1;
	lasthalf: byte = 0;

procedure DrawProgressBar(progress: integer; size: integer = 20; showvalue: boolean = true; text: string = '');
var
	sp: 	integer;
	half: 	integer;
begin
	if (showvalue) then size := size - 5;
	if ((progress < 0) or (progress > 100)) then exit;
	sp := trunc(progress / (100 / size));
	half := round(progress / (100 / size))-sp;
	if ((sp = lastsp) and (half = lasthalf)) then exit;
	lastsp := sp;
	lasthalf := half;
	write(PB_RESET+text);
	write(PB_BEGIN);
	write(StrRepeat(PB_DONE, sp));
	if (half > 0) then write(PB_HALF);
	write(StrRepeat(PB_TODO, size - sp - half));
	write(PB_END);
	if (showvalue) then write(format(' %3d%%', [progress]));
end;

procedure PrintBanner;
begin
	writeln('------------------------------------------------------------');
	writeln(' UnCodeX Commandline Utility (ucxcu) version '+VERSION);
	writeln(' Engine version: '+APPTITLE+' '+APPVERSION+' '+APPPLATFORM);
	writeln(' (c) 2003, 2004 Michiel ''El Muerte'' Hendriks');
	writeln(' http://wiki.beyondunreal.com/wiki/UnCodeX');
	writeln('------------------------------------------------------------');
	writeln('');
end;

procedure PrintVersion;
begin
	writeln('ucxcu version:	'+VERSION);
	writeln('engine version: '+APPTITLE+' '+APPVERSION+' '+APPPLATFORM);
end;

procedure PrintHelp;
begin
	writeln('Accepted commandline switches:');
	writeln(#9'-c <filename>'	 +#9'Set configuration file (uncodex.ini used by default)');
	writeln(#9'-d <filename>'	 +#9'Package description file');
	writeln(#9'-e <filename>'	 +#9'External comment file');
	writeln(#9'-h'#9						+#9'This message');
	writeln(#9'-l <filename>'	 +#9'Log to file <filename>, logging disablled by default');
	writeln(#9'-m'#9						+#9'Create MS HTML Help file');
	writeln(#9'-mc <path>'			+#9'Path to the MS HTML Help compiler');
	writeln(#9'-me'#9					 +#9'Delete HTML output directory after the MS HTML Help');
	writeln(#9#9								+#9'has been created');
	writeln(#9'-mo <filename>'	+#9'MS HTML Help output filename. If this is not set');
	writeln(#9#9								+#9'no MS HTML HELP file will be generated');
	writeln(#9'-nc'#9					 +#9'Don''t read the configuration file');
	writeln(#9'-o <path>'			 +#9'Output directory for the HTML files');
	writeln(#9'-p <...>'				+#9'Comma seperated list of package names (exclusive)');
	writeln(#9'-pa <...>'			 +#9'Comma seperated list of package names (additional)');
	writeln(#9'-s <path>'			 +#9'Source path (multiple allowed)');
	writeln(#9'-t <path>'			 +#9'Path to the template directory');
	writeln(#9'-uc <filename>'	+#9'UnrealEngine system ini file');
	writeln(#9'-v'#9						+#9'Be verbose (default)');
	writeln(#9'-vv'#9					 +#9'Be very verbose');
	writeln(#9'-V'#9						+#9'Print version and quit');
	writeln(#9'-q'#9						+#9'Be quite');

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

procedure RecurseDelete(dirname: string);
var
	sr: TSearchRec;
begin
	dirname := ExcludeTrailingPathDelimiter(dirname);
	if (not DirectoryExists(dirname)) then exit;
	if (FindFirst(dirname+PathDelim+WILDCARD, faAnyFile, sr) = 0) then begin
		repeat
			if (sr.Attr and faDirectory <> 0) then begin
				if ((sr.Name <> '.') and (sr.Name <> '..')) then begin
					RecurseDelete(dirname+PathDelim+sr.Name);
				end;
			end
			else begin
				Log('Deleting file: '+dirname+PathDelim+sr.Name);
				DeleteFile(dirname+PathDelim+sr.Name)
			end;
		until (FindNext(sr) <> 0);
		FindClose(sr);
	end;
	Log('Deleting dir: '+dirname);
	RemoveDir(dirname);
end;

end.
