{*******************************************************************************
    Name:
        ucxcu.pas
    Author(s):
        Michiel 'El Muerte' Hendriks
    Purpose:
        UnCodeX Commandline Utility Client

    $Id: ucxcu.dpr,v 1.12 2004-11-20 12:18:44 elmuerte Exp $
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
program ucxcu;

{$IFDEF MSWINDOWS}
{$APPTYPE CONSOLE}
{$ENDIF}

{$I ..\defines.inc}

uses
  SysUtils,
  {$IFDEF FPC}
  unit_fpc_compat in '..\unit_fpc_compat.pas',
  {$ENDIF}
  unit_clpipe in '..\unit_clpipe.pas',
  unit_copyparser in '..\unit_copyparser.pas',
  unit_definitions in '..\unit_definitions.pas',
  unit_htmlout in '..\unit_htmlout.pas',
  {$IFDEF MSWINDOWS}
  unit_mshtmlhelp in '..\unit_mshtmlhelp.pas',
  {$ENDIF}
  {$IFDEF LINUX}
  Libc,
  {$ENDIF}
  unit_outputdefs in '..\unit_outputdefs.pas',
  unit_packages in '..\unit_packages.pas',
  unit_parser in '..\unit_parser.pas',
  unit_sourceparser in '..\unit_sourceparser.pas',
  unit_uclasses in '..\unit_uclasses.pas',
  unit_analyse in '..\unit_analyse.pas',
  Hashes in '..\Hashes.pas',
  unit_ascii in 'unit_ascii.pas',
  unit_ucxcumain in 'unit_ucxcumain.pas';

begin
  if (HasCmdOption('V')) then PrintVersion
  else begin
    if (HasCmdOption('q')) then Verbose := 0
    else if (HasCmdOption('v')) then Verbose := 1
    else if (HasCmdOption('vv')) then Verbose := 2;

    if (Verbose > 0) then PrintBanner;
    if (HasCmdOption('h')) then PrintHelp
    else begin
      {$IFDEF LINUX}
      signal(SIGINT, SigProc);
      signal(SIGABRT, SigProc);
      {$ENDIF}
    	HTMLOutputDir := ExtractFilePath(ExpandFileName(ParamStr(0)))+'Output';
    	TemplateDir := ExtractFilePath(ExpandFileName(ParamStr(0)))+TEMPLATEPATH+PATHDELIM+DEFTEMPLATE;
    	HTMLHelpFile := ExtractFilePath(ExpandFileName(ParamStr(0)))+'UnCodeX.chm';
      PackageDescFile := iFindFile(ExtractFilePath(ExpandFileName(ParamStr(0)))+DEFAULTPDF);
      ExtCommentFile := iFindFile(ExtractFilePath(ExpandFileName(ParamStr(0)))+DEFAULTECF);

      ConfigFile := ExtractFilePath(ParamStr(0)) + 'UnCodeX.ini';
      CmdOption('c', ConfigFile);
      ConfigFile := iFindFile(ConfigFile);
      if (not HasCmdOption('nc')) then LoadConfig();
      ProcessCommandline();
      Main();
    end;
  end;
end.
 