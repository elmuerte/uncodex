{-----------------------------------------------------------------------------
 Unit Name: unit_treestate
 Author:    elmuerte
 Purpose:   loading/saving the tree state
 History:
-----------------------------------------------------------------------------}

unit unit_treestate;

interface

uses
  SysUtils, Classes, ComCtrls, ComStrs, Forms, unit_uclasses, unit_definitions;

type
  TUnCodeXState = class(TStrings)
  private
    FClassTree: TTreeView;
    FClassList: TUClassList;
    FPackageList: TUPackageList;
    FPackageTree: TTreeView;
  protected
    function GetState(name: string; uclass: TUClass): TUState;
    function GetPackage(name: string): TUPackage;
    procedure SavePackageToStream(upackage: TUPackage; stream: TStream);
    procedure SaveClassToStream(uclass: TUClass; stream: TStream);
    procedure LoadClassesFromStream(stream: TStream);
    procedure LoadPackagesFromStream(stream: TStream);
  public
    constructor Create(AOwner: TUClassList; CTree: TTreeView; PList: TUPackageList; PTree: TTreeView); overload;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    function LoadTreeFromStream(Stream: TStream): boolean;
    procedure SaveTreeToStream(Stream: TStream);
  end;

implementation

uses unit_main;

const
  TabChar = #9;
  EndOfLine = #13#10;
  UnitSeperator = #31;
  StartOfText = #02;
  EndOfText = #03;
  StartOfHeader = #01;

type
  ETreeViewError = class(Exception);

procedure TreeViewError(const Msg: string);
begin
  raise ETreeViewError.Create(Msg);
end;

procedure TreeViewErrorFmt(const Msg: string; Format: array of const);
begin
  raise ETreeViewError.CreateFmt(Msg, Format);
end;

function GetUnit(const rec: string; offset: integer): string;
var
  i,j: integer;
begin
  i := 1;
  while ((offset > 0) and (i <= Length(rec))) do begin
    if (rec[i] = UnitSeperator) then Dec(offset);
    Inc(i);
  end;
  if (offset > 0) then result := ''
  else begin
    j := i;
    while ((rec[j] <> UnitSeperator) and (j <= Length(rec))) do begin
      Inc(j);
    end;
    Result := Copy(rec, i, j-i);
  end;
end;

{ TUnCodeXState }

const
  UCXheader = 'UCX051'+#13#10#0;

procedure TUnCodeXState.SavePackageToStream(upackage: TUPackage; stream: TStream);
var
  Writer: TWriter;
begin
  Writer := TWriter.Create(stream, 4096);
  try
    Writer.WriteString(upackage.name);
    Writer.WriteInteger(upackage.priority);
    Writer.WriteString(upackage.path);
    Writer.WriteBoolean(upackage.tagged);
  finally
    Writer.Free;
  end;
end;

procedure TUnCodeXState.SaveClassToStream(uclass: TUClass; stream: TStream);
var
  Writer: TWriter;
  i: integer;
begin
  Writer := TWriter.Create(stream, 4096);
  try
    Writer.WriteString(uclass.name);
    Writer.WriteInteger(uclass.treenode.Level); // position in the tree
    Writer.WriteString(uclass.package.name);
    Writer.WriteString(uclass.parentname);
    Writer.WriteString(uclass.filename);
    Writer.WriteString(uclass.modifiers);
    Writer.WriteInteger(uclass.filetime);
    Writer.WriteInteger(uclass.consts.Count);
    for i := 0 to uclass.consts.Count-1 do begin
      Writer.WriteString(uclass.consts[i].name);
      Writer.WriteString(uclass.consts[i].value);
      Writer.WriteInteger(uclass.consts[i].srcline);
    end;
    Writer.WriteInteger(uclass.properties.Count);
    for i := 0 to uclass.properties.Count-1 do begin
      Writer.WriteString(uclass.properties[i].name);
      Writer.WriteString(uclass.properties[i].ptype);
      Writer.WriteString(uclass.properties[i].modifiers);
      Writer.WriteInteger(uclass.properties[i].srcline);
    end;
    Writer.WriteInteger(uclass.enums.Count);
    for i := 0 to uclass.enums.Count-1 do begin
      Writer.WriteString(uclass.enums[i].name);
      Writer.WriteString(uclass.enums[i].options);
      Writer.WriteInteger(uclass.enums[i].srcline);
    end;
    Writer.WriteInteger(uclass.structs.Count);
    for i := 0 to uclass.structs.Count-1 do begin
      Writer.WriteString(uclass.structs[i].name);
      Writer.WriteString(uclass.structs[i].parent);
      Writer.WriteString(uclass.structs[i].modifiers);
      Writer.WriteString(uclass.structs[i].data);
      Writer.WriteInteger(uclass.structs[i].srcline);
    end;
    Writer.WriteInteger(uclass.states.Count);
    for i := 0 to uclass.states.Count-1 do begin
      Writer.WriteString(uclass.states[i].name);
      Writer.WriteString(uclass.states[i].extends);
      Writer.WriteString(uclass.states[i].modifiers);
      Writer.WriteInteger(uclass.states[i].srcline);
    end;
    Writer.WriteInteger(uclass.functions.Count);
    for i := 0 to uclass.functions.Count-1 do begin
      Writer.WriteString(uclass.functions[i].name);
      Writer.WriteInteger(Ord(uclass.functions[i].ftype));
      Writer.WriteString(uclass.functions[i].return);
      Writer.WriteString(uclass.functions[i].modifiers);
      Writer.WriteString(uclass.functions[i].params);
      if (uclass.functions[i].state = nil) then Writer.WriteString('')
        else Writer.WriteString(uclass.functions[i].state.name);
      Writer.WriteInteger(uclass.functions[i].srcline);
    end;
  finally
    Writer.Free;
  end;
end;

procedure TUnCodeXState.LoadClassesFromStream(stream: TStream);
var
  Reader: TReader;
  NumClasses: Cardinal;
  ALevel, n, m, i: integer;
  ANode, NextNode: TTreeNode;
  uclass, puclass: TUClass;
  uconst: TUConst;
  uprop: TUProperty;
  uenum: TUEnum;
  ustruct: TUStruct;
  ustate: TUstate;
  ufunc: TUFunction;
begin
  ANode := nil;
  puclass := nil;
  Reader := TReader.Create(stream, 4096);
  try
    Stream.Read(NumClasses, 4);
    for n := 0 to NumClasses-1 do begin
      uclass := TUClass.Create;
      uclass.name := Reader.ReadString;
      ALevel := Reader.ReadInteger;
      uclass.package := GetPackage(Reader.ReadString);
      uclass.tagged := uclass.package.tagged;
      uclass.parentname := Reader.ReadString;
      uclass.filename := Reader.ReadString;
      uclass.modifiers := Reader.ReadString;
      uclass.filetime := Reader.ReadInteger;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        uconst := TUconst.Create;
        uconst.name := Reader.ReadString;
        uconst.value := Reader.ReadString;
        uconst.srcline := Reader.ReadInteger;
        uclass.consts.Add(uconst)
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        uprop := TUProperty.Create;
        uprop.name := Reader.ReadString;
        uprop.ptype := Reader.ReadString;
        uprop.modifiers := Reader.ReadString;
        uprop.srcline := Reader.ReadInteger;
        uclass.properties.Add(uprop);
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        uenum := TUEnum.Create;
        uenum.name := Reader.ReadString;
        uenum.options := Reader.ReadString;
        uenum.srcline := Reader.ReadInteger;
        uclass.enums.Add(uenum);
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        ustruct := TUStruct.Create;
        ustruct.name := Reader.ReadString;
        ustruct.parent := Reader.ReadString;
        ustruct.modifiers := Reader.ReadString;
        ustruct.data := Reader.ReadString;
        ustruct.srcline := Reader.ReadInteger;
        uclass.structs.Add(ustruct);
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        ustate := TUstate.Create;
        ustate.name := Reader.ReadString;
        ustate.extends := Reader.ReadString;
        ustate.modifiers := Reader.ReadString;
        ustate.srcline := Reader.ReadInteger;
        uclass.states.Add(ustate);
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        ufunc := TUFunction.Create;
        ufunc.name := Reader.ReadString;
        ufunc.ftype := TUFunctionType(Reader.ReadInteger);
        ufunc.return := Reader.ReadString;
        ufunc.modifiers := Reader.ReadString;
        ufunc.params := Reader.ReadString;
        ufunc.state := GetState(Reader.ReadString, uclass);
        ufunc.srcline := Reader.ReadInteger;
        uclass.functions.Add(ufunc);
      end;
      if ANode = nil then // root
        ANode := FClassTree.Items.AddChildObject(nil, uclass.name, uclass)
      else if ANode.Level = ALevel then begin // same level
        uclass.parent := puclass.parent;
        ANode := FClassTree.Items.AddChildObject(ANode.Parent, uclass.name, uclass);
      end
      else if ANode.Level = (ALevel - 1) then begin // child
        uclass.parent := puclass;
        ANode := FClassTree.Items.AddChildObject(ANode, uclass.name, uclass);
      end
      else if ANode.Level > ALevel then // parent level
      begin
        NextNode := ANode.Parent;
        while NextNode.Level > ALevel do
          NextNode := NextNode.Parent;
        if (NextNode.Parent = nil) then uclass.parent := nil
          else uclass.parent := TUClass(NextNode.Parent.Data);
        ANode := FClassTree.Items.AddChildObject(NextNode.Parent, uclass.name, uclass);
      end
      else TreeViewErrorFmt(sInvalidLevelEx, [ALevel, uclass.name]);
      uclass.treenode := ANode;
      if (uclass.tagged) then begin
        uclass.treenode.ImageIndex := ICON_CLASS_TAGGED;
        uclass.treenode.StateIndex := ICON_CLASS_TAGGED;
        uclass.treenode.SelectedIndex := ICON_CLASS_TAGGED;
      end
      else begin
        uclass.treenode.ImageIndex := ICON_CLASS;
        uclass.treenode.StateIndex := ICON_CLASS;
        uclass.treenode.SelectedIndex := ICON_CLASS;
      end;
      FClassList.Add(uclass);
      uclass.package.classes.Add(uclass);
      with FPackageTree.Items.AddChildObject(uclass.package.treenode, uclass.name, uclass) do begin
        ImageIndex := uclass.treenode.ImageIndex;
        StateIndex := uclass.treenode.StateIndex;
        SelectedIndex := uclass.treenode.SelectedIndex;
      end;
      puclass := uclass;
    end;
    Reader.FlushBuffer;
  finally
    Reader.Free;
  end;
end;

procedure TUnCodeXState.LoadPackagesFromStream(stream: TStream);
var
  Reader: TReader;
  NumPackages: Cardinal;
  n: Integer;
  package: TUPackage;
begin
  Reader := TReader.Create(stream, 4096);
  try
    Stream.Read(NumPackages, 4);
    for n := 0 to NumPackages-1 do begin
      package := TUPackage.Create;
      package.name := Reader.ReadString;
      package.priority := Reader.ReadInteger;
      package.path := Reader.ReadString;
      package.tagged := Reader.ReadBoolean;
      package.treenode := FPackageTree.Items.AddObject(nil, package.name, package);
      if (package.tagged) then begin
        package.treenode.ImageIndex := ICON_PACKAGE_TAGGED;
        package.treenode.StateIndex := ICON_PACKAGE_TAGGED;
        package.treenode.SelectedIndex := ICON_PACKAGE_TAGGED;
      end
      else begin
        package.treenode.ImageIndex := ICON_PACKAGE;
        package.treenode.StateIndex := ICON_PACKAGE;
        package.treenode.SelectedIndex := ICON_PACKAGE;
      end;
      FPackageList.Add(package);
    end;
  finally
    Reader.Free;
  end;
end;

procedure TUnCodeXState.Clear;
begin
  FClassTree.Items.Clear;
  FClassList.Clear;
  FPackageTree.Items.Clear;
  FPackageList.Clear;
end;

procedure TUnCodeXState.Delete(Index: Integer);
begin

end;

procedure TUnCodeXState.Insert(Index: Integer; const S: string);
begin

end;

function TUnCodeXState.GetPackage(name: string): TUPackage;
var
  i: integer;
begin
  for i := 0 to FPackageList.Count-1 do begin
    if (CompareText(name, FPackageList[i].name) = 0) then begin
      result := FPackageList[i];
      exit;
    end;
  end;
  result := nil;
end;

function TUnCodeXState.GetState(name: string; uclass: TUClass): TUState;
var
  i: integer;
begin
  for i := 0 to uclass.states.Count-1 do begin
    if (CompareText(name, uclass.states[i].name) = 0) then begin
      result := uclass.states[i];
      exit;
    end;
  end;
  result := nil;
end;

constructor TUnCodeXState.Create(AOwner: TUClassList; CTree: TTreeView; PList: TUPackageList; PTree: TTreeView);
begin
  inherited Create;
  FClassTree := CTree;
  FClassList := AOwner;
  FPackageList := PList;
  FPackageTree := PTree;
end;

function TUnCodeXState.LoadTreeFromStream(Stream: TStream): boolean;
var
  tmp: array[0..8] of char;
begin
  Stream.Position := 0;
  Stream.Read(tmp, 9);
  result := false;
  if (StrComp(tmp, UCXheader) = 0) then begin
    Clear;
    LoadPackagesFromStream(stream);
    LoadClassesFromStream(stream);
    FClassList.Sort;
    FPackageList.Sort;
    result := true;
  end
  else Log('State file corrupt or unsupported version');
end;

procedure TUnCodeXState.SaveTreeToStream(Stream: TStream);
var
  i: integer;
  c: cardinal;
begin
  stream.WriteBuffer(UCXheader, 9);
  // packages
  c := FPackageList.Count;
  stream.WriteBuffer(c, 4);
  for i := 0 to FPackageList.Count-1 do begin
    SavePackageToStream(FPackageList[i] , stream);
  end;
  // classes
  c := FClassTree.Items.Count;
  stream.WriteBuffer(c, 4);
  for i := 0 to FClassTree.Items.Count-1 do begin
    SaveClassToStream(TUClass(FClassTree.Items[i].Data), stream);
  end;
end;

{ TUnCodeXState -- END }

end.
