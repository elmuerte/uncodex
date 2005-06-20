{*******************************************************************************
  Name:
    unit_pputils
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Various utility functions

  $Id: unit_pputils.pas,v 1.5 2005-06-20 12:11:03 elmuerte Exp $
*******************************************************************************}

{
  UCPP - UnrealScript Code PreProcessor
  Copyright (C) 2005  Michiel Hendriks
  
  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit unit_pputils;

{$I ../defines.inc}

interface

uses
  Classes, SysUtils;

  function GetToken(var input: string; delim: TSysCharSet; nocut: boolean = false): string;
  procedure ErrorMessage(msg: string);
  procedure WarningMessage(msg: string);
  procedure DebugMessage(msg: string);
  {$IFDEF FPC}
  function BoolToStr(b : boolean; useString: boolean = false): string;
  {$ENDIF}

var
  ErrorCount: integer = 0;
  WarnCount: integer = 0;
  debug_mode: boolean = false;

implementation

function GetToken(var input: string; delim: TSysCharSet; nocut: boolean = false): string;
var
  i,j: integer;
begin
  i := 1;
  while ((i <= length(input)) and (input[i] in delim)) do Inc(i);
  j := i;
  while ((j <= length(input)) and (not (input[j] in delim))) do Inc(j);
  result := copy(input, i, j-i);
  if (not nocut) then begin
    delete(input, 1, j);
  end;
end;

procedure ErrorMessage(msg: string);
begin
  Writeln(ErrOutput, 'Error: '+msg);
  Inc(ErrorCount);
end;

procedure WarningMessage(msg: string);
begin
  Writeln(ErrOutput, 'Warning: '+msg);
  Inc(WarnCount);
end;

procedure DebugMessage(msg: string);
begin
  if (debug_mode) then Writeln('DEBUG: '+msg);
end;

{$IFDEF FPC}
function BoolToStr(b: boolean; useString: boolean = false): string;
begin
  if (useString) then begin
    if (b) then result := 'True'
    else result := 'False';
  end
  else begin
    if (b) then result := '1'
    else result := '0';
  end;
end;
{$ENDIF}

end.
