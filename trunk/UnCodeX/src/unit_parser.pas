{*******************************************************************************
  Name:
    unit_parser.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Parser for UnrealScript, used for analysing the unrealscript source.
    Based on TParser by Borland.

  $Id: unit_parser.pas,v 1.37 2007/12/28 16:47:56 elmuerte Exp $
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
unit unit_parser;

{$I defines.inc}

interface

uses
  Classes, SysUtils {$IFDEF UE3_SUPPORT}, unit_ue3preproc {$ENDIF};

type
  TUCParser = class;

  TProcessMacro = procedure(Sender: TUCParser) of object;

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
    FFilename: String;
    FSaveChar: Char;
    FToken: Char;
    CopyInitComment: boolean;
    FProcessMacro: TProcessMacro;
    {$IFDEF UE3_SUPPORT}
    lineInfo: TLineNumberQueue;
    {$ENDIF}
    procedure ReadBuffer;
    procedure SkipBlanks;
    function NextTokenTmp: Char;
    {$IFDEF UE3_SUPPORT}
    procedure AdjustLineNo;
    {$ENDIF}
    function HandleNewline(var P: PChar): boolean;
  public
    FullCopy: boolean;
    FCIgnoreComments: boolean;
    MacroCallBack: boolean;
    constructor Create(Stream: TStream);
    destructor Destroy; override;
    function NextToken: Char;
    function SkipToken: Char;
    function SkipTo(char: Char): boolean;
    function SourcePos: Longint;
    function TokenString: string;
    function TokenSymbolIs(const S: string): Boolean;
    function GetCopyData(flush: boolean = true): string;
    property SourceLine: Integer read FSourceLine write FSourceLine;
    property Filename: String read FFilename write FFilename;
    property Token: Char read FToken;
    property ProcessMacro: TProcessMacro write FProcessMacro;
    {$IFDEF UE3_SUPPORT}
    property LineNumbers: TLineNumberQueue read lineInfo write lineInfo;
    {$ENDIF}
  end;

const
  toComment   = Char(6);
  toName      = Char(7);
  toMacro     = char(8);
  {$IFDEF UE3_SUPPORT}
  toUE3PP     = '`';
  {$ENDIF}

implementation

uses
  unit_definitions;

const
  ParseBufSize = 4096;

constructor TUCParser.Create(Stream: TStream);
begin
  FStream := Stream;
  FullCopy := false;
  FCIgnoreComments := false;
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
  //NextToken;
  CopyInitComment := false;
  MacroCallBack := true;
  ReadBuffer;
  // skip UTF8 "BOF"
  if ((FSourcePtr^ = #$EF) and ((FSourcePtr+1)^ = #$BB) and ((FSourcePtr+2)^ = #$BF)) then begin
    FSourcePtr := FSourcePtr+3;
  end;
end;

destructor TUCParser.Destroy;
begin
  FCopyStream.Free;
  if FBuffer <> nil then
  begin
    //FStream.Seek(Longint(FTokenPtr) - Longint(FBufPtr), 1);
    FreeMem(FBuffer, ParseBufSize);
  end;
end;

function TUCParser.NextToken: Char;
begin
  repeat
    result := NextTokenTmp;
    if (result = toMacro) then begin
      if (assigned(FProcessMacro) and MacroCallBack) then FProcessMacro(self);
      // macro processed, get the real next token, unless the token already changed
      if (FToken = toMacro) then result := toComment;
    end;
  until ((result <> toComment) or (result = toEOF));
end;

function TUCParser.SkipToken: Char;
var
  pfc: boolean;
begin
  pfc := FullCopy;
  FullCopy := false;
  result := NextToken;
  FullCopy := pfc;
end;

{$IFDEF UE3_SUPPORT}
procedure TUCParser.AdjustLineNo;
var
  lineno: TLineNumber;
begin
  if (lineInfo = nil) then exit;
  lineno := lineInfo.Pop;
  Log('Correcting line from '+FFilename+':'+IntToStr(FSourceLine)+' to '+lineno.Filename+':'+IntToStr(lineno.LineNumber));
  FSourceLine := lineno.LineNumber;
  FFilename := lineno.Filename;
  lineno.Free;
end;
{$ENDIF}

// detect and transform #10#13, #13#10, #13, #10 to -> #10 and inc line number
function TUCParser.HandleNewline(var P: PChar): boolean;
begin
  result := false;
  if (P^ = #10) then begin
    // detects: #10; #10#13
    if ((P+1)^ = #13) then begin
       P^ := #13;
       Inc(P);
       P^ := #10;
    end;
    Inc(FSourceLine);
    result := true;
  end
  else if (P^ = #13) then begin
    // detects: #13, #13#10
    if ((P+1)^ = #10) then begin
       Inc(P);
    end
    else P^ := #10;
    Inc(FSourceLine);
    result := true;
  end;
end;

function TUCParser.SkipTo(char: Char): boolean;
var
  SkipedBlanks: string;
  FirstBlank: PChar;
begin
  result := false;
  FirstBlank := FSourcePtr;
  while True do begin
    {$IFDEF UE3_SUPPORT}
    while ((FSourcePtr^ = toLineNumber) and (lineInfo <> nil)) do begin
      AdjustLineNo;
      Inc(FSourcePtr);
    end;
    {$ENDIF}
    case FSourcePtr^ of
      #0:
        begin
          if (FullCopy) then begin
            SetString(SkipedBlanks, FirstBlank, FSourcePtr - FirstBlank);
            {$IFDEF UE3_SUPPORT}
            SkipedBlanks := StringReplace(SkipedBlanks, toLineNumber, '', [rfReplaceAll]);
            {$ENDIF}
            FCopyStream.WriteString(SkipedBlanks);
          end;
          ReadBuffer;
          if FSourcePtr^ = #0 then Exit;
          FirstBlank := FSourcePtr;
          Continue;
        end;
      else begin
        if (FSourcePtr^ = char) then begin
          Inc(FSourcePtr);
          result := true;
          break;              
        end;
      end;
    end;
    Inc(FSourcePtr);
    HandleNewline(FSourcePtr);
  end;
  if (FullCopy) then begin
    SetString(SkipedBlanks, FirstBlank, FSourcePtr - FirstBlank);
    {$IFDEF UE3_SUPPORT}
    SkipedBlanks := StringReplace(SkipedBlanks, toLineNumber, '', [rfReplaceAll]);
    {$ENDIF}
    FCopyStream.WriteString(SkipedBlanks);
  end;
end;

function TUCParser.NextTokenTmp: Char;
var
  P, PX: PChar;
  isComment: boolean;
  CommentString: string;
  commentdepth: integer;

  procedure IncP;
  {$IFDEF UE3_SUPPORT}
  var
    lineNo: TLineNumber;
  {$ENDIF}
  begin
    Inc(P);
    //HandleNewline(P);
    {$IFDEF UE3_SUPPORT}
    while ((P^ = toLineNumber) and (lineInfo <> nil)) do begin
      AdjustLineNo;
      Inc(P);
    end;
    {$ENDIF}
  end;

label
  NextCommentLine;
begin
  SkipBlanks;
  P := FSourcePtr;
  FTokenPtr := P;
  case P^ of
    { identifier }
    'A'..'Z', 'a'..'z', '_':
      begin
        IncP;
        // accept '.' in the middle: Package.Class or Class.Type
        // warning: this is only valid for declarations, not for actual code
        // TODO: move this to analyser
        while P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_', '.'] do IncP;
        Result := toSymbol;
      end;
    { string }
    '"':
      begin
        IncP;
        while true do begin
          case P^ of
            #0, #10, #13: Break;
            '\':  IncP;
            '"':  begin
                    IncP;
                    Break;
                  end;
          end;
          IncP;
        end;
        Result := toString;
      end;
    { name }
    '''':
      begin
        IncP;
        while true do begin
          case P^ of
            #0, #10, #13: Break;
            '\':  IncP;
            '''': begin
                    IncP;
                    Break;
                  end;
          end;
          IncP;
        end;
        Result := toName;
      end;
    { number }
    '-', '+', '0'..'9':
      begin
        Result := toInteger;
        IncP;
        if (((P-1)^ = '0') and (P^ in ['x', 'X'])) then begin
          IncP; // hex notation
          while P^ in ['0'..'9', 'a' .. 'f', 'A' .. 'F'] do IncP;
        end
        else begin
          while P^ in ['0'..'9'] do begin
            IncP;
          end;
          if (P^ = '.') then begin
            IncP;
            while P^ in ['0'..'9', 'f' ,'F'] do begin
              IncP;
              Result := toFloat;
            end;
          end;
        end;
        if (P-FSourcePtr = 1) then begin
          Result := (P-1)^;
        end;
      end;
    { macro }
    '#':
      begin
        while not (P^ in [#10, #13, toEOF]) do IncP;
        if (P^ = toEOF) then begin
          Result := toMacro;
        end
        else begin
          IncP;
          Result := toMacro;
        end;
      end;
    { possible comment }
    '/':
      begin
        IncP;
        if (P^ = '/') then begin // comment
          IncP;
          isComment := false;
          if (P^ in ['/', '!']) then begin
            IncP;
            // also documentation: /// bla or //! bla
            isComment := P^ in [' ', #9];
            if (isComment) then begin
              GetCopyData(true); // empty buffer
              CopyInitComment := false; // tripple slash documentation
            end;
          end;
        NextCommentLine: // somewhat dirty hack
          while not (P^ in [#10, #13, toEOF]) do IncP;
          HandleNewline(P);
          if (isComment and (P^ <> toEOF)) then begin
            PX := P;
            IncP; // the #10
            while (P^ in [' ', #9]) do IncP; // find the beginning of the line
            if ((StrLComp(P, '///', 3) = 0) or (StrLComp(P, '//!', 3) = 0)) then begin
              goto NextCommentLine;
            end
            else P := PX; // nothing new
          end;
          if (P^ = toEOF) then begin
            Result := toEOF;
          end
          else begin
            if (FCIgnoreComments and FullCopy) then begin
              FCopyStream.WriteString(#10); // or else this would be cut
            end;
            IncP;
            Result := toComment;
            if (CopyInitComment or isComment) then begin
              SetString(CommentString, FTokenPtr, P - FTokenPtr);
              {$IFDEF UE3_SUPPORT}
              CommentString := StringReplace(CommentString, toLineNumber, '', [rfReplaceAll]);
              {$ENDIF}
              FCopyStream.WriteString(CommentString);
            end;
          end;
        end
        else if (P^ = '*') then begin // block comment
          isComment := (P+1)^ in ['*', '!'];
          commentdepth := 1;
          if (isComment) then begin
            GetCopyData(true); // empty buffer
            CopyInitComment := false; // /** */ is better than //
          end;
          repeat begin
            IncP;
            HandleNewline(P);
            if (P^ = #0) then begin
              FSourcePtr := P;
              if (isComment) then begin
                SetString(CommentString, FTokenPtr, FSourcePtr - FTokenPtr);
                {$IFDEF UE3_SUPPORT}
                CommentString := StringReplace(CommentString, toLineNumber, '', [rfReplaceAll]);
                {$ENDIF}
                FCopyStream.WriteString(CommentString);
              end;
              ReadBuffer;
              if FSourcePtr^ = #0 then raise Exception.Create('Unterminated block comment');
              P := FSourcePtr;
              FTokenPtr := P;
            end;
            if ((P^ ='/') and ((P+1)^ ='*' )) then Inc(commentdepth);
            if ((P^ ='*') and ((P+1)^ ='/' )) then Dec(commentdepth);
          end
          until ((P^ ='*') and ((P+1)^ ='/' ) and (commentdepth <= 0));
          IncP;
          IncP;
          if (isComment) then begin
            SetString(CommentString, FTokenPtr, P - FTokenPtr);
            {$IFDEF UE3_SUPPORT}
            CommentString := StringReplace(CommentString, toLineNumber, '', [rfReplaceAll]);
            {$ENDIF}
            FCopyStream.WriteString(CommentString);
          end;
          Result := toComment;
        end
        else begin
          Result := P^;
          if Result <> toEOF then IncP;
        end;
      end;
  else
    Result := P^;
    if Result <> toEOF then IncP;
  end;
  FSourcePtr := P;
  FToken := Result;
  if (FullCopy) then begin
    if ((not FCIgnoreComments) or ((Result <> toComment) and (Result <> toMacro))) then begin
      {$IFDEF UE3_SUPPORT}
      FCopyStream.WriteString(StringReplace(TokenString, toLineNumber, '', [rfReplaceAll]));
      {$ELSE}
      FCopyStream.WriteString(TokenString);
      {$ENDIF}
    end;
  end;
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
    {$IFDEF UE3_SUPPORT}
    while ((FSourcePtr^ = toLineNumber) and (lineInfo <> nil)) do begin
      AdjustLineNo;
      Inc(FSourcePtr);
    end;
    {$ENDIF}
    case FSourcePtr^ of
      #0:
        begin
          if (FullCopy) then begin
            SetString(SkipedBlanks, FirstBlank, FSourcePtr - FirstBlank);
            {$IFDEF UE3_SUPPORT}
            SkipedBlanks := StringReplace(SkipedBlanks, toLineNumber, '', [rfReplaceAll]);
            {$ENDIF}
            FCopyStream.WriteString(SkipedBlanks);
          end;
          ReadBuffer;
          if FSourcePtr^ = #0 then Exit;
          FirstBlank := FSourcePtr;
          Continue;
        end;
      #33..#255:
        Break;
    end;
    Inc(FSourcePtr);
    HandleNewline(FSourcePtr);
  end;
  if (FullCopy) then begin
    SetString(SkipedBlanks, FirstBlank, FSourcePtr - FirstBlank);
    {$IFDEF UE3_SUPPORT}
    SkipedBlanks := StringReplace(SkipedBlanks, toLineNumber, '', [rfReplaceAll]);
    {$ENDIF}
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
