{*******************************************************************************
  Name:
    unit_packages.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    UnrealScript package scanner, search for UnrealScript classes

  $Id: unit_packages.pas,v 1.42 2004-12-20 22:22:31 elmuerte Exp $
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

unit unit_packages;

{$I defines.inc}

interface

uses
  SysUtils, Classes, DateUtils,
  {$IFDEF USE_TREEVIEW}
  ComCtrls,
  {$ENDIF}
  unit_uclasses, unit_outputdefs, IniFiles, Hashes;

type
  TPackageScannerConfig = record
    paths: TStringList;
    {$IFDEF USE_TREEVIEW}
    packagetree, classtree: TTreeNodes;
    {$ENDIF}
    status: TStatusReport;
    packagelist: TUPackageList;
    classlist: TUClassList;
    PackagePriority, IgnorePackages: TStringList;
    CHash: TObjectHash;
    PDFile: string
  end;

  TPackageScanner = class(TThread)
  private
    paths: TStringList;
    {$IFDEF USE_TREEVIEW}
    packagetree: TTreeNodes;
    classtree: TTreeNodes;
    InterfaceNode: TTreeNode;
    {$ENDIF}
    status: TStatusReport;
    packagelist: TUPackageList;
    classlist: TUClassList;
    PackagePriority: TStringList;
    IgnorePackages: TStringList;
    ClassHash: TObjectHash;
    DuplicateHash: TStringHash;
    PDF: TMemIniFile;
    procedure ScanPackages;
    {$IFDEF USE_TREEVIEW}
    procedure CreateClassTree(classlist: TUClassList; parent: TUClass = nil;
      pnode: TTreeNode = nil);
    {$ELSE}
    procedure CreateClassTree(classlist: TUClassList; parent: TUClass = nil);
    {$ENDIF}
  public
    constructor Create(rec: TPackageScannerConfig);
    destructor Destroy; override;
    procedure Execute; override;
  end;

  TNewClassScanner = class(TThread)
    packagelist: TUPackageList;
    classlist: TUClassList;
    ClassHash: TObjectHash;
    status: TStatusReport;
    procedure FindNew;
  public
    constructor Create(mypackagelist: TUPackageList; myclasslist: TUClassList;
      mystatus: TStatusReport; CHash: TObjectHash = nil);
    procedure Execute; override;
  end;

  function CountOrphans(ClassList: TUClassList): integer;
  function GetUClassName(filename: string): TUClass;

var
  // orphan counter
  ClassOrphanCount: integer = 0;

implementation

uses
  unit_parser, unit_definitions, unit_analyse;

function CountOrphans(ClassList: TUClassList): integer;
var
  i: integer;
begin
  ClassOrphanCount := 0;
  for i := 0 to ClassList.Count-1 do begin
    if ((ClassList[i].parent = nil) and (ClassList[i].parentname <> '')) then begin
      Inc(ClassOrphanCount);                             
      Log('Orphan detected: '+ClassList[i].package.name+'.'+ClassList[i].name, ltWarn, CreateLogEntry(ClassList[i]));
    end;
  end;
  if (ClassOrphanCount > 0) then begin
    Log(IntToStr(ClassOrphanCount)+' orphan classes detected, check the package priority', ltWarn);
  end;
  result := ClassOrphanCount;
end;

function GetUClassName(filename: string): TUClass;
var
  fs: TFileStream;
  p: TUCParser;
  token: char;
begin
  guard('GetUClassName: '+filename);
  result := nil;
  fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
  p := TUCParser.Create(fs);
  try
    token := p.Token;
    while (token <> toEOF) do begin
      if (token <> toComment) then begin
        if (p.TokenSymbolIs('class')) then begin
          p.NextToken;
          result := TUClass.Create;
          try
            result.name := p.TokenString;
            p.NextToken;
            if (p.TokenSymbolIs('extends') or p.TokenSymbolIs('expands')) then begin
              p.NextToken;
              result.parentname := p.TokenString;
              if (p.NextToken = '.') then begin // package.class
                p.NextToken;                    // (should work with checking package)
                result.parentname := result.parentname+'.'+p.TokenString;
              end;
            end;
          except
            FreeAndNil(result);
            raise;
          end;
          break; // we don't need to parse the rest
        end
        else if (p.TokenSymbolIs('interface')) then begin
          p.NextToken;
          result := TUClass.Create;
          try
            result.name := p.TokenString;
            result.InterfaceType := itTribesV;
          except
            FreeAndNil(result);
            raise;
          end;
          break;
        end;
      end;
      token := p.NextToken;
    end;
  finally
    p.free;
    fs.free;
  end;
  unguard;
end;

constructor TPackageScanner.Create(rec: TPackageScannerConfig);
begin
  Self.paths := rec.paths;
  {$IFDEF USE_TREEVIEW}
  Self.packagetree := rec.packagetree;
  Self.classtree := rec.classtree;
  {$ENDIF}
  Self.status := rec.status;
  Self.packagelist := rec.packagelist;
  Self.classlist := rec.ClassList;
  self.PackagePriority := rec.PackagePriority;
  self.IgnorePackages := rec.IgnorePackages;
  Self.FreeOnTerminate := true;
  Self.ClassHash := rec.CHash;
  try
    if (FileExists(rec.PDFile)) then Self.PDF := TMemIniFile.Create(rec.PDFile);
  except
    log('Failed loading PackageDescriptionFile: '+rec.PDFile, ltError);
    Self.PDF := nil;
  end;
  DuplicateHash := TStringHash.Create;
  inherited Create(true);
end;

destructor TPackageScanner.Destroy;
begin
  FreeAndNil(DuplicateHash);
  if (PDF <> nil) then FreeAndNil(PDF);
  inherited Destroy();
end;

procedure TPackageScanner.Execute;
var
  stime: TDateTime;
begin
  resetguard();
  stime := Now();
  try
    ScanPackages();
  except
    on E: Exception do begin
      Log('Unhandled exception: '+E.Message, ltError);
      printguard;
    end;
  end;
  Status('Operation completed in '+Format('%.3f', [Millisecondsbetween(Now(), stime)/1000])+' seconds, '+IntToStr(classlist.Count)+' classes - '+IntToStr(packagelist.Count)+' packages');
end;

procedure TPackageScanner.ScanPackages;
var
  sr: TSearchRec;
  i, j: integer;
  {$IFDEF USE_TREEVIEW}
  ti: TTreeNode;
  {$ENDIF}
  UClass: TUClass;
  UPackage: TUPackage;
  knownpackages: TStringList;
  ini: TMemIniFile;
  lst: TStringList;
  tmp: string;
  pathpkgcount: integer;
begin
  guard('ScanPackages');
  {$IFDEF USE_TREEVIEW}
  packagetree.BeginUpdate;
  classtree.BeginUpdate;
  {$ENDIF}
  knownpackages := TStringList.Create;
  uclass := nil;
  if (ClassHash <> nil) then ClassHash.Clear;
  try
    // first get all packages
    for i := 0 to paths.count-1 do begin
      pathpkgcount := 0;
      if FindFirst(paths[i]+PATHDELIM+WILDCARD, faDirectory, sr) = 0 then begin
        try repeat
          if ((sr.Name <> '.') and (sr.Name <> '..')) then begin
            if (iFindDir(paths[i]+PATHDELIM+sr.name+PATHDELIM+CLASSDIR, tmp) and
              (IgnorePackages.IndexOf(sr.Name) = -1)) then begin
              if (knownpackages.IndexOf(LowerCase(sr.Name)) = -1) then begin
                Inc(pathpkgcount);
                UPackage := TUPackage.Create;
                try
                  UPackage.name := sr.Name;
                  UPackage.path := tmp;
                  UPackage.priority := PackagePriority.IndexOf(LowerCase(UPackage.name));
                  if (UPackage.priority = -1) then begin
                    log('Scanner: Unprioritised package: '+sr.Name, ltWarn);
                    UPackage.priority := PackagePriority.Count;
                    PackagePriority.Add(LowerCase(sr.Name));
                  end
                  else begin
                    UPackage.tagged := PackagePriority.Objects[UPackage.priority] <> nil;
                  end;

                  // first location <package>.upkg
                  tmp := iFindFile(UPackage.path+PATHDELIM+UPackage.name+PKGCFG);
                  if (FileExists(tmp)) then begin
                    lst := TStringList.Create;
                    ini := TMemIniFile.Create(tmp);
                    try
                      ini.ReadSectionValues('package_description', lst);
                      UPackage.comment := lst.Text;
                    finally
                      lst.Free;
                      ini.Free;
                    end;
                  end;
                  // second location: uncodex.ini
                  if (UPackage.comment = '') then begin
                    tmp := iFindFile(paths[i]+PATHDELIM+sr.name+PATHDELIM+UCXPACKAGEINFO);
                    if ( FileExists(tmp)) then begin
                      lst := TStringList.Create;
                      ini := TMemIniFile.Create(tmp);
                      try
                        ini.ReadSectionValues('package_description', lst);
                        UPackage.comment := lst.Text;
                      finally
                        lst.Free;
                        ini.Free;
                      end;
                    end
                  end;
                  // third location, general file
                  if (UPackage.comment = '') then begin
                    if (PDF <> nil) then begin
                      // get from package description file
                      lst := TStringList.Create;
                      try
                        PDF.ReadSectionValues(UPackage.name, lst);
                        UPackage.comment := lst.Text;
                      finally
                        lst.Free;
                      end;
                    end;
                  end;
                  PackageList.Add(UPackage);
                  knownpackages.Add(LowerCase(sr.Name));
                except
                  FreeAndnil(UPackage);
                  raise;
                end;
              end
              else begin
                log('Scanner: Package collision: '+paths[i]+PATHDELIM+sr.Name, ltError);
              end;
            end;
          end;
        until (FindNext(sr) <> 0) or (Self.Terminated);
        finally
          FindClose(sr);
        end;
        if (Self.Terminated) then break;
      end;
      if (pathpkgcount = 0) then begin
        log('Scanner: no packages found in '+paths[i], ltInfo);
      end;
    end;
    PackageList.Sort; // sort on priority
    // find all classes
    for i := 0 to packagelist.Count-1 do begin
      {$IFDEF USE_TREEVIEW}
      ti := packagetree.AddObject(nil, Packagelist[i].name, Packagelist[i]);
      if (packagelist[i].tagged) then begin
        ti.ImageIndex := ICON_PACKAGE_TAGGED;
        ti.StateIndex := ICON_PACKAGE_TAGGED;
        ti.SelectedIndex := ICON_PACKAGE_TAGGED;
      end
      else begin
        ti.ImageIndex := ICON_PACKAGE;
        ti.StateIndex := ICON_PACKAGE;
        ti.SelectedIndex := ICON_PACKAGE;
      end;
      Packagelist[i].treenode := ti;
      {$ENDIF}
      Status('Scanning package '+Packagelist[i].name, round((i+1) / Packagelist.Count * 100));
      lst := TStringList.Create;
      try
        FindFiles(Packagelist[i].path, '', SOURCECARD, faAnyFile, lst);
        {$IFDEF UNIX}
        FindFiles(Packagelist[i].path, '', SOURCECARD_1, faAnyFile, lst, true);
        FindFiles(Packagelist[i].path, '', SOURCECARD_2, faAnyFile, lst, true);
        FindFiles(Packagelist[i].path, '', SOURCECARD_3, faAnyFile, lst, true);
        {$ENDIF}
        for j := 0 to lst.Count-1 do begin
          Status('Parsing file '+Packagelist[i].path+PATHDELIM+lst[j]);
          try
            uclass := GetUClassName(Packagelist[i].path+PATHDELIM+lst[j]);
          except
            on E: Exception do begin
              log('Parser: error: '+E.Message, ltError);
              continue;
            end;
          end;
          if (Assigned(uclass)) then begin
            classlist.Add(uclass);
            packagelist[i].classes.Add(uclass);
            uclass.package := PackageList[i];
            uclass.tagged := UClass.package.tagged;
            uclass.filename := lst[j];
            uclass.priority := PackageList[i].priority;
            {$IFDEF USE_TREEVIEW}
            uclass.treenode2 := packagetree.AddChildObject(ti, uclass.name, uclass);
            with TTreeNode(uclass.treenode2) do begin
              if (uclass.tagged) then begin
                ImageIndex := ICON_CLASS_TAGGED;
                StateIndex := ICON_CLASS_TAGGED;
                SelectedIndex := ICON_CLASS_TAGGED;
              end
              else begin
                ImageIndex := ICON_CLASS;
                StateIndex := ICON_CLASS;
                SelectedIndex := ICON_CLASS;
              end;
            end;
            {$ENDIF}
            if (ClassHash <> nil) then begin
              if (ClassHash.Exists(LowerCase(uclass.name))) then begin
                Log('Scanner: duplicate class name: '+uclass.FullName, ltWarn, CreateLogEntry(uclass));
                DuplicateHash[LowerCase(uclass.name)] := '-'
              end
              else ClassHash.Items[LowerCase(uclass.name)] := uclass;
            end;
          end
          else log('Scanner: No class found in this file: '+sr.Name, ltWarn);
        end;
        if (Self.Terminated) then break;
      finally
        lst.Free;
      end;
      if (Self.Terminated) then break;
    end;
    if (not Self.Terminated) then begin
      for i := packagelist.Count-1 downto 0 do begin
        if packagelist[i].classes.Count = 0 then begin
          Log('Empty package: '+packagelist[i].name, ltInfo);
          {$IFDEF USE_TREEVIEW}
          packagetree.Delete(TTreeNode(Packagelist[i].treenode));
          {$ENDIF}
          packagelist.Remove(Packagelist[i]);
        end;
      end;
      CreateClassTree(classlist);
      {$IFDEF USE_TREEVIEW}
      packagetree.AlphaSort(true); // sorting
      classtree.AlphaSort(true); // sorting
      {$ENDIF}
      classlist.Sort;
      CountOrphans(ClassList);
    end;
    if (DuplicateHash.ItemCount > 0) then begin
      Log('(Warning) One or more duplicate class names detected. The class tree might be incorrect.', ltWarn);
      Log('(Warning) You should always use unique class names to avoid confusion.', ltWarn);
    end;
  finally
    knownpackages.Free;
    {$IFDEF USE_TREEVIEW}
    packagetree.EndUpdate;
    // TODO: fix
    ti := classtree.GetFirstNode;
    while (ti <> nil) do begin
      if CompareText(ti.Text, 'object') = 0 then begin
        ti.Expand(false);
        break;
      end;
      ti := ti.getNextSibling;
    end;
    classtree.EndUpdate;
    {$ENDIF}
  end;
  unguard;
end;

{$IFDEF USE_TREEVIEW}
procedure TPackageScanner.CreateClassTree(classlist: TUClassList;
  parent: TUClass = nil; pnode: TTreeNode = nil);
{$ELSE}
procedure TPackageScanner.CreateClassTree(classlist: TUClassList; parent: TUClass = nil);
{$ENDIF}
var
  pprio: integer;
  tmp, pname, packn, ppackn: string;
  i,j:  integer;
begin
  guard('CreateClassTree');
  pprio := 0;
  if (parent <> nil) then begin
    tmp := parent.name;
    ppackn := parent.package.name;
    pprio := parent.priority;
  end;

  if (Pos('.', tmp) > 0) then log(tmp);
  Status('Creating class tree for '+tmp);
  for i := 0 to classlist.Count-1 do begin
    if (classlist[i].parent = nil) then begin
      if (DuplicateHash.Exists(LowerCase(classlist[i].name))) then begin
        if (classlist[i].priority < pprio) then continue;
      end;
      pname := classlist[i].parentname;
      j := Pos('.', pname);
      if (j > 0) then begin
        packn := copy(pname, 1, j-1);
        Delete(pname, 1, j);
      end
      else packn := '';
      if ((CompareText(pname, tmp) = 0) and ((packn = '') or (CompareText(packn, ppackn) = 0))) then begin
        // in case of a partially qualified name, duplicate parent classname
        // check for a local (in this package) parent and use that
        if ((packn = '') and (parent <> nil) and DuplicateHash.Exists(LowerCase(parent.name))) then begin
          if (classlist[i].package.classes.Find(parent.name) <> parent) then begin
            log('Scanner: Found local parent class for '+classlist[i].FullName, ltInfo, CreateLogEntry(classlist[i]));
            continue;
          end;
        end;
        classlist[i].parent := parent;
        if (parent <> nil) then parent.children.Add(classlist[i]);
        {$IFDEF USE_TREEVIEW}
        if (classlist[i].InterfaceType = itTribesV) then begin
          if (InterfaceNode = nil) then begin
            InterfaceNode := classtree.AddChild(nil, 'Interfaces');
          end;
          classlist[i].treenode := classtree.AddChildObject(InterfaceNode, classlist[i].name, classlist[i]);
        end
        else begin
          classlist[i].treenode := classtree.AddChildObject(pnode, classlist[i].name, classlist[i]);
        end;
        if (classlist[i].tagged) then begin
          TTreeNode(classlist[i].treenode).ImageIndex := ICON_CLASS_TAGGED;
          TTreeNode(classlist[i].treenode).StateIndex := ICON_CLASS_TAGGED;
          TTreeNode(classlist[i].treenode).SelectedIndex := ICON_CLASS_TAGGED;
        end
        else begin
          TTreeNode(classlist[i].treenode).ImageIndex := ICON_CLASS;
          TTreeNode(classlist[i].treenode).StateIndex := ICON_CLASS;
          TTreeNode(classlist[i].treenode).SelectedIndex := ICON_CLASS;
        end;
        CreateClassTree(classlist, classlist[i], TTreeNode(classlist[i].treenode));
        {$ELSE}
        CreateClassTree(classlist, classlist[i]);
        {$ENDIF}
      end;
    end;
  end;
  unguard;
end;

{ TNewClassScanner }

constructor TNewClassScanner.Create(mypackagelist: TUPackageList; myclasslist: TUClassList; mystatus: TStatusReport; CHash: TObjectHash = nil);
begin
  packagelist := mypackagelist;
  classlist := myclasslist;
  ClassHash := CHash;
  status := mystatus;
  inherited Create(true);
  Self.FreeOnTerminate := true;
end;

procedure TNewClassScanner.Execute;
var
  stime: TDateTime;
begin
  stime := Now();
  try
    FindNew();
  except
    on E: Exception do Log('Unhandled exception: '+E.Message, ltError);
  end;
  Status('Operation completed in '+Format('%.3f', [Millisecondsbetween(Now(), stime)/1000])+' seconds, '+IntToStr(classlist.Count)+' classes');
end;

procedure TNewClassScanner.FindNew;
var
  i, j: integer;
  sl: TStringList;
  uclass: TUClass;
  newclasses: TUClassList;

  procedure SortNewClasses;
  var
    i,j:  integer;
    tmpc:   TUClass;
  begin
    for i := 0 to newclasses.Count-2 do begin
      for j := i+1 to newclasses.Count-1 do begin
        if (CompareText(newclasses[i].parentname, newclasses[j].name) = 0) then begin
          tmpc := newclasses[j];
          newclasses[j] := newclasses[i];
          newclasses[i] := tmpc;
        end;
      end;
    end;
  end;

begin
  sl := TStringList.Create;
  newclasses := TUClassList.Create(false);
  try
    for i := 0 to packagelist.Count-1 do begin
      if (Terminated) then exit;
      status('Scanning package '+packagelist[i].name+' for new classes', (i+1)*100 div packagelist.Count);
      
      GetFiles(packagelist[i].path+PathDelim+SOURCECARD, faAnyFile and not faDirectory, sl);
      for j := 0 to sl.Count-1 do begin
        if (packagelist[i].classes.Find(ExtractBaseName(sl[j])) = nil) then begin
          uclass := nil;
          try
            uclass := GetUClassName(sl[j]);
          except
            on E: Exception do log('Parser: error: '+E.Message, ltError);
          end;
          if (not Assigned(uclass)) then continue;

          classlist.Add(uclass);
          packagelist[i].classes.Add(uclass);
          newclasses.Add(uclass);
          uclass.package := PackageList[i];
          uclass.tagged := UClass.package.tagged;
          uclass.filename := ExtractFileName(sl[j]);
          uclass.priority := PackageList[i].priority;
          {$IFDEF USE_TREEVIEW}
          uclass.treenode2 := TTreeNode(packagelist[i].treenode).Owner.AddChildObject(TTreeNode(packagelist[i].treenode), uclass.name, uclass);
          with TTreeNode(uclass.treenode2) do begin
            if (uclass.tagged) then begin
              ImageIndex := ICON_CLASS_TAGGED;
              StateIndex := ICON_CLASS_TAGGED;
              SelectedIndex := ICON_CLASS_TAGGED;
            end
            else begin
              ImageIndex := ICON_CLASS;
              StateIndex := ICON_CLASS;
              SelectedIndex := ICON_CLASS;
            end;
          end;
          TTreeNode(packagelist[i].treenode).AlphaSort();
          {$ENDIF}
          if (ClassHash <> nil) then begin
            if (ClassHash.Exists(LowerCase(uclass.name))) then begin
              Log('Scanner: duplicate class name: '+uclass.FullName, ltWarn, CreateLogEntry(uclass));
              //DuplicateHash[LowerCase(uclass.name)] := '-'
            end
            else ClassHash.Items[LowerCase(uclass.name)] := uclass;
          end;
          log('New class found: '+uclass.FullName, ltInfo, CreateLogEntry(uclass));
        end;
      end;
    end;
    if (newclasses.Count > 0) then begin
      Log('Found '+IntToStr(newclasses.Count)+' new class(es)');
      SortNewClasses;
      for i := 0 to newclasses.Count-1 do begin
        if (Terminated) then exit;
        uclass := classlist.Find(newclasses[i].parentname);
        if (Assigned(uclass)) then begin
          newclasses[i].parent := uclass;
          uclass.children.Add(newclasses[i]);
          {$IFDEF USE_TREEVIEW}
          newclasses[i].treenode := TTreeNode(uclass.treenode).Owner.AddChildObject(TTreeNode(uclass.treenode), newclasses[i].name, newclasses[i]);
          if (newclasses[i].tagged) then begin
            TTreeNode(newclasses[i].treenode).ImageIndex := ICON_CLASS_TAGGED;
            TTreeNode(newclasses[i].treenode).StateIndex := ICON_CLASS_TAGGED;
            TTreeNode(newclasses[i].treenode).SelectedIndex := ICON_CLASS_TAGGED;
          end
          else begin
            TTreeNode(newclasses[i].treenode).ImageIndex := ICON_CLASS;
            TTreeNode(classlist[i].treenode).StateIndex := ICON_CLASS;
            TTreeNode(newclasses[i].treenode).SelectedIndex := ICON_CLASS;
          end;
          TTreeNode(uclass.treenode).AlphaSort();
          {$ENDIF}
        end;
      end;
    end;
    {$IFDEF USE_TREEVIEW}
    TreeUpdated := true;
    {$ENDIF}
    packagelist.Sort;
    classlist.Sort;
  finally
    sl.Free;
    newclasses.Free;
  end;
end;

end.
