unit unit_bookmarks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ImgList, Buttons;

type
  Tfrm_Bookmarks = class(TForm)
    tv_Bookmarks: TTreeView;
    gb_Mark: TGroupBox;
    lbl_Class: TLabel;
    cb_Class: TComboBox;
    rb_Linenumber: TRadioButton;
    rb_Fieldentry: TRadioButton;
    ed_LineNumber: TEdit;
    ud_LineNumber: TUpDown;
    mm_Comment: TMemo;
    lbl_Comment: TLabel;
    lbl_Location: TLabel;
    cb_FieldnameEx: TComboBoxEx;
    il_Types: TImageList;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cb_ClassChange(Sender: TObject);
    procedure ed_LineNumberChange(Sender: TObject);
    procedure cb_FieldnameExChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Bookmarks: Tfrm_Bookmarks;

implementation

uses unit_main, unit_uclasses;

{$R *.dfm}

procedure Tfrm_Bookmarks.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tfrm_Bookmarks.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to config.ClassList.Count-1 do begin
    cb_Class.Items.AddObject(config.ClassList[i].FullName, config.ClassList[i]);
  end;
end;

procedure Tfrm_Bookmarks.cb_ClassChange(Sender: TObject);
var
  uclass: TUClass;
  i: integer;
  it: TComboExItem;
begin
  if (cb_Class.ItemIndex = -1) then begin
    rb_Fieldentry.Enabled := False;
    rb_Linenumber.Checked := true;
    exit;
  end;
  rb_Fieldentry.Enabled := True;
  uclass := TUClass(cb_Class.Items.Objects[cb_Class.ItemIndex]);
  cb_FieldnameEx.Clear;
  for i := 0 to uclass.consts.count-1 do begin
    it := cb_FieldnameEx.ItemsEx.Add;
    it.Caption := uclass.consts[i].Name;
    it.ImageIndex := 0;
  end;
  for i := 0 to uclass.enums.count-1 do begin
    it := cb_FieldnameEx.ItemsEx.Add;
    it.Caption := uclass.enums[i].Name;
    it.ImageIndex := 2;
  end;
  for i := 0 to uclass.structs.count-1 do begin
    it := cb_FieldnameEx.ItemsEx.Add;
    it.Caption := uclass.structs[i].Name;
    it.ImageIndex := 3;
  end;
  for i := 0 to uclass.delegates.count-1 do begin
    it := cb_FieldnameEx.ItemsEx.Add;
    it.Caption := uclass.delegates[i].Name;
    it.ImageIndex := 7;
  end;
  for i := 0 to uclass.properties.count-1 do begin
    it := cb_FieldnameEx.ItemsEx.Add;
    it.Caption := uclass.properties[i].Name;
    it.ImageIndex := 1;
  end;
  for i := 0 to uclass.functions.count-1 do begin
    it := cb_FieldnameEx.ItemsEx.Add;
    it.Caption := uclass.functions[i].Name;
    if (uclass.functions[i].state <> nil) then it.Caption := it.Caption+' @ '+uclass.functions[i].state.Name;
    it.ImageIndex := 4;
  end;
  for i := 0 to uclass.states.count-1 do begin
    it := cb_FieldnameEx.ItemsEx.Add;
    it.Caption := uclass.states[i].Name;
    it.ImageIndex := 8;
  end;
  cb_FieldnameEx.ItemsEx.Sort;
end;

procedure Tfrm_Bookmarks.ed_LineNumberChange(Sender: TObject);
begin
  rb_Linenumber.Checked := true;
end;

procedure Tfrm_Bookmarks.cb_FieldnameExChange(Sender: TObject);
begin
  if (cb_FieldnameEx.ItemIndex <> -1) then rb_Fieldentry.Checked := true;
end;

end.
