{-----------------------------------------------------------------------------
 Unit Name: unit_settings
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   program settings window
-----------------------------------------------------------------------------}

unit unit_settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons {$IFDEF MSWINDOWS},FileCtrl{$ENDIF}, ComCtrls,
  Menus, ExtCtrls, IniFiles, CheckLst, ActnList, unit_richeditex;

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
    cd_Color: TColorDialog;
    lbl_LogLayout: TLabel;
    btn_LogFont: TBitBtn;
    lb_LogLayout: TListBox;
    cb_ExpandObject: TCheckBox;
    ts_ProgramOptions: TTabSheet;
    gb_ProgramOptions: TGroupBox;
    ed_StateFilename: TEdit;
    lbl_StateFile: TLabel;
    cb_MinimzeOnClose: TCheckBox;
    clb_PackagePriority: TCheckListBox;
    btn_Help: TBitBtn;
    cb_ModifiedOnStartup: TCheckBox;
    ts_HotKeys: TTabSheet;
    gb_HotKeys: TGroupBox;
    ed_HotKey: TEdit;
    hk_HotKey: THotKey;
    btn_SetHotKey: TBitBtn;
    lv_HotKeys: TListView;
    lbl_HTMLTitle: TLabel;
    ed_HHTitle: TEdit;
    Label1: TLabel;
    ed_DefInheritanceDepth: TEdit;
    ud_DefInheritDepth: TUpDown;
    cb_LoadCustomModules: TCheckBox;
    btn_Ignore: TBitBtn;
    ts_SourceSnoop: TTabSheet;
    gb_Sourcesnoop: TGroupBox;
    btn_SourceFont: TBitBtn;
    re_Preview: TRichEditEx;
    cb_cf0: TColorBox;
    cb_cf1: TColorBox;
    cb_cf2: TColorBox;
    cb_cf3: TColorBox;
    cb_cf4: TColorBox;
    cb_cf5: TColorBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cb_Background: TColorBox;
    Label9: TLabel;
    Label10: TLabel;
    ud_TabSize: TUpDown;
    ed_TabSize: TEdit;
    cb_CPAsWindow: TCheckBox;
    lbl_HTMLTargetExt: TLabel;
    ed_HTMLTargetExt: TEdit;
    cb_FontColor: TColorBox;
    cb_BGColor: TColorBox;
    cb_LogFontColor: TColorBox;
    cb_LogColor: TColorBox;
    btn_UnIgnore: TBitBtn;
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
    procedure btn_LogFontClick(Sender: TObject);
    procedure btn_SetHotKeyClick(Sender: TObject);
    procedure btn_HelpClick(Sender: TObject);
    procedure lv_HotKeysSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btn_IgnoreClick(Sender: TObject);
    procedure btn_SourceFontClick(Sender: TObject);
    procedure cb_cf0Change(Sender: TObject);
    procedure cb_cf1Change(Sender: TObject);
    procedure cb_cf2Change(Sender: TObject);
    procedure cb_cf3Change(Sender: TObject);
    procedure cb_cf4Change(Sender: TObject);
    procedure cb_cf5Change(Sender: TObject);
    procedure cb_BackgroundChange(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure ed_TabSizeChange(Sender: TObject);
    procedure cb_FontColorChange(Sender: TObject);
    procedure cb_BGColorChange(Sender: TObject);
    procedure cb_LogFontColorChange(Sender: TObject);
    procedure cb_LogColorChange(Sender: TObject);
    procedure btn_UnIgnoreClick(Sender: TObject);
    procedure clb_PackagePriorityClickCheck(Sender: TObject);
  private
  public
    TagChanged: boolean;
    procedure ReloadPreview;
  end;

var
  frm_Settings: Tfrm_Settings;

implementation

uses unit_main, unit_rtfhilight;

{$R *.dfm}

var
  bcf1,bcf2,bcf3,bcf4,bcf5,bcf6: TColor;
  btextfont: TFont;
  btabs: integer;

procedure Tfrm_Settings.ReloadPreview;
var
  ms: TMemoryStream;
  rs: TResourceStream;
begin
  rs := TResourceStream.Create(HInstance, 'PREVIEW', 'USCRIPT');
  ms := TMemoryStream.Create;
  try
    RTFHilightUScript(rs, ms, nil);
    re_Preview.Lines.Clear;
    ms.Position := 0;
    re_Preview.Lines.LoadFromStream(ms);
  finally
    ms.Free;
    rs.Free;
  end;
end;

procedure Tfrm_Settings.btn_PUpClick(Sender: TObject);
var
  i: integer;
begin
  if (clb_PackagePriority.ItemIndex < 1) then exit;
  i := clb_PackagePriority.ItemIndex;
  clb_PackagePriority.Items.Move(i, i-1);
  clb_PackagePriority.Selected[i-1] := true;
end;

procedure Tfrm_Settings.btn_PDownClick(Sender: TObject);
var
  i: integer;
begin
  if (clb_PackagePriority.ItemIndex = clb_PackagePriority.Items.Count-1) then exit;
  i := clb_PackagePriority.ItemIndex;
  clb_PackagePriority.Items.Move(i, i+1);
  clb_PackagePriority.Selected[i+1] := true;
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
  if (clb_PackagePriority.ItemIndex = -1) then exit;
  clb_PackagePriority.Items.Delete(clb_PackagePriority.ItemIndex);
end;

procedure Tfrm_Settings.btn_AddPackageClick(Sender: TObject);
var
  tmp: string;
begin
  if (InputQuery('Add package', 'Enter the package name', tmp)) then begin
    tmp := LowerCase(tmp);
    if (clb_PackagePriority.Items.IndexOf(tmp) = -1) then clb_PackagePriority.Items.Add(tmp);
  end;
end;

procedure Tfrm_Settings.FormCreate(Sender: TObject);
var
  i: integer;
  li: TListItem;
begin
  TagChanged := false;
  lb_Settings.Items.Clear;
  for i := 0 to pc_Settings.PageCount-1 do begin
    lb_Settings.Items.Add(pc_Settings.Pages[i].Caption);
  end;
  lb_Settings.ItemIndex := 0;
  pc_Settings.ActivePageIndex := 0;
  tv_TreeLayout.FullExpand;
  for i := 0 to frm_UnCodeX.al_Main.ActionCount-1 do begin
    li := lv_HotKeys.Items.Add;
    li.Caption := TAction(frm_UnCodeX.al_Main.Actions[i]).Caption;
    li.SubItems.Add(ShortCutToText(TAction(frm_UnCodeX.al_Main.Actions[i]).ShortCut));
    li.Data := frm_UnCodeX.al_Main.Actions[i];
  end;
  // backup old colors
  bcf1 := unit_rtfhilight.cf1;
  bcf2 := unit_rtfhilight.cf2;
  bcf3 := unit_rtfhilight.cf3;
  bcf4 := unit_rtfhilight.cf4;
  bcf5 := unit_rtfhilight.cf5;
  bcf6 := unit_rtfhilight.cf6;
  btextfont.Name := unit_rtfhilight.textfont.Name;
  btextfont.Size := unit_rtfhilight.textfont.Size;
  btabs := unit_rtfhilight.tabs;
  //
  re_Preview.Font.Name := unit_rtfhilight.textfont.Name;
  re_Preview.Font.Size := unit_rtfhilight.textfont.Size;
  cb_cf0.Selected := unit_rtfhilight.cf6;
  cb_cf1.Selected := unit_rtfhilight.cf1;
  cb_cf2.Selected := unit_rtfhilight.cf2;
  cb_cf3.Selected := unit_rtfhilight.cf3;
  cb_cf4.Selected := unit_rtfhilight.cf4;
  cb_cf5.Selected := unit_rtfhilight.cf5;
  ud_TabSize.Position := unit_rtfhilight.tabs;
  ReloadPreview;
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
    tmp := LowerCase(tmp);
    if (lb_IgnorePackages.Items.IndexOf(tmp) = -1) then lb_IgnorePackages.Items.Add(tmp);
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
  if (clb_PackagePriority.Items.Count > 0) then begin
    if MessageDlg('This will clear the current priority list.'+#13+#10+
      'Are you sure you want to continue ?', mtWarning, [mbYes,mbNo], 0) = mrNo then exit;
    clb_PackagePriority.Items.Clear;
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
          clb_PackagePriority.Items.Add(tmp);
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

procedure Tfrm_Settings.btn_LogFontClick(Sender: TObject);
begin
  fd_Font.Font := lb_LogLayout.Font;
  if (fd_Font.Execute) then begin
    lb_LogLayout.Font := fd_Font.Font;        
  end;
end;

procedure Tfrm_Settings.btn_SetHotKeyClick(Sender: TObject);
begin
  if (lv_HotKeys.Selected = nil) then exit;
  lv_HotKeys.Selected.SubItems[0] := ShortCutToText(hk_HotKey.HotKey);
end;

procedure Tfrm_Settings.btn_HelpClick(Sender: TObject);
begin
  hh_Help.HelpTopic('window_settings.html#'+pc_Settings.ActivePage.HelpKeyword);
end;

procedure Tfrm_Settings.lv_HotKeysSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if (Item = nil) then exit;
  ed_HotKey.Text := Item.Caption;
  hk_HotKey.HotKey := TextToShortCut(Item.SubItems[0]);
end;

procedure Tfrm_Settings.btn_IgnoreClick(Sender: TObject);
begin
  if (clb_PackagePriority.ItemIndex = -1) then exit;
  if (lb_IgnorePackages.Items.IndexOf(clb_PackagePriority.Items[clb_PackagePriority.ItemIndex]) = -1)
    then lb_IgnorePackages.Items.Add(clb_PackagePriority.Items[clb_PackagePriority.ItemIndex]);
  clb_PackagePriority.Items.Delete(clb_PackagePriority.ItemIndex);
end;

procedure Tfrm_Settings.btn_SourceFontClick(Sender: TObject);
begin
  fd_Font.Font.Name := unit_rtfhilight.textfont.Name;
  fd_Font.Font.Size := unit_rtfhilight.textfont.Size;
  if (fd_Font.Execute) then begin
    unit_rtfhilight.textfont.Name := fd_Font.Font.Name;
    unit_rtfhilight.textfont.Size := fd_Font.Font.Size;
    ReloadPreview;
  end;
end;

procedure Tfrm_Settings.cb_cf0Change(Sender: TObject);
begin
  unit_rtfhilight.cf6 := cb_cf0.Selected;
  ReloadPreview;
end;

procedure Tfrm_Settings.cb_cf1Change(Sender: TObject);
begin
  unit_rtfhilight.cf1 := cb_cf1.Selected;
  ReloadPreview;
end;

procedure Tfrm_Settings.cb_cf2Change(Sender: TObject);
begin
  unit_rtfhilight.cf2 := cb_cf2.Selected;
  ReloadPreview;
end;

procedure Tfrm_Settings.cb_cf3Change(Sender: TObject);
begin
  unit_rtfhilight.cf3 := cb_cf3.Selected;
  ReloadPreview;
end;

procedure Tfrm_Settings.cb_cf4Change(Sender: TObject);
begin
  unit_rtfhilight.cf4 := cb_cf4.Selected;
  ReloadPreview;
end;

procedure Tfrm_Settings.cb_cf5Change(Sender: TObject);
begin
  unit_rtfhilight.cf5 := cb_cf5.Selected;
  ReloadPreview;
end;

procedure Tfrm_Settings.cb_BackgroundChange(Sender: TObject);
begin
  re_Preview.Color := cb_Background.Selected;
end;

procedure Tfrm_Settings.btn_CancelClick(Sender: TObject);
begin
  unit_rtfhilight.cf1 := bcf1;
  unit_rtfhilight.cf2 := bcf2;
  unit_rtfhilight.cf3 := bcf3;
  unit_rtfhilight.cf4 := bcf4;
  unit_rtfhilight.cf5 := bcf5;
  unit_rtfhilight.cf6 := bcf6;
  unit_rtfhilight.textfont.Name := btextfont.Name;
  unit_rtfhilight.textfont.Size := btextfont.Size;
  unit_rtfhilight.tabs := btabs;
end;

procedure Tfrm_Settings.ed_TabSizeChange(Sender: TObject);
begin
  unit_rtfhilight.tabs := ud_TabSize.Position;
  ReloadPreview;
end;

procedure Tfrm_Settings.cb_FontColorChange(Sender: TObject);
begin
  tv_TreeLayout.Font.Color := cb_FontColor.Selected;
end;

procedure Tfrm_Settings.cb_BGColorChange(Sender: TObject);
begin
  tv_TreeLayout.Color := cb_BGColor.Selected;
end;

procedure Tfrm_Settings.cb_LogFontColorChange(Sender: TObject);
begin
  lb_LogLayout.Font.Color := cb_LogFontColor.Selected;
end;

procedure Tfrm_Settings.cb_LogColorChange(Sender: TObject);
begin
  lb_LogLayout.Color := cb_LogColor.Selected;
end;

procedure Tfrm_Settings.btn_UnIgnoreClick(Sender: TObject);
begin
  if (lb_IgnorePackages.ItemIndex = -1) then exit;
  if (clb_PackagePriority.Items.IndexOf(lb_IgnorePackages.Items[lb_IgnorePackages.ItemIndex]) = -1)
    then clb_PackagePriority.Items.Add(lb_IgnorePackages.Items[lb_IgnorePackages.ItemIndex]);
  lb_IgnorePackages.Items.Delete(lb_IgnorePackages.ItemIndex);
end;

procedure Tfrm_Settings.clb_PackagePriorityClickCheck(Sender: TObject);
begin
  TagChanged := true;
end;

initialization
  btextfont := TFont.Create;
finalization
  btextfont.Free;
end.
