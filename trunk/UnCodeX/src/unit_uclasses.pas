{*******************************************************************************
  Name:
    unit_uclasses.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Class definitions for UnrealScript elements

  $Id: unit_uclasses.pas,v 1.47 2005-03-13 09:25:20 elmuerte Exp $
*******************************************************************************}
{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003-2005  Michiel Hendriks

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

{$I defines.inc}

interface

uses
  Classes, Contnrs, SysUtils;

const
  // used for output module compatibility testing
  UCLASSES_REV: LongInt = 3;

type
  TUCommentType = (ctSource, ctExtern, ctInherited);

  TUClass = class;
  TUPackage = class;
  TUFunctionList = class;
                    
  TDefinitionList = class(TObject)
    fowner:   TUClass;
    defines:  TStringList;
    curToken:   string;
    procedure _nextToken(var line: string);
    function _expr(var line: string): boolean;
    function _orx(var line: string): boolean;
    function _andx(var line: string): boolean;
    function _unaryx(var line: string): boolean;
    function _operand(var line: string): boolean;
    function _lvalue(var line: string): boolean;
  public
    function IsDefined(name: string): boolean;
    function GetDefine(name: string): string;
    function Eval(line: string): boolean;
    function define(name, value: string): boolean;
    function undefine(name: string): boolean;
    constructor Create(owner: TUClass);
    destructor Destroy; override;
    property Definitions: TStringList read defines;
  end;

  // general Unreal Object
  TUObject = class(TObject)
    name:         string;
    comment:      string;
    CommentType:  TUCommentType;
    function declaration: string; virtual;
  end;

  // used for declarations in classes(e.g. functions, variables)
  TUDeclaration = class(TUObject)
    srcline:      integer;
    definedIn:    string; // set to the filename this variable was
                // declared in if not in the class source file
                // itself (e.g. via the #include macro).
  end;

  // general Unreal Object List
  TUObjectList = class(TObjectList)
  public
    function Find(name: string): TUObject;
  end;

  TUConst = class(TUDeclaration)
    value:  string;
    function declaration: string; override;
  end;

  TUConstList = class(TUObjectList)
  private
    function GetItem(Index: Integer): TUConst;
    procedure SetItem(Index: Integer; AObject: TUConst);
  public
    procedure Sort;
    function Find(name: string): TUConst;
    property Items[Index: Integer]: TUConst read GetItem write SetItem; default;
  end;

  TUProperty = class(TUDeclaration)
    ptype:      string;
    modifiers:  string;
    tag:        string;
    function declaration: string; override;
  end;

  TUPropertyList = class(TUObjectList)
  private
    function GetItem(Index: Integer): TUProperty;
    procedure SetItem(Index: Integer; AObject: TUProperty);
  public
    procedure Sort;
    function Find(name: string): TUProperty;
    procedure SortOnTag;
    property Items[Index: Integer]: TUProperty read GetItem write SetItem; default;
  end;

  TUEnum = class(TUDeclaration)
    options:  string;
    function declaration: string; override;
  end;

  TUEnumList = class(TUObjectList)
  private
    function GetItem(Index: Integer): TUEnum;
    procedure SetItem(Index: Integer; AObject: TUEnum);
  public
    procedure Sort;
    function Find(name: string): TUEnum;
    property Items[Index: Integer]: TUEnum read GetItem write SetItem; default;
  end;

  TUStruct = class(TUDeclaration)
    parent:     string;
    modifiers:  string;
    properties: TUPropertyList;
    constructor Create;
    destructor Destroy; override;
    function declaration: string; override;
  end;

  TUStructList = class(TUObjectList)
  private
    function GetItem(Index: Integer): TUStruct;
    procedure SetItem(Index: Integer; AObject: TUStruct);
  public
    procedure Sort;
    function Find(name: string): TUStruct;
    property Items[Index: Integer]: TUStruct read GetItem write SetItem; default;
  end;

  TUState = class(TUDeclaration)
    extends:    string;
    modifiers:  string;
    functions:  TUFunctionList;
    constructor Create;
    destructor Destroy; override;
    function declaration: string; override;
  end;

  TUStateList = class(TUObjectList)
  private
    function GetItem(Index: Integer): TUState;
    procedure SetItem(Index: Integer; AObject: TUState);
  public
    procedure Sort;
    function Find(name: string): TUState;
    property Items[Index: Integer]: TUState read GetItem write SetItem; default;
  end;

  TUFunctionType = (uftFunction, uftEvent, uftOperator, uftPreOperator, uftPostOperator, uftDelegate);

  TUFunction = class(TUDeclaration)
    ftype:      TUFunctionType;
    return:     string;
    modifiers:  string;
    params:     string;
    state:      TUState;
    args:       TUPropertyList; // parsed argument list (NOT USED)
    locals:     TUPropertyList; // local variable delcrations (NOT USED)
    constructor Create;
    destructor Destroy; override;
    function declaration: string; override;
  end;

  TUFunctionList = class(TUObjectList)
  private
    function GetItem(Index: Integer): TUFunction;
    procedure SetItem(Index: Integer; AObject: TUFunction);
  public
    procedure Sort;
    function Find(name: string; state: string = ''): TUFunction;
    property Items[Index: Integer]: TUFunction read GetItem write SetItem; default;
  end;

  TUClassList = class;

  TUCInterfaceType = (itNone, itTribesV);

  TUClass = class(TUObject)
  public
    parent:             TUClass;
    filename:           string;
    package:            TUPackage;
    parentname:         string;
    modifiers:          string;
    InterfaceType:      TUCInterfaceType;
    //implements:       TUClassList; // implements these interfaces
    priority:           integer;
    consts:             TUConstList;
    properties:         TUPropertyList;
    enums:              TUEnumList;
    structs:            TUStructList;
    states:             TUstateList;
    functions:          TUFunctionList;
    delegates:          TUFunctionList;
    treenode:           TObject; // class tree node
    treenode2:          TObject; // the second tree node (PackageTree)
    filetime:           integer; // used for checking for changed files
    defaultproperties:  string; // AS IS
    tagged:             boolean;
    children:           TUClassList; // not owned, don't free, don't save
    deps:               TUClassList; // dependency list, not owned, don't free (NOT USED)
    defs:               TDefinitionList;
    includes:           TStringList; // #include files: "line no.=file"
    constructor Create;
    destructor Destroy; override;
    function FullName: string;
    function FullFileName: string;
    function declaration: string; override;
  end;

  TUClassList = class(TUObjectList)
  private
    function GetItem(Index: Integer): TUClass;
    procedure SetItem(Index: Integer; AObject: TUClass);
  public
    procedure Sort;
    function Find(name: string): TUClass;
    property Items[Index: Integer]: TUClass read GetItem write SetItem; default;
  end;

  TUPackage = class(TUObject)
    classes:    TUClassList;
    priority:   integer;
    path:       string; // class path
    treenode:   TObject;
    tagged:     boolean;
    constructor Create;
    destructor Destroy; override;
    function PackageDir: string; // returns the actual package dir
    function declaration: string; override;
  end;

  TUPackageList = class(TUObjectList)
  private
    function GetItem(Index: Integer): TUPackage;
    procedure SetItem(Index: Integer; AObject: TUPackage);
  public
    procedure Sort;
    procedure AlphaSort;
    function Find(name: string): TUPackage;
    property Items[Index: Integer]: TUPackage read GetItem write SetItem; default;
  end;

  function UFunctionTypeToString(utype: TUFunctionType): string;

implementation

{ }

function TUObject.declaration: string;
begin
  result := '';
end;

function TUObjectList.Find(name: string): TUObject;
var
  i: integer;
begin
  result := nil;
  for i := 0 to Count-1 do begin
    if (CompareText(TUObject(Items[i]).name, name)= 0) then begin
      result := TUObject(Items[i]);
      exit;
    end;
  end;
end;

{ TUConst }
function TUConst.declaration: string;
begin
  result := 'const '+name+' = '+value+';';
end;

{ TUConstList }
function TUConstListCompare(Item1, Item2: Pointer): integer;
begin
  result := CompareText(TUConst(Item1).name, TUConst(Item2).name);
end;

procedure TUConstList.Sort;
begin
  inherited Sort(TUConstListCompare);
end;

function TUConstList.Find(name: string): TUConst;
begin
  result := TUConst(inherited Find(name));
end;

function TUConstList.GetItem(Index: Integer): TUConst;
begin
  result := TUConst(inherited GetItem(Index));
end;

procedure TUConstList.SetItem(Index: Integer; AObject: TUConst);
begin
  inherited SetItem(index, AObject);
end;

{ TUEnum }
function TUEnum.declaration: string;
begin
  result := 'enum '+name+' { '+options+' };';
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

function TUEnumList.Find(name: string): TUEnum;
begin
  result := TUEnum(inherited Find(name));
end;

function TUEnumList.GetItem(Index: Integer): TUEnum;
begin
  result := TUEnum(inherited GetItem(Index));
end;

procedure TUEnumList.SetItem(Index: Integer; AObject: TUEnum);
begin
  inherited SetItem(index, AObject);
end;

{ TUProperty }
function TUProperty.declaration: string;
begin
  result := 'var';
  if (tag <> '') then begin
    result := result+'('+tag+')';
  end;
  result := result + ' '+modifiers+' '+ptype+' '+name+';';
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

function TUPropertyList.Find(name: string): TUProperty;
begin
  result := TUProperty(inherited Find(name));
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
  FreeAndNil(properties);
end;

function TUStruct.declaration: string;
var
  i: integer;
begin
  result := 'struct '+modifiers+' '+name;
  if (parent <> '') then result := result+ ' extends '+parent;
  result := result+ ' {';
  for i := 0 to properties.Count-1 do result := result +' '+ properties[i].declaration;
  result := result+ ' };';
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

function TUStructList.Find(name: string): TUStruct;
begin
  result := TUStruct(inherited Find(name));
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
  FreeAndNil(functions);
end;

function TUState.declaration: string;
begin
  result := modifiers+' state '+name;
  if (extends <> '') then result := result+' extends '+extends;
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

function TUStateList.Find(name: string): TUState;
begin
  result := TUState(inherited Find(name));
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
function UFunctionTypeToString(utype: TUFunctionType): string;
begin
  case utype of
     uftFunction:     result := 'function';
     uftEvent:        result := 'event';
     uftOperator:     result := 'operator';
     uftPreOperator:  result := 'preoperator';
     uftPostOperator: result := 'postoperator';
     uftDelegate:     result := 'delegate';
  end;
end;

constructor TUFunction.Create;
begin
  locals := TUPropertyList.Create(true);
end;

destructor TUFunction.Destroy;
begin
  FreeAndNil(locals);
end;

function TUFunction.declaration: string;
begin
  result := modifiers+' '+UFunctionTypeToString(ftype)+' '+return+' '+name+' ( '+params+' )';
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

function TUFunctionList.Find(name: string; state: string = ''): TUFunction;
var
  i: integer;
begin
  result := nil;
  for i := 0 to Count-1 do begin
    if (CompareText(Items[i].name, name) = 0) then begin
      // no state
      if (state = '') then begin
        if (Items[i].state = nil) then begin
          result := Items[i];
          exit;
        end;
      end
      // state
      else if (Items[i].state <> nil) then begin
        if (CompareText(Items[i].state.name, state) = 0) then begin
          result := Items[i];
          exit;
        end;
      end;
    end;
  end;
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
  defs := TDefinitionList.Create(self);
  includes := TStringList.Create;
end;

destructor TUClass.Destroy;
begin
  FreeAndNil(consts);
  FreeAndNil(properties);
  FreeAndNil(enums);
  FreeAndNil(structs);
  FreeAndNil(states);
  FreeAndNil(functions);
  FreeAndNil(delegates);
  FreeAndNil(children);
  FreeAndNil(deps);
  FreeAndNil(defs);
  FreeAndNil(includes);
end;

function TUClass.FullName: string;
begin
  result := package.name+'.'+name;
end;

function TUClass.FullFileName: string;
begin
  result := package.path+PathDelim+filename
end;

function TUClass.declaration: string;
begin
  case InterfaceType of
    itNone:   result := 'class';
    itTribesV:  result := 'interface';
  end;
  result := result + ' ' + name;
  if (parentname <> '') then result := result + 'extends' + parentname;
  result := result + ' ' + modifiers + ';'
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

function TUClassList.Find(name: string): TUClass;
begin
  result := TUClass(inherited Find(name));
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
  FreeAndNil(classes);
end;

function TUPackage.PackageDir: string;
begin
  result := ExtractFilePath(path);
end;

function TUPackage.declaration: string;
begin
  result := '';
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

function TUPackageList.Find(name: string): TUPackage;
begin
  result := TUPackage(inherited Find(name));
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

{ TDefinitionList }

const
  UNDEFINED = #1#9#1#2;

constructor TDefinitionList.Create(owner: TUClass);
begin
  fowner := owner;
  defines := TStringList.Create;
end;

destructor TDefinitionList.Destroy;
begin
  fowner := nil;
  FreeAndNil(defines);
end;

function TDefinitionList.IsDefined(name: string): boolean;
var
  val: string;
begin
  result := false;
  if (defines.IndexOfName(name) > -1) then begin
    val := defines.Values[name];
    result := (val <> '0') and (val <> UNDEFINED);
  end
  else if (fowner <> nil) then begin
    if (fowner.parent <> nil) then result := fowner.parent.defs.IsDefined(name);
  end;
end;

function TDefinitionList.GetDefine(name: string): string;
var
  val: string;
begin
  result := UNDEFINED;
  if (defines.IndexOfName(name) > -1) then begin
    val := defines.Values[name];
    result := val;
  end
  else if (fowner <> nil) then begin
    if (fowner.parent <> nil) then result := fowner.parent.defs.GetDefine(name);
  end;
end;

{ evaluator -- BEGIN }
{
  EBNF:

EXPR    ::= ORX
ORX     ::= ANDX ( '||' ORX )*
ANDX    ::= UNARYX ( '&&' ANDX )*
UNARYX    ::= ( '!' )? OPERAND
OPERAND   ::= LVALUE | '(' EXPR ')'
LVALUE    ::= integer | IDENTIFIER

  supported operators:
  && || ()

  symbols will be resolved to integers (if undefined => 0)
}

procedure TDefinitionList._nextToken(var line: string);
const
  CHAR_IDENTIFIER = ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_'];

  function isblank(c: char): boolean;
  begin
    result := false;
    case c of
      #0..#32:  result := true;
    end;
  end;

var
  i,j: integer;
begin
  if (length(line) = 0) then begin
    curToken := '';
    exit;
  end;
  i := 1;
  while (isblank(line[i]) and (i <= length(line))) do begin
    Inc(i);
  end;
  {while (not isblank(line[j]) and (j <= length(line))) do begin
    Inc(j);
  end;}
  j := i;
  case line[j] of
    '(', ')': Inc(j);
    '!', '&', '|':
      while line[j] in ['!', '&', '|'] do begin
        Inc(j);
        if (j > length(line)) then break;
      end;
  else // identifier/number
    while (not isblank(line[j]) and (line[j] in CHAR_IDENTIFIER)) do begin
      Inc(j);
      if (j > length(line)) then break;
    end;
  end;
  curToken := Copy(line, i, j-i);
  Delete(line, 1, j-1);
end;

function TDefinitionList._expr(var line: string): boolean;
begin
  _nextToken(line); // because it's not set yet
  result := _orx(line);
end;

function TDefinitionList._orx(var line: string): boolean;
begin
  result := _andx(line);
  while (curToken = '||') do begin
    _nextToken(line);
    result := result and  _orx(line);
  end;
end;

function TDefinitionList._andx(var line: string): boolean;
begin
  result := _unaryx(line);
  while (curToken = '&&') do begin
    _nextToken(line);
    result := result and  _andx(line);
  end;
end;

function TDefinitionList._unaryx(var line: string): boolean;
begin
  if ( curToken = '!' ) then begin
    _nextToken(line);
    result := not _operand(line);
  end
  else result := _operand(line);
end;

function TDefinitionList._operand(var line: string): boolean;
begin
  if ( curToken = '(') then begin
    //_nextToken(line); DON'T, this will be done in _expr()
    result := _expr(line);
    if ( curToken = ')') then _nextToken(line)
    else raise Exception.Create('Unterminated bracket. Token = "'+curToken+'"');
  end
  else result := _lvalue(line);
end;

function TDefinitionList._lvalue(var line: string): boolean;
begin
  try
    if (IsValidIdent(curToken)) then result := IsDefined(curToken)
    else begin
      try
        result := StrToInt(curToken) <> 0;
      except
        result := false;
        raise Exception.Create('Invalid literal value "'+curToken+'"');
      end;
    end;
  finally
    _nextToken(line);
  end;
end;

{ evaluator -- END }

function TDefinitionList.Eval(line: string): boolean;
begin
  result := _expr(line);
  //result := IsDefined(line);
end;

// returns true when a new value was added
function TDefinitionList.define(name, value: string): boolean;
begin
  result := defines.IndexOfName(name) = -1;
  defines.Values[name] := value;
end;

// returns true when definition was deletes
// if false it was UNDEFINED
function TDefinitionList.undefine(name: string): boolean;
var
  i: integer;
begin
  i := defines.IndexOfName(name);
  result := false;
  if (i <> -1) then begin
    result := true;
    defines.Delete(i);
  end
  else begin
    defines.Values[name] := UNDEFINED;
  end;
end;

end.


