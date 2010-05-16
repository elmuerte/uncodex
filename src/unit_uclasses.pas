{*******************************************************************************
  Name:
    unit_uclasses.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Class definitions for UnrealScript elements

  $Id: unit_uclasses.pas,v 1.65 2005/06/16 10:10:03 elmuerte Exp $
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
  Classes, Contnrs, SysUtils, unit_definitionlist;

const
  // used for output module compatibility testing
  UCLASSES_REV: LongInt = 6;

type
  TUCommentType = (ctSource, ctExtern, ctInherited);

  TUClass = class;
  TUPackage = class;
  TUFunctionList = class;

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
  public
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
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
    function CleanName: string; // returns the name without static array
    function GetDimension: integer; // get the array dimension, returns 0 if not an array
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
    procedure SetParent(Parent: TUClass);
  public
    defaultproperties:  TDefaultPropertiesRecord;
    replication:        TReplicationRecord;
  published
    property parent: TUClass read Fparent write SetParent;
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
end;

procedure TUDeclarationList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  if (Action = lnAdded) then begin
    if (TUDeclaration(Ptr) <> nil) then TUDeclaration(Ptr).Owner := Owner;
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

function TUProperty.CleanName: string;
var
  i: integer;
begin
  result := name;
  i := Pos('[', result);
  if (i > 0) then Delete(result, i, MaxInt);
end;

function TUProperty.GetDimension: integer;
var
  i: integer;
  tmp: string;
  uconst: TUConst;
begin
  result := 0;
  tmp := name;
  i := Pos('[', tmp);
  if (i > 0) then begin
    tmp := Copy(tmp, i+1, Length(tmp)-i-1);
    result := StrToIntDef(tmp, -1);
    if (result = -1) then begin
      // tmp is a const, find it
      uconst := nil;
      if (Owner <> nil) then begin
        if (Owner.ClassType = TUClass) then uconst := TUClass(Owner).consts.Find(tmp)
        else if ((Owner.ClassType = TUStruct) and (TUStruct(owner).owner <> nil))
          then uconst := TUClass(TUStruct(Owner).Owner).consts.Find(tmp);
      end;
      if (uconst <> nil) then begin
        Result := StrToIntDef(uconst.value, -1);
      end;
    end;
  end;
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
  Fargs := TUPropertyList.Create(true);
  Fargs.owner := self;
  flocals := TUPropertyList.Create(true);
  flocals.owner := self;
end;

destructor TUFunction.Destroy;
begin
  FreeAndNil(Fargs);
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
  Fdefs := TDefinitionList.Create(nil);
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

procedure TUClass.SetParent(Parent: TUClass);
begin
  Fparent := Parent;
  if (Parent <> nil) then defs.Parent := Parent.defs;
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

end.


