{*******************************************************************************
  Name:
    unit_definitions.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    FreePascalCompile compatibility unit

  $Id: unit_fpc_compat.pas,v 1.7 2005-03-18 08:42:20 elmuerte Exp $
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

unit unit_fpc_compat;

{$I defines.inc}

interface
  function ForceDirectories(Dir: string): Boolean;

type
  TFilenameCaseMatch = (mkNone, mkExactMatch, mkSingleMatch, mkAmbiguous);

  function ExpandFileNameCase(const FileName: string; out MatchFound: TFilenameCaseMatch): string;

  
implementation

uses
  SysUtils;

function ForceDirectories(Dir: string): Boolean;
begin
  result := true;
  Dir := ExcludeTrailingPathDelimiter(Dir);
  {$IFDEF MSWINDOWS}
  if (Length(Dir) < 3) or DirectoryExists(Dir) or (ExtractFilePath(Dir) = Dir) then exit;
  {$ENDIF}
  {$IFDEF LINUX}
  if (Length(Dir) = 0) or DirectoryExists(Dir) then Exit;
  {$ENDIF}
  Result := ForceDirectories(ExtractFilePath(Dir)) and CreateDir(Dir);
end;

// tries to find a file if the case wasn't correct
// not 100% the same as Borland's implementation, but it suits out perpose
function ExpandFileNameCase(const FileName: string; out MatchFound: TFilenameCaseMatch): string;
var
  sr: TSearchRec;
  path, base: string;
  found: boolean;
  {$IFDEF LINUX}
  i: integer;
  first: string;
  {$ENDIF}
begin
  path := ExtractFilePath(filename);
  base := ExtractFileName(filename);
  MatchFound := mkNone;

  // first find the path
  if (not DirectoryExists(path)) then begin
    path := ExcludeTrailingPathDelimiter(path);
    path := ExpandFileNameCase(path, MatchFound);
    if MatchFound = mkNone then exit; // path doesn't exist
    path := IncludeTrailingPathDelimiter(path);
  end;

  // try if file exists
  try
    if FindFirst(path + base, faAnyFile, sr)= 0 then begin
      // in case path was corrected
      if not (MatchFound in [mkSingleMatch, mkAmbiguous]) then MatchFound := mkExactMatch;
      Result := path + sr.Name;
      Exit;
    end;
  finally
    FindClose(SR);
  end;

  found := false;

  {$IFDEF LINUX}
  first := LowerCase(base[1]);
  for i := 0 to 1 do begin
    if (FindFirst(path + first + '*', faAnyFile, SR) = 0) then begin
      repeat
        if (CompareText(sr.name, base) = 0) then begin
          if (found) then begin
            MatchFound := mkAmbiguous;
            exit;
          end
          else begin
            result := path+sr.name;
            found := true;
          end;
        end;
      until (FindNext(sr) <> 0);
    end;
    if (UpperCase(base[1]) = first) then break;
    first := UpperCase(base[1]);
  end;
  {$ENDIF}

  if (MatchFound <> mkAmbiguous) then begin
    if (found) then MatchFound := mkExactMatch
    else MatchFound := mkNone;
  end;
end;

end.
