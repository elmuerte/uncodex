{*******************************************************************************
  Name:
    unit_comment2doc.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Convert comments to documentation

  $Id: unit_comment2doc.pas,v 1.2 2006/01/14 21:26:09 elmuerte Exp $
*******************************************************************************}

{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2005  Michiel Hendriks

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

unit unit_comment2doc;

{$I defines.inc}

interface

type
  TDocFormat = (dfAuto, dfASIS, dfDefacto, dfHTML, dfWookee);

  function convertComment(input: string; inFormat: TDocFormat = dfAuto; outFormat: TDocFormat = dfHTML): string;

implementation

uses
  SysUtils;

function discoverFormat(var input: string): TDocFormat;
begin
  result := dfASIS;
  if (Pos('@return', input)>0) then begin
    result := dfDefacto;
    exit;
  end;
  if (Pos('@param', input)>0) then begin
    result := dfDefacto;
    exit;
  end;
  if (Pos('<br', input)>0) then begin
    result := dfHTML;
    exit;
  end;
  if (Pos('&lt;', input)>0) then begin
    result := dfHTML;
    exit;
  end;
end;

function extractComment(input: string; isml: boolean): string;
var
  i, j: integer;
  tmp: string;
begin

  if (isml) then begin
    Delete(input, 1, 3); // strip /** or /*!
    Delete(input, Length(input)-1, 2); // strip */
    i := 1;
    while ((i <= length(input)) and (input[i] = '*')) do inc(i);
    if (i > 1) then Delete(input, 1, i-1);
    i := length(input);
    while ((i > 0) and (input[i] = '*')) do dec(i);
    if (i < length(input)) then Delete(input, i, MaxInt);
  end;
  i := pos(#10, input);
  if (i = 0) then i := Length(input);
  while (i <> 0) do begin
    tmp := Copy(input, 1, i);
    Delete(input, 1, i);
    if (isml) then begin
      j := 1;
      while ((j <= length(tmp)) and (tmp[j] in [' ', #9])) do Inc(j);
      if (j <= length(tmp)) then begin
        if (tmp[j] = '*') then Inc(j);
        if (j > 1) then Delete(tmp, 1, j-1);
      end;
    end
    else begin
      j := pos('//', tmp);
      if ((j < length(tmp)) and (tmp[j] in ['/', '!'])) then Inc(j);
      if (j > 1) then Delete(tmp, 1, j-1);
    end;
    result := result+tmp;
    i := pos(#10, input);
  end;
end;

// outFormat is currently always HTML
function convertComment(input: string; inFormat: TDocFormat = dfAuto; outFormat: TDocFormat = dfHTML): string;
var
  isml: boolean;
begin
  if (inFormat = dfAuto) then inFormat := discoverFormat(input);
  isml := Copy(input, 1, 2) = '/*';
  result := extractComment(input, isml);
  if (inFormat = dfDefacto) then begin
    result := StringReplace(result, '@', '<br />@', [rfReplaceAll]);
  end;
end;

end.
