{-----------------------------------------------------------------------------
 Unit Name: unit_parser
 Author:    elmuerte
 Purpose:   Tokeniser for Unreal Script
            Based on the TCopyParser class by Borland Software Corporation
 $Id: unit_sourceparser.pas,v 1.13 2004-03-08 20:02:24 elmuerte Exp $           
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
    FLinePos: integer;
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
    function NextToken: Char;
    function SkipToken(CopyBlanks: Boolean): Char;
    function TokenString: string;
    property SourceLine: Integer read FSourceLine;
    property LinePos: Integer read FLinePos write FLinePos;
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
  toMComment = Char(14);

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
  	Result := toMComment;
  	case P^ of
    	#9:		begin
      				Result := P^;
              Inc(P);
          		Inc(FLinePos);
      			end;
      #10:	begin
              Inc(P);
          		Inc(FSourceLine);
          		FLinePos := 0;
          		Result := toEOL;
      			end;
      '*':	begin
              Inc(P);
          		Inc(FLinePos);
              if (P^ = '/') then begin
              	Inc(P);
          			Inc(FLinePos);
              	IsInMComment := false;
                Result := toMCommentEnd;
              end
      			end;
      else begin
      	if Result <> toEOF then begin
        	Inc(P);
          Inc(FLinePos);
        end;
    	end;
    end;
    StartPos := FSourcePtr;
  	FSourcePtr := P;
  	if DoCopy then UpdateOutStream(StartPos);
  	FToken := Result;
    exit;
  end
  else begin
    case P^ of
      'A'..'Z', 'a'..'z', '_':
        begin
          Inc(P);
          Inc(FLinePos);
          while P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_'] do begin
          	Inc(P);
            Inc(FLinePos);
          end;
          Result := toSymbol;
        end;
      '"':
        begin
          Inc(P);
          Inc(FLinePos);
          while true do begin
            case P^ of
              #0, #10, #13: begin
              								FLinePos := 0;
                              Break;
                              //Error(SInvalidString);
                            end;
              '\':  begin
              				Inc(P);
                      Inc(FLinePos);
              			end;
              '"':  begin
                      Inc(P);
                      Inc(FLinePos);
                      Break;
                    end;
            end;
            Inc(P);
            Inc(FLinePos);
          end;
          Result := toString;
        end;
      '''':
        begin
          Inc(P);
          Inc(FLinePos);
          while true do begin
            case P^ of
              #0, #10, #13: begin
              								FLinePos := 0;
                              Break;
                              //Error(SInvalidString);
                            end;
              '\':  begin
              				Inc(P);
                      Inc(FLinePos);
              			end;
              '''':  begin
                      Inc(P);
                      Inc(FLinePos);
                      Break;
                    end;
            end;
            Inc(P);
            Inc(FLinePos);
          end;
          Result := toName;
        end;
      {'-', '+', }'0'..'9':
        begin
          Result := toInteger;
          Inc(P);
          Inc(FLinePos);
          if (((P-1)^ = '0') and (P^ in ['x', 'X'])) then begin
            Inc(P); // hex notation
            Inc(FLinePos);
            while P^ in ['0'..'9', 'a' .. 'f', 'A' .. 'F'] do begin
            	Inc(P);
              Inc(FLinePos);
            end;
          end
          else begin
            while P^ in ['0'..'9'] do begin
              Inc(P);
              Inc(FLinePos);
            end;
            if (P^ = '.') then begin
              Inc(P);
              Inc(FLinePos);
              while P^ in ['0'..'9', 'f' ,'F'] do begin
                Inc(P);
                Inc(FLinePos);
                Result := toFloat;
              end;
            end;
          end;
        end;
      '#':
        begin
          while not (P^ in [#10, toEOF]) do begin
          	Inc(P);
            Inc(FLinePos);
          end;
          if (P^ = toEOF) then begin
            Result := toEOF;
          end
          else begin
            Inc(P);
            Inc(FSourceLine); // next line
            FLinePos := 0;
            Result := toMacro;
          end;
        end;
      '/':
        begin
          Inc(P);
          Inc(FLinePos);
          if (P^ = '/') then begin // comment
            Inc(P);
            Inc(FLinePos);
            while not (P^ in [#10, toEOF]) do begin
            	Inc(P);
              Inc(FLinePos);
            end;
            if (P^ <> toEOF) then begin
              Inc(P);
              Inc(FSourceLine); // next line
              FLinePos := 0;
            end;
            Result := toComment;
          end
          else if (P^ = '*') then begin // block comment
          	Inc(P);
            Inc(FLinePos);
            Result := toMCommentBegin;
            IsInMComment := true;
          end
          else begin
            Result := P^;
            if Result <> toEOF then begin
            	Inc(P);
              Inc(FLinePos);
            end;
          end;
        end;
      #10:
        begin
          Inc(P);
          Inc(FSourceLine);
          FLinePos := 0;
          Result := toEOL;
        end;
    else
      Result := P^;
      if Result <> toEOF then begin
      	Inc(P);
        Inc(FLinePos);
      end;
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
          FLinePos := 0;
          break;
        end;
      #33..#255:
        Break;
    end;
    Inc(FLinePos);
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
