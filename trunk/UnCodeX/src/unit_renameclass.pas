{*******************************************************************************
	Name:
        unit_renameclass.pas
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        UnrealScript class rename dialog

    $Id: unit_renameclass.pas,v 1.5 2004-10-18 15:36:07 elmuerte Exp $
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
unit unit_renameclass;

{$I defines.inc}

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, Buttons, unit_uclasses, ExtCtrls;

type
	Tfrm_RenameClass = class(TForm)
		lbl_Class: TLabel;
		ed_Class: TEdit;
		lbl_OldPkg: TLabel;
		ed_NewClass: TEdit;
		lbl_Duplicate: TLabel;
		btn_Cancel: TBitBtn;
		btn_Rename: TBitBtn;
		lbl_Warning: TLabel;
		procedure ed_NewClassKeyPress(Sender: TObject; var Key: Char);
		procedure ed_NewClassChange(Sender: TObject);
		procedure FormKeyUp(Sender: TObject; var Key: Word;
			Shift: TShiftState);
	private
		{ Private declarations }
	public
		uclass: TUClass;
		uclasslist: TUClassList;
	end;

var
	frm_RenameClass: Tfrm_RenameClass;

implementation

uses unit_main;

{$R *.dfm}

procedure Tfrm_RenameClass.ed_NewClassKeyPress(Sender: TObject;
	var Key: Char);
begin
	if ((Key >= #48) and (Key <= #57)) then exit; // 0 - 9
	if ((Key >= #65) and (Key <= #90)) then exit; // A - Z
	if ((Key >= #97) and (Key <= #122)) then exit; // a - z
	if (Key = #95) then exit; // _
	if (Key < #32) then exit; // BS
	Key := #0;
end;

procedure Tfrm_RenameClass.ed_NewClassChange(Sender: TObject);
var
	i: integer;
begin
	lbl_Duplicate.Visible := false;
	lbl_Warning.Visible := false;
	btn_Rename.Enabled := true;
	if (ed_NewClass.Text = '') then begin
		btn_Rename.Enabled := false;
		exit;
	end;
	if (CompareText(ed_NewClass.Text, uclass.name) = 0) then begin
		btn_Rename.Enabled := false;
		exit;
	end;
	for i := 0 to uclasslist.Count-1 do begin
		if (CompareText(ed_NewClass.Text, uclasslist[i].name) = 0) then begin
			if (uclasslist[i].package = uclass.package) then begin
				lbl_Duplicate.Visible := true;
				btn_Rename.Enabled := false;
			end
			else begin
				lbl_Warning.Visible := true;
			end;
			break;
		end;
	end;
end;

procedure Tfrm_RenameClass.FormKeyUp(Sender: TObject; var Key: Word;
	Shift: TShiftState);
begin
	if (Key = VK_F1) then hh_Help.HelpTopic('window_renameclass.html');
end;

end.
