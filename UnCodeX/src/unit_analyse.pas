{-----------------------------------------------------------------------------
 Unit Name: unit_analyse
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   class anaylser
 $Id: unit_analyse.pas,v 1.43 2004-10-17 13:17:18 elmuerte Exp $
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

unit unit_analyse;

{$IFNDEF CONSOLE}
  {$MESSAGE 'Compiling with __USE_TREEVIEW'}
  {$DEFINE __USE_TREEVIEW}
{$ENDIF}

interface

uses
  SysUtils, Classes, DateUtils, unit_uclasses, unit_parser, unit_outputdefs,
  unit_definitions, Hashes;

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
    ClassHash: TObjectHash;
    procedure AnalyseClass();
    function pConst: TUConst;
    function pVar: TUProperty;
    function pEnum: TUEnum;
    function pStruct: TUStruct;
    function isFunctionModifier(str: string): boolean;
    function pFunc: TUFunction;
    function pState(modifiers: string): TUState;
    function pBrackets(exclude: boolean = false): string;
    function pSquareBrackets: string;
    function pAngleBrackets: string;
    function pCurlyBrackets(ignoreFirst: boolean = false): string;
    procedure ExecuteList;
    function ExecuteSingle: integer;
    function GetSecondaryComment(ref :string): string;
    procedure pMacro(Sender: TUCParser);
  public
    constructor Create(classes: TUClassList; status: TStatusReport; onlynew: boolean = false; myClassList: TObjectHash = nil); overload;
    constructor Create(uclass: TUClass; status: TStatusReport; onlynew: boolean = false; myClassList: TObjectHash = nil); overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;

  EOFException = class(Exception)
  end;

var
  TreeUpdated: boolean = false;
  GetExternalComment: TExternaComment;

implementation

{$IFDEF __USE_TREEVIEW}
uses
  ComCtrls;
{$ENDIF}

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
  KEYWORD_Array = 'array';
  KEYWORD_Ignores = 'ignores';
  KEYWORD_Import = 'import';
  UNREAL2_AT_NAME = '@';

  RES_SUCCESS = 0;
  RES_REMOVED = 1;
  RES_ERROR = 2;

  EOFExceptionFmt = 'EOF reached in %s of %s (#%d) %s';

var
	FunctionModifiers: TStringList;

// unquote an unrealscript string
function UnQuoteString(input: string): string;
begin
  result := Copy(input, 2, length(input)-2);
  result := StringReplace(result, '\"', '"', [rfReplaceAll]);
end;

// Create for a class list
constructor TClassAnalyser.Create(classes: TUClassList; status: TStatusReport; onlynew: boolean = false; myClassList: TObjectHash = nil);
begin
  self.classes := classes;
  Self.status := status;
  Self.onlynew := onlynew;
  Self.FreeOnTerminate := true;
  ClassHash := myClassList;
  instate := false;
  inherited Create(true);
end;

// Create for a single class
constructor TClassAnalyser.Create(uclass: TUClass; status: TStatusReport; onlynew: boolean = false; myClassList: TObjectHash = nil);
begin
  self.classes := nil;
  self.uclass := uclass;
  Self.status := status;
  Self.onlynew := onlynew;
  Self.FreeOnTerminate := true;
  ClassHash := myClassList;
  inherited Create(true);
end;

destructor TClassAnalyser.Destroy;
begin
  inherited Destroy();
end;

procedure TClassAnalyser.Execute;
var
  stime: TDateTime;
  j: integer;
begin
  stime := Now();
  if (classes = nil) then begin
    Status('Analysing class '+uclass.name+' ...');
    try
	    ExecuteSingle;
    except
    	on E: EOFException do begin
        LogClass('End of file reached while parsing '+uclass.filename+': '+E.Message, uclass);
        LogClass('History:', uclass);
      	for j := 0 to GuardStack.Count-1 do begin
					LogClass('    '+GuardStack[j], uclass);
      	end;
      end;
			on E: Exception do begin
      	LogClass('Unhandled exception in class '+uclass.name+': '+E.Message, uclass);
        LogClass('History:', uclass);
      	for j := 0 to GuardStack.Count-1 do begin
					LogClass('    '+GuardStack[j], uclass);
      	end;
      end;
    end;
  end
  else ExecuteList;
  Status('Operation completed in '+Format('%.3f', [Millisecondsbetween(Now(), stime)/1000])+' seconds');
end;

procedure TClassAnalyser.ExecuteList;
var
  i, j: integer;
begin
	i := 0;
  while (i < classes.Count) do begin
    uclass := classes[i];
    Status('Analysing class '+uclass.name+' ...', round(i/(classes.count-1)*100));
    try
	    case ExecuteSingle of
        RES_SUCCESS, RES_ERROR:	Inc(i);
      end;
    except
    	on E: EOFException do begin
      	Inc(i);
        LogClass('End of file reached while parsing '+uclass.filename+': '+E.Message, uclass);
        LogClass('History:', uclass);
      	for j := 0 to GuardStack.Count-1 do begin
					LogClass('    '+GuardStack[j], uclass);
      	end;
      end;
      on E: Exception do begin
      	Inc(i);
      	LogClass('Unhandled exception in class '+uclass.name+': '+E.Message, uclass);
        LogClass('History:', uclass);
      	for j := 0 to GuardStack.Count-1 do begin
					LogClass('    '+GuardStack[j], uclass);
      	end;
      end;
    end;
    if (Self.Terminated) then break;
  end;
end;

function TClassAnalyser.ExecuteSingle: integer;
var
  filename: string;
  currenttime: Integer;
begin
  resetguard;
  Result := RES_SUCCESS;
  filename := uclass.package.path+PATHDELIM+uclass.filename;
  if (not FileExists(filename)) then begin
    Log('Class has been removed: '+uclass.name+' '+filename);
    {$IFDEF __USE_TREEVIEW}
    if (classes <> nil) then begin
    	TTreeNode(uclass.TreeNode2).Delete;
	    TTreeNode(uclass.TreeNode).Delete;
      if (ClassHash <> nil) then ClassHash.Delete(LowerCase(uclass.name));
      if (uclass.parent <> nil) then uclass.parent.children.Remove(uclass);
    	uclass.package.classes.Remove(uclass);
	    classes.Remove(uclass);
      result := RES_REMOVED;
    end;
    {$ENDIF}
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
  	p.ProcessMacro := pMacro;
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

// second secondary comment
// ref= package.class.member
// ref= package.class.struct.member
// ref= package.class.function state
function TClassAnalyser.GetSecondaryComment(ref :string): string;
begin
  if (Assigned(GetExternalComment)) then result := GetExternalComment(ref);
end;

// Process (...)
function TClassAnalyser.pBrackets(exclude: boolean = false): string;
begin
	guard('pBrackets '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
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
  unguard;
end;

// Process [...]
function TClassAnalyser.pSquareBrackets: string;
begin
	guard('pSquareBrackets '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
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
  unguard;
end;

// Process <...>
function TClassAnalyser.pAngleBrackets: string;
var
  bcount: integer;
begin
	guard('pAngleBrackets '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
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
  unguard;
end;

// Process {...}
function TClassAnalyser.pCurlyBrackets(ignoreFirst: boolean = false): string;
var
  bcount: integer;
begin
	guard('pCurlyBrackets '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := '';
  if (ignoreFirst) then bcount := 1
  	else bcount := 0;
  if ((p.Token = '{') or (ignoreFirst)) then begin
    if (p.Token = '{') then Inc(bcount);
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
  unguard;
end;

// const <name> = <value>;
function TClassAnalyser.pConst: TUConst;
begin
	guard('pConst '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := TUConst.Create;
  result.comment := trim(p.GetCopyData);
  result.name := p.TokenString;
  result.srcline := p.SourceLine;
  p.NextToken; // =
  p.GetCopyData();
  p.FullCopy := true;
  p.FCIgnoreComments := true;
  p.NextToken;
  while ((p.Token <> ';') and (p.Token <> toEOF)) do p.NextToken;
  if (p.Token = toEOF) then begin
		result.Free;
    raise EOFException.CreateFmt(EOFExceptionFmt, ['pConst', uclass.name, p.SourceLine, '']);
  end;
  result.value := p.GetCopyData();
  Delete(result.value, length(result.value), 1); // strip ;
  result.value := trim(result.value);
  p.FullCopy := false;
  p.FCIgnoreComments := false;
  p.NextToken; // = ;
  if (result.comment = '') then begin
  	result.comment := GetSecondaryComment(uclass.FullName+'.'+result.name);
    result.CommentType := ctExtern;
  end;
  uclass.consts.Add(result);
  unguard;
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
	guard('pVar '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := TUProperty.Create;
  result.tag := pBrackets(true);
  result.comment := trim(p.GetCopyData);
  result.srcline := p.SourceLine;
  while (p.Token <> ';') do begin
  	if (p.Token = toEOF) then begin
			result.Free;
  	  raise EOFException.CreateFmt(EOFExceptionFMT, ['pVar', uclass.name, p.SourceLine, result.modifiers]);
	  end;
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
    // variable description
    if (p.Token = toString) then begin
      if (result.comment <> '') then begin
        logclass(uclass.FullName+' '+Result.name+': ignoring variable description', uclass);
      end
      else begin
	      result.comment := UnQuoteString(p.TokenString);
      end;
    	p.NextToken; // should be: ';'
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
    if (UseOverWriteStruct) then begin
    	if (nprop.comment = '') then begin
      	nprop.comment := GetSecondaryComment(uclass.FullName+'.'+OverWriteUstruct.name+'.'+nprop.name);
        nprop.CommentType := ctExtern;
      end;
    	OverWriteUstruct.properties.Add(nprop)
    end
    else begin
    	if (nprop.comment = '') then begin
      	nprop.comment := GetSecondaryComment(uclass.FullName+'.'+nprop.name);
        result.CommentType := ctExtern;
      end;
    	uclass.properties.Add(nprop);
    end;
    Delete(result.name, 1, i);
    i := Pos(',', result.name);
  end;
  if (UseOverWriteStruct) then begin
  	// package.class.struct.name
  	if (result.comment = '') then begin
    	result.comment := GetSecondaryComment(uclass.FullName+'.'+OverWriteUstruct.name+'.'+result.name);
      result.CommentType := ctExtern;
    end;
  	OverWriteUstruct.properties.Add(result)
  end
  else begin
  	if (result.comment = '') then begin
    	result.comment := GetSecondaryComment(uclass.FullName+'.'+result.name);
      result.CommentType := ctExtern;
    end;
  	uclass.properties.Add(result);
  end;
  p.NextToken;
  unguard;
end;

// enum <name> { <option>, ... };
function TClassAnalyser.pEnum: TUEnum;
begin
	guard('pEnum '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := TUEnum.Create;
  result.comment := trim(p.GetCopyData);
  result.name := p.TokenString;
  result.srcline := p.SourceLine;
  p.NextToken; // {
  p.NextToken; // first element
  while (p.Token <> '}') do begin
  	if (p.Token = toEOF) then begin
			result.Free;
  	  raise EOFException.CreateFmt(EOFExceptionFmt, ['pEnum', uclass.name, p.SourceLine, result.options]);
	  end;
    result.options := result.options+p.TokenString;
    p.NextToken;
  end;
  p.NextToken; // = ;
  if (result.comment = '') then begin
  	result.comment := GetSecondaryComment(uclass.FullName+'.'+result.name);
    result.CommentType := ctExtern;
  end;
  uclass.enums.Add(result);
  unguard;
end;

// struct <modifiers> <name> [extends <name>] { declaration };
function TClassAnalyser.pStruct: TUStruct;
var
  last, prev: string;
begin
	guard('pStruct '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  Result := TUStruct.Create;
  result.comment := trim(p.GetCopyData);
  result.name := p.TokenString;
  result.srcline := p.SourceLine;
  while (p.Token <> '{') do begin
  	if (p.Token = toEOF) then begin
			result.Free;
  	  raise EOFException.CreateFmt(EOFExceptionFmt, ['pStruct', uclass.name, p.SourceLine, result.modifiers]);
	  end;
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
  OverWriteUstruct := result;
  UseOverWriteStruct := true;
  p.NextToken; // = {
  while ((p.Token <> '}') and (not Self.Terminated)) do begin
  	if (p.Token = toEOF) then begin
			result.Free;
  	  raise EOFException.CreateFmt(EOFExceptionFmt, ['pStruct_variables', uclass.name, p.SourceLine, '']);
	  end;
    if (p.TokenSymbolIs(KEYWORD_var)) then begin
      p.NextToken;
      pVar();
      continue;
    end;
    p.NextToken;
  end;
  p.NextToken; // = {
  UseOverWriteStruct := false;
  if (p.Token = ';') then p.NextToken; // = ;
  if (result.comment = '') then begin
  	result.comment := GetSecondaryComment(uclass.FullName+'.'+result.name);
    result.CommentType := ctExtern;
  end;
  uclass.structs.Add(result);
  unguard;
end;

function TClassAnalyser.isFunctionModifier(str: string): boolean;
begin
	result := false;
	if (FunctionModifiers <> nil) then result := FunctionModifiers.IndexOf(str) > -1;
end;

// <modifiers> function <return> <name> ( <params>, <param> )
function TClassAnalyser.pFunc: TUFunction;
var
  last: string;
const
  OPERATOR_NAMES: set of char = ['+', '-', '!', '<', '>', '=', '~', '*', '|', '^', '&'];
begin
	guard('pFunc '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := TUFunction.Create;
  result.srcline := p.SourceLine;
  while not (p.TokenSymbolIs(KEYWORD_function) or p.TokenSymbolIs(KEYWORD_event) or
    p.TokenSymbolIs(KEYWORD_operator) or p.TokenSymbolIs(KEYWORD_preoperator) or
    p.TokenSymbolIs(KEYWORD_postoperator) or p.TokenSymbolIs(KEYWORD_delegate) or
    p.TokenSymbolIs(KEYWORD_state) or (p.token = toEOF)) do begin
    if (instate) then begin
      if (p.Token = ':') then begin // state labels
        pCurlyBrackets(true);
        currentState := nil;
        instate := false;
        result.Free;
        unguard;
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
    //log('EOF reached in pFunc of '+uclass.name+'('+IntToStr(p.SourceLine)+') '+result.modifiers);
    result.Free;
    raise EOFException.CreateFmt(EOFExceptionFmt, ['pFunc', uclass.name, p.SourceLine, result.modifiers]);
  end;
  if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
  result.modifiers := result.modifiers+last;
  if (p.TokenSymbolIs(KEYWORD_state)) then begin
    pState(result.modifiers);
    result.Free;
    unguard;
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
  // function <mod> ...
  while (isFunctionModifier(p.TokenString)) do begin
    if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
    result.modifiers := result.modifiers+p.TokenString;
    p.NextToken;
    result.modifiers := result.modifiers+pBrackets;
  end;
  result.return := p.TokenString; // optional return
  p.NextToken;
  // check if Class.Type
  if (p.Token = '.') then begin
    p.NextToken;
    result.return := result.return+'.'+p.TokenString;
    p.NextToken;
  end;
  // check if return is array<> or class<>
  if ((CompareText(result.return, KEYWORD_array) = 0) or
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
  p.FullCopy := true;
  p.FCIgnoreComments := true;
  p.GetCopyData;
  p.NextToken; // (
  while (p.Token <> ')') do p.NextToken;
  result.params := p.GetCopyData;
  Delete(result.params, Length(result.params), 1);
  result.params := trim(result.params);
  p.FullCopy := false;
  p.FCIgnoreComments := false;
  p.NextToken; // )
  if (p.Token <> ';') then pCurlyBrackets()
  else p.NextToken; // = } or ;
  result.state := currentState;
  if (currentState <> nil) then begin
  	// package.class.name state
  	if (result.comment = '') then begin
    	result.comment := GetSecondaryComment(uclass.FullName+'.'+result.name+' '+currentState.name);
      result.CommentType := ctExtern;
    end;
    currentState.functions.Add(result);
  end;
  if (result.comment = '') then begin
  	result.comment := GetSecondaryComment(uclass.FullName+'.'+result.name);
    result.CommentType := ctExtern;
  end;
  if (result.ftype = uftDelegate) then uclass.delegates.Add(result)
  else uclass.functions.Add(result);
  unguard;
end;

// [modifiers] state <name> [extends <name>] { .. }
function TClassAnalyser.pState(modifiers: string): TUState;
begin
	guard('pState '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := TUState.Create;
  result.comment := trim(p.GetCopyData);
  result.srcline := p.SourceLine;
  result.modifiers := modifiers;
  p.NextToken; // name
  pBrackets;
  result.name := p.TokenString;
  if (result.name = UNREAL2_AT_NAME) then begin
    p.NextToken; // after @
    result.name := result.name+p.TokenString;
  end;
  p.NextToken;
  if (p.TokenSymbolIs(KEYWORD_extends) or p.TokenSymbolIs(KEYWORD_expands)) then begin
    p.NextToken; // extends
    result.extends := p.TokenString;
    if (result.extends = UNREAL2_AT_NAME) then begin
    	p.NextToken; // after @
  	  result.extends := result.extends+p.TokenString;
	  end;
    p.NextToken;
  end;
  if (p.Token = '{') then begin
    p.NextToken;
    instate := true;
    while (p.TokenSymbolIs(KEYWORD_ignores)) do begin
      while (p.Token <> ';') do p.NextToken;
      p.NextToken;
    end;
  end;
  currentState := Result;
  if (result.comment = '') then begin
  	result.comment := GetSecondaryComment(uclass.FullName+'.'+result.name);
    result.CommentType := ctExtern;
  end;
  uclass.states.Add(result);
  unguard;
end;

procedure TClassAnalyser.pMacro(Sender: TUCParser);
begin
  log('Got macro: '+trim(Sender.TokenString));
end;

procedure TClassAnalyser.AnalyseClass;
var
  bHadClass: boolean;
begin
	guard('AnalyseClass '+uclass.name);
  bHadClass := false;
  while ((p.token <> toEOF) and (not Self.Terminated)) do begin
    // first check class
    // class <classname> extends [<package>].<classname> <modifiers>;
    if (p.TokenSymbolIs(KEYWORD_Class) and not bHadClass) then begin
      bHadClass := true;
      p.NextToken;
      uclass.name := p.TokenString;
      uclass.CommentType := ctSource;
      uclass.comment := trim(p.GetCopyData);
      if (uclass.comment = '') then begin
      	uclass.comment := GetSecondaryComment(uclass.FullName);
        uclass.CommentType := ctExtern;
      end;
      p.NextToken;
      if (p.TokenSymbolIs(KEYWORD_extends) or p.TokenSymbolIs(KEYWORD_expands)) then begin
        p.NextToken;
        uclass.parentname := p.TokenString;
        if (p.NextToken = '.') then begin // package.class
          p.NextToken;                    // (should work with checking package)
          uclass.parentname := uclass.parentname+'.'+p.TokenString;
          p.NextToken; 
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
      p.FCIgnoreComments := true;
      pCurlyBrackets();
      p.FullCopy := false;
      p.FCIgnoreComments := false;
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
    if (p.TokenSymbolIs(KEYWORD_Import)) then begin // ignore imports
      while (p.Token <> ';') do p.NextToken;
      p.NextToken;
      continue;
    end;
    if ((p.Token = UNREAL2_AT_NAME) and instate) then begin
    	p.NextToken;
      pCurlyBrackets(true);
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
  unguard;
end;

initialization
	FunctionModifiers := TStringList.Create;
  FunctionModifiers.CaseSensitive := false;
  FunctionModifiers.Add('native');
  FunctionModifiers.Add('intrinsic');
  FunctionModifiers.Add('final');
  FunctionModifiers.Add('private');
  FunctionModifiers.Add('protected');
  FunctionModifiers.Add('public');
  FunctionModifiers.Add('latent');
  FunctionModifiers.Add('iterator');
  FunctionModifiers.Add('singular');
  FunctionModifiers.Add('static');
  FunctionModifiers.Add('exec');
  FunctionModifiers.Add('simulated');
finalization
	FunctionModifiers.Free;
end.
