{*******************************************************************************
  Name:
    unit_sourceparser.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    UnrealScript parser. Used for syntax highlighting, not for analysing.
    Bases on the TParser by Borland.

  $Id: unit_sourceparser.pas,v 1.31 2006-02-16 22:04:31 elmuerte Exp $
*******************************************************************************}
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
unit unit_sourceparser;

{$I defines.inc}

interface

uses
  Classes, SysUtils;

type
  TSourceParser = class;

  TProcessMacro = procedure(Sender: TSourceParser);

  TParserState = record
    StreamPos: integer;
    Origin: Longint;
    Buffer: PChar;
    BufPtr: PChar;
    BufEnd: PChar;
    SourcePtr: PChar;
    SourceEnd: PChar;
    TokenPtr: PChar;
    SourceLine: Integer;
    LinePos: integer;
    SaveChar: Char;
    Token: Char;
  end;

  TSourceParser = class(TObject)
  private
    FStream: TStream;
    FOutStream: TStream;
    FCopyStream: TStringStream;

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
    commentdepth: integer;

    StateStack: TParserState;

    FProcessMacro: TProcessMacro;

    procedure ReadBuffer;
    procedure SkipBlanks(DoCopy: Boolean);
    function SkipToNextToken(CopyBlanks, DoCopy: Boolean): Char;
    procedure UpdateOutStream(StartPos: PChar);
  public
    TabIsWS: boolean;
    MacroCallBack: boolean;
    DoMacro: boolean;
    FullCopy: boolean;
    constructor Create(Stream, OutStream: TStream; TabIsWhiteSpace: boolean = true);
    destructor Destroy; override;
    procedure CopyTokenToOutput;
    function NextToken: Char;
    function SkipToken(CopyBlanks: Boolean): Char;
    function TokenString: string;
    procedure OutputString(data: string);
    property SourceLine: Integer read FSourceLine;
    property LinePos: Integer read FLinePos write FLinePos;
    property Token: Char read FToken;
    property OutputStream: TStream read FOutStream write FOutStream;
    property ProcessMacro: TProcessMacro write FProcessMacro;
    function GetCopyData(flush: boolean = true): string;

    procedure PushState;
    procedure PopState;
    procedure DiscardState;
  end;

const
  toComment       = Char(6);
  toName          = Char(7);
  toMacro         = Char(8);
  toEOL           = Char(10);
  toMCommentBegin = Char(11);
  toMCommentEnd   = Char(12);
  toMComment      = Char(14);
  {$IFDEF UE3_SUPPORT}
  toUE3PP         = '`';
  {$ENDIF}

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
  FToken := ' ';
  FOrigin := 0;
  GetMem(StateStack.Buffer, ParseBufSize);
  DoMacro := true;
  FullCopy := false;
  FCopyStream := TStringStream.Create('');
  //SkipToken(True);
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

//TODO: obsolete?
function TSourceParser.NextToken: Char;
begin
  result := SkipToNextToken(True, True);
end;

function TSourceParser.SkipToNextToken(CopyBlanks, DoCopy: Boolean): Char;
var
  P, StartPos: PChar;
  
  procedure EatNewLine;
  begin
    if (P^ = #13) then begin
      Inc(P);
      if (P^ <> #10) then Dec(P);
    end;
  end;

begin
  SkipBlanks(CopyBlanks);
  P := FSourcePtr;
  FTokenPtr := P;
  if (IsInMComment) then begin
    Result := toMComment;
    case P^ of
      #9:   begin
              Result := P^;
              Inc(P);
              Inc(FLinePos);
            end;
      #13, #10:  begin
              EatNewLine;
              Inc(P);
              Inc(FSourceLine);
              FLinePos := 0;
              Result := toEOL;
            end;
      '*':  begin
              Inc(P);
              Inc(FLinePos);
              if (P^ = '/') then begin
                Inc(P);
                Inc(FLinePos);
                Dec(commentdepth);
                if (commentdepth <= 0) then begin
                  IsInMComment := false;
                  Result := toMCommentEnd;
                end;
              end
            end;
      else begin
        if P^ <> toEOF then begin
          if ((P^ ='/') and ((P+1)^ ='*' )) then Inc(commentdepth);
          Inc(P);
          Inc(FLinePos);
        end
        else Result := toEOF;
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
              #0, #10, #13:
                begin
                  FLinePos := 0;
                  Break;
                end;
              '\':
                begin
                  Inc(P);
                  Inc(FLinePos);
                end;
              '"':
                begin
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
              #0, #10, #13:
                begin
                  FLinePos := 0;
                  Break;
                end;
              '\':
                begin
                  Inc(P);
                  Inc(FLinePos);
                end;
              '''':
                begin
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
          if (not DoMacro) then begin
            Result := P^;
            Inc(P);
            Inc(FLinePos);
          end
          else begin
            while not (P^ in [#13, #10, toEOF]) do begin
              Inc(P);
              Inc(FLinePos);
            end;
            if (P^ = toEOF) then begin
              //Result := toEOF;
              Result := toMacro;
            end
            else begin
              EatNewLine;
              Inc(P);
              Inc(FSourceLine); // next line
              FLinePos := 0;
              Result := toMacro;
            end;
          end;
        end;
      {$IFDEF UE3_SUPPORT}
      '`':
        begin
          if (not DoMacro) then begin
            Result := P^;
            Inc(P);
            Inc(FLinePos);
          end
          else begin
            while not (P^ in [#13, #10, toEOF]) do begin
              Inc(P);
              Inc(FLinePos);
              if (((P-1)^ = '\') and (P^ in [#13, #10])) then begin
                EatNewLine;
                Inc(P);
                Inc(FSourceLine); // next line
                FLinePos := 0;
              end;
            end;
            if (P^ = toEOF) then begin
              //Result := toEOF;
              Result := toUE3PP;
            end
            else begin
              EatNewLine;
              Inc(P);
              Inc(FSourceLine); // next line
              FLinePos := 0;
              Result := toUE3PP;
            end;
          end;
        end;
      {$ENDIF}
      '/':
        begin
          Inc(P);
          Inc(FLinePos);
          if (P^ = '/') then begin // comment
            Inc(P);
            Inc(FLinePos);
            while not (P^ in [#13, #10, toEOF]) do begin
              Inc(P);
              Inc(FLinePos);
            end;
            if (P^ <> toEOF) then begin
              EatNewLine;
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
            commentdepth := 1;
          end
          else begin
            Result := P^;
          end
        end;
      #13, #10:
        begin
          EatNewLine;
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
  if (FullCopy) then FCopyStream.WriteString(TokenString);
end;

function TSourceParser.SkipToken(CopyBlanks: Boolean): Char;
begin
  Result := SkipToNextToken(CopyBlanks, False);
  if ((result = toMacro) and MacroCallBack) then begin
    if (assigned(FProcessMacro)) then FProcessMacro(self);
    // macro processed, get the real next token, unless the token already changed
    if (FToken = toMacro) then result := SkipToNextToken(CopyBlanks, False);
  end;
end;

procedure TSourceParser.ReadBuffer;
var
  Count: Integer;
begin
  Inc(FOrigin, FSourcePtr - FBuffer); // increase file origin
  FSourceEnd[0] := FSaveChar; //
  Count := FBufPtr - FSourcePtr; // current buff pos - walker pointer = size of processed buffer space
  if Count <> 0 then Move(FSourcePtr[0], FBuffer[0], Count); // move re
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
  SkipedBlanks: string;
begin
  Start := FSourcePtr;
  while True do
  begin
    case FSourcePtr^ of
      #0:
        begin
          if DoCopy then UpdateOutStream(Start);
          if (FullCopy) then begin
            SetString(SkipedBlanks, Start, FSourcePtr - Start);
            FCopyStream.WriteString(SkipedBlanks);
          end;
          ReadBuffer;
          if FSourcePtr^ = #0 then Exit;
          Start := FSourcePtr;
          Continue;
        end;
      #9:
        if (not TabIsWS) then Break;
      #13, #10:
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
  if (FullCopy) then begin
    SetString(SkipedBlanks, Start, FSourcePtr - Start);
    FCopyStream.WriteString(SkipedBlanks);
  end;
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

procedure TSourceParser.OutputString(data: string);
begin
  OutputStream.WriteBuffer(PChar(data)^, length(data));
end;

function TSourceParser.GetCopyData(flush: boolean = true): string;
begin
  Result := FCopyStream.DataString;
  if (flush) then begin
    FCopyStream.Position := 0;
    FCopyStream.Size := 0;
  end;
end;

procedure TSourceParser.PushState;
begin
  StateStack.StreamPos := FStream.Position;
  StateStack.Origin := FOrigin;
  Move(FBuffer[0], StateStack.Buffer[0], ParseBufSize);
  StateStack.BufPtr := FBufPtr;
  StateStack.BufEnd := FBufEnd;
  StateStack.SourcePtr := FSourcePtr;
  StateStack.SourceEnd := FSourceEnd;
  StateStack.TokenPtr := FTokenPtr;
  StateStack.SourceLine := FSourceLine;
  StateStack.LinePos := FLinePos;
  StateStack.SaveChar := FSaveChar;
  StateStack.Token := FToken;
end;

procedure TSourceParser.PopState;
begin
  if (FOrigin <> StateStack.Origin) then begin
    FStream.Seek(StateStack.StreamPos, soFromBeginning);
    FOrigin := StateStack.Origin;
    Move(StateStack.Buffer[0], FBuffer[0], ParseBufSize);
    FBufPtr := StateStack.BufPtr;
    FBufEnd := StateStack.BufEnd;
    FSourceEnd := StateStack.SourceEnd;
    FSaveChar := StateStack.SaveChar;
  end;
  FSourcePtr := StateStack.SourcePtr;
  FTokenPtr := StateStack.TokenPtr;
  FSourceLine := StateStack.SourceLine;
  FLinePos := StateStack.LinePos;
  FToken := StateStack.Token;
  DiscardState;
end;

procedure TSourceParser.DiscardState;
begin
  //
end;

end.
