{-----------------------------------------------------------------------------
 Unit Name: unit_parser
 Author:    elmuerte
 Purpose:   Tokeniser for Unreal Script
            Based on the TParser class by Borland Software Corporation
 $Id: unit_parser.pas,v 1.10 2003-11-22 10:45:34 elmuerte Exp $
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

unit unit_parser;

interface

uses
  Classes, SysUtils, RTLConsts;

type
  TUCParser = class(TObject)
  private
    FStream: TStream;
    FCopyStream: TStringStream;
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
    FFloatType: Char;
    CopyInitComment: boolean;
    procedure ReadBuffer;
    procedure SkipBlanks;
  public
    FullCopy: boolean;
    constructor Create(Stream: TStream);
    destructor Destroy; override;
    procedure Error(const Ident: string);
    procedure ErrorFmt(const Ident: string; const Args: array of const);
    procedure ErrorStr(const Message: string);
    function NextToken: Char;
    function NextTokenTmp: Char;
    function SourcePos: Longint;
    function TokenString: string;
    function TokenSymbolIs(const S: string): Boolean;
    function GetCopyData(flush: boolean = true): string;
    property SourceLine: Integer read FSourceLine;
    property Token: Char read FToken;
  end;

const
  toComment = Char(6);
  toName = Char(7);

implementation

const
  ParseBufSize = 4096;

constructor TUCParser.Create(Stream: TStream);
begin
  FStream := Stream;
  FullCopy := false;
  CopyInitComment := true;
  FCopyStream := TStringStream.Create('');
  GetMem(FBuffer, ParseBufSize);
  FBuffer[0] := #0;
  FBufPtr := FBuffer;
  FBufEnd := FBuffer + ParseBufSize;
  FSourcePtr := FBuffer;
  FSourceEnd := FBuffer;
  FTokenPtr := FBuffer;
  FSourceLine := 1;
  NextToken;
  CopyInitComment := false;
end;

destructor TUCParser.Destroy;
begin
  FCopyStream.Free;
  if FBuffer <> nil then
  begin
    FStream.Seek(Longint(FTokenPtr) - Longint(FBufPtr), 1);
    FreeMem(FBuffer, ParseBufSize);
  end;
end;

procedure TUCParser.Error(const Ident: string);
begin
  ErrorStr(Ident);
end;

procedure TUCParser.ErrorFmt(const Ident: string; const Args: array of const);
begin
  ErrorStr(Format(Ident, Args));
end;

procedure TUCParser.ErrorStr(const Message: string);
begin
  raise EParserError.CreateResFmt(@SParseError, [Message, FSourceLine]);
end;

function TUCParser.NextToken: Char;
begin
  result := NextTokenTmp;
  while ((result = toComment) and (result <> toEOF)) do result := NextTokenTmp;
end;

function TUCParser.NextTokenTmp: Char;
var
  P: PChar;
  isComment: boolean;
  CommentString: string;
  comminit: integer; // so strip of the first /**
begin
  SkipBlanks;
  P := FSourcePtr;
  FTokenPtr := P;
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
    '-', '0'..'9':
      begin
        Inc(P);
        if ((P-1)^ = '0') and (P^ = 'x') then begin
          Inc(P);
          while P^ in ['0'..'9', 'A' .. 'F', 'a' .. 'f'] do Inc(P);
        end;
        while P^ in ['0'..'9'] do Inc(P);
        Result := toInteger;
        while P^ in ['0'..'9', '.', 'e', 'E', '+', '-', 'f', 'F'] do
        begin
          Inc(P);
          Result := toFloat;
        end;
        if (P^ in ['c', 'C', 'd', 'D', 's', 'S']) then
        begin
          Result := toFloat;
          FFloatType := P^;
          Inc(P);
        end else
          FFloatType := #0;
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
          Result := toComment; // not realy a comment but we just ignore it
        end;
      end;
    '/':
      begin
        Inc(P);
        if (P^ = '/') then begin // comment
          Inc(P);
          while not (P^ in [#10, toEOF]) do Inc(P);
          if (P^ = toEOF) then begin
            Result := toEOF;
          end
          else begin
            Inc(P);
            Inc(FSourceLine); // next line
            Result := toComment; // not realy a comment but we just ignore it
            if (CopyInitComment) then begin
              SetString(CommentString, FTokenPtr, P - FTokenPtr);
              FCopyStream.WriteString(CommentString);
            end;
          end;
        end
        else if (P^ = '*') then begin // block comment
          isComment := (P+1)^ = '*';
          comminit := 3;
          if (isComment) then begin
            GetCopyData(true); // empty buffer
            CopyInitComment := false; // /** */ is better than //
          end;
          repeat begin
            Inc(P);
            if ((P^ = #0) or (P^ = #0)) then begin
              FSourcePtr := P;
              if (isComment) then begin
                SetString(CommentString, FTokenPtr + comminit, FSourcePtr - FTokenPtr - comminit);
                FCopyStream.WriteString(CommentString);
                comminit := 0;
              end;
              ReadBuffer;
              P := FSourcePtr;
              FTokenPtr := P;
            end;
            if (P^ = #10) then Inc(FSourceLine); // next line
          end
          until ((P^ ='*') and ((P+1)^ ='/' ));
          if (isComment) then begin
            SetString(CommentString, FTokenPtr + comminit, P - FTokenPtr - comminit); // 3 to strip /**
            FCopyStream.WriteString(CommentString);
          end;
          Inc(P, 2);
          Result := toComment;
        end
        else begin
          Result := P^;
          if Result <> toEOF then Inc(P);
        end;
      end;
  else
    Result := P^;
    if Result <> toEOF then Inc(P);
  end;
  FSourcePtr := P;
  FToken := Result;
  if (FullCopy) then FCopyStream.WriteString(TokenString);
end;

procedure TUCParser.ReadBuffer;
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

procedure TUCParser.SkipBlanks;
var
  SkipedBlanks: string;
  FirstBlank: PChar;
begin
  FirstBlank := FSourcePtr;
  while True do begin
    case FSourcePtr^ of
      #0:
        begin
          if (FullCopy) then begin
            SetString(SkipedBlanks, FirstBlank, FSourcePtr - FirstBlank);
            FCopyStream.WriteString(SkipedBlanks);
          end;
          ReadBuffer;
          if FSourcePtr^ = #0 then Exit;
          FirstBlank := FSourcePtr;
          Continue;
        end;
      #10:
        Inc(FSourceLine);
      #33..#255:
        Break;
    end;
    Inc(FSourcePtr);
  end;
  if (FullCopy) then begin
    SetString(SkipedBlanks, FirstBlank, FSourcePtr - FirstBlank);
    FCopyStream.WriteString(SkipedBlanks);
  end;
end;

function TUCParser.SourcePos: Longint;
begin
  Result := FOrigin + (FTokenPtr - FBuffer);
end;

function TUCParser.TokenString: string;
begin
  SetString(Result, FTokenPtr, FSourcePtr - FTokenPtr);
end;     

function TUCParser.TokenSymbolIs(const S: string): Boolean;
begin
  Result := (Token = toSymbol) and SameText(S, TokenString);
end;

function TUCParser.GetCopyData(flush: boolean = true): string;
begin
  Result := FCopyStream.DataString;
  if (flush) then begin
    FCopyStream.Position := 0;
    FCopyStream.Size := 0;
  end;
end;

end.
