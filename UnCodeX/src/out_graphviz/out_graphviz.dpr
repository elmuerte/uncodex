{-----------------------------------------------------------------------------
 Unit Name: out_graphviz
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   create a dot file
 $Id: out_graphviz.dpr,v 1.5 2004-07-30 11:18:51 elmuerte Exp $
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
library out_graphviz;

uses
  FastShareMem in '..\FastShareMem.pas',
  SysUtils,
  Classes,
  unit_uclasses in '..\unit_uclasses.pas',
  unit_outputdefs in '..\unit_outputdefs.pas',
  unit_selector in 'unit_selector.pas' {frm_GraphViz},
  unit_deplist in 'unit_deplist.pas',
  Hashes in '..\Hashes.pas';

{$R *.res}

// return true if succesfull
function UCX_Details(var Info: TUCXOutputDetails): boolean; stdcall
begin
  Info.AName := 'GraphViz';
  Info.ADescription := 'Create a DOT file to be used with GraphViz (version '+DLLVERSION+')';
  Info.ASingleClass := false;
  Info.AMultipleClass := true;
  result := true;
end;

// return true if succesfull
function UCX_Output(var Info: TUCXOutputInfo): boolean; stdcall
begin
  frm_GraphViz := Tfrm_GraphViz.Create(nil);
  frm_GraphViz.GInfo := info;
  frm_GraphViz.Init;
  frm_GraphViz.ShowModal;
  frm_GraphViz.Free;
  Info.WaitForTerminate := false;
  result := false;
end;

exports
  UCX_Output,
  UCX_Details;

begin
end.
 