unit unit_treestate;

interface

uses
  SysUtils, Classes, ComCtrls, ComStrs, Forms, unit_uclasses, unit_definitions;

type
  TClassTreeState = class(TStrings)
  private
    FClassTree: TTreeView;
    FClassList: TUClassList;
    FPackageList: TUPackageList;
    FPackageTree: TTreeView;
  protected
    function GetPackage(name: string): TUPackage;
    function GetBufStart(Buffer: PChar; var Level: Integer): PChar;
  public
    constructor Create(AOwner: TTreeView); overload;
    constructor Create(AOwner: TUClassList; CTree: TTreeView; PList: TUPackageList; PTree: TTreeView); overload;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure LoadTreeFromStream(Stream: TStream);
    procedure SaveTreeToStream(Stream: TStream);
  end;

  TPackageState = class(TStrings)
  private
    FPackageList: TUPackageList;
    FPackageTree: TTreeView;
  public
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override; 
    constructor Create(AOwner: TUPackageList); overload;
    constructor Create(AOwner: TUPackageList; PTree: TTreeView); overload;
    procedure SaveStateToStream(Stream: TStream);
    procedure LoadStateFromStream(Stream: TStream);
  end;

implementation

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

constructor TClassTreeState.Create(AOwner: TTreeView);
begin
  inherited Create;
  FClassTree := AOwner
end;

constructor TClassTreeState.Create(AOwner: TUClassList; CTree: TTreeView; PList: TUPackageList; PTree: TTreeView);
begin
  inherited Create;
  FClassTree := CTree;
  FClassList := AOwner;
  FPackageList := PList;
  FPackageTree := PTree;
end;

function TClassTreeState.GetBufStart(Buffer: PChar; var Level: Integer): PChar;
begin
  Level := 0;
  while Buffer^ in [' ', #9] do
  begin
    Inc(Buffer);
    Inc(Level);
  end;
  Result := Buffer;
end;

procedure TClassTreeState.Clear;
begin
  FClassTree.Items.Clear;
  FClassList.Clear;
end;

procedure TClassTreeState.Delete(Index: Integer);
begin

end;

procedure TClassTreeState.Insert(Index: Integer; const S: string);
begin

end;

function TClassTreeState.GetPackage(name: string): TUPackage;
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

procedure TClassTreeState.LoadTreeFromStream(Stream: TStream);
var
  List: TStringList;
  ANode, NextNode: TTreeNode;
  ALevel, i: Integer;
  CurrStr: string;
  uclass, puclass: TUClass;
begin
  List := TStringList.Create;
  FClassTree.Items.BeginUpdate;
  FPackageTree.Items.BeginUpdate;
  try
    try
      Clear;
      List.LoadFromStream(Stream);
      ANode := nil;
      puclass := nil;
      i := 0;
      while ((i < List.Count) and (list[i] <> StartOfText+StartOfHeader+'classes')) do Inc(i);
      Inc(i);
      while ((i < List.Count) and (List[i] <> EndOfText)) do begin
        Application.ProcessMessages;
        uclass := TUClass.Create;
        CurrStr := GetBufStart(PChar(List[i]), ALevel);
        uclass.name := GetUnit(CurrStr, 0);
        uclass.package := GetPackage(GetUnit(CurrStr, 1));
        uclass.parentname := GetUnit(CurrStr, 2);
        uclass.filename := GetUnit(CurrStr, 3);
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
        else TreeViewErrorFmt(sInvalidLevelEx, [ALevel, CurrStr]);
        uclass.treenode := ANode;
        uclass.treenode.ImageIndex := 1;
        uclass.treenode.StateIndex := 1;
        uclass.treenode.SelectedIndex := 1;
        FClassList.Add(uclass);
        uclass.package.classes.Add(uclass);
        with FPackageTree.Items.AddChildObject(uclass.package.treenode, uclass.name, uclass) do begin
          ImageIndex := 1;
          StateIndex := 1;
          SelectedIndex := 1;
        end;
        puclass := uclass;
        Inc(i);
      end;
    finally
      FClassTree.Items.EndUpdate;
      FPackageTree.Items.EndUpdate;
      List.Free;
    end;
  except
    FClassTree.Invalidate;  // force repaint on exception
    FPackageTree.Invalidate;
    raise;
  end;
end;

procedure TClassTreeState.SaveTreeToStream(Stream: TStream);
var
  i: Integer;
  ANode: TTreeNode;
  NodeStr: string;
begin
  NodeStr := StartOfText + StartOfHeader + 'classes' + EndOfLine;
  Stream.Write(Pointer(NodeStr)^, Length(NodeStr));
  if FClassTree.Items.Count > 0 then
  begin
    ANode := FClassTree.Items[0];
    while ANode <> nil do
    begin
      Application.ProcessMessages;
      NodeStr := '';
      for i := 0 to ANode.Level - 1 do NodeStr := NodeStr + TabChar;
      NodeStr := NodeStr + ANode.Text + UnitSeperator +
        TUClass(ANode.Data).package.name + UnitSeperator +
        TUClass(ANode.Data).parentname + UnitSeperator +
        TUClass(ANode.Data).filename + EndOfLine;
      Stream.Write(Pointer(NodeStr)^, Length(NodeStr));
      ANode := ANode.GetNext;
    end;
  end;
  NodeStr := EndOfText + EndOfLine;
  Stream.Write(Pointer(NodeStr)^, Length(NodeStr));
end;

{ TPackageState }

constructor TPackageState.Create(AOwner: TUPackageList);
begin
  inherited Create;
  FPackageList := AOwner;
end;

constructor TPackageState.Create(AOwner: TUPackageList; PTree: TTreeView);
begin
  inherited Create;
  FPackageList := AOwner;
  FPackageTree := PTree;
end;

procedure TPackageState.Clear;
begin
  FPackageList.Clear;
  FPackageTree.Items.Clear;
end;

procedure TPackageState.Delete(Index: Integer);
begin
  
end;

procedure TPackageState.Insert(Index: Integer; const S: string);
begin
  
end;

procedure TPackageState.SaveStateToStream(Stream: TStream);
var
  i: Integer;
  NodeStr: string;
begin
  NodeStr := StartOfText + StartOfHeader + 'packages' + EndOfLine;
  Stream.Write(Pointer(NodeStr)^, Length(NodeStr));
  for i := 0 to FPackageList.Count-1 do begin
    NodeStr := FPackageList[i].name + UnitSeperator +
      IntToStr(FPackageList[i].priority) + UnitSeperator +
      FPackageList[i].path + EndOfLine;
    Stream.Write(Pointer(NodeStr)^, Length(NodeStr));
  end;
  NodeStr := EndOfText + EndOfLine;
  Stream.Write(Pointer(NodeStr)^, Length(NodeStr));
end;

procedure TPackageState.LoadStateFromStream(Stream: TStream);
var
  List: TStringList;
  i: Integer;
  package: TUPackage;
begin
  List := TStringList.Create;
  FPackageTree.Items.BeginUpdate;
  try
    try
      Clear;
      List.LoadFromStream(Stream);
      i := 0;
      while ((i < List.Count) and (list[i] <> StartOfText+StartOfHeader+'packages')) do Inc(i);
      Inc(i);
      while ((i < List.Count) and (List[i] <> EndOfText)) do begin
        package := TUPackage.Create;
        package.name := GetUnit(List[i], 0);
        package.priority := StrToIntDef(GetUnit(List[i], 1), 255);
        package.path := GetUnit(List[i], 2);
        package.treenode := FPackageTree.Items.AddObject(nil, package.name, package);
        package.treenode.ImageIndex := 0;
        package.treenode.StateIndex := 0;
        FPackageList.Add(package);
        Inc(i);
      end;
    finally
      FPackageTree.Items.EndUpdate;
      List.Free;
    end;
  except
    FPackageTree.Invalidate;  // force repaint on exception
    raise;
  end;
end;

end.
