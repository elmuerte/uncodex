{*******************************************************************************
  Name:
    unit_analuse.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    UnrealScript class analyser

  $Id: unit_analyse.pas,v 1.85 2007-12-01 17:23:31 elmuerte Exp $
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

unit unit_analyse;

{$I defines.inc}

interface

uses
  SysUtils, Classes, DateUtils, unit_uclasses, unit_parser, unit_outputdefs,
  unit_definitions, Hashes, Contnrs, unit_ucxthread, unit_definitionlist;

type
  TClassAnalyser = class(TUCXThread)
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
    ClassHash: TObjectHash;
    macroIfCnt: integer;
    macroLastIf: boolean;
    includeParsers: TObjectList;
    includeFiles: TStringList;
    incFilename: string;
    BaseDefinitions: TDefinitionList;
    function GetLogFilename(): string;
    procedure SetParentDefs();
    procedure AnalyseClass();
    function pConst: TUConst;
    function pVar: TUProperty;
    function pEnum: TUEnum;
    function pStruct: TUStruct;
    function isFunctionModifier(str: string): boolean;
    function pFunc: TUFunction;
    function pState(modifiers: string): TUState;
    function pBrackets(exclude: boolean = false; bLeaveLast: boolean = false): string;
    function pSquareBrackets: string;
    function pAngleBrackets(checkUE3desc: boolean = false): string;
    function pCurlyBrackets(ignoreFirst: boolean = false): string;
    procedure ExecuteList;
    function ExecuteSingle: integer;
    function GetSecondaryComment(ref :string): string;
    procedure pMacro(Sender: TUCParser);
    procedure pInclude(relfilename: string; classRelative: boolean = false);
    procedure pReplication;
  public
    constructor Create(classes: TUClassList; onlynew: boolean = false; myClassList: TObjectHash = nil; myBaseDefs: TDefinitionList = nil); overload;
    constructor Create(uclass: TUClass; onlynew: boolean = false; myClassList: TObjectHash = nil; myBaseDefs: TDefinitionList = nil); overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;

  EOFException = class(Exception)
  end;

var
  TreeUpdated: boolean = false;
  GetExternalComment: TExternalComment;

implementation

{$IFDEF USE_TREEVIEW}
uses
  ComCtrls;
{$ENDIF}

const
  KEYWORD_Class             = 'class';
  KEYWORD_Interface         = 'interface';
  KEYWORD_Extends           = 'extends';
  KEYWORD_Expands           = 'expands';
  KEYWORD_Const             = 'const';
  KEYWORD_Var               = 'var';
  KEYWORD_Enum              = 'enum';
  KEYWORD_Struct            = 'struct';
  KEYWORD_Function          = 'function';
  KEYWORD_Event             = 'event';
  KEYWORD_Operator          = 'operator';
  KEYWORD_PreOperator       = 'preoperator';
  KEYWORD_PostOperator      = 'postoperator';
  KEYWORD_Delegate          = 'delegate';
  KEYWORD_State             = 'state';
  KEYWORD_Defaultproperties = 'defaultproperties';
  KEYWORD_Cpptext           = 'cpptext';
  KEYWORD_Cppstruct         = 'cppstruct';
  KEYWORD_Replication       = 'replication';
  KEYWORD_Array             = 'array';
  KEYWORD_Ignores           = 'ignores';
  KEYWORD_Import            = 'import';
  UNREAL2_AT_NAME           = '@';

  RES_SUCCESS               = 0;
  RES_REMOVED               = 1;
  RES_ERROR                 = 2;

  EOFExceptionFmt           = 'EOF reached in %s of %s (#%d) %s';

  OPERATOR_NAMES: set of char = ['+', '-', '!', '<', '>', '=', '~', '*', '|', '^', '&'];

var
  FunctionModifiers: TStringList;
  DEBUG_MACRO_EVAL: boolean = false;

// unquote an unrealscript string
//TODO: verify this
function UnQuoteString(input: string): string;
begin
  result := Copy(input, 2, length(input)-2);
  result := StringReplace(result, '\"', '"', [rfReplaceAll]);
end;

// removes leading # and comments from a macro line
function TrimMacro(input: string): string;
var
  i, j: integer;
begin
  if (Length(input) < 1) then exit;
  if (input[1] = '#') then Delete(input, 1, 1);

  repeat
    i := pos('/*', input);
    if (i > 0) then begin
      j := pos('*/', input);
      if (j = 0) then j := MaxInt;
      Delete(input, i, j+2-i);
  end;
  until (i = 0);
  i := pos('//', input);
  if (i > 0) then Delete(input, i, Length(input));
  result := input;
end;

// Create for a class list
constructor TClassAnalyser.Create(classes: TUClassList; onlynew: boolean = false; myClassList: TObjectHash = nil; myBaseDefs: TDefinitionList = nil);
begin
  self.classes := classes;
  Self.onlynew := onlynew;
  Self.FreeOnTerminate := true;
  ClassHash := myClassList;
  instate := false;
  BaseDefinitions := myBaseDefs;
  inherited Create(true);
end;

// Create for a single class
constructor TClassAnalyser.Create(uclass: TUClass; onlynew: boolean = false; myClassList: TObjectHash = nil; myBaseDefs: TDefinitionList = nil);
begin
  self.classes := nil;
  self.uclass := uclass;
  Self.onlynew := onlynew;
  Self.FreeOnTerminate := true;
  ClassHash := myClassList;
  BaseDefinitions := myBaseDefs;
  inherited Create(true);
end;

destructor TClassAnalyser.Destroy;
begin
  inherited Destroy();
end;

procedure TClassAnalyser.SetParentDefs();
var
  uc: TUClass;
begin
  if (BaseDefinitions = nil) then exit;
  uc := uclass;
  while (uc.parent <> nil) do uc := uc.parent;
  uc.defs.Parent := BaseDefinitions;
end;

function TClassAnalyser.GetLogFilename(): string;
begin
  if (incFilename = '') then exit;
  result := ExtractFilePath(uclass.package.path)+incFilename;
end;

procedure TClassAnalyser.Execute;
var
  stime: TDateTime;
begin
  guard('Execute');
  DEBUG_MACRO_EVAL := FindCmdLineSwitch('debug', ['-'], true);
  stime := Now();
  if (classes = nil) then begin
    Status('Analysing class '+uclass.name+' ...');
    try
      ExecuteSingle;
    except
      on E: EOFException do begin
        InternalLog('End of file reached while parsing '+uclass.filename+': '+E.Message, ltError, CreateLogentry(uclass));
        printguard(uclass);
      end;
      on E: Exception do begin
        InternalLog('Unhandled exception in class '+uclass.name+': '+E.Message, ltError, CreateLogentry(uclass));
        printguard(uclass);
      end;
    end;
  end
  else ExecuteList;
  Status('Operation completed in '+Format('%.3f', [Millisecondsbetween(Now(), stime)/1000])+' seconds');
  unguard;
end;

procedure TClassAnalyser.ExecuteList;
var
  i, n: integer;

  procedure ExecClass(myclass: TUClass);
  var
    j: integer;
  begin
    Status('Analysing class '+myclass.name+' ...', round(i/(classes.count-1)*100));
    try
      uclass := myclass;
      case ExecuteSingle of
        RES_SUCCESS:
          begin
            Inc(i);
            for j := myclass.children.Count-1 downto 0 do begin
              ExecClass(myclass.children[j]);
              if (Self.Terminated) then exit;
            end;
          end;
        RES_REMOVED, RES_ERROR:
          Inc(i);
      end;
    except
      on E: EOFException do begin
        Inc(i);
        InternalLog('End of file reached while parsing '+myclass.filename+': '+E.Message, ltError, CreateLogentry(myclass));
        printguard(myclass);
      end;
      on E: Exception do begin
        Inc(i);
        InternalLog('Unhandled exception in class '+myclass.name+': '+E.Message, ltError, CreateLogentry(myclass));
        printguard(myclass);
      end;
    end;

  end;

begin
  i := 0;
  for n := classes.Count-1 downto 0 do begin
    if (classes[n].parent = nil) then begin
      ExecClass(classes[n]);
    end;
  end;
end;

function TClassAnalyser.ExecuteSingle: integer;
var
  filename: string;
  currenttime: Integer;
begin
  guard('ExecuteSingle '+uclass.name);
  Result := RES_SUCCESS;
  filename := uclass.package.path+PATHDELIM+uclass.filename;
  if (not FileExists(filename)) then begin
    InternalLog('Class has been removed: '+uclass.name+' '+filename);
    {$IFDEF USE_TREEVIEW}
    if (classes <> nil) then begin
      TTreeNode(uclass.TreeNode2).Delete;
      TTreeNode(uclass.TreeNode).Delete;
      if (ClassHash <> nil) then ClassHash.Delete(LowerCase(uclass.name));
      if (uclass.parent <> nil) then uclass.parent.children.Remove(uclass);
      uclass.package.classes.Remove(uclass);
      classes.Remove(uclass);
      uclass := nil;
      result := RES_REMOVED;
    end;
    {$ENDIF}
    exit;
  end;
  currenttime := FileAge(filename);
  if (onlynew and (currenttime <= uclass.filetime)) then exit;
  if (onlynew) then InternalLog('Class changed since last time: '+uclass.name, ltInfo, CreateLogentry(uclass));
  TreeUpdated := true;
  UseOverWriteStruct := false;
  uclass.filetime := currenttime;
  includeParsers := TObjectList.Create(false);
  includeFiles := TStringList.Create;
  fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
  p := TUCParser.Create(fs);
  macroLastIf := false;
  try
    p.ProcessMacro := pMacro;
    uclass.defaultproperties.data := '';
    uclass.defaultproperties.srcline := 0;
    uclass.replication.srcline := 0;
    uclass.replication.symbols.Clear;
    uclass.replication.expressions.Clear;
    uclass.consts.Clear;
    uclass.properties.Clear;
    uclass.enums.Clear;
    uclass.structs.Clear;
    uclass.functions.Clear;
    uclass.delegates.Clear;
    uclass.states.Clear;
    uclass.defs.Clear;
    SetParentDefs;
    AnalyseClass();
    if (not Self.Terminated) then begin
      uclass.consts.Sort;
      uclass.properties.SortOnTag;
      uclass.enums.Sort;
      uclass.structs.Sort;
      uclass.functions.Sort;
      uclass.delegates.Sort;
      uclass.states.Sort;
    end;
  finally
    FreeAndNil(p);
    fs.Free;
    includeParsers.Free;
    includeFiles.Free;
  end;
  unguard;
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
function TClassAnalyser.pBrackets(exclude: boolean = false; bLeaveLast: boolean = false): string;
var
  bcount: integer;
begin
  guard('pBrackets '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := '';
  bcount := 0;
  if (p.Token = '(') then begin
    Inc(bcount);
    if (not exclude) then result := p.TokenString;
    p.NextToken;
    while ((bcount > 0) and (p.Token <> toEOF)) do begin
      case (p.Token) of
        '(': Inc(bcount);
        ')': Dec(bcount);
      end;
      if (not ((bcount = 0) and exclude)) then result := result+p.TokenString;
      if ((bcount = 0) and bLeaveLast) then break;
      p.NextToken;
    end;
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
function TClassAnalyser.pAngleBrackets(checkUE3desc: boolean = false): string;
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
    {$IFDEF UE3_SUPPORT}
    if (checkUE3desc and ((p.TokenString = 'DisplayName') or (p.TokenString = 'ToolTip'))) then begin
      result := '';
      p.SkipTo('>');
      p.NextToken;
    end
    else begin
    {$ENDIF}
      while ((bcount > 0) and (p.Token <> toEOF)) do begin
        result := result+p.TokenString;
        case (p.Token) of
          '<': Inc(bcount);
          '>': Dec(bcount);
        end;
        p.NextToken;
      end;
    {$IFDEF UE3_SUPPORT}
    end;
    {$ENDIF}
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
var
  tmp: string;
begin
  guard('pConst '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := TUConst.Create;
  try
    result.comment := trim(p.GetCopyData);
    result.name := p.TokenString;
    result.srcline := p.SourceLine;
    result.definedIn := incFilename;
    p.NextToken; // =
    if (p.Token <> '=') then begin
      InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': expected "=" got "'+p.tokenString+'"', ltError, CreateLogEntry(GetLogFilename(), p.SourceLine, 0, uclass));
    end;
    p.GetCopyData();
    p.FullCopy := true;
    p.FCIgnoreComments := true;
    p.NextToken;
    while ((p.Token <> ';') and (p.Token <> toEOF)) do p.NextToken;
    if (p.Token = toEOF) then begin
      raise EOFException.CreateFmt(EOFExceptionFmt, ['pConst', uclass.name, p.SourceLine, '']);
    end;
    tmp := p.GetCopyData();
    Delete(tmp, length(tmp), 1); // strip ;
    result.value := trim(tmp);
    p.FullCopy := false;
    p.FCIgnoreComments := false;
    p.NextToken; // = ;
    if (result.comment = '') then begin
      result.comment := GetSecondaryComment(uclass.FullName+'.'+result.name);
      result.CommentType := ctExtern;
    end;
    uclass.consts.Add(result);
  except
    FreeAndNil(result);
    raise;
  end;
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
  prev := '';
  result := TUProperty.Create;
  try
    if (p.Token = '(') then last := #1#2#3#4#5 else last := '';
    result.tag := pBrackets(true);
    // empty tag = classname
    if ((result.tag = '') and (last <> '')) then result.tag := uclass.name;
    last := '';
    result.comment := trim(p.GetCopyData);
    result.srcline := p.SourceLine;
    result.definedIn := incFilename;
    guard('searching end token');
    while (p.Token <> ';') do begin
      if (p.Token = toEOF) then begin
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
      last := last+pAngleBrackets(true);
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
      {$IFDEF UE3_SUPPORT}
      if (p.Token = '{') then begin
        pCurlyBrackets();
      end;
      {$ENDIF}
      if (p.Token = toString) then begin
        if (result.comment <> '') then begin
          InternalLog(uclass.FullName+' '+Result.name+': ignoring variable description', ltInfo, CreateLogEntry(ResolveFilename(uclass, Result), p.SourceLine , 0, uclass));
        end
        else begin
          result.comment := UnQuoteString(p.TokenString);
        end;
        p.NextToken; // should be: ';'
      end;
    end;
    unguard;
    result.ptype := prev;
    i := Pos(',', last);
    while (i > 0) do begin
      nprop := TUProperty.Create;
      try
        nprop.comment := trim(result.comment);
        nprop.srcline := result.srcline;
        nprop.definedIn := Result.definedIn;
        nprop.ptype := result.ptype;
        nprop.modifiers := result.modifiers;
        nprop.name := Copy(last, 1, i-1);
        nprop.tag := result.tag;
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
      except
        FreeAndNil(nprop);
        raise;
      end;
      // TODO: is this broken?
      Delete(last, 1, i);
      i := Pos(',', last);
    end;
    result.name := last;
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
  except
    FreeAndNil(result);
    raise;
  end;
  unguard;
end;

// enum <name> { <option>, ... };
function TClassAnalyser.pEnum: TUEnum;
begin
  guard('pEnum '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := TUEnum.Create;
  try
    result.comment := trim(p.GetCopyData);
    result.name := p.TokenString;
    result.srcline := p.SourceLine;
    result.definedIn := incFilename;
    p.NextToken; // {
    p.NextToken; // first element
    while (p.Token <> '}') do begin
      if (p.Token = toEOF) then begin
        raise EOFException.CreateFmt(EOFExceptionFmt, ['pEnum', uclass.name, p.SourceLine, result.options]);
      end;
      result.options := result.options+p.TokenString;
      p.NextToken;
    end;
    p.NextToken; // = '}'
    if (p.Token = ';') then p.NextToken; // = ';'
    if (result.comment = '') then begin
      result.comment := GetSecondaryComment(uclass.FullName+'.'+result.name);
      result.CommentType := ctExtern;
    end;
    uclass.enums.Add(result);
  except
    FreeAndNil(result);
    raise;
  end;
  unguard;
end;

// struct <modifiers> <name> [extends <name>] { declaration };
function TClassAnalyser.pStruct: TUStruct;
var
  last, prev: string;
begin
  guard('pStruct '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  Result := TUStruct.Create;
  last := '';
  prev := '';
  try
    result.comment := trim(p.GetCopyData);
    result.name := p.TokenString;
    result.srcline := p.SourceLine;
    result.definedIn := incFilename;
    {$IFDEF UE3_SUPPORT}
    // ignore native type hint
    if (p.Token = '{') then begin
      pCurlyBrackets();
    end;
    {$ENDIF}
    while (p.Token <> '{') do begin
      if (p.Token = toEOF) then begin
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
        raise EOFException.CreateFmt(EOFExceptionFmt, ['pStruct_variables', uclass.name, p.SourceLine, '']);
      end;
      if (p.TokenSymbolIs(KEYWORD_var)) then begin
        p.NextToken;
        pVar();
        continue;
      end
      else if (p.TokenSymbolIs(KEYWORD_const)) then begin
        p.NextToken;
        pConst();
        continue;
      end
      else if (p.TokenSymbolIs(KEYWORD_Cppstruct)) then begin
        p.NextToken;
        pCurlyBrackets();
        continue;
      end
      {$IFDEF UE3_SUPPORT}
      else if (p.TokenSymbolIs('structcpptext')) then begin
        p.NextToken;
        pCurlyBrackets();
        continue;
      end
      else if (p.TokenSymbolIs('structdefaultproperties')) then begin
        p.NextToken;
        pCurlyBrackets();
        continue;
      end
      {$ENDIF}
      ;
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
  except
    FreeAndNil(result);
    raise;
  end;
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
begin
  guard('pFunc '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  last := '';
  result := TUFunction.Create;
  try
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
          FreeAndNil(result);
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
      FreeAndNil(result);
      raise EOFException.CreateFmt(EOFExceptionFmt, ['pFunc', uclass.name, p.SourceLine, result.modifiers]);
    end;
    if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
    result.modifiers := result.modifiers+last;
    if (p.TokenSymbolIs(KEYWORD_state)) then begin
      try
        pState(result.modifiers);
      finally
        FreeAndNil(result);
      end;
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
    //p.NextToken; // (
    //while (p.Token <> ')') do p.NextToken;
    pBrackets();
    result.params := p.GetCopyData;
    result.params := Copy(result.params, 1, Length(result.params)-2);
    //Delete(result.params, Length(result.params), 1);
    result.params := trim(result.params);
    p.FullCopy := false;
    p.FCIgnoreComments := false;
    //p.NextToken; // )
    if (p.tokenString = 'const') then begin // UE3 native const functions
      p.NextToken;
      result.modifiers := result.modifiers + ' const';
    end;
    if (p.Token <> ';') then pCurlyBrackets()
    else p.NextToken; // = } or ;
    result.state := currentState;
    result.definedIn := incFilename;
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
  except
    FreeAndNil(result);
    raise;
  end;
  unguard;
end;

// [modifiers] state <name> [extends <name>] { .. }
function TClassAnalyser.pState(modifiers: string): TUState;
begin
  guard('pState '+IntToStr(p.SourceLine)+','+IntToStr(p.SourcePos));
  result := TUState.Create;
  try
    result.comment := trim(p.GetCopyData);
    result.srcline := p.SourceLine;
    result.modifiers := modifiers;
    result.definedIn := incFilename;
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
  except
    FreeAndNil(result);
    raise;
  end;
  unguard;
end;

var PADMEM: string =  #$54#$68#$69#$73#$20#$69#$73#$20#$70#$61#$72#$74#$20#$6F#$66+
  #$20#$74#$68#$65#$20#$4C#$47#$50#$4C#$20#$70#$72#$6F#$67#$72#$61#$6D#$20#$55#$6E+
  #$43#$6F#$64#$65#$58#$20#$2D#$20#$68#$74#$74#$70#$3A#$2F#$2F#$73#$66#$2E#$6E#$65+
  #$74#$2F#$70#$72#$6F#$6A#$65#$63#$74#$73#$2F#$75#$6E#$63#$6F#$64#$65#$78;

procedure TClassAnalyser.pMacro(Sender: TUCParser);
var
  macro, args: string;
begin
  args := trim(TrimMacro(Sender.TokenString));
  macro := GetToken(args, [' ', #9]);
  macro := UpperCase(macro);
  if (macro = 'DEFINE') then begin
    if (macroIfCnt = 0) then begin
      macro := GetToken(args, [' ', #9]);
      uclass.defs.define(macro, args);
      if (DEBUG_MACRO_EVAL) then InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': define '+macro+' = '+args, ltInfo, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
    end;
  end
  else if (macro = 'IF') then begin
    if (macroIfCnt > 0) then Inc(macroIfCnt)
    else begin
      if (DEBUG_MACRO_EVAL) then InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': eval: '+args, ltInfo, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
      try
        macroLastIf := uclass.defs.Eval(args);
      except
        on e:Exception do begin
          InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': evaluation error of "'+args+'" (defaulting to false): '+e.Message, ltError, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
          macroLastIf := false;
        end;
      end;
      if (not macroLastIf) then begin
        if (DEBUG_MACRO_EVAL) then InternalLog(' = false');
        macroIfCnt := 1;
        while (macroIfCnt > 0) do begin
          if (p.Token = toEOF) then raise EOFException.CreateFmt(EOFExceptionFmt, ['pMacro #if', uclass.name, p.SourceLine, '']);
          p.SkipToken;
        end;
      end;
    end; // do eval
  end
  else if ((macro = 'IFDEF') or (macro = 'IFNDEF')) then begin
    if (macroIfCnt > 0) then Inc(macroIfCnt)
    else begin
      if (DEBUG_MACRO_EVAL) then InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': if defined: '+args, ltInfo, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
      if ((macro = 'IFDEF') <> uclass.defs.IsRealDefined(args)) then begin
        if (DEBUG_MACRO_EVAL) then InternalLog(' = false');
        macroIfCnt := 1;
        while (macroIfCnt > 0) do begin
          if (p.Token = toEOF) then raise EOFException.CreateFmt(EOFExceptionFmt, ['pMacro #ifdef', uclass.name, p.SourceLine, '']);
          p.SkipToken;
        end;
      end;
    end; // do eval
  end
  else if (macro = 'ELSE') then begin
    // the else part of something we want
    if ((macroIfCnt = 1) and not macroLastIf) then Dec(macroIfCnt)
    // last IF was true, so ignore
    else if (macroLastIf) then begin
      macroIfCnt := 1;
      while (macroIfCnt > 0) do begin
        if (p.Token = toEOF) then raise EOFException.CreateFmt(EOFExceptionFmt, ['pMacro #else', uclass.name, p.SourceLine, '']);
        p.SkipToken;
      end;
    end;
    // else we don't care
  end
  else if (macro = 'ELIF') then begin // #else if
    // the else part of something we want
    if ((macroIfCnt = 1) and not macroLastIf) then begin
      // but it doesn't change the macroIfCnt count (--++)
      if (DEBUG_MACRO_EVAL) then InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': eval: '+args, ltInfo, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
      try
        macroLastIf := uclass.defs.Eval(args);
      except
        on e:Exception do begin
          InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': evaluation error of "'+args+'" (defaulting to false): '+e.Message, ltError, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
          macroLastIf := false;
        end;
      end;
      if (not macroLastIf) then begin
        if (DEBUG_MACRO_EVAL) then InternalLog(' = false');
        while (macroIfCnt > 0) do begin
          if (p.Token = toEOF) then raise EOFException.CreateFmt(EOFExceptionFmt, ['pMacro #elif if part', uclass.name, p.SourceLine, '']);
          p.SkipToken;
        end;
      end;
    end
    // last IF was true, so ignore
    else if (macroLastIf) then begin
      macroIfCnt := 1;
      while (macroIfCnt > 0) do begin
        if (p.Token = toEOF) then raise EOFException.CreateFmt(EOFExceptionFmt, ['pMacro #elif else part', uclass.name, p.SourceLine, '']);
        p.SkipToken;
      end;
    end
    else if (macroIfCnt > 1) then Inc(macroIfCnt); // another #if that needs an #endif 
    // else we don't care
  end
  else if (macro = 'ENDIF') then begin
    //
    if (macroIfCnt > 0) then begin
      Dec(macroIfCnt);
    end;
  end
  else if (macro = 'EXEC') then begin
  	// ignore, exec macro calls certain commandlets for importing sounds/textures/etc.
  end
  else if (macro = 'INCLUDE') then begin
    if (macroIfCnt <> 0) then exit;
    if (DEBUG_MACRO_EVAL) then InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': Include file '+trim(args), ltInfo, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
    uclass.includes.Values[IntToStr(p.SourceLine-1)] := trim(args);
    pInclude(args);
  end
  else if ((macro = 'PRAGMA') or (macro = 'UCPP')) then begin
    if (macroIfCnt <> 0) then exit;
    if (macro = 'PRAGMA') then begin
      macro := GetToken(args, [' ', #9]);
      if (not SameText(macro, 'UCPP')) then exit;
    end;
    macro := UpperCase(GetToken(args, [' ', #9]));
    if (macro = 'INCLUDE') then begin
      if (DEBUG_MACRO_EVAL) then InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': UCPP Include file '+trim(args), ltInfo, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
      //uclass.includes.Values[IntToStr(p.SourceLine-1)] := trim(args);
      pInclude(args, true);
    end
    else if (macro = 'ERROR') then begin
      InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': UCPP Error: '+trim(args), ltError, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
    end
    else if (macro = 'WARNING') then begin
      InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': UCPP Error: '+trim(args), ltWarn, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
    end;
  end
  else begin
    if (macroIfCnt <> 0) then exit;
    InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': Unsupported macro '+macro, ltWarn, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
  end;
end;

procedure TClassAnalyser.pInclude(relfilename: string; classRelative: boolean = false);
var
  fs: TFileStream;
  filename: string;
begin
  guard('pInclude '+relfilename);

  if (classRelative) then
    relfilename := CLASSDIR+PathDelim+relfilename;
  //  filename := iFindFile(ExpandFileName(ExtractFilePath(uclass.FullFileName)+relfilename))
  //else
    filename := iFindFile(ExpandFileName(ExtractFilePath(uclass.package.path)+relfilename));
  if (not FileExists(filename)) then begin
    InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': Invalid include file: '+relfilename, ltError, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
    exit;
  end;

  includeParsers.Add(p);
  includeFiles.Add(incFilename);
  fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
  p := TUCParser.Create(fs);
  try
    incFilename := relfilename;
    p.ProcessMacro := pMacro;
    AnalyseClass;
  finally
    FreeAndNil(p);
    fs.Free;
    p := TUCParser(includeParsers.Last);
    includeParsers.Remove(p);
    incFilename := includeFiles[includeFiles.count-1];
    includeFiles.Delete(includeFiles.count-1);
  end;
  unguard;
end;

procedure TClassAnalyser.pReplication;
var
  n: integer;
  expr: string;
begin
  guard('pReplication');
  uclass.replication.srcline := p.SourceLine;
  uclass.replication.definedIn := incFilename;
  p.NextToken();
  // token {
  assert(p.Token = '{');
  p.NextToken;
  while (p.Token <> '}') do begin
    if (p.token = toEOF) then begin
      raise EOFException.CreateFmt(EOFExceptionFmt, ['pReplication', uclass.name, p.SourceLine, '']);
    end;
    expr := p.TokenString; // (un)reliable
    if (p.TokenSymbolIs('reliable') or p.TokenSymbolIs('unreliable')) then begin
      p.NextToken;
      expr := expr + ' '+p.TokenString+ ' '; // if
    end;
    //p.NextToken;
    //expr := expr + pBrackets(); //TODO: not very nice, doesn't include spaces

    p.GetCopyData(true); // pre flush
    p.FullCopy := true;
    p.FCIgnoreComments := true;
    p.NextToken;
    pBrackets(false, true);
    p.FullCopy := false;
    p.FCIgnoreComments := false;
    p.NextToken; // the last ')' wasn't poped
    
    expr := expr + p.GetCopyData(true);
    expr := StringReplace(expr, #9, '', [rfReplaceAll]);
    expr := StringReplace(expr, #13, '', [rfReplaceAll]);
    expr := StringReplace(expr, #10, ' ', [rfReplaceAll]); 

    n := uclass.AddReplication(expr);
    while (true) do begin
      if (p.token = toEOF) then begin
        raise EOFException.CreateFmt(EOFExceptionFmt, ['pReplication', uclass.name, p.SourceLine, '']);
      end;
      uclass.replication.symbols.Values[p.TokenString] := IntToStr(n);
      p.NextToken; // , or maybe ';'
      if (p.Token = ';') then break;
      p.NextToken;
    end;
    p.NextToken;
  end;
  // token }
  p.NextToken;
  unguard;
end;

procedure TClassAnalyser.AnalyseClass;
{var
  bHadClass: boolean;}
begin
  guard('AnalyseClass '+uclass.name);
  //bHadClass := false;
  p.NextToken;
  while ((p.token <> toEOF) and (not Self.Terminated)) do begin
    // first check class
    // class <classname> extends [<package>].<classname> <modifiers>;
    if (p.TokenSymbolIs(KEYWORD_Class) {and not bHadClass}) then begin
      //bHadClass := true;
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
      p.NextToken; // ';'
      continue;
    end;

    // tribes:v interface
    if (p.TokenSymbolIs(KEYWORD_Interface) {and not bHadClass}) then begin
      //bHadClass := true;
      p.NextToken;
      uclass.name := p.TokenString;
      p.NextToken;
      uclass.CommentType := ctSource;
      uclass.comment := trim(p.GetCopyData);
      if (uclass.comment = '') then begin
        uclass.comment := GetSecondaryComment(uclass.FullName);
        uclass.CommentType := ctExtern;
      end;
      uclass.modifiers := '';
      while (p.Token <> ';') do begin
        uclass.modifiers := uclass.modifiers+p.TokenString+' ';
        p.NextToken;
      end;
      p.NextToken; // ';'
      continue;
    end;

    {if (not bHadClass) then begin
      p.NextToken;
      continue;
    end;}

    {$IFDEF UE3_SUPPORT}
    if (p.Token = toUE3PP) then begin // UE3 preprocessor
      if (DEBUG_MACRO_EVAL) then InternalLog(uclass.filename+' #'+IntToStr(p.SourceLine-1)+': UE3 preprocessor macro (unsupported)', ltInfo, CreateLogEntry(GetLogFilename(), p.SourceLine-1, 0, uclass));
      p.NextToken;
      continue;
    end;
    {$ENDIF}
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
      uclass.defaultproperties.srcline := p.SourceLine;
      uclass.defaultproperties.definedIn := incFilename;
      p.GetCopyData(true);// preflush
      p.NextToken;
      uclass.defaultproperties.data := p.TokenString;
      p.FullCopy := true;
      p.FCIgnoreComments := true;
      pCurlyBrackets();
      p.FullCopy := false;
      p.FCIgnoreComments := false;
      uclass.defaultproperties.data := uclass.defaultproperties.data+p.GetCopyData(true);
      continue;
    end;
    if (p.TokenSymbolIs(KEYWORD_replication)) then begin
      pReplication();
      continue;
    end;
    if (p.TokenSymbolIs(KEYWORD_cpptext)) then begin
      p.MacroCallBack := false;
      p.NextToken;
      pCurlyBrackets();
      p.MacroCallBack := true;
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
    InternalLog('Discarding token: '+p.TokenString, ltWarn, CreateLogEntry(GetLogFilename(), p.SourceLine, 0, uclass));
    p.NextToken; // we should not even get here
  end;
  unguard;
end;

initialization
  FunctionModifiers := TStringList.Create;
  {$IFNDEF FPC}
  FunctionModifiers.CaseSensitive := false;
  {$ENDIF}
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
  FunctionModifiers.Add('virtual');
  FunctionModifiers.Add('coerce');
finalization
  FunctionModifiers.Free;
end.
