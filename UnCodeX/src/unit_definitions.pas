{-----------------------------------------------------------------------------
 Unit Name: unit_definitions
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   General definitions
 $Id: unit_definitions.pas,v 1.74 2003-12-20 12:22:36 elmuerte Exp $
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

unit unit_definitions;

interface

uses
  Hashes, unit_uclasses;

type
  TLogProc = procedure (msg: string);
  TLogClassProc = procedure (msg: string; uclass: TUClass = nil);

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
  procedure ReloadKeywords;

const
  APPTITLE = 'UnCodeX';
  APPVERSION = '157';
  {$IFDEF MSWINDOWS}
  APPPLATFORM = 'MS Windows';
  {$ENDIF}
  {$IFDEF LINUX}
  APPPLATFORM = 'GNU\Linux';
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  WILDCARD = '*.*';
  {$ENDIF}
  {$IFDEF LINUX}
  WILDCARD = '*';
  {$ENDIF}
  SOURCECARD = '*.uc';
  CLASSDIR = 'Classes';
  TEMPLATEPATH = 'Templates';
  DEFTEMPLATE = 'DocStyle2';
  UCXPACKAGEINFO = 'uncodex.ini';
  DEFAULTPDF = 'PackageDescriptions.ini';
  KEYWORDFILE1 = 'keywords1.list';
  KEYWORDFILE2 = 'keywords2.list';

  // Full Text search tokens
  FTS_LN_BEGIN = ' #';
  FTS_LN_END = ': ';
  FTS_LN_SEP = ',';

  // Tree icons
  ICON_PACKAGE = 0;
  ICON_PACKAGE_TAGGED = 1;
  ICON_CLASS = 2;
  ICON_CLASS_TAGGED = 3;

  CMD_HELP =  'Commandline options:'+#13+#10+
              '-config'#9#9#9'loads a diffirent config file (next argument)'+#13+#10+
              '-batch'#9#9#9'start UnCodeX in batch processing mode, the next'+#13+#10+
              #9#9#9'arguments must contain the batch order, '+#13+#10+
              #9#9#9'which can be on of the following:'+#13+#10+
              #9'rebuild'#9#9'rebuild class tree'+#13+#10+
              #9'analyse'#9#9'analyse all classes'+#13+#10+
              #9'createhtml'#9'create HTML output'+#13+#10+
              #9'htmlhelp'#9#9'create MS HTML Help file'+#13+#10+
              #9'close'#9#9'close UnCodeX'+#13+#10+
              #9'ext:<name>'#9#9'call an custom output module'+#13+#10+
              #9'--'#9#9'end of batch commands'+#13+#10+
              '-find'#9#9#9'find a class'+#13+#10+
              '-fts'#9#9#9'show full text search dialog'+#13+#10+
              '-help'#9#9#9'display this message'+#13+#10+
              '-hide'#9#9#9'hides UnCodeX'+#13+#10+
              '-handle'#9#9#9'Window handle'+#13+#10+
              '-open'#9#9#9'find and open a class'+#13+#10+
              '-reuse'#9#9#9'reuse a previous window'+#13+#10+
              '-tags'#9#9#9'display class properties';

var
  Keywords1: Hashes.TStringHash;
  Keywords2: Hashes.TStringHash;
  Log: TLogProc;
  LogClass: TLogClassProc;              

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils, Classes;

var
  sl: TStringList;

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
{$IFDEF LINUX}
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
{$IFDEF LINUX}
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
{$IFDEF LINUX}
var
  fs1, fs2: TFileStream;
begin
  result := false;
  try
    fs1 := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite	);
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

procedure ReloadKeywords;
var
  i: integer;
begin
  if (FileExists(ExtractFilePath(ParamStr(0))+KEYWORDFILE1)) then begin
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

initialization
  Keywords1 := Hashes.TStringHash.Create;
  Keywords2 := Hashes.TStringHash.Create;
  ReloadKeywords;
  if (Keywords1.ItemCount = 0) then begin
    Keywords1.Items['abstract'] := '-';
    Keywords1.Items['array'] := '-';
    Keywords1.Items['bool'] := '-';
    Keywords1.Items['break'] := '-';
    Keywords1.Items['byte'] := '-';
    Keywords1.Items['case'] := '-';
    Keywords1.Items['class'] := '-';
    Keywords1.Items['coerce'] := '-';
    Keywords1.Items['collapsecategories'] := '-';
    Keywords1.Items['config'] := '-';
    Keywords1.Items['const'] := '-';
    Keywords1.Items['continue'] := '-';
    Keywords1.Items['cpptext'] := '-';
    Keywords1.Items['defaultproperties'] := '-';
    Keywords1.Items['delegate'] := '-';
    Keywords1.Items['dependsOn'] := '-';
    Keywords1.Items['do'] := '-';
    Keywords1.Items['editconst'] := '-';
    Keywords1.Items['editinline'] := '-';
    Keywords1.Items['editinlinenew'] := '-';
    Keywords1.Items['else'] := '-';
    Keywords1.Items['enum'] := '-';
    Keywords1.Items['event'] := '-';
    Keywords1.Items['exec'] := '-';
    Keywords1.Items['expands'] := '-';
    Keywords1.Items['export'] := '-';
    Keywords1.Items['exportstructs'] := '-';
    Keywords1.Items['extends'] := '-';
    Keywords1.Items['false'] := '-';
    Keywords1.Items['final'] := '-';
    Keywords1.Items['float'] := '-';
    Keywords1.Items['for'] := '-';
    Keywords1.Items['foreach'] := '-';
    Keywords1.Items['function'] := '-';
    Keywords1.Items['globalconfig'] := '-';
    Keywords1.Items['hidecategories'] := '-';
    Keywords1.Items['if'] := '-';
    Keywords1.Items['ignores'] := '-';
    Keywords1.Items['input'] := '-';
    Keywords1.Items['instanced'] := '-';
    Keywords1.Items['int'] := '-';
    Keywords1.Items['latent'] := '-';
    Keywords1.Items['local'] := '-';
    Keywords1.Items['localized'] := '-';
    Keywords1.Items['name'] := '-';
    Keywords1.Items['native'] := '-';
    Keywords1.Items['nativereplication'] := '-';
    Keywords1.Items['new'] := '-';
    Keywords1.Items['noexport'] := '-';
    Keywords1.Items['noteditinlinenew'] := '-';
    Keywords1.Items['notplaceable'] := '-';
    Keywords1.Items['operator'] := '-';
    Keywords1.Items['optional'] := '-';
    Keywords1.Items['out'] := '-';
    Keywords1.Items['perobjectconfig'] := '-';
    Keywords1.Items['placeable'] := '-';
    Keywords1.Items['postoperator'] := '-';
    Keywords1.Items['preoperator'] := '-';
    Keywords1.Items['private'] := '-';
    Keywords1.Items['protected'] := '-';
    Keywords1.Items['reliable'] := '-';
    Keywords1.Items['replication'] := '-';
    Keywords1.Items['return'] := '-';
    Keywords1.Items['showcategories'] := '-';
    Keywords1.Items['simulated'] := '-';
    Keywords1.Items['singular'] := '-';
    Keywords1.Items['skip'] := '-';
    Keywords1.Items['spawn'] := '-';
    Keywords1.Items['state'] := '-';
    Keywords1.Items['static'] := '-';
    Keywords1.Items['string'] := '-';
    Keywords1.Items['struct'] := '-';
    Keywords1.Items['switch'] := '-';
    Keywords1.Items['then'] := '-';
    Keywords1.Items['transient'] := '-';
    Keywords1.Items['true'] := '-';
    Keywords1.Items['unreliable'] := '-';
    Keywords1.Items['until'] := '-';
    Keywords1.Items['var'] := '-';
    Keywords1.Items['while'] := '-';
    Keywords1.Items['within'] := '-';
    sl := TStringList.Create;
    Keywords1.Restart;
    try
      while (Keywords1.Next) do begin
        if (Keywords1.CurrentKey <> '') then sl.Add(Keywords1.CurrentKey)
      end;
      sl.SaveToFile(ExtractFilePath(ParamStr(0))+KEYWORDFILE2);
    finally
      sl.Free;
    end;
  end;
  // fill keyword table -- end
finalization
  Keywords1.Clear;
  Keywords2.Clear;
end.
