{*******************************************************************************
  Name:
    unit_settings.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Program settings dialog

  $Id: unit_settings.pas,v 1.43 2004-12-08 09:25:39 elmuerte Exp $
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

unit unit_settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,
  {$WARN UNIT_PLATFORM OFF}
  {$IFDEF MSWINDOWS}
  FileCtrl,
  {$ENDIF}
  {$WARN UNIT_PLATFORM ON}
  ComCtrls, Menus, ExtCtrls, IniFiles, CheckLst, ActnList, unit_richeditex;

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
    lbl_OutputDir: TLabel;
    lbl_Template: TLabel;
    ed_HTMLOutputDir: TEdit;
    btn_HTMLOutputDir: TBitBtn;
    ed_TemplateDir: TEdit;
    btn_SelectTemplateDir: TBitBtn;
    lbl_Workshop: TLabel;
    lbl_HTMLHelpOutput: TLabel;
    ed_WorkshopPath: TEdit;
    btn_SelectWorkshop: TBitBtn;
    ed_HTMLHelpOutput: TEdit;
    btn_HTMLHelpOutput: TBitBtn;
    ts_Command: TTabSheet;
    lbl_CompilerCommandline: TLabel;
    ed_CompilerCommandline: TEdit;
    btn_BrowseCompiler: TBitBtn;
    ts_GameServer: TTabSheet;
    lbl_ServerCommandline: TLabel;
    ed_ServerCommandline: TEdit;
    btn_BrowseServer: TBitBtn;
    lbl_ServerPriority: TLabel;
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
    lb_IgnorePackages: TListBox;
    btn_AddIgnore: TBitBtn;
    btn_DelIgnore: TBitBtn;
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
    od_BrowseIni: TOpenDialog;
    ts_Layout: TTabSheet;
    lbl_TreeFont: TLabel;
    tv_TreeLayout: TTreeView;
    btn_FontSelect: TBitBtn;
    fd_Font: TFontDialog;
    lbl_LogLayout: TLabel;
    btn_LogFont: TBitBtn;
    lb_LogLayout: TListBox;
    cb_ExpandObject: TCheckBox;
    ts_ProgramOptions: TTabSheet;
    ed_StateFilename: TEdit;
    lbl_StateFile: TLabel;
    cb_MinimzeOnClose: TCheckBox;
    btn_Help: TBitBtn;
    cb_ModifiedOnStartup: TCheckBox;
    ts_HotKeys: TTabSheet;
    ed_HotKey: TEdit;
    hk_HotKey: THotKey;
    btn_SetHotKey: TBitBtn;
    lv_HotKeys: TListView;
    lbl_HTMLTitle: TLabel;
    ed_HHTitle: TEdit;
    Label1: TLabel;
    ed_DefInheritanceDepth: TEdit;
    ud_DefInheritDepth: TUpDown;
    ts_SourceSnoop: TTabSheet;
    btn_SourceFont: TBitBtn;
    re_Preview: TRichEditEx;
    cb_Background: TColorBox;
    lbl_BackGround: TLabel;
    lbl_TabSize: TLabel;
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
    lbl_TabsToSpaces: TLabel;
    ed_TabsToSpaces: TEdit;
    ud_TabsToSpaces: TUpDown;
    bvl_Sep1: TBevel;
    ed_InlineSearchTimeout: TEdit;
    lbl_InlineSearchTimeout: TLabel;
    ud_InlineSearchTimeout: TUpDown;
    lbl_CPP: TLabel;
    ed_CPPApp: TEdit;
    btn_SelectCPP: TBitBtn;
    mi_N7: TMenuItem;
    mi_SearchQuery: TMenuItem;
    mi_Inlinesearchquery: TMenuItem;
    mi_Classsearchquery: TMenuItem;
    lb_Fonts: TListBox;
    bvl_Font: TBevel;
    cb_fbold: TCheckBox;
    cb_fitalic: TCheckBox;
    cb_funderline: TCheckBox;
    cb_SelColor: TColorBox;
    cb_fstrikeout: TCheckBox;
    ts_Keywords: TTabSheet;
    bvl_Keys: TBevel;
    lb_PrimKey: TListBox;
    lb_SecKey: TListBox;
    ed_AddPrimKey: TEdit;
    ed_AddSecKey: TEdit;
    lbl_PrimKey: TLabel;
    lbl_SecondKey: TLabel;
    ed_HTMLDefaultTitle: TEdit;
    lbl_HTMLDefaultTitle: TLabel;
    ed_gpdf: TEdit;
    lbl_gpdf: TLabel;
    btn_BrowseGPDF: TBitBtn;
    lbl_OpenResult: TLabel;
    ed_OpenResultCmd: TEdit;
    btn_OpenResultPlaceHolder: TBitBtn;
    btn_OpenResultCmd: TBitBtn;
    bvl_Create: TBevel;
    lbl_Create: TLabel;
    ed_NewClassTemplate: TEdit;
    btn_BrowseTemplate: TBitBtn;
    od_BrowseUC: TOpenDialog;
    lbl_ExtCmtFile: TLabel;
    ed_ExtCmtFile: TEdit;
    btn_ExtCmtFile: TBitBtn;
    lbl_UPSDIR: TLabel;
    ed_UPSDIR: TEdit;
    btn_UPSDIR: TBitBtn;
    ts_PlugIns: TTabSheet;
    pnl_Caption: TPanel;
    btn_SAdd: TBitBtn;
    btn_SRemove: TBitBtn;
    lb_Paths: TListBox;
    btn_SUp: TBitBtn;
    btn_SDown: TBitBtn;
    clb_PackagePriority: TCheckListBox;
    btn_PUp: TBitBtn;
    btn_PDown: TBitBtn;
    btn_AddPackage: TBitBtn;
    btn_DelPackage: TBitBtn;
    btn_Ignore: TBitBtn;
    btn_Import: TBitBtn;
    cb_LoadCustomModules: TCheckBox;
    lbl_RunHint: TLabel;
    tv_SettingSelect: TTreeView;
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
    procedure cb_BackgroundChange(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure ed_TabSizeChange(Sender: TObject);
    procedure cb_FontColorChange(Sender: TObject);
    procedure cb_BGColorChange(Sender: TObject);
    procedure cb_LogFontColorChange(Sender: TObject);
    procedure cb_LogColorChange(Sender: TObject);
    procedure btn_UnIgnoreClick(Sender: TObject);
    procedure clb_PackagePriorityClickCheck(Sender: TObject);
    procedure btn_SelectCPPClick(Sender: TObject);
    procedure mi_SearchQueryClick(Sender: TObject);
    procedure mi_InlinesearchqueryClick(Sender: TObject);
    procedure mi_ClasssearchqueryClick(Sender: TObject);
    procedure ed_AddPrimKeyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ed_AddSecKeyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lb_PrimKeyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lb_SecKeyClick(Sender: TObject);
    procedure lb_PrimKeyClick(Sender: TObject);
    procedure lb_SecKeyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure lb_FontsClick(Sender: TObject);
    procedure cb_fboldClick(Sender: TObject);
    procedure cb_SelColorChange(Sender: TObject);
    procedure btn_BrowseGPDFClick(Sender: TObject);
    procedure btn_BrowseTemplateClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_ExtCmtFileClick(Sender: TObject);
    procedure btn_UPSDIRClick(Sender: TObject);
    procedure tv_SettingSelectExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tv_SettingSelectCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure tv_SettingSelectChange(Sender: TObject; Node: TTreeNode);
  private
  public
    TagChanged: boolean;
    procedure ReloadPreview;
    procedure ImportPackageList(filename: string);
  end;

var
  frm_Settings: Tfrm_Settings;

implementation

uses unit_main, unit_rtfhilight, unit_definitions;

{$R *.dfm}

var
  btextfont: TFont;
  bfntKeyword1: TFont;
  bfntKeyword2: TFont;
  bfntString: TFont;
  bfntNumber: TFont;
  bfntMacro: TFont;
  bfntComment: TFont;
  bfntName: TFont;
  bfntClassLink: TFont;
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

procedure Tfrm_Settings.ImportPackageList(filename: string);
var
  ini: TMemIniFile;
  sl: TStringList;
  i, j: integer;
  tmp: string;
begin
  ini := TMemIniFile.Create(FileName);
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
    if (clb_PackagePriority.Items.Count = 0) then begin
      if (FileExists(dir+PathDelim+'System'+PathDelim+'Default.ini')) then begin
        if MessageDlg('The "System\Default.ini" file has been found in this path.'+#13+#10+'Do you want to import the package priority from this file?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
          ImportPackageList(dir+PathDelim+'System'+PathDelim+'Default.ini');
        end;
      end;
    end;
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

  procedure TabsTree(idx: integer; root: TTreeNode = nil);
  var
    i: integer;
    ti: TTreeNode;
  begin
    for i := 0 to pc_Settings.PageCount-1 do begin
      if pc_Settings.Pages[i].Tag = idx then begin
        ti := tv_SettingSelect.Items.AddChildObject(root, pc_Settings.Pages[i].Caption, pc_Settings.Pages[i]);
        TabsTree(i, ti);
        ti.Expand(true);
      end;
    end;
  end;

begin
  TagChanged := false;
  TabsTree(-1);
  tv_SettingSelect.Select(tv_SettingSelect.Items.GetFirstNode);
  tv_TreeLayout.FullExpand;
  for i := 0 to frm_UnCodeX.al_Main.ActionCount-1 do begin
    li := lv_HotKeys.Items.Add;
    li.Caption := TAction(frm_UnCodeX.al_Main.Actions[i]).Caption;
    li.SubItems.Add(ShortCutToText(TAction(frm_UnCodeX.al_Main.Actions[i]).ShortCut));
    li.Data := frm_UnCodeX.al_Main.Actions[i];
    li.ImageIndex := TAction(frm_UnCodeX.al_Main.Actions[i]).ImageIndex;
  end;
  // backup old colors
  btextfont := TFont.Create;
  btextfont.Assign(unit_rtfhilight.textfont);
  lb_Fonts.Items.Objects[0] := unit_rtfhilight.textfont;
  bfntKeyword1 := TFont.Create;
  bfntKeyword1.Assign(unit_rtfhilight.fntKeyword1);
  lb_Fonts.Items.Objects[1] := unit_rtfhilight.fntKeyword1;
  bfntKeyword2 := TFont.Create;
  bfntKeyword2.Assign(unit_rtfhilight.fntKeyword2);
  lb_Fonts.Items.Objects[2] := unit_rtfhilight.fntKeyword2;
  bfntString := TFont.Create;
  bfntString.Assign(unit_rtfhilight.fntString);
  lb_Fonts.Items.Objects[3] := unit_rtfhilight.fntString;
  bfntNumber := TFont.Create;
  bfntNumber.Assign(unit_rtfhilight.fntNumber);
  lb_Fonts.Items.Objects[4] := unit_rtfhilight.fntNumber;
  bfntMacro := TFont.Create;
  bfntMacro.Assign(unit_rtfhilight.fntMacro);
  lb_Fonts.Items.Objects[5] := unit_rtfhilight.fntMacro;
  bfntComment := TFont.Create;
  bfntComment.Assign(unit_rtfhilight.fntComment);
  lb_Fonts.Items.Objects[6] := unit_rtfhilight.fntComment;
  bfntName := TFont.Create;
  bfntName.Assign(unit_rtfhilight.fntName);
  lb_Fonts.Items.Objects[7] := unit_rtfhilight.fntName;
  bfntClassLink := TFont.Create;
  bfntClassLink.Assign(unit_rtfhilight.fntClassLink);
  lb_Fonts.Items.Objects[8] := unit_rtfhilight.fntClassLink;
  btabs := unit_rtfhilight.tabs;
  //
  re_Preview.Font.Name := unit_rtfhilight.textfont.Name;
  re_Preview.Font.Size := unit_rtfhilight.textfont.Size;
  ud_TabSize.Position := unit_rtfhilight.tabs;
  ReloadPreview;
  
  if (FileExists(ExtractFilePath(ParamStr(0))+KEYWORDFILE1)) then
    lb_PrimKey.Items.LoadFromFile(ExtractFilePath(ParamStr(0))+KEYWORDFILE1);
  if (FileExists(ExtractFilePath(ParamStr(0))+KEYWORDFILE2)) then
    lb_SecKey.Items.LoadFromFile(ExtractFilePath(ParamStr(0))+KEYWORDFILE2);
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
  if (od_BrowseExe.Execute) then begin
    if (Pos(' ', od_BrowseExe.FileName) > 0) then ed_OpenResultCmd.Text := '"'+od_BrowseExe.FileName+'"'
    else ed_OpenResultCmd.Text := od_BrowseExe.FileName;
  end;
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
begin
  if (clb_PackagePriority.Items.Count > 0) then begin
    if MessageDlg('This will clear the current priority list.'+#13+#10+
      'Are you sure you want to continue ?', mtWarning, [mbYes,mbNo], 0) = mrNo then exit;
  end;
  if (od_BrowseIni.Execute) then begin
    clb_PackagePriority.Items.Clear;
    ImportPackageList(od_BrowseIni.FileName);
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

procedure Tfrm_Settings.cb_BackgroundChange(Sender: TObject);
begin
  re_Preview.Color := cb_Background.Selected;
end;

procedure Tfrm_Settings.btn_CancelClick(Sender: TObject);
begin
  unit_rtfhilight.textfont.Assign(btextfont);
  unit_rtfhilight.fntKeyword1.Assign(bfntKeyword1);
  unit_rtfhilight.fntKeyword2.Assign(bfntKeyword2);
  unit_rtfhilight.fntString.Assign(bfntString);
  unit_rtfhilight.fntNumber.Assign(bfntNumber);
  unit_rtfhilight.fntMacro.Assign(bfntMacro);
  unit_rtfhilight.fntComment.Assign(bfntComment);
  unit_rtfhilight.fntName.Assign(bfntName);
  unit_rtfhilight.fntClassLink.Assign(bfntClassLink);
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

procedure Tfrm_Settings.btn_SelectCPPClick(Sender: TObject);
begin
  od_BrowseExe.FileName := ed_CPPApp.Text;
  if (od_BrowseExe.Execute) then ed_CPPApp.Text := od_BrowseExe.FileName;
end;

procedure Tfrm_Settings.mi_SearchQueryClick(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %searchquery%';
end;

procedure Tfrm_Settings.mi_InlinesearchqueryClick(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %inlinesearch%';
end;

procedure Tfrm_Settings.mi_ClasssearchqueryClick(Sender: TObject);
begin
  ed_OpenResultCmd.Text := ed_OpenResultCmd.Text+' %classsearch%';
end;

procedure Tfrm_Settings.ed_AddPrimKeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_RETURN) and (ed_AddPrimKey.Text <> '')) then begin
    if (lb_PrimKey.Items.IndexOf(ed_AddPrimKey.text) = -1) then
      lb_PrimKey.Items.Add(ed_AddPrimKey.text);
    ed_AddPrimKey.Text := '';
  end;
end;

procedure Tfrm_Settings.ed_AddSecKeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_RETURN) and (ed_AddSecKey.Text <> '')) then begin
    if (lb_SecKey.Items.IndexOf(ed_AddSecKey.text) = -1) then
      lb_SecKey.Items.Add(ed_AddSecKey.text);
    ed_AddSecKey.Text := '';
  end;
end;

procedure Tfrm_Settings.lb_PrimKeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_DELETE) and (lb_PrimKey.ItemIndex <> -1)) then begin
    lb_PrimKey.Items.Delete(lb_PrimKey.ItemIndex);
  end;
end;

procedure Tfrm_Settings.lb_SecKeyClick(Sender: TObject);
begin
  if (lb_PrimKey.ItemIndex <> -1) then
    ed_AddSecKey.Text := lb_SecKey.Items[lb_SecKey.ItemIndex];
end;

procedure Tfrm_Settings.lb_PrimKeyClick(Sender: TObject);
begin
  if (lb_PrimKey.ItemIndex <> -1) then
    ed_AddPrimKey.Text := lb_PrimKey.Items[lb_PrimKey.ItemIndex];
end;

procedure Tfrm_Settings.lb_SecKeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_DELETE) and (lb_SecKey.ItemIndex <> -1)) then begin
    lb_SecKey.Items.Delete(lb_SecKey.ItemIndex);
  end;
end;

procedure Tfrm_Settings.FormDestroy(Sender: TObject);
begin
  btextfont.Free;
  bfntKeyword1.Free;
  bfntKeyword2.Free;
  bfntString.Free;
  bfntNumber.Free;
  bfntMacro.Free;
  bfntComment.Free;
  bfntName.Free;
  bfntClassLink.Free;
end;

procedure Tfrm_Settings.lb_FontsClick(Sender: TObject);
var
  tmpfnt: TFont;
begin
  if (lb_Fonts.ItemIndex = -1) then exit;
  tmpfnt := TFont(lb_Fonts.Items.Objects[lb_Fonts.ItemIndex]);
  cb_SelColor.Selected := clNone;
  cb_SelColor.Selected := tmpfnt.Color;
  cb_fbold.Checked := fsBold in tmpfnt.Style;
  cb_fItalic.Checked := fsItalic in tmpfnt.Style;
  cb_fUnderline.Checked := fsUnderline in tmpfnt.Style;
  cb_fStrikeout.Checked := fsStrikeout in tmpfnt.Style;
end;

procedure Tfrm_Settings.cb_fboldClick(Sender: TObject);
var
  tmpfnt: TFont;
  tmpstyle: TFontStyles;
begin
  if (lb_Fonts.ItemIndex = -1) then exit;
  tmpfnt := TFont(lb_Fonts.Items.Objects[lb_Fonts.ItemIndex]);
  tmpstyle := [];
  if (cb_fbold.Checked) then tmpstyle := tmpstyle + [fsBold];
  if (cb_fitalic.Checked) then tmpstyle := tmpstyle + [fsItalic];
  if (cb_funderline.Checked) then tmpstyle := tmpstyle + [fsUnderline];
  if (cb_fstrikeout.Checked) then tmpstyle := tmpstyle + [fsStrikeout];
  tmpfnt.Style := tmpstyle;
  ReloadPreview;
end;

procedure Tfrm_Settings.cb_SelColorChange(Sender: TObject);
var
  tmpfnt: TFont;
begin
  if (lb_Fonts.ItemIndex = -1) then exit;
  tmpfnt := TFont(lb_Fonts.Items.Objects[lb_Fonts.ItemIndex]);
  tmpfnt.Color := cb_SelColor.Selected;
  ReloadPreview;
end;

procedure Tfrm_Settings.btn_BrowseGPDFClick(Sender: TObject);
begin
  od_BrowseIni.FileName := ed_gpdf.Text;
  if (od_BrowseIni.Execute) then ed_gpdf.Text := od_BrowseIni.FileName;
end;

procedure Tfrm_Settings.btn_BrowseTemplateClick(Sender: TObject);
begin
  od_BrowseUC.FileName := ed_NewClassTemplate.Text;
  if (od_BrowseUC.Execute) then ed_NewClassTemplate.Text := od_BrowseUC.FileName;
end;

procedure Tfrm_Settings.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F1) then btn_Help.Click;
end;

procedure Tfrm_Settings.btn_ExtCmtFileClick(Sender: TObject);
begin
  od_BrowseIni.FileName := ed_ExtCmtFile.Text;
  if (od_BrowseIni.Execute) then ed_ExtCmtFile.Text := od_BrowseIni.FileName;
end;

procedure Tfrm_Settings.btn_UPSDIRClick(Sender: TObject);
var
  dir: string;
begin
  dir := ed_UPSDIR.Text;
  if SelectDirectory('Select the UnCodeX Pascal Script directory', '', dir) then begin
    ed_UPSDIR.Text := dir;
  end;
end;

procedure Tfrm_Settings.tv_SettingSelectExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  if (Node.Expanded) then AllowExpansion := false;
end;

procedure Tfrm_Settings.tv_SettingSelectCollapsing(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
begin
  AllowCollapse := false;
end;

procedure Tfrm_Settings.tv_SettingSelectChange(Sender: TObject;
  Node: TTreeNode);
begin
  pc_Settings.ActivePage := TTabSheet(Node.Data);
  pnl_Caption.Caption := '  '+pc_Settings.ActivePage.Caption;
end;

end.
