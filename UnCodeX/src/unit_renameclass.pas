unit unit_renameclass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, unit_uclasses;

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
  private
    { Private declarations }
  public
    uclass: TUClass;
    uclasslist: TUClassList;
  end;

var
  frm_RenameClass: Tfrm_RenameClass;

implementation

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

end.
