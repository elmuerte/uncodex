{-----------------------------------------------------------------------------
 Unit Name: unit_packages
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Unreal Package scanner, searches for classes in directories
 $Id: unit_packages.pas,v 1.16 2003-11-27 17:01:55 elmuerte Exp $
-----------------------------------------------------------------------------}
{
    UnCodeX - UnrealScript source browser & documenter
    Copyright (C) 2003  Michiel Hendriks

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

{$IFNDEF CONSOLE}
  {$MESSAGE 'Compiling with __USE_TREEVIEW'}
  {$DEFINE __USE_TREEVIEW}
{$ENDIF}

interface

uses
  Windows, SysUtils, Classes,
  {$IFDEF __USE_TREEVIEW}
  ComCtrls,
  {$ENDIF}
  unit_uclasses, unit_outputdefs, IniFiles, Hashes;

type
  TPackageScanner = class(TThread)
  private
    paths: TStringList;
    {$IFDEF __USE_TREEVIEW}
    packagetree: TTreeNodes;
    classtree: TTreeNodes;
    {$ENDIF}
    status: TStatusReport;
    packagelist: TUPackageList;
    classlist: TUClassList;
    PackagePriority: TStringList;
    IgnorePackages: TStringList;
    ClassHash: TStringHash;
    PDF: TMemIniFile;
    procedure ScanPackages;
    {$IFDEF __USE_TREEVIEW}
    procedure CreateClassTree(classlist: TUClassList; parent: TUClass = nil; pnode: TTreeNode = nil);
    {$ELSE}
    procedure CreateClassTree(classlist: TUClassList; parent: TUClass = nil);
    {$ENDIF}
    function GetClassName(filename: string): TUClass;
  public
    {$IFDEF __USE_TREEVIEW}
    constructor Create(paths: TStringList; packagetree, classtree: TTreeNodes;
      status: TStatusReport; packagelist: TUPackageList; classlist: TUClassList;
      PackagePriority, IgnorePackages: TStringList; CHash: TStringHash = nil; PDFile: string = '');
    {$ELSE}
    constructor Create(paths: TStringList;
      status: TStatusReport; packagelist: TUPackageList; classlist: TUClassList;
      PackagePriority, IgnorePackages: TStringList; CHash: TStringHash = nil; PDFile: string = '');
    {$ENDIF}
    destructor Destroy; override;
    procedure Execute; override;
  end;

implementation

uses
  unit_parser, unit_definitions;

{$IFDEF __USE_TREEVIEW}
constructor TPackageScanner.Create(paths: TStringList; packagetree, classtree: TTreeNodes;
  status: TStatusReport; packagelist: TUPackageList; classlist: TUClassList;
  PackagePriority, IgnorePackages: TStringList; CHash: TStringHash = nil; PDFile: string = '');
{$ELSE}
constructor TPackageScanner.Create(paths: TStringList;
  status: TStatusReport; packagelist: TUPackageList; classlist: TUClassList;
  PackagePriority, IgnorePackages: TStringList; CHash: TStringHash = nil; PDFile: string = '');
{$ENDIF}
begin
  Self.paths := paths;
  {$IFDEF __USE_TREEVIEW}
  Self.packagetree := packagetree;
  Self.classtree := classtree;
  {$ENDIF}
  Self.status := status;
  Self.packagelist := packagelist;
  Self.classlist := ClassList;
  self.PackagePriority := PackagePriority;
  self.IgnorePackages := IgnorePackages;
  Self.FreeOnTerminate := true;
  Self.ClassHash := CHash;
  if (FileExists(PDFile)) then Self.PDF := TMemIniFile.Create(PDFile);
  inherited Create(true);
end;

destructor TPackageScanner.Destroy;
begin
  if (PDF <> nil) then PDF.Free;
  inherited Destroy();
end;

procedure TPackageScanner.Execute;
var
  stime: Cardinal;
begin
  stime := GetTickCount();
  ScanPackages();
  Status('Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds, '+IntToStr(classlist.Count)+' classes');
end;

procedure TPackageScanner.ScanPackages;
var
  sr: TSearchRec;
  i: integer;
  {$IFDEF __USE_TREEVIEW}
  ti: TTreeNode;
  {$ENDIF}
  UClass: TUClass;
  UPackage: TUPackage;
  knownpackages: TStringList;
  ini: TMemIniFile;
  lst: TStringList;
begin
  {$IFDEF __USE_TREEVIEW}
  packagetree.BeginUpdate;
  classtree.BeginUpdate;
  {$ENDIF}
  knownpackages := TStringList.Create;
  uclass := nil;
  if (ClassHash <> nil) then ClassHash.Clear;
  try
    // first get all packages
    for i := 0 to paths.count-1 do begin
      if FindFirst(paths[i]+PATHDELIM+WILDCARD, faDirectory, sr) = 0 then begin
        repeat
          if ((sr.Name <> '.') and (sr.Name <> '..')) then begin
            if (DirectoryExists(paths[i]+PATHDELIM+sr.name+PATHDELIM+CLASSDIR) and
              (IgnorePackages.IndexOf(sr.Name) = -1)) then begin
              if (knownpackages.IndexOf(LowerCase(sr.Name)) = -1) then begin
                UPackage := TUPackage.Create;
                UPackage.name := sr.Name;
                UPackage.path := paths[i]+PATHDELIM+sr.name;
                UPackage.priority := PackagePriority.IndexOf(LowerCase(UPackage.name));
                if (UPackage.priority = -1) then begin
                  log('Scanner: (Warning) Unprioritised package: '+sr.Name);
                  UPackage.priority := PackagePriority.Count;
                  PackagePriority.Add(LowerCase(sr.Name));
                end
                else begin
                  UPackage.tagged := PackagePriority.Objects[UPackage.priority] <> nil;
                end;
                if (FileExists(UPackage.path+PATHDELIM+UCXPACKAGEINFO)) then begin
                  lst := TStringList.Create;
                  ini := TMemIniFile.Create(UPackage.path+PATHDELIM+UCXPACKAGEINFO);
                  try
                    ini.ReadSectionValues('package_description', lst);
                    UPackage.comment := lst.Text;
                  finally
                    lst.Free;
                    ini.Free;
                  end;
                end
                else if (PDF <> nil) then begin
                  // get from package description file
                  lst := TStringList.Create;
                  try
                    PDF.ReadSectionValues(UPackage.name, lst);
                    UPackage.comment := lst.Text;
                  finally
                    lst.Free;
                  end;
                end;
                PackageList.Add(UPackage);
                knownpackages.Add(LowerCase(sr.Name));
              end
              else begin
                log('Scanner: (Error) Package collision: '+paths[i]+PATHDELIM+sr.Name);
              end;
            end;
          end;
        until (FindNext(sr) <> 0) or (Self.Terminated);
        FindClose(sr);
        if (Self.Terminated) then break;
      end;
    end;
    PackageList.Sort; // sort on priority
    // find all classes
    for i := 0 to packagelist.Count-1 do begin
      {$IFDEF __USE_TREEVIEW}
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
      {$ENDIF}
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
            uclass.tagged := UClass.package.tagged;
            uclass.filename := sr.Name;
            uclass.priority := PackageList[i].priority;
            {$IFDEF __USE_TREEVIEW}
            with packagetree.AddChildObject(ti, uclass.name, uclass) do begin
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
            if (ClassHash <> nil) then ClassHash.Items[LowerCase(uclass.name)] := '-';
          end
          else log('Scanner: No class found in this file: '+sr.Name);
        until (FindNext(sr) <> 0) or (Self.Terminated);
        FindClose(sr);
        if (Self.Terminated) then break;
      end;
    end;
    if (not Self.Terminated) then begin
      {$IFDEF __USE_TREEVIEW}
      packagetree.AlphaSort(true); // sorting
      {$ENDIF}
      CreateClassTree(classlist);
      {$IFDEF __USE_TREEVIEW}
      classtree.AlphaSort(true); // sorting
      {$ENDIF}
      classlist.Sort;
    end;
  finally
    knownpackages.Free;
    {$IFDEF __USE_TREEVIEW}
    packagetree.EndUpdate;
    classtree.EndUpdate;
    {$ENDIF}
  end;
end;

{$IFDEF __USE_TREEVIEW}
procedure TPackageScanner.CreateClassTree(classlist: TUClassList; parent: TUClass = nil; pnode: TTreeNode = nil);
{$ELSE}
procedure TPackageScanner.CreateClassTree(classlist: TUClassList; parent: TUClass = nil);
{$ENDIF}
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
        if (parent <> nil) then parent.children.Add(classlist[i]);
        {$IFDEF __USE_TREEVIEW}
        classlist[i].treenode := classtree.AddChildObject(pnode, classlist[i].name, classlist[i]);
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
          if (p.TokenSymbolIs('extends') or p.TokenSymbolIs('expands')) then begin
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
