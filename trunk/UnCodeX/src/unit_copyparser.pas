{-----------------------------------------------------------------------------
 Unit Name: unit_copyparser
 Author:    elmuerte
 Purpose:   parser class based on CopyParser.pas used for processing the HTML
            templates
            Based on the Borland's TCopyParser
 $Id: unit_copyparser.pas,v 1.6 2003-06-22 08:58:45 elmuerte Exp $
-----------------------------------------------------------------------------}

{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{ Internet Application Runtime                                                }
{                                                                             }
{ Copyright (C) 1997, 2001 Borland Software Corporation                       }
{                                                                             }
{ Licensees holding a valid Borland No-Nonsense License for this Software may }
{ use this file in accordance with such license, which appears in the file    }
{ license.txt that came with this Software.                                   }
{                                                                             }
{ *************************************************************************** }


unit unit_copyparser;

interface

uses
  Classes;

const
  toEOL = Char(5);

type
{ TCopyParser }

  TCopyParser = class(TObject)
  private
    FStream: TStream;
    FOutStream: TStream;
    FOrigin: Longint;
    FBuffer: PChar;
    FBufPtr: PChar;
    FBufEnd: PChar;
    FSourcePtr: PChar;
    FSourceEnd: PChar;
    FTokenPtr: PChar;
    FStringPtr: PChar;
    FSourceLine: Integer;
    FSaveChar: Char;
    FToken: Char;
    procedure ReadBuffer;
    procedure SkipBlanks(DoCopy: Boolean);
    function SkipToNextToken(CopyBlanks, DoCopy: Boolean): Char;
    function CopySkipToToken(AToken: Char; DoCopy: Boolean): string;
    procedure UpdateOutStream(StartPos: PChar);
  public
    constructor Create(Stream, OutStream: TStream);
    destructor Destroy; override;
    procedure CopyTokenToOutput;
    procedure Error(const Ident: string);
    procedure ErrorFmt(const Ident: string; const Args: array of const);
    procedure ErrorStr(const Message: string);
    function NextToken: Char;
    function SkipToken(CopyBlanks: Boolean): Char;
    function SkipToToken(AToken: Char): string;
    function SourcePos: Longint;
    function TokenString: string;
    property SourceLine: Integer read FSourceLine;
    property Token: Char read FToken;
    property OutputStream: TStream read FOutStream write FOutStream;
  end;

implementation

uses
  SysUtils, RTLConsts;

{ TCopyParser }

const
  ParseBufSize = 4096;

constructor TCopyParser.Create(Stream, OutStream: TStream);
begin
  FStream := Stream;
  FOutStream := OutStream;
  GetMem(FBuffer, ParseBufSize);
  FBuffer[0] := #0;
  FBufPtr := FBuffer;
  FBufEnd := FBuffer + ParseBufSize;
  FSourcePtr := FBuffer;
  FSourceEnd := FBuffer;
  FTokenPtr := FBuffer;
  FSourceLine := 1;
  SkipToken(True);
end;

destructor TCopyParser.Destroy;
begin
  if FBuffer <> nil then
  begin
    FStream.Seek(Longint(FTokenPtr) - Longint(FBufPtr), 1);
    FreeMem(FBuffer, ParseBufSize);
  end;
end;

function TCopyParser.CopySkipToToken(AToken: Char; DoCopy: Boolean): string;
var
  S: PChar;
  Temp: string;

  procedure InternalSkipBlanks;
  begin
    while True do
    begin
      case FSourcePtr^ of
        #0:
          begin
            SetString(Temp, S, FSourcePtr - S);
            Result := Result + Temp;
            if DoCopy then UpdateOutStream(S);
            ReadBuffer;
            if FSourcePtr^ = #0 then Exit;
            S := FSourcePtr;
            Continue;
          end;
        #10:
          Inc(FSourceLine);
        #33..#255:
          Break;
      end;
      Inc(FSourcePtr);
    end;
    if DoCopy then UpdateOutStream(S);
  end;

var
  InSingleQuote, InDoubleQuote: Boolean;
  Found: Boolean;
begin
  InSingleQuote := False;
  InDoubleQuote := False;
  Found := False;
  Result := '';
  while (not Found) and (Token <> toEOF) do
  begin
    S := FSourcePtr;
    InternalSkipBlanks;
    if S <> FSourcePtr then
    begin
      SetString(Temp, S, FSourcePtr - S);
      Result := Result + Temp;
    end;
    SkipToNextToken(DoCopy, DoCopy);
    if Token = '"' then
      InDoubleQuote := not InDoubleQuote and not InSingleQuote
    else if Token = '''' then
      InSingleQuote := not InSingleQuote and not InDoubleQuote;
    Found := (Token = AToken) and
         (((Token = '"') and (not InSingleQuote)) or
          ((Token = '''') and (not InDoubleQuote)) or
           not (InDoubleQuote or InSingleQuote));
    if not Found then
    begin
      SetString(Temp, FTokenPtr, FSourcePtr - FTokenPtr);
      Result := Result + Temp;
    end;
  end;
end;

procedure TCopyParser.CopyTokenToOutput;
begin
  UpdateOutStream(FTokenPtr);
end;

procedure TCopyParser.Error(const Ident: string);
begin
  ErrorStr(Ident);
end;

procedure TCopyParser.ErrorFmt(const Ident: string; const Args: array of const);
begin
  ErrorStr(Format(Ident, Args));
end;

procedure TCopyParser.ErrorStr(const Message: string);
begin
  raise EParserError.CreateResFmt(@SParseError, [Message, FSourceLine]);
end;

function TCopyParser.NextToken: Char;
begin
  Result := SkipToNextToken(True, True);
end;

function TCopyParser.SkipToToken(AToken: Char): string;
begin
  Result := CopySkipToToken(AToken, False);
end;

function TCopyParser.SkipToNextToken(CopyBlanks, DoCopy: Boolean): Char;
var
  P, StartPos: PChar;
begin
  SkipBlanks(CopyBlanks);
  P := FSourcePtr;
  FTokenPtr := P;
  case P^ of
    'A'..'Z', 'a'..'z', '_':
      begin
        Inc(P);
        while P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_'] do Inc(P);
        Result := toSymbol;
      end;
    #10:
      begin
        Inc(P);
        Inc(FSourceLine);
        Result := toEOL;
      end;
  else
    Result := P^;
    if Result <> toEOF then Inc(P);
  end;
  StartPos := FSourcePtr;
  FSourcePtr := P;
  if DoCopy then UpdateOutStream(StartPos);
  FToken := Result;
end;

function TCopyParser.SkipToken(CopyBlanks: Boolean): Char;
begin
  Result := SkipToNextToken(CopyBlanks, False);
end;

procedure TCopyParser.ReadBuffer;
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
    if FSourceEnd = FBuffer then Error(SLineTooLong);
  end;
  FSaveChar := FSourceEnd[0];
  FSourceEnd[0] := #0;
end;

procedure TCopyParser.SkipBlanks(DoCopy: Boolean);
var
  Start: PChar;
begin
  Start := FSourcePtr;
  while True do
  begin
    case FSourcePtr^ of
      #0:
        begin
          if DoCopy then UpdateOutStream(Start);
          ReadBuffer;
          if FSourcePtr^ = #0 then Exit;
          Start := FSourcePtr;
          Continue;
        end;
      #10:
        Inc(FSourceLine);
      #33..#255:
        Break;
    end;
    Inc(FSourcePtr);
  end;
  if DoCopy then UpdateOutStream(Start);
end;

function TCopyParser.SourcePos: Longint;
begin
  Result := FOrigin + (FTokenPtr - FBuffer);
end;

function TCopyParser.TokenString: string;
var
  L: Integer;
begin
  if FToken = toString then
    L := FStringPtr - FTokenPtr else
    L := FSourcePtr - FTokenPtr;
  SetString(Result, FTokenPtr, L);
end;

procedure TCopyParser.UpdateOutStream(StartPos: PChar);
begin
  if FOutStream <> nil then
    FOutStream.WriteBuffer(StartPos^, FSourcePtr - StartPos);
end;

end.
