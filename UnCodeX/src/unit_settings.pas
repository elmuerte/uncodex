unit unit_settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons {$IFDEF MSWINDOWS},FileCtrl{$ENDIF}, ComCtrls,
  Menus, ExtCtrls;

type
  

  Tfrm_Settings = class(TForm)
    btn_Ok: TBitBtn;
    btn_Cancel: TBitBtn;
    sd_SaveFile: TSaveDialog;
    pc_Settings: TPageControl;
    ts_SourcePaths: TTabSheet;
    ts_PackagePriority: TTabSheet;
    ts_HTMLOutput: TTabSheet;
    ts_HTMLHelp: TTabSheet;
    gb_SourcePaths: TGroupBox;
    lb_Paths: TListBox;
    btn_SAdd: TBitBtn;
    btn_SRemove: TBitBtn;
    btn_SUp: TBitBtn;
    btn_SDown: TBitBtn;
    gb_PackagePriority: TGroupBox;
    lb_PackagePriority: TListBox;
    btn_PUp: TBitBtn;
    btn_PDown: TBitBtn;
    btn_AddPackage: TBitBtn;
    btn_DelPackage: TBitBtn;
    gb_HTMLOutput: TGroupBox;
    lbl_OutputDir: TLabel;
    lbl_Template: TLabel;
    ed_HTMLOutputDir: TEdit;
    btn_HTMLOutputDir: TBitBtn;
    ed_TemplateDir: TEdit;
    btn_SelectTemplateDir: TBitBtn;
    gb_HTMLHelp: TGroupBox;
    lbl_Workshop: TLabel;
    lbl_HTMLHelpOutput: TLabel;
    ed_WorkshopPath: TEdit;
    btn_SelectWorkshop: TBitBtn;
    ed_HTMLHelpOutput: TEdit;
    btn_HTMLHelpOutput: TBitBtn;
    lb_Settings: TListBox;
    ts_Compile: TTabSheet;
    gb_Compile: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    ts_GameServer: TTabSheet;
    gb_GameServer: TGroupBox;
    Label2: TLabel;
    Edit2: TEdit;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    ComboBox1: TComboBox;
    btn_CompilerPlaceholders: TBitBtn;
    pm_CompilerPlaceholders: TPopupMenu;
    Classname1: TMenuItem;
    Classfilename1: TMenuItem;
    N1: TMenuItem;
    Packagename1: TMenuItem;
    Packagepath1: TMenuItem;
    Fullclasspath1: TMenuItem;
    procedure btn_PUpClick(Sender: TObject);
    procedure btn_PDownClick(Sender: TObject);
    procedure btn_SUpClick(Sender: TObject);
    procedure btn_SDownClick(Sender: TObject);
    procedure btn_SRemoveClick(Sender: TObject);
    procedure btn_SAddClick(Sender: TObject);
    procedure btn_HTMLOutputDirClick(Sender: TObject);
    procedure btn_SelectTemplateDirClick(Sender: TObject);
    procedure btn_SelectWorkshopClick(Sender: TObject);
    procedure btn_HTMLHelpOutputClick(Sender: TObject);
    procedure btn_DelPackageClick(Sender: TObject);
    procedure btn_AddPackageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lb_SettingsClick(Sender: TObject);
    procedure btn_CompilerPlaceholdersClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Settings: Tfrm_Settings;

implementation

{$R *.dfm}

procedure Tfrm_Settings.btn_PUpClick(Sender: TObject);
var
  i: integer;
begin
  if (lb_PackagePriority.ItemIndex < 1) then exit;
  i := lb_PackagePriority.ItemIndex;
  lb_PackagePriority.Items.Move(i, i-1);
  lb_PackagePriority.Selected[i-1] := true;
end;

procedure Tfrm_Settings.btn_PDownClick(Sender: TObject);
var
  i: integer;
begin
  if (lb_PackagePriority.ItemIndex = lb_PackagePriority.Items.Count-1) then exit;
  i := lb_PackagePriority.ItemIndex;
  lb_PackagePriority.Items.Move(i, i+1);
  lb_PackagePriority.Selected[i+1] := true;
end;

procedure Tfrm_Settings.btn_SUpClick(Sender: TObject);
var
  i: integer;
begin
  if (lb_Paths.ItemIndex < 1) then exit;
  i := lb_Paths.ItemIndex;
  lb_Paths.Items.Move(i, i-1);
  lb_Paths.Selected[i-1] := true;
end;

procedure Tfrm_Settings.btn_SDownClick(Sender: TObject);
var
  i: integer;
begin
  if (lb_Paths.ItemIndex = lb_Paths.Items.Count-1) then exit;
  i := lb_Paths.ItemIndex;
  lb_Paths.Items.Move(i, i+1);
  lb_Paths.Selected[i+1] := true;
end;

procedure Tfrm_Settings.btn_SRemoveClick(Sender: TObject);
begin
  if (lb_Paths.ItemIndex < 0) then exit;
  lb_Paths.Items.Delete(lb_Paths.ItemIndex);
end;

procedure Tfrm_Settings.btn_SAddClick(Sender: TObject);
var
  dir: string;
begin
  if SelectDirectory('Select the root directory', '', dir) then begin
    if (lb_Paths.Items.IndexOf(dir) = -1) then lb_Paths.Items.Add(dir);
  end;
end;

procedure Tfrm_Settings.btn_HTMLOutputDirClick(Sender: TObject);
var
  dir: string;
begin
  dir := ed_HTMLOutputDir.Text;
  if SelectDirectory('Select the HTML Output directory', '', dir) then begin
    ed_HTMLOutputDir.Text := dir;
  end;
end;

procedure Tfrm_Settings.btn_SelectTemplateDirClick(Sender: TObject);
var
  dir: string;
begin
  dir := ed_TemplateDir.Text;
  if SelectDirectory('Select the template directory', '', dir) then begin
    ed_TemplateDir.Text := dir;
  end;
end;

procedure Tfrm_Settings.btn_SelectWorkshopClick(Sender: TObject);
var
  dir: string;
begin
  dir := ed_WorkshopPath.Text;
  if SelectDirectory('Select the HTML Help Workshop', '', dir) then begin
    ed_WorkshopPath.Text := dir;
  end;
end;

procedure Tfrm_Settings.btn_HTMLHelpOutputClick(Sender: TObject);
begin
  sd_SaveFile.FileName := ed_HTMLHelpOutput.Text;
  if (sd_SaveFile.Execute) then begin
    ed_HTMLHelpOutput.Text := sd_SaveFile.FileName;
  end;
end;

procedure Tfrm_Settings.btn_DelPackageClick(Sender: TObject);
begin
  if (lb_PackagePriority.ItemIndex = -1) then exit;
  lb_PackagePriority.Items.Delete(lb_PackagePriority.ItemIndex);
end;

procedure Tfrm_Settings.btn_AddPackageClick(Sender: TObject);
var
  tmp: string;
begin
  if (InputQuery('Add package', 'Enter the package name', tmp)) then begin
    lb_PackagePriority.Items.Add(LowerCase(tmp));
  end;
end;

procedure Tfrm_Settings.FormCreate(Sender: TObject);
var
  i: integer;
begin
  lb_Settings.Items.Clear;
  for i := 0 to pc_Settings.PageCount-1 do begin
    lb_Settings.Items.Add(pc_Settings.Pages[i].Caption);
  end;
  pc_Settings.ActivePageIndex := 0;
end;

procedure Tfrm_Settings.lb_SettingsClick(Sender: TObject);
begin
  if (lb_Settings.ItemIndex < 0) then exit;
  pc_Settings.ActivePageIndex := lb_Settings.ItemIndex;
end;

procedure Tfrm_Settings.btn_CompilerPlaceholdersClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt := btn_CompilerPlaceholders.ClientToScreen(Point(0, btn_CompilerPlaceholders.Height));
  pm_CompilerPlaceholders.Popup(pt.X, pt.Y);
end;

end.
