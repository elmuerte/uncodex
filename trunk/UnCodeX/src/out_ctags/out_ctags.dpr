{-----------------------------------------------------------------------------
 Unit Name: out_ctags
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   CTAGS file creation library
 $Id: out_ctags.dpr,v 1.2 2004-05-13 07:08:28 elmuerte Exp $
-----------------------------------------------------------------------------}
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

library out_ctags;

uses
  FastShareMem in '..\FastShareMem.pas',
  SysUtils,
  Classes,
  unit_uclasses in '..\unit_uclasses.pas',
  unit_outputdefs in '..\unit_outputdefs.pas',
  unit_ctags in 'unit_ctags.pas' {frm_CTAGS};

{$R *.res}

const
  DLLVERSION = '100';

// return true if succesfull
function UCX_Details2(var Info: TUCXOutputDetails2): boolean; stdcall
begin
  Info.AName := 'CTAGS';
  Info.ADescription := 'Create a CTAGS file (version '+DLLVERSION+')';
  Info.ASingleClass := true;
  Info.AMultipleClass := true;
  result := true;
end;

// return true if succesfull
function UCX_Output2(var Info: TUCXOutputInfo2): boolean; stdcall
begin
  frm_CTAGS := Tfrm_CTAGS.Create(nil);
  frm_CTAGS.Info := info;
  frm_CTAGS.Init;
  frm_CTAGS.ShowModal;
  frm_CTAGS.Free;
  Info.WaitForTerminate := false;
  result := false;
end;

function UCX_Version: integer; stdcall
begin
	result := 2;
end;

exports
  UCX_Output2,
  UCX_Details2,
  UCX_Version;

begin
end.
