unit unit_packages;

interface

uses
  Windows, SysUtils, Variants, Classes, Controls, ComCtrls, unit_uclasses,
  unit_definitions;

type
  TPackageScanner = class(TThread)
  private
    paths: TStringList;
    packagetree: TTreeView;
    classtree: TTreeView;
    status: TStatusReport;
    packagelist: TUPackageList;
    classlist: TUClassList;
    PackagePriority: TStringList;
    procedure ScanPackages;
    procedure CreateClassTree(classlist: TUClassList; parent: TUClass = nil; pnode: TTreeNode = nil);
    function GetClassName(filename: string): TUClass;
  public
    constructor Create(paths: TStringList; packagetree, classtree: TTreeView; status: TStatusReport; packagelist: TUPackageList; PackagePriority: TStringList; classlist: TUClassList);
    destructor Destroy; override;
    procedure Execute; override;
  end;

implementation

uses unit_main, unit_parser;

constructor TPackageScanner.Create(paths: TStringList; packagetree, classtree: TTreeView; status: TStatusReport; packagelist: TUPackageList; PackagePriority: TStringList; classlist: TUClassList);
begin
  Self.paths := paths;
  Self.packagetree := packagetree;
  Self.classtree := classtree;
  Self.status := status;
  Self.packagelist := packagelist;
  Self.classlist := ClassList;
  self.PackagePriority := PackagePriority;
  Self.FreeOnTerminate := true;
  inherited Create(true);
end;

destructor TPackageScanner.Destroy;
begin
  inherited Destroy();
end;

procedure TPackageScanner.Execute;
var
  stime: Cardinal;
begin
  stime := GetTickCount();
  ScanPackages();
  Status('Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds, '+IntToStr(classtree.Items.Count)+' classes')
end;

procedure TPackageScanner.ScanPackages;
var
  sr: TSearchRec;
  i: integer;
  ti: TTreeNode;
  UClass: TUClass;
  UPackage: TUPackage;
  knownpackages: TStringList;
begin
  packagetree.Items.BeginUpdate;
  classtree.Items.BeginUpdate;
  knownpackages := TStringList.Create;
  uclass := nil;
  try
    // first get all packages
    for i := 0 to paths.count-1 do begin
      if FindFirst(paths[i]+PATHDELIM+WILDCARD, faDirectory, sr) = 0 then begin
        repeat
          if ((sr.Name <> '.') and (sr.Name <> '..')) then begin
            if (DirectoryExists(paths[i]+PATHDELIM+sr.name+PATHDELIM+CLASSDIR)) then begin
              if (knownpackages.IndexOf(LowerCase(sr.Name)) = -1) then begin
                UPackage := TUPackage.Create;
                UPackage.name := sr.Name;
                UPackage.path := paths[i]+PATHDELIM+sr.name;
                UPackage.priority := PackagePriority.IndexOf(LowerCase(UPackage.name));
                if (UPackage.priority = -1) then begin
                  log('Scanner: (Warning) Unprioritised package: '+sr.Name);
                  UPackage.priority := PackagePriority.Count;
                  PackagePriority.Add(LowerCase(sr.Name));
                end;
                PackageList.Add(UPackage);
                knownpackages.Add(LowerCase(sr.Name));
              end
              else begin
                log('Scanner: (Error) Package collision: '+paths[i]+PATHDELIM+sr.Name);
              end;
            end;
          end;
        until FindNext(sr) <> 0;
        FindClose(sr);
      end;
    end;
    PackageList.Sort; // sort on priority
    // find all classes
    for i := 0 to packagelist.Count-1 do begin
      ti := packagetree.Items.AddObject(nil, Packagelist[i].name, Packagelist[i]);
      ti.ImageIndex := 0;
      ti.StateIndex := 0;
      Status('Scanning package '+Packagelist[i].name, round((i+1) / Packagelist.Count * 100));
      if FindFirst(Packagelist[i].path+PATHDELIM+CLASSDIR+PATHDELIM+SOURCECARD, faAnyFile, sr) = 0 then begin
        repeat
          Status('Parsing file '+Packagelist[i].path+PATHDELIM+CLASSDIR+PATHDELIM+sr.Name);
          try
            uclass := GetClassName(Packagelist[i].path+PATHDELIM+CLASSDIR+PATHDELIM+sr.Name);
          except
            on E: Exception do log('Parser: error: '+E.Message);
          end;
          if (Assigned(uclass)) then begin
            classlist.Add(uclass);
            packagelist[i].classes.Add(uclass);
            uclass.package := PackageList[i];
            uclass.filename := sr.Name;
            uclass.priority := PackageList[i].priority;
            with packagetree.Items.AddChildObject(ti, uclass.name, uclass) do begin
              ImageIndex := 1;
              StateIndex := 1;
              SelectedIndex := 1;
            end;
          end
          else log('Scanner: No class found in this file: '+sr.Name);
        until FindNext(sr) <> 0;
        FindClose(sr);
      end;
    end;
    packagetree.Items.AlphaSort(true); // sorting
    CreateClassTree(classlist);
    classtree.Items.AlphaSort(true); // sorting
  finally
    knownpackages.Free;
    packagetree.Items.EndUpdate;
    classtree.Items.EndUpdate;
  end;
end;

procedure TPackageScanner.CreateClassTree(classlist: TUClassList; parent: TUClass = nil; pnode: TTreeNode = nil);
var
  pprio: integer;
  tmp: string;
  i: integer;
begin
  pprio := 0;
  if (parent <> nil) then begin
    tmp := parent.name;
    pprio := parent.priority;
  end;

  if (Pos('.', tmp) > 0) then log(tmp);
  Status('Creating class tree for '+tmp);
  for i := 0 to classlist.Count-1 do begin
    if ((classlist[i].parent = nil) and
      (classlist[i].priority >= pprio)) then begin
      if (CompareText(classlist[i].parentname, tmp) = 0) then begin
        classlist[i].parent := parent;
        classlist[i].treenode := classtree.Items.AddChildObject(pnode, classlist[i].name, classlist[i]);
        classlist[i].treenode.ImageIndex := 1;
        classlist[i].treenode.StateIndex := 1;
        classlist[i].treenode.SelectedIndex := 1;
        CreateClassTree(classlist, classlist[i], classlist[i].treenode);
      end;
    end;
  end;
end;

function TPackageScanner.GetClassName(filename: string): TUClass;
var
  fs: TFileStream;
  p: TUCParser;
  token: char;
begin
  result := nil;
  fs := TFileStream.Create(filename, fmOpenRead	or fmShareDenyWrite);
  p := TUCParser.Create(fs);
  try
    token := p.Token;
    while (token <> toEOF) do begin
      if (token <> toComment) then begin
        if (p.TokenSymbolIs('class')) then begin
          p.NextToken;
          result := TUClass.Create;
          result.name := p.TokenString;
          p.NextToken;
          if (p.TokenSymbolIs('extends')) then begin
            p.NextToken;
            result.parentname := p.TokenString;
            if (p.NextToken = '.') then begin // package.class
              p.NextToken;                    // (should work with checking package)
              result.parentname := p.TokenString;
            end;
          end;
          break; // we don't need to parse the rest
        end;
      end;
      token := p.NextToken;
    end;
  finally
    p.free;
    fs.free;
  end;
end;

end.