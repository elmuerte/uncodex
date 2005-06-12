{*******************************************************************************
  Name:
    unit_definitionlist.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Keeps track of macro definitions and stuff like that

  $Id: unit_definitionlist.pas,v 1.1 2005-06-12 20:21:56 elmuerte Exp $
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

interface

uses
  Classes, SysUtils;

type

  TDefinitionEntry = class(TObject)
  protected
    //TODO:
    // delay parsing of function until first use
    // store temp info
  public
    name:       string; // AS IS
    value:      string; // AS IS
    argCount:   integer; // if > 0 then it's a function
    //constructor Create(name, value: string);
    //function evalFunction(args: array of string): string;
    //function baseName();
  end;

  TDefinitionList = class(TObject)
  protected
    fparent:  TDefinitionList;
    defines:  TStringList;
    curToken: string;
    procedure _nextToken(var line: string);
    procedure _requireToken(token: string; var line: string);
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
    //function CallDefine(name: string; args: array of string);
    function Eval(line: string): boolean;
    function define(name, value: string): boolean;
    function undefine(name: string): boolean;
    constructor Create(parent: TDefinitionList);
    destructor Destroy; override;
    procedure AddEntry(entry: string);
    property Parent: TDefinitionList read fparent write fparent;
    property Count: integer read GetCount;
    property Entry[Index: Integer]: string read GetEntry;
  end;

implementation

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
  val: string;
begin
  result := false;
  if (defines.IndexOfName(name) > -1) then begin
    val := defines.Values[name];
    result := (val <> '0') and (val <> UNDEFINED);
  end
  else if (fparent <> nil) then begin
    result := fparent.IsDefined(name);
  end;
end;

function TDefinitionList.IsRealDefined(name: string): boolean;
var
  val: string;
begin
  result := false;
  if (defines.IndexOfName(name) > -1) then begin
    val := defines.Values[name];
    result := (val <> UNDEFINED);
  end
  else if (fparent <> nil) then begin
    result := fparent.IsRealDefined(name);
  end;
end;

function TDefinitionList.GetDefine(name: string): string;
var
  val: string;
begin
  result := UNDEFINED;
  if (defines.IndexOfName(name) > -1) then begin
    val := defines.Values[name];
    if (val = DEFINED) then val := ''; // was an empty define
    result := val;
  end
  else if (fparent <> nil) then begin
    result := fparent.GetDefine(name);
  end;
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
    '(', ')': Inc(j);
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
  else
    raise Exception.Create('Illegal token "'+line[j]+'"');
  end;
  curToken := Copy(line, i, j-i);
  Delete(line, 1, j-1);
end;

procedure TDefinitionList._requireToken(token: string; var line: string);
begin
  if ( curToken = token) then _nextToken(line)
  else raise Exception.Create('Expected token "'+token+'" got "'+curToken+'"');
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
    else if (curToken = '=>') then result := 2
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
    result := ord((result <> 0) or (_orx(line) <> 0));
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
    result := ord((result <> 0) and (_orx(line) <> 0));
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
begin
  try
    if (IsValidIdent(curToken)) then begin
      if (_builtin(line, Result)) then exit;
      if (IsRealDefined(curToken)) then begin
        Result := StrToIntDef(GetDefine(curToken), 1); // default to 1 if defined
      end
      else begin
        result := 0;
        raise Exception.Create('Identifier does not exist "'+curToken+'"');
      end;
    end
    else begin
      try
        result := StrToInt(curToken);
      except
        result := 0;
        raise Exception.Create('Invalid literal value "'+curToken+'"');
      end;
    end;
  finally
    _nextToken(line);
  end;
end;

function TDefinitionList._builtin(var line: string; var res: integer): boolean;
begin
  Result := false;
  if (SameText(curToken, 'defined')) then begin
    _nextToken(line);
    Result := true;
    _requireToken('(', line);
    res := ord(IsRealDefined(curToken));
    _nextToken(line);
    _requireToken(')', line);
  end;
end;

{ evaluator -- END }

function TDefinitionList.Eval(line: string): boolean;
begin
  result := _expr(line) <> 0;
end;

// returns true when a new value was added
function TDefinitionList.define(name, value: string): boolean;
begin
  result := defines.IndexOfName(name) = -1;
  if (value = '') then value := DEFINED;
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
 