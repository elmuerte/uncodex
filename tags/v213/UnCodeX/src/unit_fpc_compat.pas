{*******************************************************************************
    Name:
        unit_definitions.pas
    Author(s):
        Michiel 'El Muerte' Hendriks
    Purpose:
        FreePascalCompile compatibility unit

    $Id: unit_fpc_compat.pas,v 1.3 2004-10-20 14:19:28 elmuerte Exp $
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

end.
