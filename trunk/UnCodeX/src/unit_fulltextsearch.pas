{*******************************************************************************
	Name:
        unit_fulltextsearch.pas
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        Full text search thread. Includes support for regular expressions.

    $Id: unit_fulltextsearch.pas,v 1.15 2004-10-18 15:36:06 elmuerte Exp $
*******************************************************************************}

{
	UnCodeX - UnrealScript source browser & documenter
	Copyright (C) 2003	Michiel Hendriks

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

unit unit_fulltextsearch;

{$I defines.inc}

interface

uses
	Windows, SysUtils, Classes, RegExpr, ComCtrls, unit_uclasses,
    unit_outputdefs, unit_searchform;

type
	TSearchThread = class(TThread)
		PackageList: TUPackageList;
		Tree: TTreeView;
		Status: TStatusReport;
		re: TRegExpr;
		seltreenode: TTreeNode;
		Total: integer;
		Matches: integer;
		RealExpr: string;
		config: TClassSearch;
		curpos1: integer;
		curclass: TUClass;
		function SearchFile(uclass: TUClass): boolean;
		function GetNextClass(): TUClass;
	public
		constructor Create(var sc: TClassSearch; Status: TStatusReport); overload;
		destructor Destroy; override;
		procedure Execute; override;
	end;

	TSearchStackItem = record
		offset: integer;
		uclass:	TUClass;
	end;

implementation

uses
	unit_definitions;

var
	SearchStack: array of TSearchStackItem;

const
	BUFFSIZE = 4096;

constructor TSearchThread.Create(var sc: TClassSearch; Status: TStatusReport);
begin
	Self.Tree := sc.searchtree;
	Self.Status := Status;
	Self.PackageList := PackageList;
	Self.config := sc;

	re := TRegExpr.Create;
	re.Expression := config.query;
	RealExpr := config.query;
	if (not config.isRegex) then re.Expression := UpperCase(re.Expression);
	re.ModifierI := true;
	Matches := 0;
	curpos1 := 0;
	Total := Tree.Items.Count;
	case config.Scope of
		1:		if (Tree.Selected <> nil) then begin
					Total := Total-Tree.Selected.AbsoluteIndex;
					curpos1 := Tree.Selected.AbsoluteIndex+1;
				end;
		2:		begin
					if (Tree.Selected <> nil) then begin
						curclass := TUClass(Tree.Selected.Data);
					end;
					SetLength(SearchStack, 1);
					SearchStack[High(SearchStack)].offset := 0;
					SearchStack[High(SearchStack)].uclass := curclass;
				end;
		3:		if (Tree.Selected <> nil) then begin
					curclass := TUClass(Tree.Selected.Data);
				end;
	end;
	if (not sc.isFindFirst) then sc.Wrapped := false;
	inherited Create(true);
end;

destructor TSearchThread.Destroy;
begin
	SearchStack := nil;
	re.Free;
end;

procedure TSearchThread.Execute;
var
	ccount: 	integer;
	stime: 		Cardinal;
	uclass: 	TUClass;
	res: 		boolean;
begin
	try
		stime := GetTickCount();
		ccount := 0;
		uclass := GetNextClass();
		while (uclass <> nil) do begin
			Status('Searching file '+uclass.filename+' ...', round((ccount+1)/total*100));
			res := SearchFile(uclass);
			if (res and config.isFindFirst) then begin
				break;
			end;
			inc(ccount);
			uclass := GetNextClass();
			if (Self.Terminated) then break;
		end;
		if (Matches = 0) then	Status('Nothing found for '''+RealExpr+'''. Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds', 100)
			else Status(IntToStr(Matches)+' matches found for '''+RealExpr+'''. Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds', 100);
	except
		on E: Exception do Log('Unhandled exception: '+E.Message);
	end;
end;

function TSearchThread.GetNextClass: TUClass;
var
	obj: TObject;
begin
	result := nil;
	case config.Scope of
		0,1:begin // all or from selection
					while (curpos1 < Tree.Items.Count) do begin
						if (Tree.Items[curpos1].data = nil) then begin
							Inc(curpos1);
							continue;
						end;
						obj := TObject(Tree.Items[curpos1].data);
						if (obj.ClassType = TUClass) then begin
							result := TUClass(obj);
							Inc(curpos1);
							exit;
						end;
						Inc(curpos1);
					end;
				end;
		2:	begin	// subclasses
					while (SearchStack[High(SearchStack)].uclass.children.Count <= SearchStack[High(SearchStack)].offset) do begin
						if (High(SearchStack) < 1) then exit;
						SetLength(SearchStack, High(SearchStack));
					end;
					result := SearchStack[High(SearchStack)].uclass;
					result := result.children[SearchStack[High(SearchStack)].offset];
					Inc(SearchStack[High(SearchStack)].offset); // increase offset
					// add new
					if (result.children.Count > 0) then begin
						SetLength(SearchStack, Length(SearchStack)+1);
						SearchStack[High(SearchStack)].offset := 0;
						SearchStack[High(SearchStack)].uclass := result;
					end;
				end;
		3:	begin // parent classes
					curclass := curclass.parent;
					result := curclass;
				end;
	end;
end;

function TSearchThread.SearchFile(uclass: TUClass): boolean;
var
	fs: 		TFileStream;
	buffer,
    line: 		array[0..BUFFSIZE-1] of char;
	linecnt,
    lineptr,
    bufcnt: 	integer;
	filename: 	string;


	procedure Grep(line: string);
	var
		i: integer;
	begin
		if (config.isRegex) then begin
			if (re.Exec(line)) then begin
				Inc(Matches);
				result := true;
				LogClass(uclass.filename+FTS_LN_BEGIN+IntToStr(linecnt)+FTS_LN_SEP+IntToStr(re.MatchPos[0])+FTS_LN_END+line, uclass);
			end;
		end
		else begin
			i := Pos(re.Expression, UpperCase(line));
			if (i > 0) then begin
				Inc(Matches);
				result := true;
				LogClass(uclass.filename+FTS_LN_BEGIN+IntToStr(linecnt)+FTS_LN_SEP+IntToStr(i)+FTS_LN_END+line, uclass);
			end;
		end;
	end;

	procedure RegexBuffer(buffer: array of char);
	var
		i: integer;
	begin
		for i := 0 to bufcnt-1 do begin
			if (buffer[i] = #10) then begin
				Inc(linecnt);
				line[lineptr] := #0;
				lineptr := 0;
				Grep(line);
			end
			else if (buffer[i] = #13) then begin
				// ignore
			end
			else if (buffer[i] = #9) then begin
				line[lineptr] := ' ';
				Inc(lineptr);
			end
			else begin
				line[lineptr] := buffer[i];
				Inc(lineptr);
				if (lineptr >= BUFFSIZE) then begin
					line[lineptr] := #0;
					lineptr := 0;
					Grep(line);
				end;
			end;
		end;
	end;

begin
	result := false;
	linecnt := 0;
	lineptr := 0;
	filename := uclass.package.path+PATHDELIM+uclass.filename;
	if (not FileExists(filename)) then exit;
	fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
	try
		bufcnt := BUFFSIZE;
		while (fs.Position+bufcnt < fs.Size) do begin
			fs.ReadBuffer(buffer, bufcnt);
			RegexBuffer(buffer);
		end;
		// read remainder
		if (fs.Position < fs.Size) then begin
			bufcnt := fs.Size-fs.Position;
			fs.ReadBuffer(buffer, bufcnt);
			RegexBuffer(buffer);
		end;
	finally
		fs.Free;
	end;
end;

end.
