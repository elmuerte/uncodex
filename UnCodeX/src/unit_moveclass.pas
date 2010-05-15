{*******************************************************************************
  Name:
    unit_moveclass.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    GUI dialog for moving an UnrealScript class to a new package

  $Id: unit_moveclass.pas,v 1.9 2005/04/02 11:42:11 elmuerte Exp $
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
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA   02111-1307  USA
}

unit unit_moveclass;

{$I defines.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, unit_uclasses, ComCtrls, ExtCtrls;

type
  Tfrm_MoveClass = class(TForm)
    lbl_Class: TLabel;
    ed_Class: TEdit;
    lbl_OldPkg: TLabel;
    lbl_NewPkg: TLabel;
    btn_Move: TBitBtn;
    btn_Cancel: TBitBtn;
    lbl_Duplicate: TLabel;
    ed_OldPkg: TEdit;
    cb_NewPkg: TComboBox;
    cb_NewPackage: TCheckBox;
    procedure cb_NewPkgChange(Sender: TObject);
    procedure cb_NewPkgKeyPress(Sender: TObject; var Key: Char);
    procedure cb_NewPackageClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    uclass: TUClass;
  end;

var
  frm_MoveClass: Tfrm_MoveClass;

implementation

uses unit_main;

{$R *.dfm}

procedure Tfrm_MoveClass.cb_NewPkgChange(Sender: TObject);
var
  i: integer;
  upkg: TUPackage;
begin
  i := cb_NewPkg.Items.IndexOf(cb_NewPkg.Text);
  cb_NewPackage.Checked := i = -1;
  lbl_Duplicate.Visible := false;
  btn_Move.Enabled := cb_NewPkg.Text <> '';
  if (i > -1) then begin
    upkg := TUPackage(cb_NewPkg.Items.Objects[i]);
    if (upkg = uclass.package) then begin
      btn_Move.Enabled := false;
      exit;
    end;
    for i := 0 to upkg.classes.Count-1 do begin
      if (CompareText(upkg.classes[i].name, uclass.name) = 0) then begin
        lbl_Duplicate.Visible := true;
        btn_Move.Enabled := false;
        break;
      end;
    end;
  end
end;

procedure Tfrm_MoveClass.cb_NewPkgKeyPress(Sender: TObject; var Key: Char);
begin
  if ((Key >= #48) and (Key <= #57)) then exit; // 0 - 9
  if ((Key >= #65) and (Key <= #90)) then exit; // A - Z
  if ((Key >= #97) and (Key <= #122)) then exit; // a - z
  if (Key = #95) then exit; // _
  if (Key < #32) then exit; // BS
  Key := #0;
end;

procedure Tfrm_MoveClass.cb_NewPackageClick(Sender: TObject);
begin
  cb_NewPackage.Checked := cb_NewPkg.Items.IndexOf(cb_NewPkg.Text) = -1;
end;

procedure Tfrm_MoveClass.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F1) then hh_Help.HelpTopic('window_moveclass.html');
end;

end.
