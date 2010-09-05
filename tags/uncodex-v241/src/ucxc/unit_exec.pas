{-----------------------------------------------------------------------------
 Unit Name: unit_exec
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   main execution of the commandline edition
-----------------------------------------------------------------------------}

unit unit_exec;

interface

uses
  unit_uclasses;

  procedure optMain();
  procedure Log(msg: string);
  procedure LogClass(msg: string; uclass: TUClass = nil);

implementation

uses
  IniFiles, SysUtils, Classes, unit_definitions, unit_packages, unit_bogus,
  windows;

var
  ConfigFile: string;
  OutputDir: string;
  TemplateDir: string;
  Verbose: integer = 0;
  PackagePriority: TStringList;
  SourcePaths: TStringList;
  IgnorePackages: TStringList;
  ClassList: TUClassList;
  PackageList: TUPackageList;

procedure Log(msg: string);
begin
  writeln(msg);
end;

procedure LogClass(msg: string; uclass: TUClass = nil);
begin

end;

procedure StatusReport(msg: string; progress: byte = 255);
begin
  if (progress <> 255) then begin
    if (verbose = 0) then write('.')
    else if (verbose = 1) then writeln('['+format('%.3d%%', [progress])+'] '+msg)
    else if (verbose = 2) then writeln('['+format('%.3d%%', [progress])+'] '+msg)
  end
  else if (verbose = 2) then writeln('['+format('    ', [progress])+'] '+msg)
end;

procedure optMain();
var
  ini: TMemIniFile;
  i: integer;
  sl: TStringList;
  tmp, tmp2: string;
  trd: TThread;
begin
  PackagePriority := TStringList.Create;
  SourcePaths := TStringList.Create;
  IgnorePackages := TStringList.Create;
  frm_Bogus := Tfrm_Bogus.Create(nil);
  ClassList := TUClassList.Create(false);
  PackageList := TUPackageList.Create(true);

  // locate config file to use
  ConfigFile := ExtractFilePath(ParamStr(0))+'UnCodeX.ini';
  for i := 1 to ParamCount-1 do begin
    if (CompareText('-ini', ParamStr(i)) = 0) then begin
      if (ParamCount > i+1) then ConfigFile := ParamStr(i+1);
    end;
  end;
  if (ExtractFilePath(ConfigFile) = '') then ConfigFile := ExtractFilePath(ParamStr(0))+configfile;
  if (FileExists(ConfigFile)) then begin
    ini := TMemIniFile.Create(ConfigFile);
    sl := TStringList.Create;
    try
      OutputDir := ini.ReadString('Config', 'HTMLOutputDir', ExtractFilePath(ParamStr(0))+'Output');
      TemplateDir := ini.ReadString('Config', 'TemplateDir', ExtractFilePath(ParamStr(0))+'Templates'+PATHDELIM+'UnrealWiki');

      // TODO
      {HTMLTargetExt := ini.ReadString('Config', 'HTMLTargetExt', '');
      HHCPath := ini.ReadString('Config', 'HHCPath', '');
      HTMLHelpFile := ini.ReadString('Config', 'HTMLHelpFile', ExtractFilePath(ParamStr(0))+'UnCodeX.chm');
      HHTitle := ini.ReadString('Config', 'HHTitle', '');}

      { Unreal Packages }
      ini.ReadSectionValues('PackagePriority', sl);
      for i := 0 to sl.Count-1 do begin
        tmp := sl[i];
        tmp2 := Copy(tmp, 1, Pos('=', tmp));
        Delete(tmp, 1, Pos('=', tmp));
        if (LowerCase(tmp2) = 'packages=') then begin
          PackagePriority.Add(LowerCase(tmp));
        end;
      end;
      ini.ReadSectionValues('IgnorePackages', sl);
      for i := 0 to sl.Count-1 do begin
        tmp := sl[i];
        Delete(tmp, 1, Pos('=', tmp));
        IgnorePackages.Add(LowerCase(tmp));
      end;
      { Unreal Packages -- END }
      { Source paths }
      ini.ReadSectionValues('SourcePaths', sl);
      for i := 0 to sl.Count-1 do begin
        tmp := sl[i];
        Delete(tmp, 1, Pos('=', tmp));
        SourcePaths.Add(tmp);
      end;
      { Source paths -- END }
    finally
      ini.Free;
      sl.Free;
    end;
  end;
  // overwrite other config items
  if FindCmdLineSwitch('id', ['-'], true) then SourcePaths.Clear;
  for i := 1 to ParamCount do begin
    if (CompareText('-od', ParamStr(i)) = 0) then begin
      if (ParamCount > i+1) then OutputDir := ParamStr(i+1);
    end
    else if (CompareText('-td', ParamStr(i)) = 0) then begin
      if (ParamCount > i+1) then TemplateDir := ParamStr(i+1);
    end
    else if (CompareText('-v', ParamStr(i)) = 0) then begin
      verbose := 1;
    end
    else if (CompareText('-vv', ParamStr(i)) = 0) then begin
      verbose := 2;
    end
    else if (CompareText('-id', ParamStr(i)) = 0) then begin
      if (ParamCount > i+1) then SourcePaths.Add(ParamStr(i+1));
    end
    else if (CompareText('-gini', ParamStr(i)) = 0) then begin
      if (ParamCount > i+1) then begin
        // TODO: ... import from game ini
      end;
    end
  end;

  // execute parts
  trd := TPackageScanner.Create(SourcePaths, frm_Bogus.tv_Packages.Items,
          frm_Bogus.tv_Classes.Items, statusReport, PackageList, ClassList,
          PackagePriority, IgnorePackages);
  trd.Resume;
  WaitForSingleObject(trd.Handle, INFINITE);
  
  // clean up
  frm_Bogus.Free;
  PackagePriority.Free;
  SourcePaths.Free;
  IgnorePackages.Free;
  ClassList.Free;
  PackageList.Free;
end;

initialization
  unit_definitions.Log := Log;
  unit_definitions.LogClass := LogClass;
end.
