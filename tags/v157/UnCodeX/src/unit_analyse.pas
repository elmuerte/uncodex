{-----------------------------------------------------------------------------
 Unit Name: unit_analyse
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   class anaylser
 $Id: unit_analyse.pas,v 1.25 2003-12-03 10:31:23 elmuerte Exp $
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

unit unit_analyse;

interface

uses
  SysUtils, Classes, DateUtils, unit_uclasses, unit_parser, unit_outputdefs;

type
  TClassAnalyser = class(TThread)
  private
    onlynew: boolean;
    instate: boolean;
    currentState: TUState;
    classes: TUClassList;
    uclass: TUClass;
    OverWriteUstruct: TUstruct; // if set enums and vars will be added to this
    UseOverWriteStruct: boolean;
    fs: TFileStream;
    p: TUCParser;
    status: TStatusReport;
    procedure AnalyseClass();
    function pConst: TUConst;
    function pVar: TUProperty;
    function pEnum: TUEnum;
    function pStruct: TUStruct;
    function pFunc: TUFunction;
    function pState(modifiers: string): TUState;
    function pBrackets(exclude: boolean = false): string;
    function pSquareBrackets: string;
    function pAngleBrackets: string;
    function pCurlyBrackets: string;
    procedure ExecuteList;
    procedure ExecuteSingle;
  public
    constructor Create(classes: TUClassList; status: TStatusReport; onlynew: boolean = false); overload;
    constructor Create(uclass: TUClass; status: TStatusReport; onlynew: boolean = false); overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;

var
  TreeUpdated: boolean = false;

implementation

uses
  unit_definitions;

const
  KEYWORD_Class = 'class';
  KEYWORD_Extends = 'extends';
  KEYWORD_Expands = 'expands';
  KEYWORD_Const = 'const';
  KEYWORD_Var = 'var';
  KEYWORD_Enum = 'enum';
  KEYWORD_Struct = 'struct';
  KEYWORD_Function = 'function';
  KEYWORD_Event = 'event';
  KEYWORD_Operator = 'operator';
  KEYWORD_PreOperator = 'preoperator';
  KEYWORD_PostOperator = 'postoperator';
  KEYWORD_Delegate = 'delegate';
  KEYWORD_State = 'state';
  KEYWORD_Defaultproperties = 'defaultproperties';
  KEYWORD_Cpptext = 'cpptext';
  KEYWORD_Replication = 'replication';

// Create for a class list
constructor TClassAnalyser.Create(classes: TUClassList; status: TStatusReport; onlynew: boolean = false);
begin
  self.classes := classes;
  Self.status := status;
  Self.onlynew := onlynew;
  Self.FreeOnTerminate := true;
  instate := false;
  inherited Create(true);
end;

// Create for a single class
constructor TClassAnalyser.Create(uclass: TUClass; status: TStatusReport; onlynew: boolean = false);
begin
  self.classes := nil;
  self.uclass := uclass;
  Self.status := status;
  Self.onlynew := onlynew;
  Self.FreeOnTerminate := true;
  inherited Create(true);
end;

destructor TClassAnalyser.Destroy;
begin
  inherited Destroy();
end;

procedure TClassAnalyser.Execute;
var
  stime: TDateTime;
begin
  stime := Now();
  if (classes = nil) then begin
    Status('Analysing class '+uclass.name+' ...');
    ExecuteSingle;
  end
  else ExecuteList;
  Status('Operation completed in '+Format('%.3f', [Millisecondsbetween(Now(), stime)/1000])+' seconds');
end;

procedure TClassAnalyser.ExecuteList;
var
  i: integer;
begin
  for i := 0 to classes.Count-1 do begin
    uclass := classes[i];
    Status('Analysing class '+uclass.name+' ...', round(i/(classes.count-1)*100));
    ExecuteSingle;
    if (Self.Terminated) then break;
  end;
end;

procedure TClassAnalyser.ExecuteSingle;
var
  filename: string;
  currenttime: Integer;
begin
  filename := uclass.package.path+PATHDELIM+uclass.filename;
  if (not FileExists(filename)) then begin
    Log('Cant''t open file: '+filename);
    exit;
  end;
  currenttime := FileAge(filename);
  if (onlynew and (currenttime <= uclass.filetime)) then exit;
  if (onlynew) then LogClass('Class changed since last time: '+uclass.name, uclass);
  TreeUpdated := true;
  UseOverWriteStruct := false;
  uclass.filetime := currenttime;
  fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
  p := TUCParser.Create(fs);
  try
    uclass.consts.Clear;
    uclass.properties.Clear;
    uclass.enums.Clear;
    uclass.structs.Clear;
    uclass.functions.Clear;
    uclass.delegates.Clear;
    uclass.states.Clear;
    AnalyseClass();
    if (not Self.Terminated) then begin
      uclass.consts.Sort;
      uclass.properties.Sort;
      uclass.enums.Sort;
      uclass.structs.Sort;
      uclass.functions.Sort;
      uclass.delegates.Sort;
      uclass.states.Sort;
    end;
  finally
    p.Free;
    fs.Free;
  end;
end;

// Process (...)
function TClassAnalyser.pBrackets(exclude: boolean = false): string;
begin
  result := '';
  if (p.Token = '(') then begin
    p.NextToken;
    while ((p.Token <> ')')  and (p.Token <> toEOF)) do begin
      if (result <> '') then result := result+' ';
      result := result+p.TokenString;
      p.NextToken;
    end;
    p.NextToken;
    if (not exclude) then result := '('+result+')';
  end;
  if (p.Token = toEOF) then result := '';
end;

// Process [...]
function TClassAnalyser.pSquareBrackets: string;
begin
  result := '';
  if (p.Token = '[') then begin
    p.NextToken;
    while ((p.Token <> ']') and (p.Token <> toEOF)) do begin
      if (result <> '') then result := result+' ';
      result := result+p.TokenString;
      p.NextToken;
    end;
    p.NextToken;
    result := '['+result+']';
  end;
  if (p.Token = toEOF) then result := '';
end;

// Process <...>
function TClassAnalyser.pAngleBrackets: string;
var
  bcount: integer;
begin
  result := '';
  bcount := 0;
  if (p.Token = '<') then begin
    Inc(bcount);
    result := p.TokenString;
    p.NextToken;
    while ((bcount > 0)  and (p.Token <> toEOF)) do begin
      result := result+p.TokenString;
      case (p.Token) of
        '<': Inc(bcount);
        '>': Dec(bcount);
      end;
      p.NextToken;
    end;
  end;
  if (p.Token = toEOF) then result := '';
end;

// Process {...}
function TClassAnalyser.pCurlyBrackets: string;
var
  bcount: integer;
begin
  result := '';
  bcount := 0;
  if (p.Token = '{') then begin
    Inc(bcount);
    result := p.TokenString;
    p.NextToken;
    while ((bcount > 0) and (p.Token <> toEOF)) do begin
      result := result+p.TokenString;
      case (p.Token) of
        '{': Inc(bcount);
        '}': Dec(bcount);
      end;
      p.NextToken;
    end;
  end;
  if (p.Token = toEOF) then result := '';
end;

// const <name> = <value>;
function TClassAnalyser.pConst: TUConst;
begin
  result := TUConst.Create;
  result.comment := trim(p.GetCopyData);
  result.name := p.TokenString;
  result.srcline := p.SourceLine;
  p.NextToken; // =
  p.NextToken;
  result.value := p.TokenString;
  p.NextToken; // = ;
  uclass.consts.Add(result);
end;

// var(tag) <modifiers> <type> <name>,<name>;
// var(tag) <modifiers> enum <name> {...} <name>,<name>;
// var(tag) <modifiers> struct <name> {...} <name>,<name>;
function TClassAnalyser.pVar: TUProperty;
var
  last, prev: string;
  nprop: TUProperty;
  i: integer;
begin
  result := TUProperty.Create;
  result.tag := pBrackets(true);
  result.comment := trim(p.GetCopyData);
  result.srcline := p.SourceLine;
  while (p.Token <> ';') do begin
    if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
    result.modifiers := result.modifiers+prev;
    
    prev := last;
    last := p.TokenString;
    p.NextToken;
    // check if Class.type
    if (p.Token = '.') then begin
      p.NextToken;
      last := last+'.'+p.TokenString;
      p.NextToken;
    end;
    last := last+pAngleBrackets;
    last := last+pSquareBrackets;
    while (p.Token = ',') do begin
      p.NextToken;
      last := last+','+p.TokenString;
      p.NextToken;
      last := last+pSquareBrackets;
    end;
    // inline enum
    if (CompareText(last, KEYWORD_enum) = 0) then begin
      prev := pEnum.name;
      last := p.TokenString;
      p.NextToken;
      last := last+pSquareBrackets; // name
      while (p.Token = ',') do begin
        p.NextToken;
        last := last+','+p.TokenString;
        p.NextToken;
        last := last+pSquareBrackets; // name
      end;
      break;
    end;
    // inline struct
    if (CompareText(last, KEYWORD_struct) = 0) then begin
      prev := pStruct.name;
      last := p.TokenString;
      p.NextToken;
      last := last+pSquareBrackets; // name
      while (p.Token = ',') do begin
        p.NextToken;
        last := last+','+p.TokenString;
        p.NextToken;
        last := last+pSquareBrackets; // name
      end;
      break;
    end;
  end;
  result.ptype := prev;
  result.name := last;
  i := Pos(',', result.name);
  while (i > 0) do begin
    nprop := TUProperty.Create;
    nprop.comment := trim(result.comment);
    nprop.srcline := result.srcline;
    nprop.ptype := result.ptype;
    nprop.modifiers := result.modifiers;
    nprop.name := Copy(result.name, 1, i-1);
    if (UseOverWriteStruct) then OverWriteUstruct.properties.Add(nprop)
      else uclass.properties.Add(nprop);
    Delete(result.name, 1, i);
    i := Pos(',', result.name);
  end;
  if (UseOverWriteStruct) then OverWriteUstruct.properties.Add(result)
    else uclass.properties.Add(result);
  p.NextToken;
end;

// enum <name> { <option>, ... };
function TClassAnalyser.pEnum: TUEnum;
begin
  result := TUEnum.Create;
  result.comment := trim(p.GetCopyData);
  result.name := p.TokenString;
  result.srcline := p.SourceLine;
  p.NextToken; // {
  p.NextToken; // first element
  while (p.Token <> '}') do begin
    result.options := result.options+p.TokenString;
    p.NextToken;
  end;
  p.NextToken; // = ;
  uclass.enums.Add(result);
end;

// struct <modifiers> <name> [extends <name>] { declaration };
function TClassAnalyser.pStruct: TUStruct;
var
  last, prev: string;
begin
  Result := TUStruct.Create;
  result.comment := trim(p.GetCopyData);
  result.name := p.TokenString;
  result.srcline := p.SourceLine;
  while (p.Token <> '{') do begin
    if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
    result.modifiers := result.modifiers+prev;
    prev := last;
    last := p.TokenString;
    p.NextToken;
    if (p.TokenSymbolIs(KEYWORD_extends) or p.TokenSymbolIs(KEYWORD_expands)) then begin
      p.NextToken;
      result.parent := p.TokenString;
      p.NextToken;
      // check if Class.type
      if (p.Token = '.') then begin
        p.NextToken;
        result.parent := result.parent+'.'+p.TokenString;
        p.NextToken;
      end;
      break;
    end;
  end;
  result.name := last;
  result.data := p.TokenString;
  {$DEFINE USTRUCT_FULLCOPY}
  {$IF USTRUCT_FULLCOPY}
  p.FullCopy := true;
  p.GetCopyData(true);// preflush
  pCurlyBrackets();
  p.FullCopy := false;
  result.data := result.data+p.GetCopyData(true);
  {$ELSE}
  result.data := '';
  OverWriteUstruct := result;
  UseOverWriteStruct := true;
  p.NextToken; // = {
  while ((p.Token <> '}') and (p.token <> toEOF) and (not Self.Terminated)) do begin
    if (p.TokenSymbolIs(KEYWORD_var)) then begin
      p.NextToken;
      pVar();
      continue;
    end;
    p.NextToken;
  end;
  p.NextToken; // = {
  UseOverWriteStruct := false;
  {$IFEND}
  if (p.Token = ';') then p.NextToken; // = ;
  uclass.structs.Add(result);
end;

// <modifiers> function <return> <name> ( <params>, <param> )
function TClassAnalyser.pFunc: TUFunction;
var
  bcount: integer;
  last: string;
const
  OPERATOR_NAMES: set of char = ['+', '-', '!', '<', '>', '=', '~', '*', '|', '^', '&'];
begin
  bcount := 0;
  result := TUFunction.Create;
  result.srcline := p.SourceLine;
  while not (p.TokenSymbolIs(KEYWORD_function) or p.TokenSymbolIs(KEYWORD_event) or
    p.TokenSymbolIs(KEYWORD_operator) or p.TokenSymbolIs(KEYWORD_preoperator) or
    p.TokenSymbolIs(KEYWORD_postoperator) or p.TokenSymbolIs(KEYWORD_delegate) or
    p.TokenSymbolIs(KEYWORD_state) or (p.token = toEOF)) do begin
    if (instate) then begin
      if (p.Token = ':') then begin // state labels
        bcount := 1;
        while (bcount > 0) do begin
          p.NextToken;
          case (p.token) of
            '{' : Inc(bcount);
            '}' : Dec(bcount);
          end;
        end;
        p.NextToken;
        currentState := nil;
        instate := false;
        result.Free;
        exit;
      end;
    end;
    if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
    result.modifiers := result.modifiers+last;
    last := p.TokenString;
    p.NextToken;
    last := last+pBrackets;
  end;
  if (p.token = toEOF) then begin
    log('EOF reached in pFunc of '+uclass.name+'('+IntToStr(p.SourceLine)+') '+result.modifiers);
    result.Free;
    Exception.Create('EOF reached');
  end;
  if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
  result.modifiers := result.modifiers+last;
  if (p.TokenSymbolIs(KEYWORD_state)) then begin
    pState(result.modifiers);
    result.Free;
    exit;
  end
  else if (p.TokenSymbolIs(KEYWORD_event)) then result.ftype := uftEvent
  else if (p.TokenSymbolIs(KEYWORD_operator)) then result.ftype := uftOperator
  else if (p.TokenSymbolIs(KEYWORD_preoperator)) then result.ftype := uftPreoperator
  else if (p.TokenSymbolIs(KEYWORD_postoperator)) then result.ftype := uftPostoperator
  else if (p.TokenSymbolIs(KEYWORD_delegate)) then result.ftype := uftDelegate
  else result.ftype := uftFunction;
  result.comment := trim(p.GetCopyData);
  p.NextToken;
  pBrackets; // possible operator precendence
  result.return := p.TokenString; // optional return
  p.NextToken;
  // check if Class.Type
  if (p.Token = '.') then begin
    p.NextToken;
    result.return := result.return+'.'+p.TokenString;
    p.NextToken;
  end;
  // check if return is array<> or class<>
  if ((CompareText(result.return, 'array') = 0) or
      (CompareText(result.return, KEYWORD_class) = 0)) then result.return := result.return+pAngleBrackets;
  if (p.Token = '(') then begin
    result.name := result.return;
    result.return := '';
  end
  else begin
    result.name := p.TokenString;
    p.NextToken; // (
  end;
  // fix operator names
  while (p.Token in OPERATOR_NAMES) do begin
    result.name := result.name+p.TokenString;
    p.NextToken; 
  end;
  p.NextToken; // (
  while (p.Token <> ')') do begin
    // todo params
    result.params := result.params+' '+p.TokenString;
    p.NextToken;
    if (p.Token = '.') then begin
      p.NextToken;
      result.params := result.params+'.'+p.TokenString;
      p.NextToken;
    end;
    result.params := result.params+pAngleBrackets
  end;
  p.NextToken; // )
  if (p.Token <> ';') then begin
    if (p.Token = '{') then bcount := 1;
    while (bcount > 0) do begin
     p.NextToken;
     case (p.token) of
        '{' : Inc(bcount);
        '}' : Dec(bcount);
      end;
    end;
  end;
  p.NextToken; // = } or ;
  result.state := currentState;
  if (currentState <> nil) then begin
    currentState.functions.Add(result);
  end;
  if (result.ftype = uftDelegate) then uclass.delegates.Add(result)
  else uclass.functions.Add(result);
end;

// [modifiers] state <name> [extends <name>] { .. }
function TClassAnalyser.pState(modifiers: string): TUState;
begin
  result := TUState.Create;
  result.comment := trim(p.GetCopyData);
  result.srcline := p.SourceLine;
  result.modifiers := modifiers;
  p.NextToken; // name
  pBrackets;
  result.name := p.TokenString;
  p.NextToken;
  if (p.TokenSymbolIs(KEYWORD_extends) or p.TokenSymbolIs(KEYWORD_expands)) then begin
    p.NextToken; // extends
    result.extends := p.TokenString;
    p.NextToken;
  end;
  if (p.Token = '{') then begin
    p.NextToken;
    instate := true;
    if (p.TokenSymbolIs('ignores')) then begin
      while (p.Token <> ';') do p.NextToken;
    end;
  end;
  currentState := Result;
  uclass.states.Add(result);
end;

procedure TClassAnalyser.AnalyseClass;
var
  bHadClass: boolean;
begin
  bHadClass := false;
  while ((p.token <> toEOF) and (not Self.Terminated)) do begin
    // first check class
    // class <classname> extends [<package>].<classname> <modifiers>;
    if (p.TokenSymbolIs(KEYWORD_Class) and not bHadClass) then begin
      bHadClass := true;
      p.NextToken;
      uclass.name := p.TokenString;
      uclass.comment := trim(p.GetCopyData);
      p.NextToken;
      if (p.TokenSymbolIs(KEYWORD_extends) or p.TokenSymbolIs(KEYWORD_expands)) then begin
        p.NextToken;
        uclass.parentname := p.TokenString;
        if (p.NextToken = '.') then begin // package.class
          p.NextToken;                    // (should work with checking package)
          uclass.parentname := p.TokenString;
        end;
      end;
      uclass.modifiers := '';
      while (p.Token <> ';') do begin
        uclass.modifiers := uclass.modifiers+p.TokenString+' ';
        p.NextToken;
      end;
      continue;
    end;
    if (not bHadClass) then begin
      p.NextToken;
      continue;
    end;
    
    if (p.TokenSymbolIs(KEYWORD_var)) then begin
      p.NextToken;
      pVar();
      continue;
    end;
    if (p.TokenSymbolIs(KEYWORD_const)) then begin
      p.NextToken;
      pConst();
      continue;
    end;
    if (p.TokenSymbolIs(KEYWORD_enum)) then begin
      p.NextToken;
      pEnum();
      continue;
    end;
    if (p.TokenSymbolIs(KEYWORD_struct)) then begin
      p.NextToken;
      pStruct();
      continue;
    end;
    if (p.TokenSymbolIs(KEYWORD_defaultproperties)) then begin
      p.GetCopyData(true);// preflush
      p.NextToken;
      uclass.defaultproperties := p.TokenString;
      p.FullCopy := true;
      pCurlyBrackets();
      p.FullCopy := false;
      uclass.defaultproperties := uclass.defaultproperties+p.GetCopyData(true);
      continue;
    end;
    if (p.TokenSymbolIs(KEYWORD_replication)) then begin
      p.NextToken;
      pCurlyBrackets();
      continue;
    end;
    if (p.TokenSymbolIs(KEYWORD_cpptext)) then begin
      p.NextToken;
      pCurlyBrackets();
      continue;
    end;
    if ((p.Token = '}') and instate) then begin
      currentState := nil;
      instate := false;
      p.NextToken;
      continue;
    end;
    if (p.Token = toSymbol) then begin
      // I think it's a function or an event
      pFunc();
      continue;
    end;
    p.NextToken; // we should not even get here
  end;
end;

end.
