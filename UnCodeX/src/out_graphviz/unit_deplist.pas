unit unit_deplist;

interface

uses
  Classes, Contnrs, SysUtils, unit_uclasses;

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
    property Items[Index: Integer]: TDependency read GetItem write SetItem; default;
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

function TDepListSortOnPackage(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TDependency(Item1).source.package.name, TDependency(Item2).source.package.name);
end;

procedure TDepList.SortOnPackage;
begin
  inherited Sort(TDepListSortOnPackage);
end;

end.
