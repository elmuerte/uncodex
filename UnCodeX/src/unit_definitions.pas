{*******************************************************************************
  Name:
    unit_definitions.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    General definitions and independed utility functions

  $Id: unit_definitions.pas,v 1.125 2004-12-08 09:25:37 elmuerte Exp $
*******************************************************************************}

{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003,2004  Michiel Hendriks

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

unit unit_definitions;

{$I defines.inc}

interface

uses
  Hashes, unit_uclasses, Classes, IniFiles;

type
  TLogProc = procedure (msg: string);
  TLogClassProc = procedure (msg: string; uclass: TUClass = nil);
  TExternaComment = function(ref: string): string;

  // Used for -reuse
  TRedirectStruct = packed record
    Find: string[64];
    OpenFind: boolean;
    OpenTags: boolean;
    Batch: string[255];
    NewHandle: integer;
    OpenFTS: boolean;
  end;

  // repeat a string
  function StrRepeat(line: string; count: integer): string;
  function iFindFile(filename: string): string;
  function iFindDir(dirname: string; var output: string): boolean;
  function CopyFile(filename, target: string): boolean;
  function GetFiles(path: string; Attr: Integer; var files: TStringList): boolean;
  function FindFiles(base, path, mask: string; Attr: Integer; var files: TStringList; append: boolean = false): boolean;
  function ExtractBaseName(filename: string): string;

  procedure ReloadKeywords;

  procedure guard(s: string);
  procedure unguard;
  procedure resetguard();

  function RetExternalComment(ref: string): string;
  procedure SetExtCommentFile(ini: string);

const
  APPTITLE        = 'UnCodeX';
  APPVERSION      = '214';
  {$IFDEF MSWINDOWS}
  APPPLATFORM     = 'MS Windows';
  {$ENDIF}
  {$IFDEF LINUX}
  APPPLATFORM     = 'GNU\Linux';
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  WILDCARD        = '*.*';
  {$ENDIF}
  {$IFDEF UNIX}
  WILDCARD        = '*';
  {$ENDIF}
  UCEXT           = '.uc';
  PKGCFG          = '.upkg';
  SOURCECARD      = '*'+UCEXT;
  {$IFDEF UNIX} // because the find is not case-insensitive
  SOURCECARD_1    = '*.UC';
  SOURCECARD_2    = '*.Uc';
  SOURCECARD_3    = '*.uC';
  {$ENDIF}
  CLASSDIR        = 'Classes';
  TEMPLATEPATH    = 'Templates';
  DEFTEMPLATE     = 'DocStyle2';
  UCXPACKAGEINFO  = 'uncodex.ini';
  DEFAULTPDF      = 'PackageDescriptions.ini';
  KEYWORDFILE1    = 'keywords1.list';
  KEYWORDFILE2    = 'keywords2.list';
  DEFAULTECF      = 'ExternalComments.ini';

  UPSEXT          = '.ups'; // uncodex pascal script
  UPSDIR          = 'Macros'; // default dir where Macros can be found

  // Full Text search tokens
  FTS_LN_BEGIN    = ' #';
  FTS_LN_END      = ': ';
  FTS_LN_SEP      = ',';

  // Tree icons
  ICON_PACKAGE        = 0;
  ICON_PACKAGE_TAGGED = 1;
  ICON_CLASS          = 2;
  ICON_CLASS_TAGGED   = 3;

var
  Keywords1: Hashes.TStringHash;
  Keywords2: Hashes.TStringHash;
  Log: TLogProc;
  LogClass: TLogClassProc;
  GuardStack: TStringList;

implementation

uses
{$IFDEF FPC}
   unit_fpc_compat,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils;

var
  sl, TmpExtCmt: TStringList;
  ExtCommentIni: TMemIniFile;

function StrRepeat(line: string; count: integer): string;
begin
  result := '';
  while (count > 0) do begin
    result := result+line;
    Dec(count);
  end;
end;

function iFindFile(filename: string): string;
{$IFDEF MSWINDOWS}
begin
  result := LowerCase(ExpandFileName(filename));
end;
{$ENDIF}
{$IFDEF UNIX}
var
  fcm: TFilenameCaseMatch;
begin
  result := ExpandFileNameCase(filename, fcm);
  if (fcm = mkAmbiguous) then begin
    Log('Warning: two or more matches for '+filename);
  end;
end;
{$ENDIF}

function iFindDir(dirname: string; var output: string): boolean;
{$IFDEF MSWINDOWS}
begin
  result := DirectoryExists(dirname);
  output := LowerCase(dirname);
end;
{$ENDIF}
{$IFDEF UNIX}
var
  basename: string;
begin
  if (Length(dirname) = 0) then begin
    result := false;
    exit;
  end;
  if (DirectoryExists(dirname)) then begin
    output := dirname;
    result := true;
  end
  else begin
    dirname := ExcludeTrailingPathDelimiter(dirname);
    basename := ExtractFileName(dirname);
    dirname := ExtractFilePath(dirname);
    result := iFindDir(dirname, output); // find the parent dir
    if (result) then begin
      output := iFindFile(basename); // find the file
      if (output <> '') then output := output+PATHDELIM;
      result := (output <> '');
    end;
  end;
end;
{$ENDIF}

function CopyFile(filename, target: string): boolean;
{$IFDEF MSWINDOWS}
begin
  result := Windows.CopyFile(PChar(filename), PChar(target), false);
end;
{$ENDIF}
{$IFDEF UNIX}
var
  fs1, fs2: TFileStream;
begin
  result := false;
  try
    fs1 := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite  );
    fs2 := TFileStream.Create(target, fmCreate or fmShareExclusive);
    try
      fs2.CopyFrom(fs1, fs1.Size);
      result := true;
    finally
      fs1.Free;
      fs2.Free;
    end;
  except;
  end;
end;
{$ENDIF}

procedure guard(s: string);
begin
  GuardStack.Append(s);
end;

procedure unguard;
begin
  GuardStack.Delete(GuardStack.Count-1);
end;

procedure resetguard();
begin
  GuardStack.Clear;
  GuardStack.Sorted := false;
  GuardStack.Duplicates := dupIgnore;
end;

var
  kwl1, kwl2: boolean;

procedure ReloadKeywords;
var
  i: integer;
begin
  if (FileExists(ExtractFilePath(ParamStr(0))+KEYWORDFILE1)) then begin
    kwl1 := true;
    Keywords1.Clear;
    sl := TStringList.Create;
    try
      sl.LoadFromFile(ExtractFilePath(ParamStr(0))+KEYWORDFILE1);
      for i := 0 to sl.Count-1 do begin
        if (sl[i] <> '') then Keywords1.Items[LowerCase(sl[i])] := '-';
      end;
    finally
      sl.Free;
    end;
  end;
  if (FileExists(ExtractFilePath(ParamStr(0))+KEYWORDFILE2)) then begin
    kwl2 := true;
    Keywords2.Clear;
    sl := TStringList.Create;
    try
      sl.LoadFromFile(ExtractFilePath(ParamStr(0))+KEYWORDFILE2);
      for i := 0 to sl.Count-1 do begin
        if (sl[i] <> '') then Keywords2.Items[LowerCase(sl[i])] := '-';
      end;
    finally
      sl.Free;
    end;
  end;
end;

function RetExternalComment(ref: string): string;
begin
  if (ExtCommentIni = nil) then exit;
  TmpExtCmt.Clear;
  ExtCommentIni.ReadSectionValues(ref, TmpExtCmt);
  result := trim(TmpExtCmt.Text);
end;

procedure SetExtCommentFile(ini: string);
begin
  if (not FileExists(ini)) then exit;
  if (ExtCommentIni <> nil) then FreeAndNil(ExtCommentIni);
  ExtCommentIni := TMemIniFile.Create(ini);
end;

function GetFiles(path: string; Attr: Integer; var files: TStringList): boolean;
var
  sr: TSearchRec;
  dir: string;
begin
  files.Clear;
  dir := extractfilepath(path);
  if (FindFirst(path, Attr, sr) = 0) then begin
    repeat
      if ((sr.Name = '.') or (sr.Name = '..')) then continue;
      Files.Add(dir+sr.Name);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  result := files.count > 0;
end;

function FindFiles(base, path, mask: string; Attr: Integer; var files: TStringList; append: boolean = false): boolean;
var
  sr: TSearchRec;
begin
  if ((path = '') and (not append)) then files.Clear;
  // pass #1 - sub dirs
  if (FindFirst(base+PathDelim+path+WILDCARD, faDirectory, sr) = 0) then begin
    repeat
      if ((sr.Name = '.') or (sr.Name = '..')) then continue;
      FindFiles(base, path+sr.Name+PathDelim, mask, Attr, files);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  // pass #2 - files
  if (FindFirst(base+PathDelim+path+mask, Attr, sr) = 0) then begin
    repeat
      if ((sr.Name = '.') or (sr.Name = '..')) then continue;
      Files.Add(path+sr.Name);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  result := files.count > 0;
end;

function ExtractBaseName(filename: string): string;
var
  ext: string;
begin
  result := ExtractFileName(filename);
  ext := ExtractFileExt(filename);
  result := Copy(result, 1, length(result)-length(ext));
end;

initialization
  GuardStack := TStringList.Create;
  kwl1 := false;
  kwl2 := false;
  Keywords1 := Hashes.TStringHash.Create;
  Keywords2 := Hashes.TStringHash.Create;
  ReloadKeywords;
  if (not kwl1) then begin
    Keywords1.Items['array'] := '-';
    Keywords1.Items['bool'] := '-';
    Keywords1.Items['break'] := '-';
    Keywords1.Items['byte'] := '-';
    Keywords1.Items['case'] := '-';
    Keywords1.Items['class'] := '-';
    Keywords1.Items['const'] := '-';
    Keywords1.Items['cpptext'] := '-';
    Keywords1.Items['defaultproperties'] := '-';
    Keywords1.Items['delegate'] := '-';
    Keywords1.Items['else'] := '-';
    Keywords1.Items['enum'] := '-';
    Keywords1.Items['event'] := '-';
    Keywords1.Items['expands'] := '-';
    Keywords1.Items['extends'] := '-';
    Keywords1.Items['false'] := '-';
    Keywords1.Items['float'] := '-';
    Keywords1.Items['for'] := '-';
    Keywords1.Items['foreach'] := '-';
    Keywords1.Items['function'] := '-';
    Keywords1.Items['if'] := '-';
    Keywords1.Items['ignores'] := '-';
    Keywords1.Items['int'] := '-';
    Keywords1.Items['local'] := '-';
    Keywords1.Items['name'] := '-';
    Keywords1.Items['none'] := '-';
    Keywords1.Items['operator'] := '-';
    Keywords1.Items['postoperator'] := '-';
    Keywords1.Items['preoperator'] := '-';
    Keywords1.Items['reliable'] := '-';
    Keywords1.Items['replication'] := '-';
    Keywords1.Items['return'] := '-';
    Keywords1.Items['state'] := '-';
    Keywords1.Items['string'] := '-';
    Keywords1.Items['struct'] := '-';
    Keywords1.Items['super'] := '-';
    Keywords1.Items['switch'] := '-';
    Keywords1.Items['true'] := '-';
    Keywords1.Items['unreliable'] := '-';
    Keywords1.Items['var'] := '-';
    Keywords1.Items['while'] := '-';

    {$IFNDEF DONT_SAVE_KEYWORDS}
    sl := TStringList.Create;
    Keywords1.Restart;
    try
      while (Keywords1.Next) do begin
        if (Keywords1.CurrentKey <> '') then sl.Add(Keywords1.CurrentKey)
      end;
      sl.SaveToFile(ExtractFilePath(ParamStr(0))+KEYWORDFILE1);
    finally
      sl.Free;
    end;
    {$ENDIF}
  end;

  if (not kwl2) then begin
    Keywords2.Items['abstract'] := '-';
    Keywords2.Items['auto'] := '-';
    Keywords2.Items['cache'] := '-';
    Keywords2.Items['cacheexempt'] := '-';
    Keywords2.Items['coerce'] := '-';
    Keywords2.Items['collapsecategories'] := '-';
    Keywords2.Items['config'] := '-';
    Keywords2.Items['dependson'] := '-';
    Keywords2.Items['edfindable'] := '-';
    Keywords2.Items['editconst'] := '-';
    Keywords2.Items['editinlinenew'] := '-';
    Keywords2.Items['exec'] := '-';
    Keywords2.Items['export'] := '-';
    Keywords2.Items['exportstructs'] := '-';
    Keywords2.Items['final'] := '-';
    Keywords2.Items['globalconfig'] := '-';
    Keywords2.Items['hidecategories'] := '-';
    Keywords2.Items['hidedropdown'] := '-';
    Keywords2.Items['init'] := '-';
    Keywords2.Items['instanced'] := '-';
    Keywords2.Items['iterator'] := '-';
    Keywords2.Items['localized'] := '-';
    Keywords2.Items['native'] := '-';
    Keywords2.Items['nativereplication'] := '-';
    Keywords2.Items['noteditinlinenew'] := '-';
    Keywords2.Items['noexport'] := '-';
    Keywords2.Items['notplaceable'] := '-';
    Keywords2.Items['optional'] := '-';
    Keywords2.Items['out'] := '-';
    Keywords2.Items['perobjectconfig'] := '-';
    Keywords2.Items['placeable'] := '-';
    Keywords2.Items['private'] := '-';
    Keywords2.Items['protected'] := '-';
    Keywords2.Items['showcategories'] := '-';
    Keywords2.Items['simulated'] := '-';
    Keywords2.Items['static'] := '-';
    Keywords2.Items['transient'] := '-';
    Keywords2.Items['within'] := '-';

    {$IFNDEF DONT_SAVE_KEYWORDS}
    sl := TStringList.Create;
    Keywords2.Restart;
    try
      while (Keywords2.Next) do begin
        if (Keywords2.CurrentKey <> '') then sl.Add(Keywords2.CurrentKey)
      end;
      sl.SaveToFile(ExtractFilePath(ParamStr(0))+KEYWORDFILE2);
    finally
      sl.Free;
    end;
    {$ENDIF}
  end;
  // fill keyword table -- end
  TmpExtCmt := TStringList.Create;
finalization
  Keywords1.Clear;
  Keywords2.Clear;
  GuardStack.Free;
  TmpExtCmt.Free;
  if (Assigned(ExtCommentIni)) then ExtCommentIni.Free;
end.
