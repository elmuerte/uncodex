{-----------------------------------------------------------------------------
 Unit Name: unit_uclasses
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   definitions for Unreal Classes
 $Id: unit_uclasses.pas,v 1.28 2004-07-28 21:31:44 elmuerte Exp $
-----------------------------------------------------------------------------}
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

unit unit_uclasses;

interface

uses
  Classes, Contnrs, SysUtils;

type
	TUCommentType = (ctSource, ctExtern, ctInherited);

  TUPackage = class;
  TUFunctionList = class;

  // general Unreal Object
  TUObject = class(TObject)
    name:       	string;
    srcline:    	integer;
    comment:    	string;
    CommentType:	TUCommentType;
  end;

  TUConst = class(TUObject)
    value:      string;
  end;

  TUConstList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUConst;
    procedure SetItem(Index: Integer; AObject: TUConst);
  public
    procedure Sort;
    property Items[Index: Integer]: TUConst read GetItem write SetItem; default;
  end;

  TUProperty = class(TUObject)
    ptype:      string;
    modifiers:  string;
    tag:        string;
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

  TUEnum = class(TUObject)
    options:    string;
  end;

  TUEnumList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUEnum;
    procedure SetItem(Index: Integer; AObject: TUEnum);
  public
    procedure Sort;
    property Items[Index: Integer]: TUEnum read GetItem write SetItem; default;
  end;

  TUStruct = class(TUObject)
    parent:     string;
    modifiers:  string;
    data:       string;
    properties: TUPropertyList;
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

  TUState = class(TUObject)
    extends:    string;
    modifiers:  string;
    functions:  TUFunctionList;
    constructor Create;
    destructor Destroy; override;
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

  TUFunction = class(TUObject)
    ftype:      TUFunctionType;
    return:     string;
    modifiers:  string;
    params:     string;
    state:      TUState;
    args:				TUPropertyList; // parsed argument list (NOT USED)
    locals:			TUPropertyList; // local variable delcrations (NOT USED)
    constructor Create;
    destructor Destroy; override;
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

  TUClass = class(TUObject)
  public
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
    delegates:  TUFunctionList;
    treenode:   TObject; // class tree node
    treenode2:  TObject; // the second tree node (PackageTree)
    filetime:   integer; // used for checking for changed files
    defaultproperties: string; // AS IS
    tagged:     boolean;
    children:   TUClassList; // not owned, don't free, don't save
    deps:				TUClassList; // dependency list, not owned, don't free (NOT USED)
    constructor Create;
    destructor Destroy; override;
    function FullName: string;
    function FullFileName: string;
  end;

  TUClassList = class(TObjectList)
  private
    function GetItem(Index: Integer): TUClass;
    procedure SetItem(Index: Integer; AObject: TUClass);
  public
    procedure Sort;
    property Items[Index: Integer]: TUClass read GetItem write SetItem; default;
  end;

  TUPackage = class(TUObject)
    classes:    TUClassList;
    priority:   integer;
    path:       string;
    treenode:   TObject;
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
end;

destructor TUStruct.Destroy;
begin
  properties.Free;
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

{ TUState }
constructor TUState.Create;
begin
  functions := TUFunctionList.Create(false);
end;

destructor TUState.Destroy;
begin
  functions.Free;
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

{ TUFunction }
constructor TUFunction.Create;
begin
  locals := TUPropertyList.Create(true);
end;

destructor TUFunction.Destroy;
begin
  locals.Free;
end;

{ TUFunctionList }
function TUFunctionListCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUFunction(Item1).name, TUFunction(Item2).name);
	if (result <> 0) then exit;
  if ((TUFunction(Item1).state = nil) and (TUFunction(Item2).state = nil)) then exit;
  if ((TUFunction(Item1).state = nil) and (TUFunction(Item2).state <> nil)) then result := -1
  else if ((TUFunction(Item1).state <> nil) and (TUFunction(Item2).state = nil)) then result := 1
  else result := CompareText(TUFunction(Item1).state.name, TUFunction(Item2).state.name);
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
  delegates := TUFunctionList.Create(true);
  children := TUClassList.Create(false);
  deps := TUClassList.Create(false);
end;

destructor TUClass.Destroy;
begin
  consts.Free;
  properties.Free;
  enums.Free;
  structs.Free;
  states.Free;
  functions.Free;
  delegates.Free;
  children.Free;
  deps.Free;
end;

function TUClass.FullName: string;
begin
  result := package.name+'.'+name;
end;

function TUClass.FullFileName: string;
begin
	result := package.path+PathDelim+filename
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
  classes := TUClassList.Create(false); // or else we can't move them around
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


