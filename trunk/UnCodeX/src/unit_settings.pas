unit unit_settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons {$IFDEF MSWINDOWS},FileCtrl{$ENDIF}, ComCtrls,
  Menus, ExtCtrls, IniFiles;

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
    lbl_CompilerCommandline: TLabel;
    ed_CompilerCommandline: TEdit;
    btn_BrowseCompiler: TBitBtn;
    ts_GameServer: TTabSheet;
    gb_GameServer: TGroupBox;
    lbl_ServerCommandline: TLabel;
    ed_ServerCommandline: TEdit;
    btn_BrowseServer: TBitBtn;
    Label3: TLabel;
    cb_ServerPriority: TComboBox;
    btn_CompilerPlaceholders: TBitBtn;
    pm_CompilerPlaceholders: TPopupMenu;
    mi_Classname: TMenuItem;
    mi_Classfilename: TMenuItem;
    N1: TMenuItem;
    mi_Packagename: TMenuItem;
    mi_Packagepath: TMenuItem;
    mi_Fullclasspath: TMenuItem;
    od_BrowseExe: TOpenDialog;
    lbl_ClientCommandline: TLabel;
    ed_ClientCommandline: TEdit;
    btn_ClientCommandline: TBitBtn;
    ts_IgnorePackages: TTabSheet;
    gb_IgnorePackages: TGroupBox;
    lb_IgnorePackages: TListBox;
    btn_AddIgnore: TBitBtn;
    btn_DelIgnore: TBitBtn;
    ts_FullTextSearch: TTabSheet;
    gb_FullTextSearch: TGroupBox;
    lbl_OpenResult: TLabel;
    btn_OpenResultPlaceHolder: TBitBtn;
    ed_OpenResultCmd: TEdit;
    btn_OpenResultCmd: TBitBtn;
    pm_OpenResultPlaceHolders: TPopupMenu;
    mi_ClassName2: TMenuItem;
    mi_ClassFile2: TMenuItem;
    mi_ClassPath2: TMenuItem;
    mi_N2: TMenuItem;
    mi_PackageName2: TMenuItem;
    mi_PackagePath2: TMenuItem;
    mi_N3: TMenuItem;
    mi_Resultline1: TMenuItem;
    mi_Resultposition1: TMenuItem;
    cb_FTSRegExp: TCheckBox;
    btn_Import: TBitBtn;
    od_BrowseIni: TOpenDialog;
    ts_Layout: TTabSheet;
    gb_Layout: TGroupBox;
    lbl_TreeFont: TLabel;
    tv_TreeLayout: TTreeView;
    btn_FontSelect: TBitBtn;
    fd_Font: TFontDialog;
    btn_BGColor: TBitBtn;
    cd_Color: TColorDialog;
    btn_FontColor: TBitBtn;
    lbl_LogLayout: TLabel;
    btn_LogFont: TBitBtn;
    btn_LogFontColor: TBitBtn;
    btn_LogColor: TBitBtn;
    lb_LogLayout: TListBox;
    cb_ExpandObject: TCheckBox;
    ts_ProgramOptions: TTabSheet;
    gb_ProgramOptions: TGroupBox;
    Edit1: TEdit;
    lbl_StateFile: TLabel;
    CheckBox1: TCheckBox;
    Edit2: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
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
    procedure btn_BrowseCompilerClick(Sender: TObject);
    procedure mi_ClassnameClick(Sender: TObject);
    procedure mi_ClassfilenameClick(Sender: TObject);
    procedure mi_FullclasspathClick(Sender: TObject);
    procedure mi_PackagenameClick(Sender: TObject);
    procedure mi_PackagepathClick(Sender: TObject);
    procedure btn_BrowseServerClick(Sender: TObject);
    procedure btn_ClientCommandlineClick(Sender: TObject);
    procedure btn_AddIgnoreClick(Sender: TObject);
    procedure btn_DelIgnoreClick(Sender: TObject);
    procedure btn_OpenResultCmdClick(Sender: TObject);
    procedure btn_OpenResultPlaceHolderClick(Sender: TObject);
    procedure mi_ClassName2Click(Sender: TObject);
    procedure mi_ClassFile2Click(Sender: TObject);
    procedure mi_ClassPath2Click(Sender: TObject);
    procedure mi_PackageName2Click(Sender: TObject);
    procedure mi_PackagePath2Click(Sender: TObject);
    procedure mi_Resultline1Click(Sender: TObject);
    procedure mi_Resultposition1Click(Sender: TObject);
    procedure btn_ImportClick(Sender: TObject);
    procedure btn_FontSelectClick(Sender: TObject);
    procedure btn_FontColorClick(Sender: TObject);
    procedure btn_BGColorClick(Sender: TObject);
    procedure btn_LogFontClick(Sender: TObject);
    procedure btn_LogFontColorClick(Sender: TObject);
    procedure btn_LogColorClick(Sender: TObject);
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
  lb_Settings.ItemIndex := 0;
  pc_Settings.ActivePageIndex := 0;
  tv_TreeLayout.FullExpand;
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

procedure Tfrm_Settings.btn_BrowseCompilerClick(Sender: TObject);
begin
  od_BrowseExe.FileName := ed_CompilerCommandline.Text;
  if (od_BrowseExe.Execute) then ed_CompilerCommandline.Text := od_BrowseExe.FileName;
end;

procedure Tfrm_Settings.mi_ClassnameClick(Sender: TObject);
begin
  ed_CompilerCommandline.Text := ed_CompilerCommandline.Text+' %classname%';
end;

procedure Tfrm_Settings.mi_ClassfilenameClick(Sender: TObject);
begin
  ed_CompilerCommandline.Text := ed_CompilerCommandline.Text+' %classfile%';
end;

procedure Tfrm_Settings.mi_FullclasspathClick(Sender: TObject);
begin
  ed_CompilerCommandline.Text := ed_CompilerCommandline.Text+' %classpath%';
end;

procedure Tfrm_Settings.mi_PackagenameClick(Sender: TObject);
begin
  ed_CompilerCommandline.Text := ed_CompilerCommandline.Text+' %packagename%';
end;

procedure Tfrm_Settings.mi_PackagepathClick(Sender: TObject);
begin
  ed_CompilerCommandline.Text := ed_CompilerCommandline.Text+' %packagepath%';
end;

procedure Tfrm_Settings.btn_BrowseServerClick(Sender: TObject);
begin
  od_BrowseExe.FileName := ed_ServerCommandline.Text;
  if (od_BrowseExe.Execute) then ed_ServerCommandline.Text := od_BrowseExe.FileName;
end;

procedure Tfrm_Settings.btn_ClientCommandlineClick(Sender: TObject);
begin
  od_BrowseExe.FileName := ed_ClientCommandline.Text;
  if (od_BrowseExe.Execute) then ed_ClientCommandline.Text := od_BrowseExe.FileName;
end;

procedure Tfrm_Settings.btn_AddIgnoreClick(Sender: TObject);
var
  tmp: string;
begin
  if (InputQuery('Add package', 'Enter the package name', tmp)) then begin
    lb_IgnorePackages.Items.Add(LowerCase(tmp));
  end;
end;

procedure Tfrm_Settings.btn_DelIgnoreClick(Sender: TObject);
begin
  if (lb_IgnorePackages.ItemIndex = -1) then exit;
  lb_IgnorePackages.Items.Delete(lb_IgnorePackages.ItemIndex);
end;

procedure Tfrm_Settings.btn_OpenResultCmdClick(Sender: TObject);
begin
  od_BrowseExe.FileName := ed_OpenResultCmd.Text;
  if (od_BrowseExe.Execute) then ed_OpenResultCmd.Text := od_BrowseExe.FileName;
end;

procedure Tfrm_Settings.btn_OpenResultPlaceHolderClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt := btn_OpenResultPlaceHolder.ClientToScreen(Point(0, btn_OpenResultPlaceHolder.Height));
  pm_OpenResultPlaceHolders.Popup(pt.X, pt.Y);
end;

procedure Tfrm_Settings.mi_ClassName2Click(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %classname%';
end;

procedure Tfrm_Settings.mi_ClassFile2Click(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %classfile%';
end;

procedure Tfrm_Settings.mi_ClassPath2Click(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %classpath%';
end;

procedure Tfrm_Settings.mi_PackageName2Click(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %packagename%';
end;

procedure Tfrm_Settings.mi_PackagePath2Click(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %packagepath%';
end;

procedure Tfrm_Settings.mi_Resultline1Click(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %resultline%';
end;

procedure Tfrm_Settings.mi_Resultposition1Click(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %resultpos%';
end;

procedure Tfrm_Settings.btn_ImportClick(Sender: TObject);
var
  ini: TMemIniFile;
  sl: TStringList;
  i, j: integer;
  tmp: string;
begin
  if (lb_PackagePriority.Items.Count > 0) then begin
    if MessageDlg('This will clear the current priority list.'+#13+#10+
      'Are you sure you want to continue ?', mtWarning, [mbYes,mbNo], 0) = mrNo then exit;
    lb_PackagePriority.Items.Clear;
  end;
  if (od_BrowseIni.Execute) then begin
    ini := TMemIniFile.Create(od_BrowseIni.FileName);
    sl := TStringList.Create;
    try
      ini.ReadSectionValues('Editor.EditorEngine', sl);
      for i := 0 to sl.Count-1 do begin
        tmp := sl[i];
        j := Pos('=', tmp);
        if (LowerCase(Copy(tmp, 1, j-1)) = 'editpackages') then begin
          Delete(tmp, 1, j);
          lb_PackagePriority.Items.Add(tmp);
        end;
      end;
    finally
      sl.Free;
      ini.Free;
    end;
  end;
end;

procedure Tfrm_Settings.btn_FontSelectClick(Sender: TObject);
begin
  fd_Font.Font := tv_TreeLayout.Font;
  if (fd_Font.Execute) then begin
    tv_TreeLayout.Font := fd_Font.Font;        
  end;
end;

procedure Tfrm_Settings.btn_FontColorClick(Sender: TObject);
begin
  cd_Color.Color := tv_TreeLayout.Font.Color;
  if (cd_Color.Execute) then begin
    tv_TreeLayout.Font.Color := cd_Color.Color;
  end;
end;

procedure Tfrm_Settings.btn_BGColorClick(Sender: TObject);
begin
  cd_Color.Color := tv_TreeLayout.Color;
  if (cd_Color.Execute) then begin
    tv_TreeLayout.Color := cd_Color.Color;
  end;
end;

procedure Tfrm_Settings.btn_LogFontClick(Sender: TObject);
begin
  fd_Font.Font := lb_LogLayout.Font;
  if (fd_Font.Execute) then begin
    lb_LogLayout.Font := fd_Font.Font;        
  end;
end;

procedure Tfrm_Settings.btn_LogFontColorClick(Sender: TObject);
begin
  cd_Color.Color := lb_LogLayout.Font.Color;
  if (cd_Color.Execute) then begin
    lb_LogLayout.Font.Color := cd_Color.Color;
  end;
end;

procedure Tfrm_Settings.btn_LogColorClick(Sender: TObject);
begin
  cd_Color.Color := lb_LogLayout.Color;
  if (cd_Color.Execute) then begin
    lb_LogLayout.Color := cd_Color.Color;
  end;
end;

end.
