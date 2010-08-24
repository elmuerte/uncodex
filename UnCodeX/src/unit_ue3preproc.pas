{*******************************************************************************
  Name:
    unit_ue3preproc.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Preprocessor that conforms to UE3's preprocessor
*******************************************************************************}
{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003-2010  Michiel Hendriks

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

unit unit_ue3preproc;

{$I defines.inc}

interface

uses
  Classes, SysUtils, Contnrs;

type
  TStringArray = array of string;
  TCharSet = set of char;

  UE3PPException = class(Exception)
  protected
    FLineNumber: Integer;
    FLinePos: Integer;
    FFilename: String;
    BaseException: Exception;
  public
    constructor Create(filename: String; LineNo: Integer; LinePos: Integer; const Cause: Exception);
    property LineNumber: Integer read FLineNumber;
    property LinePos: Integer read FLinePos;
    property Filename: String read FFilename;
    property CausedBy: Exception read BaseException;
  end;

  TLineNumber = class(TObject)
  public
    Filename: String;
    LineNumber: Integer;
    LinePos: Integer;
    constructor Create(_filename: String; _LineNo: Integer; _LinePos: Integer);
  end;

  TLineNumberQueue = class(TObjectQueue)
  public
    function Pop: TLineNumber;
  end;

  TUE3DefinitionList = class;

  TUE3PreProcessor = class(TStream)
  protected
    finit: boolean;
    
    FStream: TStream;
    filename: String;
    basepath: String;
    FEOF: boolean;
    FData: TMemoryStream;

    currentLine: Integer;
    linePos: Integer;
    macroIfCnt: Integer;
    macroLastIf: boolean;

    FOrigin: Longint;
    FBuffer: PChar;
    FBufPtr: PChar;
    FBufEnd: PChar;
    FSourcePtr: PChar;
    FSourceEnd: PChar;
    FSourceLine: Integer;
    FSaveChar: Char;
    P: PChar; // current "pointer"

    defines: TUE3DefinitionList;

    lineInfo: TLineNumberQueue;

    CommentDepth: integer;
    procedure IncP;
    procedure Flush;
    procedure EmitLineNo;
    function MacroName: String;
    function ConsumeTokensTill(const tokens: TCharSet; doProcMacro: boolean): string;
    procedure GetArgs(out result: TStringArray);
    function SkipIf: string;
    function ProcMacro(): string;

    procedure InternalRead;
    procedure ReadBuffer;
  public
    constructor Create(Stream: TStream; _basepath: String; _filename: String; usedefines: TUE3DefinitionList);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function IncludeFile(const incfile: string; silent: boolean = false): string;
    property LineNumbers: TLineNumberQueue read lineInfo write lineInfo;
  end;

  TUE3Definition = class(TObject)
  protected
    fname: string;
    fvalue: string;
    fargnames: array of string;
    fowner: TUE3DefinitionList;
    fisfunction: boolean;
    ffilename: string;
    flineno: integer;
    flinepos: integer;
  public
    constructor Create(_name: string; _value: string; _args: array of string; _owner: TUE3DefinitionList);
    destructor Destroy; override;
    function Eval(args: array of string): string;
    property Name: string read fname;
    property Value: string read fvalue;
    property Owner: TUE3DefinitionList read fowner;
    property IsFunction: boolean read fisfunction;
    property Filename: string read ffilename write ffilename;
    property LineNo: integer read flineno write flineno;
    property LinePos: integer read flinepos write flinepos;
  end;

  TUE3DefinitionList = class(TObject)
  protected
    fparent: TUE3DefinitionList;
    defines: TStringList;
    fwriteToParent: boolean;
    counters: TStringList;
    procedure InitDefines;
  public
    constructor Create(parent: TUE3DefinitionList);
    destructor Destroy; override;
    function IsDefined(name: string): boolean;
    function GetDefine(name: string): string;
    function EvalDefine(name: string; args: array of string): string;
    procedure Define(name: string; args: array of string; value: string; filename: string; lineno: integer; linepos: integer);
    procedure UnDefine(name: string);
    function GetCounter(name: string): integer;
    function SetCounter(name: string; value: integer): integer;
    property Parent: TUE3DefinitionList read fparent write fparent;
    property WriteToParent: boolean read fwriteToParent write fwriteToParent;
  end;

const
  INTERNAL_FILENAME = '__internal_defition__';
  toLineNumber = #127; // used to identity line number markers

implementation

uses
  unit_definitions;

const
  ParseBufSize = $1000;
  CALL_MACRO_CHAR = '`';
  BEGIN_MACRO_BLOCK_CHAR = '{';
  END_MACRO_BLOCK_CHAR = '}';
  MACRO_PARAMCOUNT_CHAR = '#';

constructor TLineNumber.Create(_filename: String; _LineNo: Integer; _LinePos: Integer);
begin
  Filename := _filename;
  LineNumber := _LineNo;
  LinePos := _LinePos;
end;

function TLineNumberQueue.Pop: TLineNumber;
begin
  result := TLineNumber(inherited Pop);
end;

constructor UE3PPException.Create(filename: String; LineNo: Integer; LinePos: Integer; const Cause: Exception);
begin
  inherited CreateFmt('Preprocessor error at %s(%d,%d): %s', [filename, LineNo, LinePos, Cause.Message]);
  FLineNumber := LineNo;
  FLinePos := LinePos;
  FFileName := filename;
  BaseException := Cause;
end;

constructor TUE3PreProcessor.Create(Stream: TStream; _basepath: String; _filename: String; usedefines: TUE3DefinitionList);
begin
  FEOF := false;
  filename := _filename;
  basepath := _basepath;
  FStream := Stream;
  FData := TMemoryStream.Create;
  FData.SetSize(ParseBufSize);

  GetMem(FBuffer, ParseBufSize);
  FBuffer[0] := #0;
  FBufPtr := FBuffer;
  FBufEnd := FBuffer + ParseBufSize;
  FSourcePtr := FBuffer;
  FSourceEnd := FBuffer;

  currentLine := 1;
  linePos := 0;
  CommentDepth := 0;

  defines := usedefines;
  
  finit := true;
end;

destructor TUE3PreProcessor.Destroy;
begin
  FStream := nil;
  FreeMem(FBuffer, ParseBufSize);
  inherited;
end;

function TUE3PreProcessor.Read(var Buffer; Count: Longint): Longint;
begin
  if (finit) then begin
    finit := false;
    InternalRead;
  end;
  result := 0;
  if (FEOF) then exit;
  try
    if (FData.Position = FData.Size) then InternalRead;
  except
    on E: Exception do raise UE3PPException.Create(basepath + PATHDELIM + filename, currentLine, linePos, e);
  end;
  if (FEOF) then exit;
  result := FData.Read(buffer, Count);
end;

function TUE3PreProcessor.Write(const Buffer; Count: Longint): Longint;
begin
  // not actually supported
  result := FStream.Write(Buffer, Count);
end;

procedure TUE3PreProcessor.IncP;
begin
  // increase the current pointer, but also check for newlines
  Inc(P);
  if (P^ = #10) then begin
    Inc(currentLine);
    linePos := 0;
  end
  else if (not (P^ in [#0, #13])) then begin
    Inc(linePos);
  end;
end;

function TUE3PreProcessor.MacroName: String;
var
  Start: PChar;
  wrapped: boolean;
begin
  wrapped := false;
  if (P^ = '{') then begin
    IncP;
    wrapped := true;
  end;
  Start := P;
  while (P^ in ['0'..'9', 'a'..'z', 'A'..'Z', '_', '#']) do begin
    IncP;
  end;
  SetString(result, Start, P-Start);
  // skip whitespace
  while (P^ in [' ', #9]) do begin
    IncP;
  end;
  if (wrapped) then begin
    if (not (P^ = '}')) then begin
      // TODO: include line?
      raise Exception.Create('Unterminated macro, missing }');
    end;
    IncP;
  end;
end;

function TUE3PreProcessor.ConsumeTokensTill(const tokens: TCharSet; doProcMacro: boolean): string;
var
  StartP: PChar;
  res: String;
begin
  StartP := P;
  result := '';
  while (not (P^ in tokens)) do begin
    if ((P = FSourceEnd) or (P^ = #0)) then begin
      FSourcePtr := P;
      ReadBuffer;
      P := FSourcePtr;
    end;
    if (P^ = '\') then begin
      IncP;
      if (P^ = CALL_MACRO_CHAR) then IncP;
    end;
    if (doProcMacro and (P^ = CALL_MACRO_CHAR)) then begin
      SetString(res, StartP, P-StartP);
      result := result+res;
      IncP;
      result := result+ProcMacro();
      StartP := P;
    end
    else begin
      IncP;
    end;
  end;
  if (P <> StartP) then begin
    SetString(res, StartP, P-StartP);
    result := result+res;
  end;
end;

procedure TUE3PreProcessor.GetArgs(out result: TStringArray);
var
  start: PChar;
  arg: string;
  idx: integer;
begin
  if (P^ <> '(') then begin
    // no args
    exit;
  end;
  IncP;
  idx := 0;
  while (not (P^ in [')', #0])) do begin
    arg := ConsumeTokensTill([',', ')'], true);
    SetLength(result, idx+1);
    result[idx] := arg;
    Inc(idx);
    if (P^ = ',') then begin
      IncP;
    end;
  end;
  if (P^ <> ')') then begin
    raise Exception.Create('Missing )');
  end;
  IncP;
end;

function TUE3PreProcessor.SkipIf: string;
var
  lineStart: Integer;
begin
  lineStart := currentLine;
  while (macroIfCnt > 0) do begin
    if ((P = FSourceEnd) or (P^ = #0)) then begin
      FSourcePtr := P;
      ReadBuffer;
      P := FSourcePtr;
    end;
    if (P^ = '\') then begin
      IncP;
      if (P^ = CALL_MACRO_CHAR) then IncP;
    end;
    if (P^ = CALL_MACRO_CHAR) then begin
      IncP;
      ProcMacro();
    end
    else begin
      IncP;
    end;
  end;
end;

function TUE3PreProcessor.ProcMacro(): string;
var
  macro, macroOrig, body, tmp: string;
  args: TStringArray;
  startP: PChar;
  tmpLineNo, tmpLinePos: integer;

  function DoSkipMacro(): boolean;
  begin
    result := false;
    if (macroIfCnt > 0) then begin
      result := true;
      if ((P^ = '(') and (macro <> 'define')) then begin
        GetArgs(args);
      end;
    end;
  end;

begin
  result := '';
  macroOrig := MacroName;
  macro := LowerCase(macroOrig);
  //Log('Found macro: '+macro, ltInfo, CreateLogEntry(basepath+pathdelim+filename, currentLine, linePos));     // TODO remove
  if (macro = 'if') then begin
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `if macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`if expects 1 argument');
    end;
    if (macroIfCnt > 0) then Inc(macroIfCnt)
    else begin
      macroLastIf := (Length(Trim(args[0])) > 0);
      if (not macroLastIf) then begin
        //Log('`if argument was empty, ignoring body', ltInfo, CreateLogEntry(basepath+pathdelim+filename, currentLine, linePos));
        macroIfCnt := 1;
        SkipIf;
      end;
    end;
  end
  {$IFDEF UE3PP_ifcondition}
  else if (macro = 'ifcondition') then begin
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `ifcondition macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`if expects 1 argument');
    end;
    if (macroIfCnt > 0) then Inc(macroIfCnt)
    else begin
      macroLastIf := (Length(Trim(args[0])) > 0);
      // FIXME: evaluate
      if (not macroLastIf) then begin
        Log('`if argument was empty, ignoring body', ltInfo);
        macroIfCnt := 1;
        SkipIf;
      end;
    end;
  end
  {$ENDIF}
  else if (macro = 'else') then begin
    if ((macroIfCnt = 1) and not macroLastIf) then Dec(macroIfCnt)
    else if (macroLastIf) then begin
          // last IF was true, so ignore
      macroIfCnt := 1;
      SkipIf;
    end;
  end
  else if (macro = 'endif') then begin
    if (macroIfCnt > 0) then begin
      Dec(macroIfCnt);
    end;
  end
  else if (macro = 'include') then begin
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `include macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`include expects 1 argument');
    end;
    if (macroIfCnt > 0) then exit; // should be ignored
    result := IncludeFile(args[0]);
  end
  else if (macro = 'define') then begin
    while (P^ in [#9, #32]) do begin
      IncP;
    end;
    macro := MacroName;
    if (Length(macro) = 0) then begin
      raise Exception.Create('`define requires name');
    end;
    if (P^ = '(') then begin
      GetArgs(args);
    end;
    startP := P;
    body := '';
    tmpLineNo := currentLine;
    tmpLinePos := linePos;
    while (not (P^ in [#0, #10])) do begin
      IncP;
      if (P^ = #10) then begin
        // enscaped newline
        if ((P-1)^ = '\') then begin
          Inc(P);
        end;
        if (P^ = #0) then begin
          // TODO read more buffer?
        end;
      end;
    end;
    if (P <> StartP) then begin
      SetString(tmp, StartP, P-StartP);
      body := body+tmp;
    end;
    if (DoSkipMacro()) then exit;
    //Log('`define '+macro, ltWarn, CreateLogEntry(basepath + PathDelim + filename, currentLine-1, linePos));
    defines.Define(macro, args, TrimRight(body), basepath+pathdelim+filename, tmpLineNo, tmpLinePos);
  end
  else if (macro = 'isdefined') then begin
    if (DoSkipMacro()) then exit;
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `isdefined macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`isdefined expects 1 argument');
    end;
    if (defines.IsDefined(Trim(args[0]))) then begin
      result := '1';
    end
    else begin
      result := '';
    end;
  end
  else if (macro = 'notdefined') then begin
    if (DoSkipMacro()) then exit;
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `notdefined macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`notdefined expects 1 argument');
    end;
    if (defines.IsDefined(Trim(args[0]))) then begin
      result := '';
    end
    else begin
      result := '1';
    end;
  end
  else if (macro = 'undefine') then begin
    if (DoSkipMacro()) then exit;
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `undefine macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`undefine expects 1 argument');
    end;
    defines.UnDefine(Trim(args[0]));
  end
  else if ((macro = 'counter') or (macro = 'getcounter')) then begin
    if (DoSkipMacro()) then exit;
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `'+macro+' macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`'+macro+' expects 1 argument');
    end;
    // TODO
    // result := counter value
  end
  else if (macro = 'setcounter') then begin
    if (DoSkipMacro()) then exit;
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `setcounter macro');
    end;
    GetArgs(args);
    if (Length(args) <> 2) then begin
      raise Exception.Create('`setcounter expects 2 argument');
    end;
    // TODO
  end
  else if (macro = 'engineversion') then begin
    if (DoSkipMacro()) then exit;
  end
  else if (macroOrig = '__LINE__') then begin
    if (DoSkipMacro()) then exit;
    result := IntToStr(currentLine);
  end
  else if (macroOrig = '__FILE__') then begin
    if (DoSkipMacro()) then exit;
    result := basepath + PathDelim + filename;
  end
  else begin
    if (DoSkipMacro()) then exit;
    if (P^ = '(') then begin
      GetArgs(args);      
    end;
    if (defines.IsDefined(macro)) then begin
      result := defines.EvalDefine(macro, args);
    end
    else begin
      Log('No such macro defined: `'+macro+' (might be defined in globals.uci; check package priority)', ltError, CreateLogEntry(basepath + PathDelim + filename, currentLine, linePos));
      result := ''; // simply ignore it
    end;
  end;
end;

// Flush the current data to the data stream
procedure TUE3PreProcessor.Flush;
var
  s: string;
begin
  // TODO optimize so that it doesn't copy another time
  // directly writing from the button goes wrong for some reason
  SetString(s, FSourcePtr, P-FSourcePtr);
  FData.WriteBuffer(PChar(s)^, Length(s));
  FSourcePtr := P;
end;

procedure TUE3PreProcessor.EmitLineNo;
var
  macroRes: string;
begin
  // emit correct line number macro
  if ((lineInfo <> nil) and (filename <> '')) then begin
    macroRes := toLineNumber;
    FData.WriteBuffer(PChar(macroRes)^, Length(macroRes));
    lineInfo.Push(TLineNumber.Create(filename, currentLine, linePos));
  end;
end;

procedure TUE3PreProcessor.InternalRead;
var
  macroRes: string;
begin
  //FData.Seek(0, 0); // reset position
  FData.Clear;
  if (FSourcePtr = FSourceEnd) then ReadBuffer;
  FEOF := FSourcePtr^ = #0;
  if (FEOF) then exit;

  P := FSourcePtr;
  while (P <> FSourceEnd) do begin
    case P^ of
      '\':
        begin
          IncP;
          if (P^ = CALL_MACRO_CHAR) then IncP;
        end;
      CALL_MACRO_CHAR:
        begin
          if (CommentDepth > 0) then begin
            // ignore macros in comments
            IncP;
            continue;
          end;
          Flush;
          //EmitLineNo;
          IncP;
          macroRes := ProcMacro();
          FData.WriteBuffer(PChar(macroRes)^, Length(macroRes));
          FSourcePtr := P;
          EmitLineNo;
        end;
      '/':
        begin
          IncP;
          if (P^ = '/') then begin
            // single line comment
            while (not (P^ in [#10, #0])) do begin
              if (P = FSourceEnd) then break;
              IncP;
            end;
          end
          else if (P^ = '*') then begin
            // start of block comment
            IncP;
            Inc(CommentDepth);
          end;
        end;
      '*':
        begin
          IncP;
          if (P^ = '/') then begin
            // end of block comment
            IncP;
            Dec(CommentDepth);
          end;
        end;
    else
      IncP;
    end;
  end;
  Flush;
  FData.Seek(0, 0); // reset to read from the beginning
end;

procedure TUE3PreProcessor.ReadBuffer;
var
  Count: Integer;
begin
  Inc(FOrigin, FSourcePtr - FBuffer);
  FSourceEnd[0] := FSaveChar;
  Count := FBufPtr - FSourcePtr;
  if Count <> 0 then Move(FSourcePtr[0], FBuffer[0], Count);
  FBufPtr := FBuffer + Count;
  Inc(FBufPtr, FStream.Read(FBufPtr[0], FBufEnd - FBufPtr));
  FSourcePtr := FBuffer;
  FSourceEnd := FBufPtr;
  if FSourceEnd = FBufEnd then
  begin
    FSourceEnd := LineStart(FBuffer, FSourceEnd - 1);
  end;
  FSaveChar := FSourceEnd[0];
  FSourceEnd[0] := #0;
end;

// Filename = relative form basepath+'..'
function TUE3PreProcessor.IncludeFile(const incfile: string; silent: boolean = false): string;
var
  stream: TStringStream;
  instream: TFileStream;
  realFn: string;
  relativeFn: string;
  pp: TUE3PreProcessor;
  buffer: PChar;
  i: integer;
begin
  result := '';
  // try Development\Package\<incfile>
  relativeFn := incfile;
  realFn := basepath+PathDelim+'..'+PathDelim+incfile;
  if (not FileExists(realFn)) then begin
    // try Development\Package\Classes\<incfile>
    realFn := basepath+PathDelim+incfile;
    relativeFn := CLASSDIR+PathDelim+incfile;
  end;
  if (not FileExists(realFn)) then begin
    // try Development\<incfile>
    relativeFn := '..'+PathDelim+incfile;
    realFn := basepath+PathDelim+'..'+PathDelim+'..'+PathDelim+incfile;;
  end;
  if (not FileExists(realFn)) then begin
    if (not silent) then begin
      Log('Include file not found: '+incfile, ltError, CreateLogEntry(basepath+pathdelim+filename, currentLine, linePos));
    end;
    result := '/* include file not found: '+incfile+' */';
    exit;
  end;

  if (not silent) then begin
    Log('Processing include file: '+relativeFn, ltInfo, CreateLogEntry(basepath+pathdelim+filename, currentLine, linePos));
  end;

  stream := TStringStream.Create('');
  try
    GetMem(buffer, ParseBufSize);
    instream := TFileStream.Create(realFn, fmOpenRead);
    pp := TUE3PreProcessor.Create(instream, ExtractFileDir(basepath), relativeFn, defines);
    pp.LineNumbers := lineInfo;
    try
      if (lineInfo <> nil) then begin
        stream.WriteString(toLineNumber);
        lineInfo.Push(TLineNumber.Create(relativeFn, 0, 0));
      end;
      i := pp.Read(buffer^, ParseBufSize);
      while (i > 0) do begin
        SetString(relativeFn, buffer, i);
        stream.WriteString(relativeFn);
        i := pp.Read(buffer^, ParseBufSize);
      end;
      if (lineInfo <> nil) then begin
        stream.WriteString(toLineNumber);
        lineInfo.Push(TLineNumber.Create(filename, currentLine, linePos));
      end;
      result := stream.DataString;
    finally
      FreeMem(buffer, ParseBufSize);
      instream.Free;
      pp.Free;
    end;
  finally
    stream.Free;
  end;
end;

{ TUE3Definition }
constructor TUE3Definition.Create(_name: string; _value: string; _args: array of string; _owner: TUE3DefinitionList);
var
  i: integer;
begin
  inherited Create();
  fname := _name;
  fvalue := _value;
  SetLength(fargnames, Length(_args));
  for i := Low(_args) to High(_args) do fargnames[i] := trim(_args[i]);
  fisfunction := Length(fargnames) > 0;
  fowner := _owner;
end;

destructor TUE3Definition.Destroy;
begin
  inherited;
end;

function TUE3Definition.Eval(args: array of string): string;
var
  stream, instream: TStringStream;
  defs: TUE3DefinitionList;
  i: integer;
  val: string;
  pp: TUE3PreProcessor;
  buffer: PChar;
begin
  stream := TStringStream.Create('');
  try
    if (IsFunction) then begin
      defs := TUE3DefinitionList.Create(Owner);
      for i := Low(fargnames) to High(fargnames) do begin
        if (i >= Length(args)) then val := '' else val := args[i];
        defs.Define(fargnames[i], [], val, '', -1, -1);
      end;
      defs.WriteToParent := true;
      instream := TStringStream.Create(value);
      pp := TUE3PreProcessor.Create(instream, '', filename, defs);
      GetMem(buffer, ParseBufSize);
      try
        i := pp.Read(buffer^, ParseBufSize);
        while (i > 0) do begin
          SetString(val, buffer, i);
          stream.WriteString(val);
          i := pp.Read(buffer, ParseBufSize);
        end;
      finally
        FreeMem(Buffer, ParseBufSize);
        instream.Free;
        pp.Free;
        defs.free;
      end;
    end
    else begin
      stream.WriteString(value);
    end;
    result := stream.DataString;
  finally
    stream.Free;
  end;
end;


{ TUE3DefinitionList }
constructor TUE3DefinitionList.Create(parent: TUE3DefinitionList);
begin
  inherited Create();
  fparent := parent;
  defines := TStringList.Create;
  counters := TStringList.Create;
  InitDefines;
end;

destructor TUE3DefinitionList.Destroy;
begin
  FreeAndNil(defines);
  FreeAndNil(counters);
  inherited;
end;

procedure TUE3DefinitionList.InitDefines;
var
  isfinal, isdebug: boolean;
begin
  isfinal := GetDefine('FINAL_RELEASE') <> '';
  isdebug := GetDefine('__UCX_DEBUG__') <> ''; // debug mode is actually a -debug commandline switch

  if (not IsDefined('log')) then begin
    if (isfinal) then begin
      Define('log', [], '', INTERNAL_FILENAME, 0, 0);
    end
    else begin
      Define('log', ['msg', 'cond', 'tag'], '`if(`cond)if (`cond) `{endif}LogInternal(`msg`if(`tag),`tag`endif)', INTERNAL_FILENAME, 0, 0);
    end;
  end;

  if (not IsDefined('logd')) then begin
    if (not isdebug or isfinal) then begin
      Define('logd', [], '', INTERNAL_FILENAME, 0, 0);
    end
    else begin
      Define('logd', ['msg', 'cond', 'tag'], '`if(`cond)if (`cond) `{endif}LogInternal(`msg`if(`tag),`tag`endif)', INTERNAL_FILENAME, 0, 0);
    end;
  end;

  if (not IsDefined('warn')) then begin
    if (isfinal) then begin
      Define('warn', [], '', INTERNAL_FILENAME, 0, 0);
    end
    else begin
      Define('warn', ['msg', 'cond'], '`if(`cond)if (`cond) `{endif}WarnInternal(`msg)', INTERNAL_FILENAME, 0, 0);
    end;
  end;

  if (not IsDefined('assert')) then begin
    if (isfinal) then begin
      Define('assert', [], '', INTERNAL_FILENAME, 0, 0);
    end
    else begin
      Define('assert', ['cond'], 'Assert(`cond)', INTERNAL_FILENAME, 0, 0);
    end;
  end;
end;

function TUE3DefinitionList.IsDefined(name: string): boolean;
begin
  result := defines.IndexOf(LowerCase(name)) <> -1;
  if ((not result) and (fparent <> nil)) then begin
    result := fparent.IsDefined(name);
  end;
end;

function TUE3DefinitionList.GetDefine(name: string): string;
var
  idx: integer;
  entry: TUE3Definition;
begin
  idx := defines.IndexOf(LowerCase(name));
  result := '';
  if (idx <> -1) then begin
    entry := TUE3Definition(defines.Objects[idx]);
    result := entry.value;
  end
  else if (fparent <> nil) then begin
    result := fparent.GetDefine(name);
  end;
end;

procedure TUE3DefinitionList.Define(name: string; args: array of string; value: string; filename: string; lineno: integer; linepos: integer);
var
  entry: TUE3Definition;
begin
  if (WriteToParent and (fparent <> nil)) then begin
    fparent.Define(name, args, value, filename, lineno, linepos);
    exit;
  end;
  entry := TUE3Definition.Create(name, value, args, self);
  entry.Filename := filename;
  entry.LineNo := lineno;
  entry.LinePos := linepos;
  defines.AddObject(LowerCase(name), entry);
end;

procedure TUE3DefinitionList.UnDefine(name: string);
var
  idx: integer;
begin
  if (WriteToParent and (fparent <> nil)) then begin
    fparent.UnDefine(name);
    exit;
  end;
  idx := defines.IndexOf(LowerCase(name));
  if (idx <> -1) then begin
    defines.Delete(idx);
  end;
end;

function TUE3DefinitionList.EvalDefine(name: string; args: array of string): string;
var
  idx: integer;
  entry: TUE3Definition;
begin
  idx := defines.IndexOf(LowerCase(name));
  result := '';
  if (idx <> -1) then begin
    entry := TUE3Definition(defines.Objects[idx]);
    result := entry.Eval(args);
  end
  else if (fparent <> nil) then begin
    result := fparent.EvalDefine(name, args);
  end;
end;

function TUE3DefinitionList.GetCounter(name: string): integer;
begin
  // TODO
end;

function TUE3DefinitionList.SetCounter(name: string; value: integer): integer;
begin
  // TODO
end;

end.
