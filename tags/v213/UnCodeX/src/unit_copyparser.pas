{*******************************************************************************
    Name:
        unit_copyparser.pas
    Author(s):
        Michiel 'El Muerte' Hendriks
    Purpose:
        text parser based on Borland's TCopyParser, used for processing the HTML
        templates. Only special token is %

    $Id: unit_copyparser.pas,v 1.12 2004-10-20 14:19:27 elmuerte Exp $
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

unit unit_copyparser;

{$I defines.inc}

interface

uses
    Classes;

type
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
        function NextToken: Char;
        function SkipToken(CopyBlanks: Boolean): Char;
        function SkipToToken(AToken: Char): string;
        property Token: Char read FToken;
        property OutputStream: TStream read FOutStream write FOutStream;
    end;

implementation

uses
    SysUtils;

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
    S:      PChar;
    Temp:   string;

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
                '%': break;
            end;
            Inc(FSourcePtr);
        end;
        if DoCopy then UpdateOutStream(S);
    end;

var
    Found: Boolean;
begin
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
        Found := (Token = AToken);
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

function TCopyParser.NextToken: Char;
begin
    Result := SkipToNextToken(True, True);
end;

function TCopyParser.SkipToToken(AToken: Char): string;
begin
    Result := CopySkipToToken(AToken, False);
end;

function TCopyParser.SkipToNextToken(CopyBlanks, DoCopy: Boolean): Char;
begin
    SkipBlanks(CopyBlanks);
    FTokenPtr := FSourcePtr;
    Result := FSourcePtr^;
    if Result <> toEOF then Inc(FSourcePtr);
    if DoCopy then UpdateOutStream(FTokenPtr);
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
            '%': break;
        end;
        Inc(FSourcePtr);
    end;
    if DoCopy then UpdateOutStream(Start);
end;

procedure TCopyParser.UpdateOutStream(StartPos: PChar);
begin
    if FOutStream <> nil then
        FOutStream.WriteBuffer(StartPos^, FSourcePtr - StartPos);
end;

end.
