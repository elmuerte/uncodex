{-----------------------------------------------------------------------------
 Unit Name: unit_parser
 Author:    elmuerte
 Purpose:   Tokeniser for Unreal Script
            Based on the TParser class by Borland Software Corporation
 History:
-----------------------------------------------------------------------------}

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
    FFloatType: Char;
    procedure ReadBuffer;
    procedure SkipBlanks(DoCopy: Boolean);
    function SkipToNextToken(CopyBlanks, DoCopy: Boolean): Char;
    function CopySkipTo(Length: Integer; DoCopy: Boolean): string;
    function CopySkipToToken(AToken: Char; DoCopy: Boolean): string;
    function CopySkipToEOL(DoCopy: Boolean): string;
    function CopySkipToEOF(DoCopy: Boolean): string;
    procedure UpdateOutStream(StartPos: PChar);
  public
    constructor Create(Stream, OutStream: TStream);
    destructor Destroy; override;
    procedure CheckToken(T: Char);
    procedure CheckTokenSymbol(const S: string);
    function CopyTo(Length: Integer): string;
    function CopyToToken(AToken: Char): string;
    function CopyToEOL: string;
    function CopyToEOF: string;
    procedure CopyTokenToOutput;
    procedure Error(const Ident: string);
    procedure ErrorFmt(const Ident: string; const Args: array of const);
    procedure ErrorStr(const Message: string);
    function NextToken: Char;
    function SkipToken(CopyBlanks: Boolean): Char;
    procedure SkipEOL;
    function SkipTo(Length: Integer): string;
    function SkipToToken(AToken: Char): string;
    function SkipToEOL: string;
    function SkipToEOF: string;
    function SourcePos: Longint;
    function TokenComponentIdent: string;
    function TokenFloat: Extended;
    function TokenInt: Int64;
    function TokenString: string;
    function TokenSymbolIs(const S: string): Boolean;
    property FloatType: Char read FFloatType;
    property SourceLine: Integer read FSourceLine;
    property Token: Char read FToken;
    property OutputStream: TStream read FOutStream write FOutStream;
  end;

const
  toComment = Char(6);
  toName = Char(7);
  toEOL = Char(8);
  toMacro = Char(9);

implementation

const
  ParseBufSize = 4096;

constructor TSourceParser.Create(Stream, OutStream: TStream);
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

destructor TSourceParser.Destroy;
begin
  if FBuffer <> nil then
  begin
    FStream.Seek(Longint(FTokenPtr) - Longint(FBufPtr), 1);
    FreeMem(FBuffer, ParseBufSize);
  end;
end;

procedure TSourceParser.CheckToken(T: Char);
begin
  if Token <> T then
    case T of
      toSymbol:
        Error(SIdentifierExpected);
      toString, toWString:
        Error(SStringExpected);
      toInteger, toFloat:
        Error(SNumberExpected);
    else
      ErrorFmt(SCharExpected, [T]);
    end;
end;

procedure TSourceParser.CheckTokenSymbol(const S: string);
begin
  if not TokenSymbolIs(S) then ErrorFmt(SSymbolExpected, [S]);
end;

function TSourceParser.CopySkipTo(Length: Integer; DoCopy: Boolean): string;
var
  P: PChar;
  Temp: string;
begin
  Result := '';
  repeat
    P := FTokenPtr;
    while (Length > 0) and (P^ <> #0) do
    begin
      Inc(P);
      Dec(Length);
    end;
    if DoCopy and (FOutStream <> nil) then
        FOutStream.WriteBuffer(FTokenPtr^, P - FTokenPtr);
    SetString(Temp, FTokenPtr, P - FTokenPtr);
    Result := Result + Temp;
    if Length > 0 then ReadBuffer;
  until (Length = 0) or (Token = toEOF);
  FSourcePtr := P;
end;

function TSourceParser.CopySkipToEOL(DoCopy: Boolean): string;
var
  P: PChar;
begin
  P := FTokenPtr;
  while not (P^ in [#13, #10, #0]) do Inc(P);
  SetString(Result, FTokenPtr, P - FTokenPtr);
  if P^ = #13 then Inc(P);
  FSourcePtr := P;
  if DoCopy then UpdateOutStream(FTokenPtr);
  NextToken;
end;

function TSourceParser.CopySkipToEOF(DoCopy: Boolean): string;
var
  P: PChar;
  Temp: string;
begin
  repeat
    P := FTokenPtr;
    while P^ <> #0 do Inc(P);
    FSourcePtr := P;
    SetString(Temp, FTokenPtr, P - FTokenPtr);
    Result := Result + Temp;
    if DoCopy then
    begin
      UpdateOutStream(FTokenPtr);
      NextToken;
    end else SkipToken(False);
    FTokenPtr := FSourcePtr;
  until Token = toEOF;
end;

function TSourceParser.CopySkipToToken(AToken: Char; DoCopy: Boolean): string;
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

function TSourceParser.CopyTo(Length: Integer): string;
begin
  Result := CopySkipTo(Length, True);
end;

function TSourceParser.CopyToToken(AToken: Char): string;
begin
  Result := CopySkipToToken(AToken, True);
end;

function TSourceParser.CopyToEOL: string;
begin
  Result := CopySkipToEOL(True);
end;

function TSourceParser.CopyToEOF: string;
begin
  Result := CopySkipToEOF(True);
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

procedure TSourceParser.SkipEOL;
begin
  if Token = toEOL then
  begin
    while FTokenPtr^ in [#13, #10] do Inc(FTokenPtr);
    FSourcePtr := FTokenPtr;
    if FSourcePtr^ <> #0 then
      NextToken
    else FToken := #0;
  end;
end;

function TSourceParser.SkipToNextToken(CopyBlanks, DoCopy: Boolean): Char;
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
          if (P^ = toEOF) then begin
            Result := toEOF;
          end
          else begin
            Inc(P);
            Inc(FSourceLine); // next line
            Result := toComment; // not realy a comment but we just ignore it
          end;
        end
        else if (P^ = '*') then begin // block comment
          repeat begin
            Inc(P);
            if ((P^ = #0) or (P^ = #0)) then begin
              FSourcePtr := P;
              ReadBuffer;
              P := FSourcePtr;
              FTokenPtr := P;
            end;
            if (P^ = #10) then Inc(FSourceLine); // next line
          end
          until ((P^ ='*') and ((P+1)^ ='/' ));
          Inc(P, 2);
          Result := toComment;
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
  StartPos := FSourcePtr;
  FSourcePtr := P;
  if DoCopy then UpdateOutStream(StartPos);
  FToken := Result;
end;

function TSourceParser.SkipTo(Length: Integer): string;
begin
  Result := CopySkipTo(Length, False);
end;

function TSourceParser.SkipToToken(AToken: Char): string;
begin
  Result := CopySkipToToken(AToken, False);
end;

function TSourceParser.SkipToEOL: string;
begin
  Result := CopySkipToEOL(False);
end;

function TSourceParser.SkipToEOF: string;
begin
  Result := CopySkipToEOF(False);
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

function TSourceParser.SourcePos: Longint;
begin
  Result := FOrigin + (FTokenPtr - FBuffer);
end;

function TSourceParser.TokenFloat: Extended;
begin
  if FFloatType <> #0 then Dec(FSourcePtr);
  Result := StrToFloat(TokenString);
  if FFloatType <> #0 then Inc(FSourcePtr);
end;

function TSourceParser.TokenInt: Int64;
begin
  Result := StrToInt64(TokenString);
end;

function TSourceParser.TokenString: string;
begin
  SetString(Result, FTokenPtr, FSourcePtr - FTokenPtr);
end;     

function TSourceParser.TokenSymbolIs(const S: string): Boolean;
begin
  Result := (Token = toSymbol) and SameText(S, TokenString);
end;

function TSourceParser.TokenComponentIdent: string;
var
  P: PChar;
begin
  CheckToken(toSymbol);
  P := FSourcePtr;
  while P^ = '.' do
  begin
    Inc(P);
    if not (P^ in ['A'..'Z', 'a'..'z', '_']) then
      Error(SIdentifierExpected);
    repeat
      Inc(P)
    until not (P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_']);
  end;
  FSourcePtr := P;
  Result := TokenString;
end;

procedure TSourceParser.UpdateOutStream(StartPos: PChar);
begin
  if FOutStream <> nil then
    FOutStream.WriteBuffer(StartPos^, FSourcePtr - StartPos);
end;

end.
