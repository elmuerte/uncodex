{-----------------------------------------------------------------------------
 Unit Name: unit_fulltextsearch
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Full Text Search (+ regular expressions) thread
 $Id: unit_fulltextsearch.pas,v 1.9 2003-11-04 19:35:27 elmuerte Exp $
-----------------------------------------------------------------------------}
{
    UnCodeX - UnrealScript source browser & documenter
    Copyright (C) 2003  Michiel Hendriks

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

unit unit_fulltextsearch;

interface

uses
  Windows, SysUtils, Classes, RegExpr, ComCtrls, unit_uclasses, unit_outputdefs;

type
  TSearchThread = class(TThread)
    PackageList: TUPackageList;
    Tree: TTreeView;
    Status: TStatusReport;
    re: TRegExpr;
    IsRegex: boolean;
    Total: integer;
    Matches: integer;
    RealExpr: string;
    function SearchFile(uclass: TUClass): boolean;
    procedure ExecuteFTS;
    procedure ExecuteBody;
  public
    constructor Create(PackageList: TUPackageList; Status: TStatusReport; expr: string; IsRegEx: boolean = true; total: integer = -1); overload;
    constructor Create(Tree: TTreeView; Status: TStatusReport; expr: string; IsRegEx: boolean = true); overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;

implementation

uses
  unit_definitions;

const
  BUFFSIZE = 4096;

constructor TSearchThread.Create(PackageList: TUPackageList; Status: TStatusReport; expr: string; IsRegEx: boolean = true; total: integer = -1);
begin
  Self.PackageList := PackageList;
  Self.Status := Status;
  Self.IsRegex := IsRegEx;
  Self.Total := Total;
  re := TRegExpr.Create;
  re.Expression := expr;
  RealExpr := expr;
  if (not IsRegEx) then re.Expression := UpperCase(re.Expression);
  re.ModifierI := true;
  Matches := 0;
  inherited Create(true);
end;

constructor TSearchThread.Create(Tree: TTreeView; Status: TStatusReport; expr: string; IsRegEx: boolean = true);
begin
  Self.Tree := Tree;
  Self.Status := Status;
  Self.IsRegex := IsRegEx;
  re := TRegExpr.Create;
  re.Expression := expr;
  RealExpr := expr;
  if (not IsRegEx) then re.Expression := UpperCase(re.Expression);
  re.ModifierI := true;
  Matches := 0;
  inherited Create(true);
end;

destructor TSearchThread.Destroy;
begin
  re.Free;
end;

procedure TSearchThread.Execute;
begin
  if (Tree <> nil) then ExecuteBody
  else if (PackageList <> nil) then ExecuteFTS;
end;

procedure TSearchThread.ExecuteFTS;
var
  i,j, ccount: integer;
  stime: Cardinal;
begin
  stime := GetTickCount();
  ccount := 0;
  for i := 0 to PackageList.Count-1 do begin
    for j := 0 to PackageList[i].classes.Count-1 do begin
      Status('Searching file '+PackageList[i].classes[j].filename+' ...', round((ccount+1)/total*100));
      SearchFile(PackageList[i].classes[j]);
      Inc(ccount);
      if (Self.Terminated) then break;
    end;
    if (Self.Terminated) then break;
  end;
  Status(IntToStr(Matches)+' matches found for '''+RealExpr+'''. Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds', 100);
end;

procedure TSearchThread.ExecuteBody;
var
  i,j, ccount: integer;
  stime: Cardinal;
  uclass: TUClass;
begin
  uclass := nil;
  stime := GetTickCount();
  ccount := Tree.Items.Count;
  if (Tree.Selected <> nil) then j := Tree.Selected.AbsoluteIndex+1
    else j := 0;
  for i := j to ccount-1 do begin
    if (TObject(Tree.Items[i].Data).ClassType = TUClass) then begin
      uclass := TUClass(Tree.Items[i].Data);
      Status('Searching file '+uclass.filename+' ...', round((i+1)/ccount*100));
      if (SearchFile(uclass)) then begin
        Tree.Select(Tree.Items[i]);
        break;
      end;
    end;
    if (Self.Terminated) then break;
  end;
  if ((Tree.Selected = nil) or (Matches = 0)) then  Status('Nothing found for '''+RealExpr+'''. Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds', 100)
    else Status(IntToStr(Matches)+' matches found for '''+RealExpr+''' in '+uclass.name+'. Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds');
end;

function TSearchThread.SearchFile(uclass: TUClass): boolean;
var
  fs: TFileStream;
  buffer, line: array[0..BUFFSIZE-1] of char;
  linecnt, lineptr, bufcnt: integer;
  filename: string;


  procedure Grep(line: string);
  var
    i: integer;
  begin
    if (IsRegex) then begin
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
  filename := uclass.package.path+PATHDELIM+CLASSDIR+PATHDELIM+uclass.filename;
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
