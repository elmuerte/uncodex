unit unit_deplist;

interface

uses
  Classes, Contnrs, SysUtils, unit_uclasses, Graphics;

type
  TDependency = class(TObject)
  public
    source:   TUClass;
    depends:  TUClass;
    isChild:  boolean;
    constructor Create(insource, independs: TUClass; inisChild: boolean = true);
  end;

  TDepList = class(TObjectList)
  private
    function GetItem(Index: Integer): TDependency;
    procedure SetItem(Index: Integer; AObject: TDependency);
  public
    procedure SortOnPackage;
    procedure FilterDuplicates;
    procedure FilterDuplicatePackages;
    function Add(AObject: TDependency): Integer;
    property Items[Index: Integer]: TDependency read GetItem write SetItem; default;
  end;

  TGraphUPAckageList = class(TUPackageList)
  public
    colors: TStringList;
    constructor Create(AOwnsObjects: Boolean);
    destructor Destroy; override;
  end;

  TOrphan = class(TObject)
  public
    uclass:   TUClass;
    constructor Create(inuclass: TUClass);
  end;

  TOrphanList = class(TObjectList)
  private
    function GetItem(Index: Integer): TOrphan;
    procedure SetItem(Index: Integer; AObject: TOrphan);
  public
    procedure SortOnPackage;
    procedure FilterPackages(plist: TUPackageList);
    property Items[Index: Integer]: TOrphan read GetItem write SetItem; default;
  end;

implementation

{ TDependency }

constructor TDependency.Create(insource, independs: TUClass; inisChild: boolean = true);
begin
  inherited Create;
  source := insource;
  depends := independs;
  isChild := inisChild;
end;

{ TDepList }

function TDepList.GetItem(Index: Integer): TDependency;
begin
  result := TDependency(inherited GetItem(Index));
end;

procedure TDepList.SetItem(Index: Integer; AObject: TDependency);
begin
  inherited SetItem(index, AObject);
end;

function TDepList.Add(AObject: TDependency): Integer;
var
  i: integer;
begin
  for i := 0 to Count-1 do begin
    if (AObject.source = Items[i].source) and (AObject.depends = Items[i].depends) then begin
      result := -1;
      exit;
    end;
  end;
  result := inherited Add(AObject);
end;

function TDepListSortOnPackage(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TDependency(Item1).source.package.name, TDependency(Item2).source.package.name);
  //if (result = 0) then result := CompareText(TDependency(Item1).source.name, TDependency(Item2).source.name);
  //if (result = 0) then result := CompareText(TDependency(Item1).depends.name, TDependency(Item2).depends.name);
  //if (result = 0) then result := Ord(TDependency(Item1).isChild)-Ord(TDependency(Item2).isChild);
end;

procedure TDepList.SortOnPackage;
begin
  inherited Sort(TDepListSortOnPackage);
end;

procedure TDepList.FilterDuplicates;
var
  i,j: integer;
begin
  for i := Count-1 downto 0 do begin
    for j := i-1 downto 0 do begin
      if ((Items[j].source = Items[i].source) and (Items[j].depends = Items[i].depends)) then begin
        Delete(i);
        break;
      end;
    end;
  end;
end;

procedure TDepList.FilterDuplicatePackages;
var
  i,j: integer;
begin
  for i := Count-1 downto 0 do begin
    for j := i-1 downto 0 do begin
      if ((Items[j].source.package = Items[i].source.package)
        and (Items[j].depends.package = Items[i].depends.package)) then begin
        Delete(i);
        break;
      end;
    end;
  end;
end;

{ TGraphUPAckageList }

constructor TGraphUPAckageList.Create(AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);
  colors := TStringList.Create;
end;

destructor TGraphUPAckageList.Destroy;
begin
  colors.free;
  inherited;
end;

{ TOrphan }

constructor TOrphan.Create(inuclass: TUClass);
begin
  inherited Create;
  uclass := inuclass;
end;

{ TOrphanList }

function TOrphanList.GetItem(Index: Integer): TOrphan;
begin
  result := TOrphan(inherited GetItem(Index));
end;

procedure TOrphanList.SetItem(Index: Integer; AObject: TOrphan);
begin
  inherited SetItem(index, AObject);
end;

function TOrphanListSortOnPackage(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TOrphan(Item1).uclass.package.name, TOrphan(Item2).uclass.package.name);
end;

procedure TOrphanList.SortOnPackage;
begin
  inherited Sort(TDepListSortOnPackage);
end;

procedure TOrphanList.FilterPackages(plist: TUPackageList);
var
  i,j: integer;
begin
  for i := Count-1 downto 0 do begin
    for j := 0 to plist.Count-1 do begin
      if (Items[i].uclass.package = plist[j]) then begin
        Remove(Items[i]);
        break;
      end;
    end;
  end;
end;

end.
