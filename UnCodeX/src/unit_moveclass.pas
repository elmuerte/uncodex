unit unit_moveclass;

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
  private
    { Private declarations }
  public
    uclass: TUClass;
  end;

var
  frm_MoveClass: Tfrm_MoveClass;

implementation

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
  if (Key = #8) then exit; // BS
  if (Key = #127) then exit; // DEL
  Key := #0;
end;

procedure Tfrm_MoveClass.cb_NewPackageClick(Sender: TObject);
begin
	cb_NewPackage.Checked := cb_NewPkg.Items.IndexOf(cb_NewPkg.Text) = -1;
end;

end.
