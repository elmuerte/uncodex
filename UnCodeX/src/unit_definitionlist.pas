{*******************************************************************************
  Name:
    unit_definitionlist.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Keeps track of macro definitions and stuff like that

  $Id: unit_definitionlist.pas,v 1.15 2005/10/27 10:57:45 elmuerte Exp $
*******************************************************************************}
{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2005  Michiel Hendriks

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
unit unit_definitionlist;

{$I defines.inc}

interface

uses
  Classes, SysUtils, Contnrs;

type
  EDefinitionList = class(Exception);
  ERedefinition = class(EDefinitionList);
  ENoDefinitionParser = class(EDefinitionList);
  // eval() exceptions
  EDefinitionListEval = class(EDefinitionList);
  EInvalidExpression = class(EDefinitionListEval);
  EIllegalToken = class(EDefinitionListEval);
  ERequireToken = class(EDefinitionListEval);
  EInvalidLiteral = class(EDefinitionListEval);
  EUnknownIdentifier = class(EDefinitionListEval);
  EUnknownFunction = class(EDefinitionListEval);
  EUnterminatedStringConstant = class(EDefinitionListEval);

  TDefinitionList = class;

  TArgumentAction = ( aaNone, aaQuote, aaConcat );

  TArgumentRecord = record
    idx:    integer;
    offset: integer;
    len:    integer;
    action: TArgumentAction
  end;

  TDefinitionEntry = class(TObject)
  protected
    fname:       string; // AS IS
    fvalue:      string; // AS IS
    farglist:    array of string;
    argreps:     array of TArgumentRecord;
    function GetArgCount: integer;
    function getArgItem(index: integer): string;
  public
    owner:      TDefinitionList;
    constructor Create(name, value: string);
    destructor Destroy; override;
    function evalFunction(args: array of string): string;
    function baseName: string;
    property Name: string read fname;
    property Value: string read fvalue;
    property ArgCount: integer read GetArgCount;
    property ArgList[index: integer]: string read getArgItem;
    procedure AddOffset(argidx, offset: integer; len: integer = -1; action: TArgumentAction = aaNone);
  end;

  TOnParseDefinition = procedure(def: TDefinitionEntry);
  TOnExternalDefine = function(token: string; var output: string): boolean;
  TOnExpandArgument = function(input: string): string;

  TDefinitionList = class(TObject)
  protected
    fparent:  TDefinitionList;
    defines:  TStringList;
    curToken: string;
    FOnParseDefinition: TOnParseDefinition;
    FOnExternalDefine: TOnExternalDefine;
    FOnExpandArgument: TOnExpandArgument; 
    procedure _nextToken(var line: string);
    procedure _requireToken(token: string; var line: string; getnext: boolean = true);
    function _expr(var line: string): integer;
    function _cmpx(var line: string): integer;
    function _orx(var line: string): integer;
    function _accumx(var line: string): integer;
    function _andx(var line: string): integer;
    function _multx(var line: string): integer;
    function _unaryx(var line: string): integer;
    function _operand(var line: string): integer;
    function _lvalue(var line: string): integer;
    function _builtin(var line: string; var res: integer): boolean;
  protected
    function GetCount: integer;
    function GetEntry(index: integer): string;
  public
    function IsDefined(name: string): boolean;
    function IsRealDefined(name: string): boolean;
    function GetDefine(name: string): string;
    function CallDefine(name: string; args: array of string): string;
    function Eval(line: string): boolean;
    function define(name, value: string): boolean;
    function undefine(name: string): boolean;
    procedure Clear;
    procedure ParseDefinition(def: TDefinitionEntry);
    function ExpandArgument(input: string): string;
    constructor Create(parent: TDefinitionList);
    destructor Destroy; override;
    procedure AddEntry(entry: string);
    property Parent: TDefinitionList read fparent write fparent;
    property Count: integer read GetCount;
    property Entry[Index: Integer]: string read GetEntry;
    property OnParseDefinition: TOnParseDefinition read FOnParseDefinition write FOnParseDefinition;
    property OnExternalDefine: TOnExternalDefine read FOnExternalDefine write FOnExternalDefine;
    property OnExpandArgument: TOnExpandArgument read FOnExpandArgument write FOnExpandArgument;
  end;

resourcestring
  ENO_DEFINITION_PARSER = 'Event TDefinitionList.OnParseDefinition not set.';
  EILLEGAL_TOKEN = 'Illegal token "%s".';
  EREQUIRE_TOKEN = 'Expected token "%s" got "%s".';
  EINVALID_LITERAL = 'Invalid literal value "%s"';
  EUNKNOWN_IDENTIFIER = 'Identifier does not exist "%s"';
  EUNKNOWN_FUNCTION = 'No function defined with that footprint "%s".';
  ENON_EMPTY_EXPRESSION = 'Invalid expression, failed token: "%s"';
  EUNTERMINATED_STRING_CONSTANT = 'Unterminated string constant';

implementation

uses
  RTLConsts;

{ TDefinitionEntry }

constructor TDefinitionEntry.Create(name, value: string);
var
  i, j: integer;
begin
  fname := name;
  fvalue := value;
  // parse name for arg count
  i := pos('(', fname);
  SetLength(farglist, 0);
  SetLength(argreps, 0);
  while (i > 0) do begin
    Inc(i); // begin
    j := i+1;
    while ((fname[j] <> ',') and (fname[j] <> ')') and (j < Length(fname))) do inc(j);
    SetLength(farglist, High(farglist)+2);
    farglist[High(farglist)] := Copy(fname, i, j-i);
    if ((fname[j] = ')') or (j >= Length(fname))) then break;
    i := j;
  end;
end;

destructor TDefinitionEntry.Destroy;
begin
  inherited;
end;

function TDefinitionEntry.GetArgCount: integer;
begin
  if (fargList = nil) then result := 0
  else result := High(farglist)+1;
end;

function TDefinitionEntry.getArgItem(index: integer): string;
begin
  if ((index < Low(farglist)) and (index > High(farglist))) then raise EListError.CreateFmt(SListIndexError, [index]);
  result := farglist[index];
end;

function TDefinitionEntry.baseName: string;
var
  i: integer;
begin
  i := pos('(', fname);
  if (i = 0) then result := fname;
  result := Copy(fname, 1, i-1);
end;

procedure TDefinitionEntry.AddOffset(argidx, offset: integer; len: integer = -1; action: TArgumentAction = aaNone);
var
  i: integer;
begin
  if ((argidx < Low(farglist)) and (argidx > High(farglist))) then raise EListError.CreateFmt(SListIndexError, [argidx]);
  i := High(argreps)+1;
  SetLength(argreps, i+1);
  argreps[i].idx := argidx;
  argreps[i].offset := offset;
  if (len = -1) then argreps[i].len := length(farglist[argidx])
  else argreps[i].len := len;
  argreps[i].action := action;
end;


function TDefinitionEntry.evalFunction(args: array of string): string;
var
  i: integer;
  argentry: string;
begin
  //TODO: other exception
  // not enough args
  if (High(fargList) < High(args)) then raise Exception.CreateFmt('Not enough arguments, expected %d, received %d.', [High(fargList), High(args)]);
  if (high(argreps) = -1) then owner.ParseDefinition(self);
  result := Value;
  for i := High(argreps) downto Low(argreps) do begin
    argentry := args[argreps[i].idx];
    if (argreps[i].action = aaQuote) then begin
      argentry := StringReplace(argentry, '\', '\\', [rfReplaceAll]);
      argentry := StringReplace(argentry, '"', '\"', [rfReplaceAll]);
      argentry := '"'+argentry+'"';
    end
    else argentry := owner.ExpandArgument(argentry);
    {if (argreps[i].action = aaConcat) then begin
      // string concat hack, check left concat
      if ((Copy(argentry, Length(argentry)-1, 1) = '"') and (Copy(result, argreps[i].offset+1+argreps[i].len, 1) = '"')) then begin
        Delete(argentry, Length(argentry)-1, 1);
        Delete(result, argreps[i].offset+1+argreps[i].len, 1);
      end;
    end
    else
    if (i < High(argreps)) then begin
    if (argreps[i+1].action = aaConcat) then begin
      // string concat hack, check right concat
      if ((Copy(argentry, 1, 1) = '"') and (Copy(result, argreps[i+1].offset, 1) = '"')) then begin
        Delete(argentry, 1, 1);
        Delete(result, argreps[i+1].offset, 1);
      end;
    end;
    end;}
    result := Copy(result, 1, argreps[i].offset)+argentry+Copy(result, argreps[i].offset+1+argreps[i].len, MaxInt);
  end;
end;

{ TDefinitionList }

const
  UNDEFINED = #1#9#1#2#255;
  DEFINED = #1#9#1#3#255;
  DEF_SEP = '=';

constructor TDefinitionList.Create(parent: TDefinitionList);
begin
  fparent := parent;
  defines := TStringList.Create;
end;

destructor TDefinitionList.Destroy;
begin
  fparent := nil;
  FreeAndNil(defines);
end;

function TDefinitionList.GetCount: integer;
begin
  result := defines.Count;
end;

function TDefinitionList.GetEntry(index: integer): string;
var
  entry: TDefinitionEntry;
begin
  entry := TDefinitionEntry(defines.Objects[index]);
  if (entry <> nil) then result := entry.name+DEF_SEP+entry.value;
end;

procedure TDefinitionList.Clear;
var
  i: integer;
begin
  for i :=  defines.Count-1 downto 0 do begin
    defines.Objects[i].Free;
  end;
  defines.Clear;
end;

procedure TDefinitionList.AddEntry(entry: string);
var
  rhs: string;
  idx: integer;
begin
  idx := Pos(DEF_SEP, entry);
  rhs := Copy(entry, idx+1, MaxInt);
  Delete(entry, idx, MaxInt);
  if (entry <> '') then define(entry, rhs);
end;

function TDefinitionList.IsDefined(name: string): boolean;
var
  idx: integer;
  val: string;
begin
  result := false;
  idx := defines.IndexOf(name);
  if (idx > -1) then begin
    val := TDefinitionEntry(defines.Objects[idx]).Value;
    result := (val <> '0') and (val <> UNDEFINED);
  end
  else if (fparent <> nil) then begin
    result := fparent.IsDefined(name);
  end;
end;

function TDefinitionList.IsRealDefined(name: string): boolean;
var
  idx: integer;
  val: string;
begin
  result := false;
  idx := defines.IndexOf(name);
  if (defines.IndexOf(name) > -1) then begin
    val := TDefinitionEntry(defines.Objects[idx]).Value;
    result := (val <> UNDEFINED);
  end
  else if (fparent <> nil) then begin
    result := fparent.IsRealDefined(name);
  end;
end;

function TDefinitionList.GetDefine(name: string): string;
var
  idx: integer;
  val: string;
begin
  result := UNDEFINED;
  idx := defines.IndexOf(name);
  if (defines.IndexOf(name) > -1) then begin
    val := TDefinitionEntry(defines.Objects[idx]).Value;
    //if (val = DEFINED) then val := ''; // was an empty define
    result := val;
  end
  else if (fparent <> nil) then begin
    result := fparent.GetDefine(name);
  end;
end;

function TDefinitionList.CallDefine(name: string; args: array of string): string;
var
  idx: integer;
  sname: string;
begin
  sname := name+'/'+IntToStr(high(args)+1);
  idx := defines.IndexOf(sname);
  if (defines.IndexOf(sname) > -1) then begin
    result := TDefinitionEntry(defines.Objects[idx]).evalFunction(args);
  end
  else if (fparent <> nil) then begin
    result := fparent.CallDefine(name, args);
  end
  else raise EUnknownFunction.CreateFmt(EUNKNOWN_FUNCTION, [sname]);
end;

procedure TDefinitionList.ParseDefinition(def: TDefinitionEntry);
begin
  if (Assigned(fOnParseDefinition)) then fOnParseDefinition(def)
  else raise ENoDefinitionParser.Create(ENO_DEFINITION_PARSER);
end;

function TDefinitionList.ExpandArgument(input: string): string;
begin
  if (Assigned(fOnExpandArgument)) then result := fOnExpandArgument(input)
  else result := input;
end;

{ evaluator -- BEGIN }
{
  EBNF:

EXPR      ::= CMPX
CMPX      ::= ORX ( CMPOP CMPX )*
ORX       ::= ACCUM ( '||' ORX )*
ACCUMX    ::= ANDX ( '+'|'-' ACCUM )*
ANDX      ::= MULTX ( '&&' ANDX )*
MULTX     ::= UNARYX ( '*'|'/' MULTX )*
UNARYX    ::= ( '!' )? OPERAND
OPERAND   ::= LVALUE | '(' EXPR ')'
LVALUE    ::= integer | BUILTIN '(' EXPR ')' | IDENTIFIER

CMPOP     ::= '<' | '<=' | '=>' | '>' | '==' | '!='
BUILTIN   ::= 'defined' | ... 

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
    '(', ')', ',': Inc(j);
    '!', '&', '|', '+', '-', '=', '<', '>', '%', '*', '/':
      while line[j] in ['!', '&', '|', '+', '-', '=', '<', '>', '%', '*', '/'] do begin
        Inc(j);
        if (j > length(line)) then break;
      end;
    // identifier/number
    'a' .. 'z', 'A' .. 'Z', '0' .. '9', '_':
      while (not isblank(line[j]) and (line[j] in CHAR_IDENTIFIER)) do begin
        Inc(j);
        if (j > length(line)) then break;
      end;
    // string
    '"':
      begin
        repeat
          if (line[j] = '\') then Inc(j);
          Inc(j);
          if (j > length(line)) then break;
        until (line[j] = '"');
        Inc(j);
        if (j > length(line)) then raise EUnterminatedStringConstant.Create(EUNTERMINATED_STRING_CONSTANT);
      end;
  else
    raise EIllegalToken.CreateFmt(EILLEGAL_TOKEN, [line[j]]);
  end;
  curToken := Copy(line, i, j-i);
  Delete(line, 1, j-1);
end;

procedure TDefinitionList._requireToken(token: string; var line: string; getnext: boolean = true);
begin
  if ( curToken = token) then begin
    if (getnext) then _nextToken(line);
  end
  else raise ERequireToken.CreateFmt(EREQUIRE_TOKEN, [token, curToken]);
end;

function TDefinitionList._expr(var line: string): integer;
begin
  _nextToken(line); // because it's not set yet
  result := _cmpx(line);
end;

function TDefinitionList._cmpx(var line: string): integer;
var
  cmdopidx: integer;

  function GetCmdOpIdx(): integer;
  begin
    result := -1;
    if (curToken = '<') then result := 0
    else if (curToken = '<=') then result := 1
    else if (curToken = '=<') then result := 1
    else if (curToken = '=>') then result := 2
    else if (curToken = '>=') then result := 2
    else if (curToken = '>') then result := 3
    else if (curToken = '==') then result := 4
    else if (curToken = '!=') then result := 5;
    cmdopidx := result;
  end;

begin
  result := _orx(line);
  while (GetCmdOpIdx() > -1) do begin
    _nextToken(line);
    case cmdopidx of
      0: result := ord(result < _cmpx(line));
      1: result := ord(result <= _cmpx(line));
      2: result := ord(result >= _cmpx(line));
      3: result := ord(result > _cmpx(line));
      4: result := ord(result = _cmpx(line));
      5: result := ord(result <> _cmpx(line));
    end;
  end;
end;

function TDefinitionList._orx(var line: string): integer;
begin
  result := _accumx(line);
  while (curToken = '||') do begin
    _nextToken(line);
    result := ord((_orx(line) <> 0) or (result <> 0));
  end;
end;

function TDefinitionList._accumx(var line: string): integer;
var
  cmdopidx: integer;

  function GetCmdOpIdx(): integer;
  begin
    result := -1;
    if (curToken = '-') then result := 0
    else if (curToken = '+') then result := 1;
    cmdopidx := result;
  end;
  
begin
  result := _andx(line);
  while (GetCmdOpIdx() > -1) do begin
    _nextToken(line);
    case cmdopidx of
      0: result := result - _accumx(line);
      1: result := result + _accumx(line);
    end;
  end;
end;

function TDefinitionList._andx(var line: string): integer;
begin
  result := _multx(line);
  while (curToken = '&&') do begin
    _nextToken(line);
    result := ord((_andx(line) <> 0) and (result <> 0));
  end;
end;

function TDefinitionList._multx(var line: string): integer;
var
  cmdopidx: integer;

  function GetCmdOpIdx(): integer;
  begin
    result := -1;
    if (curToken = '*') then result := 0
    else if (curToken = '/') then result := 1
    else if (curToken = '%') then result := 2;
    cmdopidx := result;
  end;
  
begin
  result := _unaryx(line);
  while (GetCmdOpIdx() > -1) do begin
    _nextToken(line);
    case cmdopidx of
      0: result := result * _multx(line);
      1: result := result div _multx(line);
      2: result := result mod _multx(line);
    end;
  end;
end;

function TDefinitionList._unaryx(var line: string): integer;
begin
  if ( curToken = '!' ) then begin
    _nextToken(line);
    result := ord(_operand(line) = 0); // 0 => 1; * => 0
  end
  else result := _operand(line);
end;

function TDefinitionList._operand(var line: string): integer;
begin
  if ( curToken = '(') then begin
    //_nextToken(line); DON'T, this will be done in _expr()
    result := _expr(line);
    _requireToken(')', line);
  end
  else result := _lvalue(line);
end;

function TDefinitionList._lvalue(var line: string): integer;
var
  tmp: string;
begin
  result := 0;
  try
    if (IsValidIdent(curToken)) then begin
      if (_builtin(line, Result)) then exit;
      if (IsRealDefined(curToken)) then begin
        Result := StrToIntDef(GetDefine(curToken), 1); // default to 1 if defined
      end
      else begin
        if (Assigned(FOnExternalDefine)) then begin
          if (FOnExternalDefine(curToken, tmp)) then begin
            Result := StrToIntDef(tmp, 1);
            exit;
          end;
        end;
        result := 0;
        raise EUnknownIdentifier.CreateFmt(EUNKNOWN_IDENTIFIER, [curToken])
      end;
    end
    else begin
      try
        result := StrToInt(curToken);
      except
        result := 0;
        raise EInvalidLiteral.Createfmt(EINVALID_LITERAL, [curToken]);
      end;
    end;
  finally
    _nextToken(line);
  end;
end;

function TDefinitionList._builtin(var line: string; var res: integer): boolean;
var
  v1, v2: string;
begin
  Result := false;
  if (SameText(curToken, 'defined')) then begin
    _nextToken(line);
    Result := true;
    _requireToken('(', line);
    res := ord(IsRealDefined(curToken));
    _nextToken(line);
    _requireToken(')', line, false);
  end
  // strcmp(string|token, string|token)
  else if (SameText(curToken, 'strcmp')) then begin
    _nextToken(line);
    Result := true;
    _requireToken('(', line);
    // curtoken = v1
    v1 := curToken;
    if (IsValidIdent(v1)) then v1 := GetDefine(v1);
    if (v1 = UNDEFINED) then raise EUnknownIdentifier.CreateFmt(EUNKNOWN_IDENTIFIER, [v1]);
    _nextToken(line);
    _requireToken(',', line);
    // curtoken = v2
    v2 := curToken;
    if (IsValidIdent(v2)) then v2 := GetDefine(v2);
    if (v2 = UNDEFINED) then raise EUnknownIdentifier.CreateFmt(EUNKNOWN_IDENTIFIER, [v2]);
    _nextToken(line);
    res := CompareStr(v1, v2);
    _requireToken(')', line, false);
  end
  // stricmp(string|token, string|token)
  else if (SameText(curToken, 'stricmp')) then begin
    _nextToken(line);
    Result := true;
    _requireToken('(', line);
    // curtoken = v1
    v1 := curToken;
    if (IsValidIdent(v1)) then v1 := GetDefine(v1);
    if (v1 = UNDEFINED) then raise EUnknownIdentifier.CreateFmt(EUNKNOWN_IDENTIFIER, [curToken]);
    _nextToken(line);
    _requireToken(',', line);
    // curtoken = v2
    v2 := curToken;
    if (IsValidIdent(v2)) then v2 := GetDefine(v2);
    if (v2 = UNDEFINED) then raise EUnknownIdentifier.CreateFmt(EUNKNOWN_IDENTIFIER, [curToken]);
    _nextToken(line);
    res := CompareText(v1, v2);
    _requireToken(')', line, false);
  end;
end;

{ evaluator -- END }

function TDefinitionList.Eval(line: string): boolean;
begin
  line := trim(line);
  result := _expr(line) <> 0;
  if (trim(line) <> '') then raise EInvalidExpression.CreateFmt(ENON_EMPTY_EXPRESSION, [curToken]);
end;

// returns true when a new value was added
function TDefinitionList.define(name, value: string): boolean;
var
  i,j,cnt: integer;
  fname: string;
  entry: TDefinitionEntry;

  procedure CountArgs;
  begin
    cnt := 0;
    fname := Copy(name, 1, i-1);
    while (i > 0) do begin
      Inc(i); // begin
      j := i+1;
      while ((name[j] <> ',') and (name[j] <> ')') and (j < Length(name))) do inc(j);
      Inc(cnt);
      if ((name[j] = ')') or (j >= Length(name))) then break;
      i := j;
    end;
    fname := fname+'/'+IntToStr(cnt);
  end;

begin
  i := Pos('(', name);
  if (i > 0) then CountArgs()
  else fname := name;

  if (IsRealDefined(fname)) then begin
    raise ERedefinition.CreateFmt('"%s" is already defined.', [fname]);
  end;

  j := defines.IndexOf(fname);
  result := j = -1;
  if (not result) then begin
    entry := TDefinitionEntry(defines.Objects[j]);
    defines.Delete(j);
    entry.Free;
  end;
  entry := TDefinitionEntry.Create(name, value);
  entry.owner := self;
  defines.AddObject(fname, entry);
end;

// returns true when definition was deleted
// if false it was UNDEFINED
// requires footprints for functions
function TDefinitionList.undefine(name: string): boolean;
var
  idx: integer;
  entry: TDefinitionEntry;
begin
  idx := defines.IndexOf(name);
  if (defines.IndexOf(name) > -1) then begin
    defines.Objects[idx].Free;
    defines.Delete(idx);
    result := true;
  end
  else begin
    entry := TDefinitionEntry.Create(name, UNDEFINED);
    entry.owner := self;
    defines.AddObject(name, entry);
    result := false;
  end;
end;

end.
