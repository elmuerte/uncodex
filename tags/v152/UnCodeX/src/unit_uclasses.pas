{-----------------------------------------------------------------------------
 Unit Name: unit_uclasses
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   definitions for Unreal Classes
 $Id: unit_uclasses.pas,v 1.15 2003-11-04 19:35:28 elmuerte Exp $
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

unit unit_uclasses;

interface

uses
  Classes, Contnrs, SysUtils;

type
  TUPackage = class;

  TUConst = class(TObject)
    name:       string;
    value:      string;
    srcline:    integer;
    comment:    string;
  end;

  TUConstList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUConst;
    procedure SetItem(Index: Integer; AObject: TUConst);
  public
    procedure Sort;
    property Items[Index: Integer]: TUConst read GetItem write SetItem; default;
  end;

  TUProperty = class(TObject)
    name:       string;
    ptype:      string;
    modifiers:  string;
    tag:        string;
    srcline:    integer;
    comment:    string;
  end;

  TUPropertyList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUProperty;
    procedure SetItem(Index: Integer; AObject: TUProperty);
  public
    procedure Sort;
    procedure SortOnTag;
    property Items[Index: Integer]: TUProperty read GetItem write SetItem; default;
  end;

  TUEnum = class(TObject)
    name:       string;
    options:    string;
    srcline:    integer;
    comment:    string;
  end;

  TUEnumList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUEnum;
    procedure SetItem(Index: Integer; AObject: TUEnum);
  public
    procedure Sort;
    property Items[Index: Integer]: TUEnum read GetItem write SetItem; default;
  end;

  TUStruct = class(TObject)
    name:       string;
    parent:     string;
    modifiers:  string;
    data:       string;
    properties: TUPropertyList;
    enums:      TUEnumList;
    srcline:    integer;
    comment:    string;
    constructor Create;
    destructor Destroy; override;
  end;

  TUStructList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUStruct;
    procedure SetItem(Index: Integer; AObject: TUStruct);
  public
    procedure Sort;
    property Items[Index: Integer]: TUStruct read GetItem write SetItem; default;
  end;

  TUState = class(TObject)
    name:       string;
    extends:    string;
    modifiers:  string;
    srcline:    integer;
    comment:    string;
  end;

  TUStateList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUState;
    procedure SetItem(Index: Integer; AObject: TUState);
  public
    procedure Sort;
    property Items[Index: Integer]: TUState read GetItem write SetItem; default;
  end;

  TUFunctionType = (uftFunction, uftEvent, uftOperator, uftPreOperator, uftPostOperator, uftDelegate);

  TUFunction = class(TObject)
    name:       string;
    ftype:      TUFunctionType;
    return:     string;
    modifiers:  string;
    params:     string;
    state:      TUState;
    srcline:    integer;
    comment:    string;
  end;

  TUFunctionList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUFunction;
    procedure SetItem(Index: Integer; AObject: TUFunction);
  public
    procedure Sort;
    property Items[Index: Integer]: TUFunction read GetItem write SetItem; default;
  end;

  TUClassList = class;

  TUClass = class(TObject)
  public
    name:       string;
    filename:   string;
    package:    TUPackage;
    parent:     TUClass;
    parentname: string;
    modifiers:  string;
    priority:   integer;
    consts:     TUConstList;
    properties: TUPropertyList;
    enums:      TUEnumList;
    structs:    TUStructList;
    states:     TUstateList;
    functions:  TUFunctionList;
    treenode:   TObject;
    filetime:   integer;
    defaultproperties: string;
    comment:    string;
    tagged:     boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  TUClassList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUClass;
    procedure SetItem(Index: Integer; AObject: TUClass);
  public
    procedure Sort;
    property Items[Index: Integer]: TUClass read GetItem write SetItem; default;
  end;

  TUPackage = class(TObject)
    name:       string;
    classes:    TUClassList;
    priority:   integer;
    path:       string;
    treenode:   TObject;
    comment:    string;
    tagged:     boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  TUPackageList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUPackage;
    procedure SetItem(Index: Integer; AObject: TUPackage);
  public
    procedure Sort;
    procedure AlphaSort;
    property Items[Index: Integer]: TUPackage read GetItem write SetItem; default;
  end;

implementation

{ TUConstList }
function TUConstListCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUConst(Item1).name, TUConst(Item2).name);
end;

procedure TUConstList.Sort;
begin
  inherited Sort(TUConstListCompare);
end;

function TUConstList.GetItem(Index: Integer): TUConst;
begin
  result := TUConst(inherited GetItem(Index));
end;

procedure TUConstList.SetItem(Index: Integer; AObject: TUConst);
begin
  inherited SetItem(index, AObject);
end;

{ TUEnumList }
function TUEnumListCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUEnum(Item1).name, TUEnum(Item2).name);
end;

procedure TUEnumList.Sort;
begin
  inherited Sort(TUEnumListCompare);
end;

function TUEnumList.GetItem(Index: Integer): TUEnum;
begin
  result := TUEnum(inherited GetItem(Index));
end;

procedure TUEnumList.SetItem(Index: Integer; AObject: TUEnum);
begin
  inherited SetItem(index, AObject);
end;

{ TUPropertyList }
function TUPropertyListCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUProperty(Item1).name, TUProperty(Item2).name);
end;

procedure TUPropertyList.Sort;
begin
  inherited Sort(TUPropertyListCompare);
end;

function TUPropertyListCompareTag(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUProperty(Item1).tag, TUProperty(Item2).tag);
  if (result = 0) then result := TUPropertyListCompare(Item1, Item2);
end;

procedure TUPropertyList.SortOnTag;
begin
  inherited Sort(TUPropertyListCompareTag);
end;

function TUPropertyList.GetItem(Index: Integer): TUProperty;
begin
  result := TUProperty(inherited GetItem(Index));
end;

procedure TUPropertyList.SetItem(Index: Integer; AObject: TUProperty);
begin
  inherited SetItem(index, AObject);
end;

{ TUStruct }

constructor TUStruct.Create;
begin
  properties := TUPropertyList.Create(true);
  enums := TUEnumList.Create(true);
end;

destructor TUStruct.Destroy;
begin
  properties.Free;
  enums.Free;
end;

{ TUStructList }
function TUStructListCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUStruct(Item1).name, TUStruct(Item2).name);
end;

procedure TUStructList.Sort;
begin
  inherited Sort(TUStructListCompare);
end;

function TUStructList.GetItem(Index: Integer): TUStruct;
begin
  result := TUStruct(inherited GetItem(Index));
end;

procedure TUStructList.SetItem(Index: Integer; AObject: TUStruct);
begin
  inherited SetItem(index, AObject);
end;

{ TUStateList }
function TUStateListCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUState(Item1).name, TUState(Item2).name);
end;

procedure TUStateList.Sort;
begin
  inherited Sort(TUStateListCompare);
end;

function TUStateList.GetItem(Index: Integer): TUState;
begin
  result := TUState(inherited GetItem(Index));
end;

procedure TUStateList.SetItem(Index: Integer; AObject: TUState);
begin
  inherited SetItem(index, AObject);
end;

{ TUFunctionList }
function TUFunctionListCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUFunction(Item1).name, TUFunction(Item2).name);
  {if (result = 0) then begin  //stack overflow ?!
    if (TUFunction(Item1).state = nil) then result := -1
    else if (TUFunction(Item2).state = nil) then result := 1
      else result := CompareText(TUFunction(Item1).state.name, TUFunction(Item2).state.name);
  end;}
end;

procedure TUFunctionList.Sort;
begin
  inherited Sort(TUFunctionListCompare);
end;

function TUFunctionList.GetItem(Index: Integer): TUFunction;
begin
  result := TUFunction(inherited GetItem(Index));
end;

procedure TUFunctionList.SetItem(Index: Integer; AObject: TUFunction);
begin
  inherited SetItem(index, AObject);
end;

{ TUClass }

constructor TUClass.Create;
begin
  consts := TUConstList.Create(true);
  properties := TUPropertyList.Create(true);
  enums := TUEnumList.Create(true);
  structs := TUStructList.Create(true);
  states := TUStateList.Create(true);
  functions := TUFunctionList.Create(true);
end;

destructor TUClass.Destroy;
begin
  consts.Free;
  properties.Free;
  enums.Free;
  structs.Free;
  states.Free;
  functions.Free;
end;

{ TUClassList }
function TUClassListCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUClass(Item1).name, TUClass(Item2).name);
end;

procedure TUClassList.Sort;
begin
  inherited Sort(TUClassListCompare);
end;

function TUClassList.GetItem(Index: Integer): TUClass;
begin
  result := TUClass(inherited GetItem(Index));
end;

procedure TUClassList.SetItem(Index: Integer; AObject: TUClass);
begin
  inherited SetItem(index, AObject);
end;

{ TUPackage }

constructor TUPackage.Create;
begin
  classes := TUClassList.Create(true);
end;

destructor TUPackage.Destroy;
begin
  classes.Free;
end;

{ TUPackageList }
function TUPackageListCompare(Item1, Item2: Pointer): integer;
begin
  result := TUPackage(Item1).priority - TUPackage(Item2).priority;
  if (result = 0) then result := CompareText(TUPackage(Item1).name, TUPackage(Item2).name);
end;

procedure TUPackageList.Sort;
begin
  inherited Sort(TUPackageListCompare);
end;

function TUPackageListAlphaCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUPackage(Item1).name, TUPackage(Item2).name);
end;

procedure TUPackageList.AlphaSort;
begin
  inherited Sort(TUPackageListAlphaCompare);
end;

function TUPackageList.GetItem(Index: Integer): TUPackage;
begin
  result := TUPackage(inherited GetItem(Index));
end;

procedure TUPackageList.SetItem(Index: Integer; AObject: TUPackage);
begin
  inherited SetItem(index, AObject);
end;

end.


