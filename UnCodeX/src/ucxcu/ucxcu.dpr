program ucxcu;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  unit_clpipe in '../unit_clpipe.pas',
  unit_copyparser in '../unit_copyparser.pas',
  unit_definitions in '../unit_definitions.pas',
  unit_htmlout in '../unit_htmlout.pas',
  {$IFDEF MSWINDOWS}
  unit_mshtmlhelp in '../unit_mshtmlhelp.pas',
  {$ENDIF}
  {$IFDEF LINUX}
  Libc,
  {$ENDIF}
  unit_outputdefs in '../unit_outputdefs.pas',
  unit_packages in '../unit_packages.pas',
  unit_parser in '../unit_parser.pas',
  unit_sourceparser in '../unit_sourceparser.pas',
  unit_uclasses in '../unit_uclasses.pas',
  unit_analyse in '../unit_analyse.pas',
  Hashes in '../Hashes.pas',
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
 