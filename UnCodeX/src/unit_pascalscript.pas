{*******************************************************************************
  Name:
    unit_pascalscript.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Global PascalScript routines and functionality

  $Id: unit_pascalscript.pas,v 1.14 2004-12-28 15:55:58 elmuerte Exp $
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
unit unit_pascalscript;

{$I defines.inc}

interface

uses
  SysUtils, uPSComponent, uPSUtils;

  // pre-compile routines
  procedure RegisterPS(ps: TPSScript);

implementation

uses unit_definitions;

procedure RegisterPS(ps: TPSScript);
begin
  { string functions }
  ps.AddFunction(@Format, 'function Format(const Format: string; const Args: array of const): string;');
  ps.AddFunction(@CompareStr, 'function CompareStr(const S1, S2: string): Integer;');
  ps.AddFunction(@CompareText, 'function CompareText(const S1, S2: string): Integer;');
  ps.AddFunction(@SameText, 'function SameText(const S1, S2: string): Boolean;');
  ps.AddFunction(@TrimLeft, 'function TrimLeft(const S: string): string;');
  ps.AddFunction(@TrimRight, 'function TrimRight(const S: string): string;');
  ps.AddFunction(@QuotedStr, 'function QuotedStr(const S: string): string;');
  ps.AddFunction(@IntToHex, 'function IntToHex(Value: Integer; Digits: Integer): string;');
  ps.AddFunction(@StrToBool, 'function StrToBool(const S: string): Boolean;');
  ps.AddFunction(@StrToBoolDef, 'function StrToBoolDef(const S: string; const Default: Boolean): Boolean;');
  ps.AddFunction(@BoolToStr, 'function BoolToStr(B: Boolean; UseBoolStrs: Boolean): string;');
  ps.Comp.AddTypeS('TReplaceFlags_', '(rfReplaceAll, rfIgnoreCase);');
  ps.Comp.AddTypeS('TReplaceFlags', 'set of TReplaceFlags_;');
  ps.AddFunction(@StringReplace, 'function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;');


  { file access }
  ps.Comp.AddTypeS('TCharSet', 'set of Char');
  ps.AddFunction(@FileAge, 'function FileAge(const FileName: string): Integer;');
  ps.AddFunction(@FileExists, 'function FileExists(const FileName: string): Boolean;');
  ps.AddFunction(@DirectoryExists, 'function DirectoryExists(const Directory: string): Boolean;');
  ps.AddFunction(@ForceDirectories, 'function ForceDirectories(Dir: string): Boolean;');
  ps.AddFunction(@FileIsReadOnly, 'function FileIsReadOnly(const FileName: string): Boolean;');
  ps.AddFunction(@DeleteFile, 'function DeleteFile(const FileName: string): Boolean;');
  ps.AddFunction(@RenameFile, 'function RenameFile(const OldName, NewName: string): Boolean;');
  ps.AddFunction(@ChangeFileExt, 'function ChangeFileExt(const FileName, Extension: string): string;');
  ps.AddFunction(@ExtractFilePath, 'function ExtractFilePath(const FileName: string): string;');
  ps.AddFunction(@ExtractFileDir, 'function ExtractFileDir(const FileName: string): string;');
  ps.AddFunction(@ExtractFileDrive, 'function ExtractFileDrive(const FileName: string): string;');
  ps.AddFunction(@ExtractFileName, 'function ExtractFileName(const FileName: string): string;');
  ps.AddFunction(@ExtractFileExt, 'function ExtractFileExt(const FileName: string): string;');
  ps.AddFunction(@ExpandFileName, 'function ExpandFileName(const FileName: string): string;');
  ps.AddFunction(@ExtractRelativePath, 'function ExtractRelativePath(const BaseName, DestName: string): string;');
  ps.AddFunction(@FileSearch, 'function FileSearch(const Name, DirList: string): string;');
  ps.AddFunction(@DiskFree, 'function DiskFree(Drive: Byte): Int64;');
  ps.AddFunction(@DiskSize, 'function DiskSize(Drive: Byte): Int64;');
  ps.AddFunction(@FileDateToDateTime, 'function FileDateToDateTime(FileDate: Integer): TDateTime;');
  ps.AddFunction(@DateTimeToFileDate, 'function DateTimeToFileDate(DateTime: TDateTime): Integer;');
  ps.AddFunction(@CreateDir, 'function CreateDir(const Dir: string): Boolean;');
  ps.AddFunction(@RemoveDir, 'function RemoveDir(const Dir: string): Boolean;');
  
  ps.AddFunction(@GetFiles, 'function GetFiles(path: string; Attr: Integer; var files: TStringList): boolean;');
  ps.AddFunction(@ExtractBaseName, 'function ExtractBaseName(filename: string): string;');

  { Commandline support }
  ps.AddFunction(@FindCmdLineSwitch, 'function FindCmdLineSwitch(const Switch: string; const Chars: TCharSet; IgnoreCase: Boolean): Boolean;');
  ps.AddFunction(@ParamCount, 'function ParamCount: Integer;');
  ps.AddFunction(@ParamStr, 'function ParamStr(Index: Integer): string;');

  { Misc }
  //TODO: fix
  ps.Comp.AddTypeS('TLogType', '(ltInfo, ltWarn, ltError, ltSearch);');
  ps.AddFunction(@Log, 'procedure Log(msg: string);');
  ps.AddFunction(@Log, 'procedure LogType(msg: string; mt: TLogType);');
  ps.AddFunction(@Log, 'procedure LogTypeObject(msg: string; mt: TLogType; obj: TObject);');
  ps.AddFunction(@CreateLogEntry, 'function CreateLogEntry(filename: string; line: integer; pos: integer; obj: TObject): TLogEntry;');
  ps.AddFunction(@ResolveFilename, 'function ResolveFilename(uclass: TUClass; udecl: TUDeclaration): string;');
end;

end.
