{*******************************************************************************
  Name:
    unit_uclasses.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Class definitions for UnrealScript elements

  $Id: unit_uclasses.pas,v 1.59 2005-04-19 07:49:05 elmuerte Exp $
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
{$M+}

interface

uses
  Classes, Contnrs, SysUtils;

const
  // used for output module compatibility testing
  UCLASSES_REV: LongInt = 6;

type
  TUCommentType = (ctSource, ctExtern, ctInherited);

  TUClass = class;
  TUPackage = class;
  TUFunctionList = class;

  TDefinitionList = class(TObject)
  protected
    fowner:   TUClass;
    defines:  TStringList;
    curToken: string;
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
  protected
    Fname:         string;
    Fcomment:      string;
    FCommentType:  TUCommentType;
  published
    property Name: string read Fname write FName;
    property Comment: string read Fcomment write Fcomment;
    property CommentType: TUCommentType read FCommentType write FCommentType;
    function HTMLdeclaration: string; virtual;
    function declaration: string; virtual; // implemented to make it work for pascalscript
  end;

  // used for declarations in classes(e.g. functions, variables)
  TUDeclaration = class(TUObject)
  protected
    Fsrcline:      integer;
    FdefinedIn:    string; // set to the filename this variable was
                // declared in if not in the class source file
                // itself (e.g. via the #include macro).
    Fowner:        TUObject; // points to uclass or ustruct
  published
    property srcline: integer read Fsrcline write Fsrcline;
    property definedIn: string read FdefinedIn write FdefinedIn;
    property owner: TUObject read Fowner write Fowner;
  end;

  // general Unreal Object List
  TUObjectList = class(TObjectList)
  published
    function Find(name: string): TUObject;
    property Count;
  end;

  TUDeclarationList = class(TUObjectList)
  protected
    Fowner: TUObject; // points to uclass or ustruct
  protected
    procedure SetItem(Index: Integer; AObject: TUDeclaration);
  published
    property owner: TUObject read Fowner write Fowner;
  end;

  TUConst = class(TUDeclaration)
  protected
    Fvalue:  string;
  published
    property value: string read Fvalue write Fvalue;
    function declaration: string; override;
  end;

  TUConstList = class(TUDeclarationList)
  protected
    function GetItem(Index: Integer): TUConst;
    procedure SetItem(Index: Integer; AObject: TUConst);
  public
    property Items[Index: Integer]: TUConst read GetItem write SetItem; default;
  published
    procedure Sort;
    function Find(name: string): TUConst;
  end;

  TUProperty = class(TUDeclaration)
  protected
    Fptype:      string;
    Fmodifiers:  string;
    Ftag:        string;
  published
    property ptype: string read Fptype write Fptype;
    property modifiers: string read Fmodifiers write Fmodifiers;
    property tag: string read Ftag write Ftag;
    function declaration: string; override;
  end;

  TUPropertyList = class(TUDeclarationList)
  protected
    function GetItem(Index: Integer): TUProperty;
    procedure SetItem(Index: Integer; AObject: TUProperty);
  public
    property Items[Index: Integer]: TUProperty read GetItem write SetItem; default;
  published
    procedure Sort;
    function Find(name: string): TUProperty;
    function FindEx(name: string): TUProperty;
    procedure SortOnTag;
  end;

  TUEnum = class(TUDeclaration)
  protected
    Foptions:  string;
  published
    property options: string read Foptions write Foptions;
    function declaration: string; override;
  end;

  TUEnumList = class(TUDeclarationList)
  protected
    function GetItem(Index: Integer): TUEnum;
    procedure SetItem(Index: Integer; AObject: TUEnum);
  public
    property Items[Index: Integer]: TUEnum read GetItem write SetItem; default;
  published
    procedure Sort;
    function Find(name: string): TUEnum;
  end;

  TUStruct = class(TUDeclaration)
  protected
    Fparent:     string;
    Fmodifiers:  string;
    Fproperties: TUPropertyList;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property parent: string read Fparent write Fparent;
    property modifiers: string read Fmodifiers write Fmodifiers;
    property properties: TUPropertyList read Fproperties write Fproperties;
    function declaration: string; override;
  end;

  TUStructList = class(TUDeclarationList)
  protected
    function GetItem(Index: Integer): TUStruct;
    procedure SetItem(Index: Integer; AObject: TUStruct);
  public
    property Items[Index: Integer]: TUStruct read GetItem write SetItem; default;
  published
    procedure Sort;
    function Find(name: string): TUStruct;
  end;

  TUState = class(TUDeclaration)
  protected
    Fextends:    string;
    Fmodifiers:  string;
    Ffunctions:  TUFunctionList;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property extends: string read Fextends write Fextends;
    property modifiers: string read Fmodifiers write Fmodifiers;
    property functions: TUFunctionList read Ffunctions write Ffunctions;
    function declaration: string; override;
  end;

  TUStateList = class(TUDeclarationList)
  protected
    function GetItem(Index: Integer): TUState;
    procedure SetItem(Index: Integer; AObject: TUState);
  public
    property Items[Index: Integer]: TUState read GetItem write SetItem; default;
  published
    procedure Sort;
    function Find(name: string): TUState;
  end;

  TUFunctionType = (uftFunction, uftEvent, uftOperator, uftPreOperator, uftPostOperator, uftDelegate);

  TUFunction = class(TUDeclaration)
  protected
    Fftype:      TUFunctionType;
    Freturn:     string;
    Fmodifiers:  string;
    Fparams:     string;
    Fstate:      TUState;
    Fargs:       TUPropertyList; // parsed argument list (CURRENTLY NOT USED)
    Flocals:     TUPropertyList; // local variable delcrations (CURRENTLY NOT USED)
  public
    constructor Create;
    destructor Destroy; override;
  published
    property ftype: TUFunctionType read Fftype write Fftype;
    property return: string read Freturn write Freturn;
    property modifiers: string read Fmodifiers write Fmodifiers;
    property params: string read Fparams write Fparams;
    property state: TUState read Fstate write Fstate;
    property args: TUPropertyList read Fargs write Fargs;
    property locals: TUPropertyList read Flocals write Flocals;
    function declaration: string; override;
  end;

  TUFunctionList = class(TUDeclarationList)
  protected
    function GetItem(Index: Integer): TUFunction;
    procedure SetItem(Index: Integer; AObject: TUFunction);
  public
    property Items[Index: Integer]: TUFunction read GetItem write SetItem; default;
  published
    procedure Sort;
    function Find(name: string; state: string = ''): TUFunction;
  end;

  TUClassList = class;

  TUCInterfaceType = (itNone, itTribesV);

  TDefaultPropertiesRecord = record
    srcline:            integer; // start of the default properties block in the source
    definedIn:          string;
    data:               string; // AS IS
  end;

  TReplicationRecord = record
    srcline:            integer; // start of the replication block in the source
    definedIn:          string;
    symbols:            TStringList; // symbol=index
    expressions:        TStringList; // expression (DO NOT SORT)
  end;

  TUClass = class(TUObject)
  private
    Fparent:             TUClass;
    Ffilename:           string;
    Fpackage:            TUPackage;
    Fparentname:         string;
    Fmodifiers:          string;
    FInterfaceType:      TUCInterfaceType;
    //implements:       TUClassList; // implements these interfaces
    Fpriority:           integer;
    Fconsts:             TUConstList;
    Fproperties:         TUPropertyList;
    Fenums:              TUEnumList;
    Fstructs:            TUStructList;
    Fstates:             TUstateList;
    Ffunctions:          TUFunctionList;
    Fdelegates:          TUFunctionList;
    Ftreenode:           TObject; // class tree node
    Ftreenode2:          TObject; // the second tree node (PackageTree)
    Ffiletime:           integer; // used for checking for changed files
    Ftagged:             boolean;
    Fchildren:           TUClassList; // not owned, don't free, don't save
    Fdeps:               TUClassList; // dependency list, not owned, don't free (CURRENTLY NOT USED)
    Fdefs:               TDefinitionList;
    Fincludes:           TStringList; // #include files: "line no.=file"
  public
    defaultproperties:  TDefaultPropertiesRecord;
    replication:        TReplicationRecord;
  published
    property parent: TUClass read Fparent write Fparent;
    property filename: string read Ffilename write Ffilename;
    property package: TUPackage read Fpackage write Fpackage;
    property parentname: string read Fparentname write Fparentname;
    property modifiers: string read Fmodifiers write Fmodifiers;
    property InterfaceType: TUCInterfaceType read FInterfaceType write FInterfaceType;
    property priority: integer read Fpriority write Fpriority;
    property consts: TUConstList read Fconsts write Fconsts;
    property properties: TUPropertyList read Fproperties write Fproperties;
    property enums: TUEnumList read Fenums write Fenums;
    property structs: TUStructList read Fstructs write Fstructs;
    property states: TUstateList read Fstates write Fstates;
    property functions: TUFunctionList read Ffunctions write Ffunctions;
    property delegates: TUFunctionList read Fdelegates write Fdelegates;
    property treenode: TObject read Ftreenode write Ftreenode;
    property treenode2: TObject read Ftreenode2 write Ftreenode2;
    property filetime: integer read Ffiletime write Ffiletime;
    //property defaultproperties: TDefaultPropertiesRecord read Fdefaultproperties write Fdefaultproperties;
    //property replication: TReplicationRecord read Freplication write Freplication;
    property tagged: boolean read Ftagged write Ftagged;
    property children: TUClassList read Fchildren write Fchildren;
    property deps: TUClassList read Fdeps write Fdeps;
    property defs: TDefinitionList read Fdefs write Fdefs;
    property includes: TStringList read Fincludes write Fincludes;
  public
    constructor Create;
    destructor Destroy; override;
  published
    function FullName: string;
    function FullFileName: string;
    function declaration: string; override;
    // replication functions
    function IsReplicated(symbol: string): boolean; // returns true of symbol is replicated
    function GetReplication(symbol: string): string; // returns the expression required to replicate
    function AddReplication(expression: string): integer; // adds an expression and returns the index
  end;

  TUClassList = class(TUObjectList)
  protected
    function GetItem(Index: Integer): TUClass;
    procedure SetItem(Index: Integer; AObject: TUClass);
  public
    property Items[Index: Integer]: TUClass read GetItem write SetItem; default;
  published
    procedure Sort;
    function Find(name: string): TUClass;
  end;

  TUPackage = class(TUObject)
  protected
    Fclasses:    TUClassList;
    Fpriority:   integer;
    Fpath:       string; // class path
    Ftreenode:   TObject;
    Ftagged:     boolean;
  public
    constructor Create;
    destructor Destroy; override;  
  published
    property classes: TUClassList read Fclasses write Fclasses;
    property priority: integer read Fpriority write Fpriority;
    property path: string read Fpath write Fpath;
    property treenode: TObject read Ftreenode write Ftreenode;
    property tagged: boolean read Ftagged write Ftagged;
    function PackageDir: string; // returns the actual package dir
    function declaration: string; override;
  end;

  TUPackageList = class(TUObjectList)
  protected
    function GetItem(Index: Integer): TUPackage;
    procedure SetItem(Index: Integer; AObject: TUPackage);
  public
    property Items[Index: Integer]: TUPackage read GetItem write SetItem; default;
  published
    procedure Sort;
    procedure AlphaSort;
    function Find(name: string): TUPackage;
  end;

  function UFunctionTypeToString(utype: TUFunctionType): string;

implementation

function TUObject.HTMLdeclaration: string;
begin
  result := StringReplace(StringReplace(declaration, '>', '&gt;', [rfReplaceAll]), '<', '&lt;', [rfReplaceAll]);
end;

function TUObject.declaration: string;
begin
  result := '';
end;

{ TUObjectList }

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

{ TUDeclarationList }

procedure TUDeclarationList.SetItem(Index: Integer; AObject: TUDeclaration);
begin
  inherited SetItem(Index, AObject);
  if (AObject <> nil) then AObject.Owner := Owner;
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
  result := 'enum '+name+' { '+StringReplace(options, ',', ', ', [rfReplaceAll])+' };';
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
  result := result+' '+modifiers+' '+ptype+' '+name+';';
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

// same as Find() except this one ignored variable dimensions in the name
function TUPropertyList.FindEx(name: string): TUProperty;
var
  i, n: integer;
  tmp: string;
begin
  result := nil;
  for i := 0 to Count-1 do begin
    tmp := TUObject(Items[i]).name;
    n := Pos('[', tmp);
    if (n > 0) then System.Delete(tmp, n, maxint);
    if (CompareText(tmp, name)= 0) then begin
      result := TUProperty(Items[i]);
      exit;
    end;
  end;
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
  fproperties := TUPropertyList.Create(true);
  fproperties.owner := self;
end;

destructor TUStruct.Destroy;
begin
  FreeAndNil(fproperties);
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
  ffunctions := TUFunctionList.Create(false);
end;

destructor TUState.Destroy;
begin
  FreeAndNil(ffunctions);
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
  flocals := TUPropertyList.Create(true);
  flocals.owner := self;
end;

destructor TUFunction.Destroy;
begin
  FreeAndNil(flocals);
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
  Fconsts := TUConstList.Create(true);
  Fconsts.owner := self;
  Fproperties := TUPropertyList.Create(true);
  Fproperties.owner := self;
  Fenums := TUEnumList.Create(true);
  Fenums.owner := self;
  Fstructs := TUStructList.Create(true);
  Fstructs.owner := self;
  Fstates := TUStateList.Create(true);
  Fstates.owner := self;
  Ffunctions := TUFunctionList.Create(true);
  Ffunctions.owner := self;
  Fdelegates := TUFunctionList.Create(true);
  Fdelegates.owner := self;
  Fchildren := TUClassList.Create(false);
  Fdeps := TUClassList.Create(false);
  Fdefs := TDefinitionList.Create(self);
  Fincludes := TStringList.Create;
  replication.expressions := TStringList.Create;
  replication.symbols := TStringList.Create;
  {$IFNDEF FPC}
  replication.symbols.CaseSensitive := false;
  {$ENDIF}
  replication.symbols.Duplicates := dupIgnore; //TODO: might need to be an error?
end;

destructor TUClass.Destroy;
begin
  FreeAndNil(Fconsts);
  FreeAndNil(Fproperties);
  FreeAndNil(Fenums);
  FreeAndNil(Fstructs);
  FreeAndNil(Fstates);
  FreeAndNil(Ffunctions);
  FreeAndNil(Fdelegates);
  FreeAndNil(Fchildren);
  FreeAndNil(Fdeps);
  FreeAndNil(Fdefs);
  FreeAndNil(Fincludes);
  FreeAndNil(replication.expressions);
  FreeAndNil(replication.symbols);
end;

function TUClass.FullName: string;
begin
  result := Fpackage.name+'.'+Fname;
end;

function TUClass.FullFileName: string;
begin
  result := Fpackage.path+PathDelim+Ffilename
end;

function TUClass.declaration: string;
begin
  case FInterfaceType of
    itNone:     result := 'class';
    itTribesV:  result := 'interface';
  end;
  result := result + ' ' + Fname;
  if (Fparentname <> '') then result := result + 'extends' + Fparentname;
  result := result + ' ' + Fmodifiers + ';'
end;

function TUClass.IsReplicated(symbol: string): boolean;
begin
  result := replication.symbols.IndexOfName(symbol) > -1;
end;

function TUClass.GetReplication(symbol: string): string;
var
  i: integer;
begin
  i := StrToIntDef(replication.symbols.values[symbol], -1);
  result := '';
  if ((i > 0) and (i < replication.expressions.Count)) then begin
    result := replication.expressions[i];
  end;
end;

function TUClass.AddReplication(expression: string): integer;
begin
  result := replication.expressions.Add(expression);
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
  fclasses := TUClassList.Create(false); // or else we can't move them around
end;

destructor TUPackage.Destroy;
begin
  FreeAndNil(fclasses);
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

EXPR      ::= ORX
ORX       ::= ANDX ( '||' ORX )*
ANDX      ::= UNARYX ( '&&' ANDX )*
UNARYX    ::= ( '!' )? OPERAND
OPERAND   ::= LVALUE | '(' EXPR ')'
LVALUE    ::= integer | IDENTIFIER

  supported operators:
  && || () !

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


