{-----------------------------------------------------------------------------
 Unit Name: unit_parser
 Author:    elmuerte
 Purpose:   Tokeniser for Unreal Script
            Based on the TParser class by Borland Software Corporation
 $Id: unit_sourceparser.pas,v 1.9 2003-06-22 08:58:45 elmuerte Exp $           
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

unit unit_sourceparser;

interface

uses
  Classes, SysUtils, RTLConsts;

type
  TSourceParser = class(TObject)
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
    FSourceLine: Integer;
    FSaveChar: Char;
    FToken: Char;
    IsInMComment: boolean;
    procedure ReadBuffer;
    procedure SkipBlanks(DoCopy: Boolean);
    function SkipToNextToken(CopyBlanks, DoCopy: Boolean): Char;
    procedure UpdateOutStream(StartPos: PChar);
  public
    TabIsWS: boolean;
    constructor Create(Stream, OutStream: TStream; TabIsWhiteSpace: boolean = true);
    destructor Destroy; override;
    procedure CopyTokenToOutput;
    procedure Error(const Ident: string);
    procedure ErrorFmt(const Ident: string; const Args: array of const);
    procedure ErrorStr(const Message: string);
    function NextToken: Char;
    function SkipToken(CopyBlanks: Boolean): Char;
    function TokenString: string;
    property SourceLine: Integer read FSourceLine;
    property Token: Char read FToken;
    property OutputStream: TStream read FOutStream write FOutStream;
  end;

const
  toComment = Char(6);
  toName = Char(7);
  toMacro = Char(8);
  toEOL = Char(10);
  toMCommentBegin = Char(11);
  toMCommentEnd = Char(12);

implementation

const
  ParseBufSize = 4096;

constructor TSourceParser.Create(Stream, OutStream: TStream; TabIsWhiteSpace: boolean = true);
begin
  TabIsWS := TabIsWhiteSpace;
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

destructor TSourceParser.Destroy;
begin
  if FBuffer <> nil then
  begin
    FStream.Seek(Longint(FTokenPtr) - Longint(FBufPtr), 1);
    FreeMem(FBuffer, ParseBufSize);
  end;
end;

procedure TSourceParser.CopyTokenToOutput;
begin
  UpdateOutStream(FTokenPtr);
end;

procedure TSourceParser.Error(const Ident: string);
begin
  ErrorStr(Ident);
end;

procedure TSourceParser.ErrorFmt(const Ident: string; const Args: array of const);
begin
  ErrorStr(Format(Ident, Args));
end;

procedure TSourceParser.ErrorStr(const Message: string);
begin
  raise EParserError.CreateResFmt(@SParseError, [Message, FSourceLine]);
end;

function TSourceParser.NextToken: Char;
begin
  result := SkipToNextToken(True, True);
end;

function TSourceParser.SkipToNextToken(CopyBlanks, DoCopy: Boolean): Char;
var
  P, StartPos: PChar;
begin
  SkipBlanks(CopyBlanks);
  P := FSourcePtr;
  FTokenPtr := P;
  if (IsInMComment) then begin
    Result := toMCommentEnd;
    IsInMComment := false;
    repeat begin
      Inc(P);
      if (P^ = #0) then begin
        Result := toMCommentBegin;
        IsInMComment := true;
        break;
      end;
      if (P^ = #10) then Inc(FSourceLine); // next line
    end
    until ((P^ ='*') and ((P+1)^ ='/' ));
    if (Result = toMCommentEnd) then Inc(P, 2);
  end
  else begin
    case P^ of
      'A'..'Z', 'a'..'z', '_':
        begin
          Inc(P);
          while P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_'] do Inc(P);
          Result := toSymbol;
        end;
      '"':
        begin
          Inc(P);
          while true do begin
            case P^ of
              #0, #10, #13: begin
                              Break;
                              //Error(SInvalidString);
                            end;
              '\':  Inc(P);
              '"':  begin
                      Inc(P);
                      Break;
                    end;
            end;
            Inc(P);
          end;
          Result := toString;
        end;
      '''':
        begin
          Inc(P);
          while true do begin
            case P^ of
              #0, #10, #13: begin
                              Break;
                              //Error(SInvalidString);
                            end;
              '\':  Inc(P);
              '''':  begin
                      Inc(P);
                      Break;
                    end;
            end;
            Inc(P);
          end;
          Result := toName;
        end;
      {'-', '+', }'0'..'9':
        begin
          Result := toInteger;
          Inc(P);
          if (((P-1)^ = '0') and (P^ in ['x', 'X'])) then begin
            Inc(P); // hex notation
            while P^ in ['0'..'9', 'a', 'f', 'A', 'F'] do Inc(P);
          end
          else begin
            while P^ in ['0'..'9'] do begin
              Inc(P);
            end;
            if (P^ = '.') then begin
              Inc(P);
              while P^ in ['0'..'9'] do begin
                Inc(P);
                Result := toFloat;
              end;
            end;
          end;
        end;
      '#':
        begin
          while not (P^ in [#10, toEOF]) do Inc(P);
          if (P^ = toEOF) then begin
            Result := toEOF;
          end
          else begin
            Inc(P);
            Inc(FSourceLine); // next line
            Result := toMacro; // not realy a comment but we just ignore it
          end;
        end;
      '/':
        begin
          Inc(P);
          if (P^ = '/') then begin // comment
            Inc(P);
            while not (P^ in [#10, toEOF]) do Inc(P);
            if (P^ <> toEOF) then begin
              Inc(P);
              Inc(FSourceLine); // next line
            end;
            Result := toComment; // not realy a comment but we just ignore it
          end
          else if (P^ = '*') then begin // block comment
            Result := toComment;
            repeat begin
              Inc(P);
              if (P^ = #0) then begin
                Dec(P);
                Result := toMCommentBegin;
                IsInMComment := true;
                break;
              end;
              if (P^ = #10) then Inc(FSourceLine); // next line
            end
            until ((P^ ='*') and ((P+1)^ ='/' ));
            if (Result <> toMCommentBegin) then Inc(P, 2);
          end
          else begin
            Result := P^;
            if Result <> toEOF then Inc(P);
          end;
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
  end;
  StartPos := FSourcePtr;
  FSourcePtr := P;
  if DoCopy then UpdateOutStream(StartPos);
  FToken := Result;
end;

function TSourceParser.SkipToken(CopyBlanks: Boolean): Char;
begin
  Result := SkipToNextToken(CopyBlanks, False);
end;

procedure TSourceParser.ReadBuffer;
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

procedure TSourceParser.SkipBlanks(DoCopy: Boolean);
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
      #9:
        if (not TabIsWS) then Break;
      #10:
        begin
          //Inc(FSourceLine);
          break;
        end;
      #33..#255:
        Break;
    end;
    Inc(FSourcePtr);
  end;
  if DoCopy then UpdateOutStream(Start);
end;

function TSourceParser.TokenString: string;
begin
  SetString(Result, FTokenPtr, FSourcePtr - FTokenPtr);
end;     

procedure TSourceParser.UpdateOutStream(StartPos: PChar);
begin
  if FOutStream <> nil then
    FOutStream.WriteBuffer(StartPos^, FSourcePtr - StartPos);
end;

end.
