unit unit_ucxcumain;

interface

uses
  Classes, SysUtils, IniFiles, unit_uclasses;

  procedure LoadConfig;
  procedure ProcessCommandline;
  procedure Main;
  procedure FatalError(msg: string; errorcode: integer = -1);
  procedure StatusReport(msg: string; progress: byte = 255);
  procedure Log(msg: string);
  procedure LogClass(msg: string; uclass: TUClass = nil);

var
  Verbose: byte = 1;
  ConfigFile: string;
  sourcepaths, packagepriority, ignorepackages: TStringList;
  // HTML output config:
  HTMLOutputDir, TemplateDir, HTMLTargetExt, CPPApp: string;
  TabsToSpaces: integer;
  // HTML Help config:
  HHCPath, HTMLHelpFile, HHTitle: string;

implementation

uses unit_packages, unit_ascii, unit_definitions, unit_analyse,
  unit_htmlout;

var
  PackageList: TUPackageList;
  ClassList: TUClassList;
  PhaseLabel, StatusFormat: string;

procedure LoadConfig;
var
  ini: TMemIniFile;
  tmp, tmp2: string;
  i: integer;
  sl: TStringList;
begin
  if (not FileExists(ConfigFile)) then FatalError('Config file does not exist: '+ConfigFile);
  ini := TMemIniFile.Create(ConfigFile);
  sl := TStringList.Create;
  try
    HTMLOutputDir := ini.ReadString('Config', 'HTMLOutputDir', ExtractFilePath(ParamStr(0))+'Output');
    TemplateDir := ini.ReadString('Config', 'TemplateDir', ExtractFilePath(ParamStr(0))+'Templates'+PATHDELIM+'UnrealWiki');
    HTMLTargetExt := ini.ReadString('Config', 'HTMLTargetExt', '');
    TabsToSpaces := ini.ReadInteger('Config', 'TabsToSpaces', 0);
    CPPApp := ini.ReadString('Config', 'CPP', '');
    HHCPath := ini.ReadString('Config', 'HHCPath', '');
    HTMLHelpFile := ini.ReadString('Config', 'HTMLHelpFile', ExtractFilePath(ParamStr(0))+'UnCodeX.chm');
    HHTitle := ini.ReadString('Config', 'HHTitle', '');

    { Unreal Packages }
    ini.ReadSectionValues('PackagePriority', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      tmp2 := Copy(tmp, 1, Pos('=', tmp));
      Delete(tmp, 1, Pos('=', tmp));
      if (LowerCase(tmp2) = 'packages=') then begin
        Log('Config: Package = '+tmp);
        PackagePriority.Add(LowerCase(tmp));
      end;
    end;
    // must be after Package= listing
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      tmp2 := Copy(tmp, 1, Pos('=', tmp));
      Delete(tmp, 1, Pos('=', tmp));
      if (LowerCase(tmp2) = 'tag=') then begin
        Log('Config: Tagged package = '+tmp);
        PackagePriority.Objects[PackagePriority.IndexOf(LowerCase(tmp))] := PackagePriority;
      end;
    end;
    ini.ReadSectionValues('IgnorePackages', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Config: Ignore = '+tmp);
      IgnorePackages.Add(LowerCase(tmp));
    end;
    { Unreal Packages -- END }
    { Source paths }
    ini.ReadSectionValues('SourcePaths', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Config: Path = '+tmp);
      SourcePaths.Add(LowerCase(tmp));
    end;
  finally
    sl.free;
    ini.Free;
  end;
end;

procedure ProcessCommandline;
begin

end;

procedure Main;
var
  ps: TPackageScanner;
  ca: TClassAnalyser;
  ho: THTMLOutput;
  hoc: THTMLoutConfig;
begin
  if (Verbose = 1) then StatusFormat := '%2d) %-20s : '
  else if (Verbose = 2) then StatusFormat := 'Phase %d)';

  PhaseLabel := format(StatusFormat, [1, 'Scanning packages']);
  ps := TPackageScanner.Create(sourcepaths, statusreport, PackageList, ClassList, packagepriority, ignorepackages);
  try
    ps.FreeOnTerminate := false;
    ps.Resume;
    ps.WaitFor;
  finally
    ps.Free;
  end;
  writeln('');

  PhaseLabel := format(StatusFormat, [2, 'Analyzing classes']);
  ca := TClassAnalyser.Create(ClassList, statusreport);
  try
    ca.FreeOnTerminate := false;
    ca.Resume;
    ca.WaitFor;
  finally
    ca.Free;
  end;
  writeln('');

  PhaseLabel := format(StatusFormat, [3, 'Creating HTML files']);
  hoc.PackageList := PackageList;
  hoc.ClassList := ClassList;
  hoc.outputdir := HTMLOutputDir;
  hoc.TemplateDir := TemplateDir;
  hoc.TabsToSpaces := TabsToSpaces;
  hoc.TargetExtention := TargetExtention;
  hoc.CPP := CPPApp;
  hoc.CreateSource := true;
  ho := THTMLOutput.Create(hoc, statusreport);
  try
    ho.FreeOnTerminate := false;
    ho.Resume;
    ho.WaitFor;
  finally
    ho.Free;
  end;
  writeln('');
end;

procedure FatalError(msg: string; errorcode: integer = -1);
begin
  writeln('');
  writeln('Fatal error:');
  writeln(#9+msg);
  Halt(errorcode);
end;

procedure StatusReport(msg: string; progress: byte = 255);
begin
  if (Verbose = 1) then DrawProgressBar(progress, 30, true, PhaseLabel)
  else if (Verbose = 2) then begin
    if (progress = 255) then Writeln(PhaseLabel+format(' ....', [progress])+' | '+msg)
    else Writeln(PhaseLabel+format(' %3d%%', [progress])+' | '+msg);
  end;
end;

procedure Log(msg: string);
begin
end;

procedure LogClass(msg: string; uclass: TUClass = nil);
begin
end;

initialization
  sourcepaths := TStringList.Create;
  packagepriority := TStringList.Create;
  ignorepackages := TStringList.Create;
  PackageList := TUPackageList.Create(true);
  ClassList := TUClassList.Create(false);
  unit_definitions.Log := Log;
  unit_definitions.LogClass := LogClass;
finalization
  sourcepaths.Free;
  packagepriority.Free;
  ignorepackages.Free;
  ClassList.Free;
  PackageList.Free;
end.
