{*******************************************************************************
	Name:
        unit_parser.pas
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        Parser for UnrealScript, used for analysing the unrealscript source.
        Based on TParser by Borland.

	$Id: unit_parser.pas,v 1.22 2004-10-20 13:00:41 elmuerte Exp $
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
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
	Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA	02111-1307	USA
}
unit unit_parser;

{$I defines.inc}

interface

uses
	Classes, SysUtils;

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
		FSaveChar: Char;
		FToken: Char;
		CopyInitComment: boolean;
		FProcessMacro: TProcessMacro;
		procedure ReadBuffer;
		procedure SkipBlanks;
		function NextTokenTmp: Char;
	public
		FullCopy: boolean;
		FCIgnoreComments: boolean;
		constructor Create(Stream: TStream);
		destructor Destroy; override;
		function NextToken: Char;
		function SourcePos: Longint;
		function TokenString: string;
		function TokenSymbolIs(const S: string): Boolean;
		function GetCopyData(flush: boolean = true): string;
		property SourceLine: Integer read FSourceLine;
		property Token: Char read FToken;
		property ProcessMacro: TProcessMacro write FProcessMacro;
	end;

const
	toComment 	= Char(6);
	toName 		= Char(7);
	toMacro 	= char(8);

implementation

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

function TUCParser.NextToken: Char;
begin
	repeat
		result := NextTokenTmp;
		if (result = toMacro) then begin
			if (assigned(FProcessMacro)) then FProcessMacro(self);
			result := toComment;	// macro processed, get the real next token
		end;
	until ((result <> toComment) or (result = toEOF));
end;

function TUCParser.NextTokenTmp: Char;
var
	P, PX: 			PChar;
	isComment: 		boolean;
	CommentString: 	string;
	comminit: 		integer; // so strip of the first /**
	commentdepth: 	integer;
begin
	SkipBlanks;
	P := FSourcePtr;
	FTokenPtr := P;
	case P^ of
		{ identifier }
		'A'..'Z', 'a'..'z', '_':
			begin
				Inc(P);
				while P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_'] do Inc(P);
				Result := toSymbol;
			end;
		{ string }
		'"':
			begin
				Inc(P);
				while true do begin
					case P^ of
						#0, #10, #13: Break;
						'\':	Inc(P);
						'"':	begin
                        			Inc(P);
									Break;
                        		end;
					end;
					Inc(P);
				end;
				Result := toString;
			end;
		{ name }
		'''':
			begin
				Inc(P);
				while true do begin
					case P^ of
						#0, #10, #13: Break;
						'\':	Inc(P);
						'''':	begin
                        			Inc(P);
                        			Break;
                        		end;
					end;
					Inc(P);
				end;
				Result := toName;
			end;
		{ number }
		'-', '+', '0'..'9':
			begin
				Result := toInteger;
				Inc(P);
				if (((P-1)^ = '0') and (P^ in ['x', 'X'])) then begin
					Inc(P); // hex notation
					while P^ in ['0'..'9', 'a' .. 'f', 'A' .. 'F'] do Inc(P);
				end
				else begin
					while P^ in ['0'..'9'] do begin
						Inc(P);
					end;
					if (P^ = '.') then begin
						Inc(P);
						while P^ in ['0'..'9', 'f' ,'F'] do begin
							Inc(P);
							Result := toFloat;
						end;
					end;
				end;
			end;
		{ macro }
		'#':
			begin
				while not (P^ in [#10, toEOF]) do Inc(P);
				if (P^ = toEOF) then begin
					Result := toEOF;
				end
				else begin
					Inc(P);
					Inc(FSourceLine); // next line
					Result := toMacro;
				end;
			end;
		{ possible comment }
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
						if (FCIgnoreComments and FullCopy) then begin
							FCopyStream.WriteString(#10); // or else this would be cut
						end;
						Inc(P);
						Inc(FSourceLine); // next line
						Result := toComment;
						if (CopyInitComment) then begin
							SetString(CommentString, FTokenPtr, P - FTokenPtr);
							FCopyStream.WriteString(CommentString);
						end;
					end;
				end
				else if (P^ = '*') then begin // block comment
					isComment := (P+1)^ = '*';
					comminit := 3;
					commentdepth := 1;
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
						if ((P^ ='/') and ((P+1)^ ='*' )) then Inc(commentdepth);
						if ((P^ ='*') and ((P+1)^ ='/' )) then Dec(commentdepth);
					end
					until ((P^ ='*') and ((P+1)^ ='/' ) and (commentdepth <= 0));
					if (isComment) then begin
						while ((FTokenPtr + comminit)^ = '*') do Inc(comminit);
						PX := P;
						while (PX^ = '*') do Dec(PX);
						SetString(CommentString, FTokenPtr + comminit, PX - FTokenPtr - comminit); // 3 to strip /**
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
	if (FullCopy) then begin
		if ((not FCIgnoreComments) or ((Result <> toComment) or (Result <> toMacro))) then FCopyStream.WriteString(TokenString);
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
	SkipedBlanks: 	string;
	FirstBlank: 	PChar;
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
