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
  Classes, SysUtils;

type
  TStringArray = array of string;
  TCharSet = set of char;

  UE3PPException = class(Exception)
  protected
    FLineNumber: Integer;
    FLinePos: Integer;
    BaseException: Exception;
  public
    constructor Create(LineNo: Integer; LinePos: Integer; const Cause: Exception);
    property LineNumber: Integer read FLineNumber;
    property LinePos: Integer read FLinePos;
    property CausedBy: Exception read BaseException;
  end;

  TUE3PreProcessor = class(TStream)
  protected
    FStream: TStream;
    FEOF: boolean;
    FData: TMemoryStream;

    currentLine: Integer;
    linePos: Integer;
    FOrigin: Longint;
    FBuffer: PChar;
    FBufPtr: PChar;
    FBufEnd: PChar;
    FSourcePtr: PChar;
    FSourceEnd: PChar;
    FSourceLine: Integer;
    FSaveChar: Char;
    P: PChar; // current "pointer"

    CommentDepth: integer;
    procedure IncP;
    procedure Flush;
    function MacroName: String;
    function ConsumeTokensTill(const tokens: TCharSet): string;
    procedure GetArgs(out result: TStringArray);
    function ProcMacro(): string;

    procedure InternalRead;
    procedure ReadBuffer;
  public
    constructor Create(Stream: TStream);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

implementation

uses
  unit_definitions;

const
  ParseBufSize = $1000;
  CALL_MACRO_CHAR = '`';
  BEGIN_MACRO_BLOCK_CHAR = '{';
  END_MACRO_BLOCK_CHAR = '}';
  MACRO_PARAMCOUNT_CHAR = '#';

constructor UE3PPException.Create(LineNo: Integer; LinePos: Integer; const Cause: Exception);
begin
  inherited CreateFmt('Preprocessor error on #%d,%d: %s', [LineNo, LinePos, Cause.Message]);
  FLineNumber := LineNo;
  FLinePos := LinePos;
  BaseException := Cause;
end;

constructor TUE3PreProcessor.Create(Stream: TStream);
begin
  FEOF := false;
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
  
  InternalRead;
end;

destructor TUE3PreProcessor.Destroy;
begin
  FStream := nil;
  inherited;
end;

function TUE3PreProcessor.Read(var Buffer; Count: Longint): Longint;
begin
  result := 0;
  if (FEOF) then exit;
  try
    if (FData.Position = FData.Size) then InternalRead;
  except
    on E: Exception do raise UE3PPException.Create(currentLine, linePos, e);
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
  while (P^ in ['0'..'9', 'a'..'z', 'A'..'Z', '_', '#', #0]) do begin
    IncP;
  end;
  SetString(result, Start, P-Start);
  if (wrapped) then begin
    if (not (P^ = '}')) then begin
      // TODO: include line?
      raise Exception.Create('Unterminated macro, missing }');
    end;
    IncP;
  end;
end;

function TUE3PreProcessor.ConsumeTokensTill(const tokens: TCharSet): string;
var
  StartP: PChar;
  res: String;
begin
  StartP := P;
  while (not (P^ in tokens)) do begin
    if ((P = FSourceEnd) or (P^ = #0)) then begin
      // end of buffer?
    end;
    if (P^ = CALL_MACRO_CHAR) then begin
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
    arg := ConsumeTokensTill([',', ')']);
    SetLength(result, idx+1);
    result[idx] := arg;
    Inc(idx);
  end;
  if (P^ <> ')') then begin
    raise Exception.Create('Missing )');
  end;
  IncP;
end;

function TUE3PreProcessor.ProcMacro(): string;
var
  macro: string;
  args: TStringArray;
begin
  macro := MacroName;
  Log('Found macro: '+macro, ltInfo);     // TODO remove
  if (macro = 'if') then begin
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `if macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`if expects 1 argument');
    end;
    // TODO
  end
  else if (macro = 'else') then begin

  end
  else if (macro = 'endif') then begin

  end
  else if (macro = 'include') then begin

  end
  else if (macro = 'define') then begin

  end
  else if (macro = 'isdefined') then begin
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `isdefined macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`isdefined expects 1 argument');
    end;
    // TODO
    // result := '1' or ''
  end
  else if (macro = 'notdefined') then begin
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `notdefined macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`notdefined expects 1 argument');
    end;
    // TODO
    // result := '1' or ''
  end
  else if (macro = 'undefine') then begin
    if (not (P^ = '(')) then begin
      raise Exception.Create('Missing ( for `undefine macro');
    end;
    GetArgs(args);
    if (Length(args) <> 1) then begin
      raise Exception.Create('`undefine expects 1 argument');
    end;
    // TODO
  end
  else begin
    // look up a definition
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
      CALL_MACRO_CHAR:
        begin
          if (CommentDepth > 0) then begin
            // ignore macros in comments
            IncP;
            continue;
          end;
          Flush;
          IncP;
          macroRes := ProcMacro();
          FData.WriteBuffer(PChar(macroRes)^, Length(macroRes));
          FSourcePtr := P;
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

end.
