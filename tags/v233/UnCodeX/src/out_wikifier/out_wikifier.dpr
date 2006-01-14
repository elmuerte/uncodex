{-----------------------------------------------------------------------------
 Unit Name: out_wikifier
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   Converts the UScript class info to UnrealWiki format
 $Id: out_wikifier.dpr,v 1.8 2006-01-14 21:26:09 elmuerte Exp $
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

library out_wikifier;

uses
  FastShareMem in '..\FastShareMem.pas',
  SysUtils,
  Classes,
  unit_uclasses in '..\unit_uclasses.pas',
  unit_outputdefs in '..\unit_outputdefs.pas',
  unit_wiki in 'unit_wiki.pas' {frm_Wikifier},
  unit_comment2doc in '..\unit_comment2doc.pas';

{$R *.res}

// return true if succesfull
function UCX_Details(var Info: TUCXOutputDetails): boolean; stdcall
begin
  Info.AName := 'Class Wikifier';
  Info.ADescription := 'Converts the class details to UnrealWiki source';
  Info.ASingleClass := true;
  Info.AMultipleClass := false;
  result := true;
end;

// return true if succesfull
function UCX_Output(var Info: TUCXOutputInfo): boolean; stdcall
begin
  if (info.ASelectedClass <> nil) then begin
    frm_Wikifier := Tfrm_Wikifier.Create(nil);
    frm_Wikifier.Wikify(info.ASelectedClass);
    frm_Wikifier.ShowModal;
    frm_Wikifier.Free;
  end;
  info.WaitForTerminate := false;
  result := true;
end;

exports
  UCX_Output,
  UCX_Details;

begin
end.
 