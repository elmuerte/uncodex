{*******************************************************************************
  Name:
    unit_main
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Main window for the GUI

  $Id: unit_main.pas,v 1.151 2005-03-28 12:22:51 elmuerte Exp $
*******************************************************************************}

{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003-2005  Michiel Hendriks

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

unit unit_main;

{$I defines.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, Menus, StdCtrls, unit_packages, ExtCtrls,
  unit_uclasses, IniFiles, ShellApi, AppEvnts, ImgList, ActnList, StrUtils,
  Clipbrd, hh, hh_funcs, ToolWin, richedit, unit_richeditex, unit_searchform,
  Buttons, DdeMan, unit_props, uPSComponent, uPSComponent_Default,
  IFSI_unit_uclasses, unit_pascalscript_ex, unit_definitions;

const
  // custom window messages
  WM_APPBAR               = WM_USER+$100;
  UM_APP_ID_CHECK         = WM_APP + 101;
  UM_RESTORE_APPLICATION  = WM_APP + 102;
  // misc constants
  TV_ALWAYSEXPAND         = 0;
  TV_NOEXPAND             = 1;

type
  Tfrm_UnCodeX = class(TForm)
    tv_Classes: TTreeView;
    tv_Packages: TTreeView;
    sb_Status: TStatusBar;
    pb_Scan: TProgressBar;
    mm_Main: TMainMenu;
    mi_Tree: TMenuItem;
    mi_ScanPackages: TMenuItem;
    tmr_StatusText: TTimer;
    mi_N1: TMenuItem;
    mi_Settings: TMenuItem;
    pm_ClassTree: TPopupMenu;
    mi_OpenClass: TMenuItem;
    mi_N2: TMenuItem;
    mi_Analyseclass: TMenuItem;
    mi_HTMLoutput: TMenuItem;
    mi_Createindexfiles: TMenuItem;
    mi_Analyseallclasses: TMenuItem;
    mi_findorphans1: TMenuItem;
    mi_N4: TMenuItem;
    ae_AppEvent: TApplicationEvents;
    al_Main: TActionList;
    ac_RecreateTree: TAction;
    ac_FindOrphans: TAction;
    ac_AnalyseAll: TAction;
    ac_CreateHTMLfiles: TAction;
    ac_Settings: TAction;
    mi_N5: TMenuItem;
    mi_Quit: TMenuItem;
    tb_Tools: TToolBar;
    btn_RebuildTree: TToolButton;
    btn_FindOrphan: TToolButton;
    btn_AnalyseAll: TToolButton;
    btn_Sep2: TToolButton;
    btn_CreateHTML: TToolButton;
    btn_Sep3: TToolButton;
    btn_Settings: TToolButton;
    il_Small: TImageList;
    btn_Sep4: TToolButton;
    btn_Abort: TToolButton;
    mi_HelpMenu: TMenuItem;
    mi_About: TMenuItem;
    ac_Abort: TAction;
    ac_FindClass: TAction;
    btn_Sep1: TToolButton;
    btn_OpenClass: TToolButton;
    btn_FindClass: TToolButton;
    ac_OpenClass: TAction;
    ac_OpenOutput: TAction;
    mi_OpenOutput: TMenuItem;
    btn_OpenOutput: TToolButton;
    ac_SaveState: TAction;
    mi_N6: TMenuItem;
    mi_SaveState: TMenuItem;
    mi_LoadState: TMenuItem;
    ac_LoadState: TAction;
    ac_About: TAction;
    btn_HTMLHelp: TToolButton;
    ac_HTMLHelp: TAction;
    mi_N8: TMenuItem;
    mi_CreateHTMLHelp: TMenuItem;
    mi_N9: TMenuItem;
    mi_Expandall: TMenuItem;
    mi_Collapseall: TMenuItem;
    mi_Compile: TMenuItem;
    mi_FindClass2: TMenuItem;
    mi_View: TMenuItem;
    mi_Toolbar: TMenuItem;
    mi_N10: TMenuItem;
    mi_PackageTree: TMenuItem;
    mi_ClassTree: TMenuItem;
    mi_Log: TMenuItem;
    mi_N11: TMenuItem;
    mi_Stayontop: TMenuItem;
    mi_Savesize: TMenuItem;
    mi_Saveposition: TMenuItem;
    mi_N12: TMenuItem;
    mi_GameServer: TMenuItem;
    mi_Startserver: TMenuItem;
    mi_Joinserver: TMenuItem;
    mi_Menubar: TMenuItem;
    mi_Toolwindow: TMenuItem;
    mi_Right: TMenuItem;
    ac_CompileClass: TAction;
    ac_RunServer: TAction;
    ac_JoinServer: TAction;
    mi_Autohide: TMenuItem;
    mi_N13: TMenuItem;
    mi_Left: TMenuItem;
    mi_FindClass: TMenuItem;
    mi_FindNext: TMenuItem;
    ac_FindNext: TAction;
    re_SourceSnoop: TRichEditEx;
    mi_SourceSnoop: TMenuItem;
    mi_FindNext2: TMenuItem;
    mi_Find: TMenuItem;
    mi_N14: TMenuItem;
    mi_FullTextSearch: TMenuItem;
    ac_FullTextSearch: TAction;
    tb_FindNext: TToolButton;
    tb_FullTextSearch: TToolButton;
    tb_Sep4: TToolButton;
    tb_RunServer: TToolButton;
    tb_JoinServer: TToolButton;
    btn_Sep5: TToolButton;
    ac_Tags: TAction;
    mi_ShowProperties: TMenuItem;
    mi_N15: TMenuItem;
    mi_Copyname: TMenuItem;
    ac_CopyName: TAction;
    mi_Help2: TMenuItem;
    ac_Help: TAction;
    ac_Close: TAction;
    ac_VMenuBar: TAction;
    ac_VToolbar: TAction;
    ac_VPackageTree: TAction;
    ac_VLog: TAction;
    ac_VSaveSize: TAction;
    ac_VSavePosition: TAction;
    ac_VStayOnTop: TAction;
    ac_VAutoHide: TAction;
    ac_VTRight: TAction;
    ac_VTLeft: TAction;
    mi_AnalyseModifiedClasses: TMenuItem;
    ac_AnalyseModified: TAction;
    btn_AnalyseModified: TToolButton;
    mi_Output: TMenuItem;
    mi_SingleOutput: TMenuItem;
    ac_SourceSnoop: TAction;
    ac_VSourceSnoop: TAction;
    pm_SourceSnoop: TPopupMenu;
    mi_CopyToCliptboard: TMenuItem;
    mi_saveToFile: TMenuItem;
    ac_CopySelection: TAction;
    ac_SaveToRTF: TAction;
    ac_SelectAll: TAction;
    sd_SaveToRTF: TSaveDialog;
    mi_N16: TMenuItem;
    mi_SelectAll: TMenuItem;
    mi_N17: TMenuItem;
    mi_ClearHilight: TMenuItem;
    mi_FindSelection: TMenuItem;
    tmr_InlineSearch: TTimer;
    mi_ClassName: TMenuItem;
    mi_PackageName: TMenuItem;
    mi_License: TMenuItem;
    ac_License: TAction;
    EXEC: TDdeServerConv;
    cmd: TDdeServerItem;
    ac_RebuildAnalyse: TAction;
    mi_N7: TMenuItem;
    mi_RebuildAnalyse: TMenuItem;
    ac_OpenHTMLHelp: TAction;
    mi_OpenHTMLHelpFile: TMenuItem;
    dckTop: TPanel;
    dckBottom: TPanel;
    dckLeft: TPanel;
    dckRight: TPanel;
    splLeft: TSplitter;
    splTop: TSplitter;
    splBottom: TSplitter;
    lb_Log: TListBox;
    ac_PropInspector: TAction;
    mi_PropInspector: TMenuItem;
    pnlCenter: TPanel;
    splRight: TSplitter;
    mi_FTS2: TMenuItem;
    mi_SwitchTree: TMenuItem;
    ac_SwitchTree: TAction;
    ac_CreateSubClass: TAction;
    mi_CreateSubClass: TMenuItem;
    ac_DeleteClass: TAction;
    mi_DeleteClass: TMenuItem;
    N1: TMenuItem;
    mi_MoveClass: TMenuItem;
    mi_RenameClass: TMenuItem;
    ac_MoveClass: TAction;
    ac_RenameClass: TAction;
    ac_PackageProps: TAction;
    mi_Properties: TMenuItem;
    pm_Log: TPopupMenu;
    mi_OpenClass1: TMenuItem;
    mi_SaveToFile1: TMenuItem;
    sd_SaveLog: TSaveDialog;
    fr_Props: Tfr_Properties;
    ac_DefProps: TAction;
    mi_DefProps: TMenuItem;
    mi_SortList: TMenuItem;
    btn_Sep6: TToolButton;
    btn_CProp: TToolButton;
    btn_PProp: TToolButton;
    mi_Donate: TMenuItem;
    mi_N21: TMenuItem;
    mi_N31: TMenuItem;
    mi_Browse: TMenuItem;
    N2: TMenuItem;
    mi_Run: TMenuItem;
    ac_Run: TAction;
    ps_Main: TPSScript;
    mi_PascalScript: TMenuItem;
    psi_Classes: TPSImport_Classes;
    psi_DateUtils: TPSImport_DateUtils;
    mi_PluginDiv2: TMenuItem;
    ac_PSEditor: TAction;
    psi_unit_uclasses: TPSImport_unit_uclasses;
    psi_miscclasses: TPSImport_miscclasses;
    ac_PluginRefresh: TAction;
    mi_Refresh: TMenuItem;
    mi_PluginDiv1: TMenuItem;
    ps_dll: TPSDllPlugin;
    ac_FindNewClasses: TAction;
    mi_FindNew: TMenuItem;
    mi_Clear: TMenuItem;
    il_LogEntries: TImageList;
    mi_Replication1: TMenuItem;
    mi_Defaultproperties1: TMenuItem;
    N3: TMenuItem;
    ac_GoToReplication: TAction;
    ac_GoToDefaultproperties: TAction;
    procedure tmr_StatusTextTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mi_AnalyseclassClick(Sender: TObject);
    procedure ae_AppEventHint(Sender: TObject);
    procedure ac_RecreateTreeExecute(Sender: TObject);
    procedure ac_FindOrphansExecute(Sender: TObject);
    procedure ac_AnalyseAllExecute(Sender: TObject);
    procedure ac_CreateHTMLfilesExecute(Sender: TObject);
    procedure ac_SettingsExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ac_AbortExecute(Sender: TObject);
    procedure ac_FindClassExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ac_OpenClassExecute(Sender: TObject);
    procedure ac_OpenOutputExecute(Sender: TObject);
    procedure ac_SaveStateExecute(Sender: TObject);
    procedure ac_LoadStateExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ac_AboutExecute(Sender: TObject);
    procedure ac_HTMLHelpExecute(Sender: TObject);
    procedure mi_ExpandallClick(Sender: TObject);
    procedure mi_CollapseallClick(Sender: TObject);
    procedure spl_Main2CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ac_RunServerExecute(Sender: TObject);
    procedure ac_JoinServerExecute(Sender: TObject);
    procedure ac_CompileClassExecute(Sender: TObject);
    procedure ac_FindNextExecute(Sender: TObject);
    procedure ac_FullTextSearchExecute(Sender: TObject);
    procedure lb_LogDblClick(Sender: TObject);
    procedure lb_LogClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tv_ClassesDblClick(Sender: TObject);
    procedure ac_TagsExecute(Sender: TObject);
    procedure ac_CopyNameExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ac_CloseExecute(Sender: TObject);
    procedure ac_VMenuBarExecute(Sender: TObject);
    procedure ac_VToolbarExecute(Sender: TObject);
    procedure ac_VPackageTreeExecute(Sender: TObject);
    procedure ac_VLogExecute(Sender: TObject);
    procedure ac_VStayOnTopExecute(Sender: TObject);
    procedure ac_VAutoHideExecute(Sender: TObject);
    procedure ac_VTRightExecute(Sender: TObject);
    procedure ac_VTLeftExecute(Sender: TObject);
    procedure ac_VSavePositionExecute(Sender: TObject);
    procedure ac_VSaveSizeExecute(Sender: TObject);
    procedure mi_Help2Click(Sender: TObject);
    procedure ac_HelpExecute(Sender: TObject);
    procedure ac_AnalyseModifiedExecute(Sender: TObject);
    procedure tv_ClassesExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tv_ClassesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tv_ClassesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ac_SourceSnoopExecute(Sender: TObject);
    procedure tv_ClassesChange(Sender: TObject; Node: TTreeNode);
    procedure ac_VSourceSnoopExecute(Sender: TObject);
    procedure ac_CopySelectionExecute(Sender: TObject);
    procedure ac_SaveToRTFExecute(Sender: TObject);
    procedure ac_SelectAllExecute(Sender: TObject);
    procedure re_SourceSnoopMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure mi_ClearHilightClick(Sender: TObject);
    procedure mi_FindSelectionClick(Sender: TObject);
    procedure re_SourceSnoopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ae_AppEventException(Sender: TObject; E: Exception);
    procedure tv_ClassesKeyPress(Sender: TObject; var Key: Char);
    procedure tmr_InlineSearchTimer(Sender: TObject);
    procedure tv_ClassesExit(Sender: TObject);
    procedure ae_AppEventMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure cmdPokeData(Sender: TObject);
    procedure mi_ClassNameDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure pm_ClassTreePopup(Sender: TObject);
    procedure mi_PackageNameDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure ac_LicenseExecute(Sender: TObject);
    procedure ac_RebuildAnalyseExecute(Sender: TObject);
    procedure ac_OpenHTMLHelpExecute(Sender: TObject);
    procedure dckLeftDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure dckLeftUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure ac_PropInspectorExecute(Sender: TObject);
    procedure tv_ClassesEnter(Sender: TObject);
    procedure splRightCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure splRightMoved(Sender: TObject);
    procedure re_SourceSnoopEndDock(Sender, Target: TObject; X,
      Y: Integer);
    procedure pnlCenterUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure pnlCenterDockDrop(Sender: TObject; Source: TDragDockObject;
      X, Y: Integer);
    procedure ac_SwitchTreeExecute(Sender: TObject);
    procedure ac_CreateSubClassExecute(Sender: TObject);
    procedure ac_DeleteClassExecute(Sender: TObject);
    procedure ac_PackagePropsExecute(Sender: TObject);
    procedure mi_SaveToFile1Click(Sender: TObject);
    procedure pm_LogPopup(Sender: TObject);
    procedure ac_MoveClassExecute(Sender: TObject);
    procedure ac_DefPropsExecute(Sender: TObject);
    procedure ac_RenameClassExecute(Sender: TObject);
    procedure mi_SortListClick(Sender: TObject);
    procedure mi_DonateClick(Sender: TObject);
    procedure ac_RunExecute(Sender: TObject);
    procedure ps_MainLine(Sender: TObject);
    procedure ps_MainCompile(Sender: TPSScript);
    procedure ac_PSEditorExecute(Sender: TObject);
    procedure ps_MainExecute(Sender: TPSScript);
    procedure ac_PluginRefreshExecute(Sender: TObject);
    procedure ac_FindNewClassesExecute(Sender: TObject);
  procedure mi_ClearClick(Sender: TObject);
    procedure lb_LogDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ac_GoToReplicationExecute(Sender: TObject);
    procedure ac_GoToDefaultpropertiesExecute(Sender: TObject);
  private
    // AppBar vars
    OldStyleEx: Cardinal;
    OldStyle: Cardinal;
    OldSize: TRect;
    OldWindowState: TWindowState;
    IsAppBar: boolean;
    ABAutoHide: boolean;
    abd: APPBARDATA;
    WorkArea: TRect;
    ABWidth: integer;
    // AppBar vars -- end;
    function ThreadCreate: boolean;
    procedure ThreadTerminate(Sender: TObject);
    procedure SearchThreadTerminate(Sender: TObject);
    procedure SaveState;
    procedure LoadState;
    procedure UpdateSystemMenu;
    procedure WMSysCommand (var Msg : TMessage); message WM_SysCommand;
    // AppBar methods
    procedure WMAppBar(var Msg : TMessage); message WM_AppBar;
    procedure WMNCLBUTTONDOWN(var Msg: TWMNCLBUTTONDOWN); message WM_NCLBUTTONDOWN;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure RegisterAppBar;
    procedure UnregisterAppBar;
    procedure RegisterABAutoHide;
    procedure UnregisterABAutoHide;
    procedure ABResize;
    // AppBar methods -- end
    // -reuse methods
    procedure UMAppIDCheck(var Message : TMessage); message UM_APP_ID_CHECK;
    procedure WMCopyData(var msg: TWMCopyData); message WM_COPYDATA;
    procedure UMRestoreApplication(var msg: TMessage); message UM_RESTORE_APPLICATION;
    // Custom output modules
    procedure LoadOutputModules;
    procedure LoadPascalScripts;
    procedure miCustomOutputClick(sender: TObject);
    procedure miPascalScriptsClick(sender: TObject);
    procedure CallCustomOutputModule(module: string; selectedclass: TUClass = nil; issingle: boolean = false);
    function ExecutePascalScript(filename: string): boolean;
    // inline search
    procedure InlineSearchNext(skipcurrent: boolean = false);
    procedure InlineSearchPrevious(skipcurrent: boolean = false);
    procedure InlineSearchComplete;
    procedure ShowDockPanel(DockHost: TControl; MakeVisible: Boolean; Client: TControl);
    procedure OnDockVisChange(client: TControl; visible: boolean; var CanChange: boolean);
    procedure OnDockDragStart(client: TControl; var CanDrag: boolean);
    // other
    procedure DeleteClass(uclass: TUClass; recurse: boolean = false);
    function SourceSnoopOpenClass(filename: string; uclass: TUClass): boolean;
    function SourceSnoopOpenPackage(upackage: TUPackage): boolean;
    // settings
    procedure SaveSettings;
    procedure SaveLayoutSettings;
    procedure LoadSettings;
    procedure AddBrowserHistory(uclass: TUClass; filename: string; line: integer; hint: string = '');
    procedure BrowseEntry(Sender: TObject);
  public
    statustext : string; // current status text
    procedure NextBatchCommand;
    procedure ExecuteProgram(exe: string; params: TStringList = nil; prio: integer = -1; show: integer = SW_SHOW);
    procedure OpenSourceLine(filename: string; line, caret: integer; uclass: TUClass);
    procedure OpenSourceInline(filename: string; line, caret: integer; uclass: TUClass = nil; nohighlight: boolean = false);
  end;

  // status redirecting
  TCodeXStatusType = (cxstLog, cxstStatus);

  TCodeXStatus = packed record
    Msg: string[255];
    mType: TCodeXStatusType;
    Progress: byte;
  end;

  // logging
  procedure Log(msg: string; mt: TLogType = ltInfo; obj: TObject = nil);
  procedure ClearLog;

  procedure StatusReport(msg: string; progress: byte = 255);

var
  frm_UnCodeX:      Tfrm_UnCodeX;
  DoInit:           boolean = true; // perform initialization on startup
  runningthread:    TThread = nil;
  InitActivateFix:  Boolean = true; // fix initial form activation
  ConfigFile:       string; // current config file
  InitialStartup:   boolean; // is first run
  hh_Help:          THookHelpSystem; // help system
  OutputModules:    TStringList; // custom output modules
  // UScript data
  PackageList:      TUPackageList;
  ClassList:        TUClassList;
  SelectedUClass:   TUClass = nil;
  SelectedUPackage: TUPackage = nil;
  // class search vars
  SearchConfig,
  DefaultSC:        TClassSearch;
  IsInlineSearch:   boolean;
  InlineSearch:     string;
  OpenFind:         boolean = false; // only on startup
  OpenTags:         boolean = false; // only on startup
  OpenFTS:          boolean = false; // only on startup
  // batch vars
  IsBatching:       boolean = false; // is batch executing
  CmdStack:         TStringList; // command stack
  // -handle argument
  StatusHandle:     integer = -1;
  // used for -reuse
  PrevInst,
  RestoreHandle:    HWND;
  AppInstanceId:    integer = 0;
  LastBuildTime,
  LastAnalyseTime:  TDateTime;

// config vars
var
  // general
  StateFile,
  GPDF,
  ExtCommentFile:         string;
  SourcePaths:            TStringList;
  PackagePriority:        TStringList;
  IgnorePackages:         TStringList;
  MinimizeOnClose:        boolean = false;
  ClassPropertiesWindow:  boolean = false;
  PascalScriptDir:        string;
  // startup
  ExpandObject:           boolean;
  AnalyseModified:        boolean;
  LoadCustomOutputModules:boolean = true;
  // HTML out
  HTMLOutputDir,
  TemplateDir,
  HTMLTargetExt,
  CPPApp,
  HTMLdefaultTitle:       string;
  TabsToSpaces:           integer;
  // HTML Help out
  HHCPath,
  HTMLHelpFile,
  HHTitle:                string;
  // Start server
  ServerCmd,
  ClientCmd:              string;
  ServerPrio: integer;
  // Commandlines
  CompilerCmd,
  OpenResultCmd:          string;
  NewClassTemplate:       string;
  // class properties
  DefaultInheritanceDepth:integer = 0;

implementation

uses unit_settings, unit_analyse, unit_htmlout,
  unit_treestate, unit_about, unit_mshtmlhelp, unit_fulltextsearch,
  unit_tags, unit_outputdefs, unit_rtfhilight, unit_utils, unit_license,
  unit_splash, unit_ucxdocktree, unit_ucops, unit_pkgprops, unit_defprops,
  unit_rungame, unit_pascalscript, unit_pascalscript_gui, unit_pseditor;

const
  PROCPRIO: array[0..3] of Cardinal = (IDLE_PRIORITY_CLASS, NORMAL_PRIORITY_CLASS,
                    HIGH_PRIORITY_CLASS, REALTIME_PRIORITY_CLASS);
  AUTOHIDEEXPOSURE = 4; // number of pixel to show of the app bar

var
  splRightHack: integer;
  OutputModule: THandle;

{$R *.dfm}

{ Status redirecting }

procedure SendStatusMsg(msg: string; mType: TCodeXStatusType; Progress: byte = 0);
var
  CopyData: TCopyDataStruct;
  Data: TCodeXStatus;
begin
  if (StatusHandle = -1) then exit;
  Data.Msg := msg;
  Data.mType := mType;
  Data.Progress := Progress;
  CopyData.cbData := SizeOf(Data);
  CopyData.dwData := StatusHandle;
  CopyData.lpData := @Data;
  SendMessage(StatusHandle, WM_COPYDATA, frm_UnCodeX.Handle, Integer(@CopyData));
end;

{ Status redirecting -- END }
{ Logging }

procedure Log(msg: string; mt: TLogType = ltInfo; obj: TObject = nil);
var
  entry: TLogEntry;
begin
  if (frm_UnCodeX = nil) then exit;
  if (msg='') then exit;
  with frm_UnCodeX.lb_Log do begin
    if (not IsA(obj, TLogEntry)) then begin
      entry := CreateLogEntry(obj);
    end
    else entry := TLogEntry(obj);

    if (entry.filename = '') then begin
      if (IsA(entry.obj, TUClass)) then begin
        entry.filename := TUClass(entry.obj).FullFileName;
      end
      else if (IsA(entry.obj, TUDeclaration)) then begin
        entry.filename := TUDeclaration(entry.obj).declaration;
        entry.line := TUDeclaration(entry.obj).srcline;
      end;
    end;

    entry.mt := mt;
    Items.AddObject(msg, entry);
    frm_UnCodeX.lb_Log.ItemIndex := frm_UnCodeX.lb_Log.Items.Count-1;
    if (StatusHandle <> -1) then SendStatusMsg(msg, cxstLog);
  end;
end;

procedure ClearLog;
var
  i: integer;
begin
  if (frm_UnCodeX = nil) then exit;
  with frm_UnCodeX.lb_Log do begin
    for i := 0 to Items.count-1 do begin
      if (IsA(Items.Objects[i], TLogEntry)) then Items.Objects[i].Free;
    end;
    Items.Clear;
  end;
end;

{ Logging -- END }

// update status
procedure StatusReport(msg: string; progress: byte = 255);
begin
  frm_UnCodeX.statustext := msg;
  if (progress <> 255) then frm_UnCodeX.pb_Scan.Position := progress;
  // redirect status if set
  if (StatusHandle <> -1) then SendStatusMsg(msg, cxstStatus, progress);
end;

function FontStylesToInt(style: TFontStyles): cardinal;
begin
  result := 0;
  if (fsBold in style) then result := result or 1;
  if (fsItalic in style) then result := result or 2;
  if (fsUnderline in style) then result := result or 4;
  if (fsStrikeout in style) then result := result or 8;
end;

function IntToFontStyles(style: cardinal): TFontStyles;
begin
  result := [];
  if (1 and style <> 0) then result := result + [fsBold];
  if (2 and style <> 0) then result := result + [fsItalic];
  if (4 and style <> 0) then result := result + [fsUnderline];
  if (8 and style <> 0) then result := result + [fsStrikeout];
end;


{ Tfrm_UnCodeX }
{ Custom methods }

// Can create a new thread
function Tfrm_UnCodeX.ThreadCreate: boolean;
begin
  if (runningthread <> nil) then Result := false
  else begin
    ac_Abort.Enabled := true;
    Result := True;
  end;
end;

// Running thread terminated, clean up
procedure Tfrm_UnCodeX.ThreadTerminate(Sender: TObject);
begin
  if (IsA(runningthread, TMSHTMLHelp)) then ac_OpenHTMLHelp.Enabled := FileExists(HTMLHelpFile);
  runningthread := nil;
  {if (OutputModule <> 0) then begin
    FreeLibrary(OutputModule);
    OutputModule := 0;
  end;}
  ac_Abort.Enabled := false;
  if (IsBatching) then NextBatchCommand
  else begin
    if (TreeUpdated and fr_Props.Visible) then begin
      fr_Props.uclass := SelectedUClass;
      fr_Props.LoadClass;
    end;
  end;
end;

procedure Tfrm_UnCodeX.SearchThreadTerminate(Sender: TObject);
var
  i: integer;
begin
  if (SearchConfig.isFindFirst and (lb_Log.Items.Count > 0)) then begin
    lb_Log.ItemIndex := 0;
    SelectedUClass := TUClass(lb_Log.Items.Objects[0]);
    for i := 0 to SearchConfig.searchtree.Items.Count do begin
      if (SearchConfig.searchtree.Items[i].Data = SelectedUClass) then begin
        SearchConfig.searchtree.Select(SearchConfig.searchtree.Items[i]);
        break;
      end;
    end;
    lb_LogClick(Sender);
  end;
  ThreadTerminate(Sender);
end;

{ Package\Class Tree state }

procedure Tfrm_UnCodeX.SaveState;
var
  fs: TFileStream;
begin
  StatusReport('Saving state to '+StateFile);
  tmr_StatusText.OnTimer(nil);
  Application.ProcessMessages;
  fs := TFileStream.Create(StateFile, fmCreate or fmShareExclusive);
  try
    with (TUnCodeXState.Create(ClassList, tv_Classes, PackageList, tv_Packages)) do begin
      SaveTreeToStream(fs);
      Free;
    end;
  finally
    fs.Free;
  end;
  StatusReport('State saved');
end;

procedure Tfrm_UnCodeX.LoadState;
var
  fs: TFileStream;
  res: boolean;
  node: TTreeNode;
begin
  if (not FileExists(StateFile)) then begin
    if (not tv_Packages.Visible) then begin
      // required for some reason
      // when it's docked hidden things go wrong
      tv_Packages.Items.Add(nil, 'dummy');
      tv_Packages.Items.Clear;
    end;
    exit;
  end;
  StatusReport('Loading state from '+StateFile);
  tmr_StatusText.OnTimer(nil);
  Application.ProcessMessages;
  fs := TFileStream.Create(StateFile, fmOpenRead or fmShareExclusive);
  try
    with (TUnCodeXState.Create(ClassList, tv_Classes, PackageList, tv_Packages)) do begin
      res := LoadTreeFromStream(fs);
      Free;
    end;
    if (res) then begin
      PackageList.Sort;
      tv_Packages.Items.AlphaSort(true);
      ClassList.Sort;
      tv_Classes.Items.AlphaSort(true);
      tv_Classes.Tag := TV_ALWAYSEXPAND;
      tv_Packages.Tag := TV_ALWAYSEXPAND;
      if (ExpandObject and (tv_Classes.Items.Count > 0)) then begin
        node := tv_Classes.Items.GetFirstNode;
        while (CompareText(node.Text, 'object') <> 0) do begin
          node := node.getNextSibling;
        end;
        node.Expand(false);
      end;
      StatusReport('State loaded');
    end
    else begin
      PackageList.Clear;
      ClassList.Clear;
      tv_Packages.Items.Clear;
      tv_Classes.Items.Clear;
      StatusReport('State '''+StateFile+''' file is corrupt');
    end;
  finally
    fs.Free;
  end;
end;

{ Package\Class Tree state -- END }
{ System menu modification }

procedure Tfrm_UnCodeX.UpdateSystemMenu;
var
  SysMenu: HMenu;
  Minfo: TMENUITEMINFO;
begin
  SysMenu := GetSystemMenu(frm_UnCodeX.Handle, false);
  Minfo.cbSize := SizeOf(TMENUITEMINFO);
  Minfo.fMask := MIIM_TYPE;
  Minfo.fType := MFT_SEPARATOR;
  InsertMenuItem(Sysmenu, 0, true, Minfo);
  // Add view menu
  Minfo.cbSize := SizeOf(TMENUITEMINFO);
  Minfo.fMask := MIIM_ID or MIIM_TYPE or MIIM_SUBMENU;
  Minfo.fType := MFT_STRING;
  Minfo.hSubMenu := mi_View.Handle;
  Minfo.dwTypeData := PChar(mi_View.Caption);
  InsertMenuItem(Sysmenu, 0, false, Minfo);
end;

// redirect system menu commands to main menu
procedure Tfrm_UnCodeX.WMSysCommand (var Msg : TMessage);
begin
  if mm_Main.DispatchCommand(Msg.WParam) then Exit;
  Inherited;
end;

{ Application bar\Tool window methods }

procedure Tfrm_UnCodeX.WMAppBar(var Msg : TMessage);
begin
  // TODO: what was this for again ?
end;

procedure Tfrm_UnCodeX.WMNCLBUTTONDOWN(var Msg: TWMNCLBUTTONDOWN);
begin
  // prevent moving
  if ((Msg.HitTest = HTCAPTION) and IsAppBar) then begin
    BringToFront;
    Msg.HitTest := Windows.HTNOWHERE;
  end;
  inherited;
end;

procedure Tfrm_UnCodeX.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  if (IsAppBar) then begin
    // show bar
    if ((Msg.Result = HTLEFT) and ABAutoHide and (abd.uEdge = ABE_RIGHT)) then begin
      Left := abd.rc.Right-Width;
    end
    else if ((Msg.Result = HTRIGHT) and ABAutoHide and (abd.uEdge = ABE_LEFT)) then begin
      Left := abd.rc.Left;
    end
    // prevent resizing
    else if (Msg.Result in [HTBOTTOM, HTTOP, HTGROWBOX, HTSIZE, HTBOTTOMLEFT,
      HTBOTTOMRIGHT, HTTOPLEFT, HTTOPRIGHT]) then begin
      Msg.Result := Windows.HTNOWHERE;
    end
    else if ((Msg.Result in [HTRIGHT]) and (abd.uEdge = ABE_RIGHT)) then begin
      Msg.Result := Windows.HTNOWHERE;
    end
    else if ((Msg.Result in [HTLEFT]) and (abd.uEdge = ABE_LEFT)) then begin
      Msg.Result := Windows.HTNOWHERE;
    end
  end;
end;

// Auto hide when the mouse leaves
procedure Tfrm_UnCodeX.CMMouseLeave(var msg: TMessage);
var
  pt: TPoint;
begin
  inherited;
  if (IsAppBar and ABAutoHide and GetCursorPos(pt)) then begin
    if ((pt.X < Left) or (pt.Y > abd.rc.Bottom) and (abd.uEdge = ABE_RIGHT)) then Left := abd.rc.Left
    else if ((pt.X > Left+Width) or (pt.Y > abd.rc.Bottom) and (abd.uEdge = ABE_LEFT)) then Left := AUTOHIDEEXPOSURE-ABWidth;
  end;
end;

// Register the Tool window
procedure Tfrm_UnCodeX.RegisterAppBar;
begin
  if (IsAppBar) then exit;
  // Change window look
  OldStyleEx := GetWindowLong(Handle, GWL_EXSTYLE);
  OldStyle := GetWindowLong(Handle, GWL_STYLE);
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  SetWindowLong(Handle, GWL_STYLE, OldStyle);
  OldSize.Left := Left;
  OldSize.Top := Top;
  OldSize.Right := Width;
  OldSize.Bottom := Height;
  OldWindowState := WindowState;
  if (WindowState <> wsNormal) then WindowState := wsNormal;
  SystemParametersInfo(SPI_GETWORKAREA, 0, @WorkArea, 0);

  // Register bar
  abd.cbSize := SizeOf(APPBARDATA);
  abd.hWnd := Handle;
  abd.uCallbackMessage := WM_APPBAR;
  SHAppBarMessage(ABM_NEW, abd);

  if (abd.uEdge = ABE_RIGHT) then begin
    abd.rc.Left := WorkArea.Right-ABWidth;
    abd.rc.Right := WorkArea.Right;
  end
  else if (abd.uEdge = ABE_Left) then begin
    abd.rc.Left := WorkArea.Left;
    abd.rc.Right := WorkArea.Left+ABWidth;
  end;
  abd.rc.Top := WorkArea.Top;
  abd.rc.Bottom := WorkArea.Bottom;
  Top := abd.rc.Top;
  Left := abd.rc.Left;
  Height := abd.rc.Bottom-abd.rc.Top;
  Width := ABWidth;
  if (not ABAutoHide) then shAppBarMessage(ABM_setPos, abd);
  if (ABAutoHide) then RegisterABAutoHide;
  abd.lParam := 1;
  shAppBarMessage(ABM_ACTIVATE, abd);
  IsAppBar := true;
end;

// Remove the tool window
procedure Tfrm_UnCodeX.UnregisterAppBar;
begin
  if (IsAppBar) then begin
    Hide;
    SetWindowLong(Handle, GWL_STYLE, OldStyle);
    SetWindowLong(Handle, GWL_EXSTYLE, OldStyleEx);
    SHAppBarMessage(ABM_REMOVE, abd);
    IsAppBar := false;
    Left := OldSize.Left;
    Top := OldSize.Top;
    Width := OldSize.Right;
    Height := OldSize.Bottom;
    Show;
    WindowState := OldWindowState;
  end;
end;

procedure Tfrm_UnCodeX.RegisterABAutoHide;
begin
  abd.lParam := 1;
  if (shAppBarMessage(ABM_SETAUTOHIDEBAR, abd) <> 0) then begin
    if (abd.uEdge = ABE_RIGHT) then begin
      abd.rc.Left := abd.rc.Right-AUTOHIDEEXPOSURE
    end
    else if (abd.uEdge = ABE_LEFT) then begin
      abd.rc.Right := AUTOHIDEEXPOSURE;
    end;
    shAppBarMessage(ABM_setPos, abd);
    Left := abd.rc.Left;
  end;
end;

procedure Tfrm_UnCodeX.UnregisterABAutoHide;
begin
  abd.lParam := 0;
  if (shAppBarMessage(ABM_SETAUTOHIDEBAR, abd) <> 0) then begin
    if (abd.uEdge = ABE_RIGHT) then begin
      abd.rc.Left := WorkArea.Right-ABWidth;
    end
    else if (abd.uEdge = ABE_LEFT) then begin
      abd.rc.Right := WorkArea.Left+ABWidth;
    end;
    shAppBarMessage(ABM_setPos, abd);
    Left := abd.rc.Left;
  end;
end;

procedure Tfrm_UnCodeX.ABResize;
begin
  if (IsAppBar) then ABWidth := Width;
  if (IsAppBar and not ABAutoHide) then begin
    if (abd.uEdge = ABE_RIGHT) then begin
      abd.rc.Left := WorkArea.Right-ABWidth;
    end
    else if (abd.uEdge = ABE_LEFT) then begin
      abd.rc.Right := WorkArea.Left+ABWidth;
    end;
    SHAppBarMessage(ABM_setPos, abd);
  end;
end;

{ Application bar\Tool window methods --  END }
{ Program execution }

// run a program
procedure Tfrm_UnCodeX.ExecuteProgram(exe: string; params: TStringList = nil; prio: integer = -1; show: integer = SW_SHOW);
var
  se: TShellExecuteInfo;
begin
  se.cbSize := SizeOf(TShellExecuteInfo);
  se.Wnd := 0;
  se.lpVerb := nil;
  se.lpFile := PChar(exe);
  if (params <> nil) then se.lpParameters := PChar(params.DelimitedText)
    else se.lpParameters := nil;
  se.nShow := show;
  se.fMask := SEE_MASK_NOCLOSEPROCESS;
  se.lpDirectory := nil;
  se.hInstApp := 0;
  se.lpIDList := nil;
  se.lpClass := nil;
  se.dwHotKey := 0;
  se.hIcon := 0;
  if (not ShellExecuteEx(@se)) then begin
    case (GetLastError) of
      ERROR_FILE_NOT_FOUND: statustext := 'File not found: '+exe;
      ERROR_PATH_NOT_FOUND: statustext := 'Path not found: '+exe;
      SE_ERR_ACCESSDENIED : statustext := 'Access denied: '+exe;
    end;
  end;
  if (prio > -1) then begin
    SetPriorityClass(se.hProcess, PROCPRIO[prio]);
  end;
end;

// Open a source file at a specific line
procedure Tfrm_UnCodeX.OpenSourceLine(filename: string; line, caret: integer; uclass: TUClass);
var
  lst: TStringList;
  i: integer;
  exe: string;
begin
  if ((filename = '') and (uclass <> nil)) then filename := ResolveFilename(uclass, nil);
  if (not fileExists(filename)) then begin
    Log('Could not open file '+filename, ltError);
    exit;
  end;

  if (OpenResultCmd = '') then begin
    ExecuteProgram(filename);
    exit;
  end;

  lst := TStringList.Create;
  try
    lst.Delimiter := ' ';
    lst.QuoteChar := '"';
    lst.DelimitedText := OpenResultCmd;
    exe := lst[0];
    lst.Delete(0);
    for i := 0 to lst.Count-1 do begin
      if (AnsiContainsText(lst[i], '%searchquery%')) then begin
        if (InlineSearch <> '') then lst[i] := AnsiReplaceStr(lst[i], '%searchquery%', InlineSearch)
          else lst[i] := AnsiReplaceStr(lst[i], '%searchquery%', SearchConfig.query);
      end;
      if (uclass <> nil) then begin
        lst[i] := AnsiReplaceStr(lst[i], '%classname%', uclass.name);
        lst[i] := AnsiReplaceStr(lst[i], '%classfile%', uclass.filename);
        lst[i] := AnsiReplaceStr(lst[i], '%classpath%', uclass.FullFileName);
        lst[i] := AnsiReplaceStr(lst[i], '%packagename%', uclass.package.name);
        lst[i] := AnsiReplaceStr(lst[i], '%packagepath%', uclass.package.path);
      end
      else begin
        lst[i] := AnsiReplaceStr(lst[i], '%classname%', '');
        lst[i] := AnsiReplaceStr(lst[i], '%classfile%', ExtractFileName(filename));
        lst[i] := AnsiReplaceStr(lst[i], '%classpath%', filename);
        lst[i] := AnsiReplaceStr(lst[i], '%packagename%', '');
        lst[i] := AnsiReplaceStr(lst[i], '%packagepath%', '');
      end;
      lst[i] := AnsiReplaceStr(lst[i], '%filename%', filename);
      lst[i] := AnsiReplaceStr(lst[i], '%classsearch%', SearchConfig.query);
      lst[i] := AnsiReplaceStr(lst[i], '%inlinesearch%', InlineSearch);
      lst[i] := AnsiReplaceStr(lst[i], '%resultline%', IntToStr(line));
      lst[i] := AnsiReplaceStr(lst[i], '%resultpos%', IntToStr(caret));
    end;
    ExecuteProgram(exe, lst);
  finally
    lst.Free;
  end;
end;

procedure Tfrm_UnCodeX.OpenSourceInline(filename: string; line, caret: integer; uclass: TUClass = nil; nohighlight: boolean = false);
var
  tmp: string;
  tmp2: array[0..255] of char;
  n: integer;
begin
  SelectedUClass := uclass;
  if (fr_Props.Visible) then begin
    //TODO: make a sticky button?
    //fr_Props.uclass := SelectedUClass;
    //fr_Props.LoadClass;
  end;
  SelectedUPackage := nil;
  if (mi_SourceSnoop.Checked) then begin
    //SourceSnoopOpen(uclass, udecl, nil);
    if (not SourceSnoopOpenClass(filename, uclass)) then exit;
    
    if (line < 0) then exit;
    tmp2[0] := #255;
    n := line;
    re_SourceSnoop.Perform(EM_GETLINE, n, integer(@tmp2));
    tmp := copy(tmp2, 1, 255);
    AddBrowserHistory(uclass, filename, line+1, tmp);
    //re_SourceSnoop.Perform(EM_LINESCROLL, 0, -1*re_SourceSnoop.Lines.Count);
    //re_SourceSnoop.Perform(EM_LINESCROLL, 0, line);
    line := re_SourceSnoop.Perform(EM_LINEINDEX, line, 0); // get line index
    re_SourceSnoop.Perform(EM_SETSEL, line, line);
    re_SourceSnoop.Perform(EM_SCROLLCARET, 0, 0);
    if (not nohighlight) then begin
      re_SourceSnoop.ClearBgColor();
      //re_SourceSnoop.SelStart := line;
      re_SourceSnoop.SelLength := re_SourceSnoop.Perform(EM_LINELENGTH, line, 0);
      re_SourceSnoop.SetSelBgColor(clBtnFace);
      re_SourceSnoop.SelLength := 0;
    end;
  end;
end;

{ Program execution -- END }

// Execute next batch command
procedure Tfrm_UnCodeX.NextBatchCommand;
var
  cmd: string;
begin
  if (not IsBatching) then begin
    Screen.Cursor := crDefault;
    exit;
  end;
  if (CmdStack.Count = 0) then begin
    Screen.Cursor := crDefault;
    IsBatching := false;
    Caption := APPTITLE+' - version '+APPVERSION;
    exit;
  end;
  Screen.Cursor := crAppStart;
  cmd := CmdStack[0];
  Caption := APPTITLE+' - version '+APPVERSION+' - Batch process: '+cmd;
  CmdStack.Delete(0);
  if (cmd = 'rebuild') then ac_RecreateTree.Execute
  else if (cmd = 'analyse') then ac_AnalyseAll.Execute
  else if (cmd = 'analysemodified') then ac_AnalyseModified.Execute
  else if (cmd = 'findnew') then ac_FindNewClasses.Execute
  else if (cmd = 'createhtml') then ac_CreateHTMLfiles.Execute
  else if (cmd = 'htmlhelp') then ac_HTMLHelp.Execute
  else if (cmd = 'close') then Close
  else if (cmd = 'orphanstop') then begin
    if ClassOrphanCount > 0 then begin
      CmdStack.Clear;
      Log('Stopped batching because of orhpan classes', ltWarn);
      Log(IntToStr(ClassOrphanCount)+' orphans found', ltWarn);
      MessageDlg(IntToStr(ClassOrphanCount)+' orphan classes found.'+#13+#10+'Check the log for more information.', mtWarning, [mbOK], 0);
      IsBatching := false;
      Caption := APPTITLE+' - version '+APPVERSION;
      exit;
    end
    else NextBatchCommand;
  end
  else if (Pos('ext:', cmd) = 1) then begin
    Delete(cmd, 1, 4);
    CallCustomOutputModule('out_'+cmd+'.dll');
  end
  else if (Pos('ups:', cmd) = 1) then begin
    Delete(cmd, 1, 4);
    if (ExtractFilePath(cmd) = '') then cmd := PascalScriptDir+cmd;
    ExecutePascalScript(cmd);
    NextBatchCommand;
  end
  else begin
    NextBatchCommand;
  end;
end;

// Check application for the same ID (config hash)
procedure Tfrm_UnCodeX.UMAppIDCheck(var Message: TMessage);
begin
  Message.Result := AppInstanceId;
end;

// WM_COPYDATA
// used for -reuse command passing
procedure Tfrm_UnCodeX.WMCopyData(var msg: TWMCopyData);
var
  data: TRedirectStruct;
  lst: TStringList;
  i: integer;
begin
  if (msg.CopyDataStruct.cbData = SizeOf(data)) then begin
    RestoreHandle := Handle;
    CopyMemory(@data, msg.CopyDataStruct.lpData, msg.CopyDataStruct.cbData);
    if (data.NewHandle <> 0) then StatusHandle := data.NewHandle;
    if (data.Find <> '') then begin
      SearchConfig.query := data.Find;
      SearchConfig.isFTS := false;
      SearchConfig.Wrapped := true;
      OpenFind := data.OpenFind;
      OpenTags := data.OpenTags;
      ActiveControl := tv_Classes;
      tv_Classes.Selected := nil;
      ac_FindNext.Execute;
    end;
    if (data.Batch <> '') then begin
      lst := TStringList.Create;
      try
        lst.DelimitedText := data.Batch;
        CmdStack.Clear;
        for i := 0 to lst.Count-1 do CmdStack.Add(lst[i]);
        IsBatching := true;
        NextBatchCommand;
      finally
        lst.Free;
      end;
    end;
    if (data.OpenFTS) then ac_FullTextSearch.Execute;
    Msg.Result := ord(true);
  end;
end;

// Bring to front this window, used for -reuse
procedure Tfrm_UnCodeX.UMRestoreApplication(var msg: TMessage);
begin
  msg.Result := RestoreHandle;
end;

{ Custom output modules }

// Search and load custom output modules
procedure Tfrm_UnCodeX.LoadOutputModules;
var
  rec: TSearchRec;
  omod: THandle;
  rfunc: TUCX_UClassesRev;
  ucr: LongInt;
  i: integer;

  procedure CreateMenuItem(caption, hint: string; parent: TMenuItem; tag: integer);
  var
    mi: TMenuItem;
  begin
    parent.Visible := true;
    mi := TMenuItem.Create(parent);
    mi.Tag := tag; // add to list
    mi.Caption := caption;
    mi.Hint := hint;
    mi.OnClick := miCustomOutputClick;
    parent.Add(mi);
  end;

  function LoadModule2: boolean;
  var
    info2: TUCXOutputDetails;
    dfunc: TUCX_Details;
    mtag: integer;
  begin
    result := false;
    @dfunc := GetProcAddress(omod, 'UCX_Details');
    if (@dfunc = nil) then exit;
    if (not dfunc(info2)) then exit;
    Log('Output module: '+rec.Name+' '+info2.AName);
    mtag := OutputModules.Add(rec.Name+'=');
    if (info2.AMultipleClass) then CreateMenuItem(info2.AName, info2.ADescription, mi_Output, mtag);
    if (info2.ASingleClass) then CreateMenuItem(info2.AName, info2.ADescription, mi_SingleOutput, mtag);
    result := true;
  end;

begin
  for i := mi_Output.Count-1 downto mi_PluginDiv2.MenuIndex+1 do begin
    mi_Output.Delete(i);
  end;
  mi_SingleOutput.Clear;

  if FindFirst(ExtractFilePath(ParamStr(0))+'out_*.dll', 0, rec) = 0 then begin
    repeat
      omod := LoadLibrary(PChar(rec.Name));
      if (omod <> 0) then begin
        try
          @rfunc := GetProcAddress(omod, 'UCX_UClassesRev');
          ucr := 0;
          if (@rfunc <> nil) then ucr := rfunc();
          if (ucr = unit_uclasses.UCLASSES_REV) then begin
            LoadModule2;
          end
          else begin
            MessageDlg('Output module '''+rec.Name+''' needs to be recompiled or is not compatible with this version.'+#13#10+
              'Application UCLASSES_REV = '+#9+IntToStr(unit_uclasses.UCLASSES_REV)+#13#10+
              'Module UCLASSES_REV = '+#9+IntToStr(ucr), mtError, [mbOk], 0);
          end;
        finally
          FreeLibrary(omod);
        end;
      end;
    until (FindNext(rec) <> 0);
    FindClose(rec);
  end;
end;

procedure Tfrm_UnCodeX.miCustomOutputClick(sender: TObject);
begin
  CallCustomOutputModule(OutputModules.Names[(Sender as TMenuItem).Tag], SelectedUClass, (sender as TMenuItem).Parent = mi_SingleOutput);
end;

procedure Tfrm_UnCodeX.CallCustomOutputModule(module: string; selectedclass: TUClass = nil; issingle: boolean = false);
var
  twait: boolean;
  waitt: TThread;
  res: boolean;

  function RunModule2: boolean;
  var
    info: TUCXOutputInfo;
    dfunc: TUCX_Output;
  begin
    result := false;
    @dfunc := nil;
    @dfunc := GetProcAddress(OutputModule, 'UCX_Output');
    if (@dfunc <> nil) then begin
      info.AClassList := ClassList;
      info.APackageList := PackageList;
      info.AStatusReport := StatusReport;
      info.AThreadTerminated := ThreadTerminate;
      info.WaitForTerminate := false;
      info.ASelectedClass := selectedclass;
      info.AThread := nil;
      info.ABatching := IsBatching;
      info.ASingleClass := issingle;
      result := dfunc(info);
      twait := info.WaitForTerminate;
      if (twait) then waitt := info.AThread;
    end;
  end;

begin
  if (runningthread <> nil) then exit;
  
  if (OutputModule <> 0) then begin
    FreeLibrary(OutputModule);
    OutputModule := 0;
  end;
  OutputModule := LoadLibrary(PChar(module));
  if (OutputModule <> 0) then begin
    try
      res := RunModule2;
      if res then begin
        if (twait) then begin
          ClearLog;
          runningthread := waitt;
          //runningthread.OnTerminate := ThreadTerminate;
          runningthread.Resume;
        end
        else if (IsBatching) then NextBatchCommand;
      end
      else if (IsBatching) then NextBatchCommand;
    finally
      if (not twait) then begin
        FreeLibrary(OutputModule);
        OutputModule := 0;
      end;
    end;
  end
  else begin
    Log('Failed loading custom output module: '+module, ltError);
    if (IsBatching) then NextBatchCommand;
  end;
end;

procedure Tfrm_UnCodeX.LoadPascalScripts;
var
  sl: TStringList;
  i: integer;
  mi: TMenuItem;
begin
  sl := TStringList.Create;
  try
    // clean old
    for i := mi_PluginDiv2.MenuIndex-1 downto mi_PluginDiv1.MenuIndex+1 do begin
      mi_Output.Delete(i);
    end;
    if (GetFiles(PascalScriptDir+'*'+UPSEXT, faAnyFile, sl)) then begin
      for i := 0 to sl.Count-1 do begin
        mi := TMenuItem.Create(mi_Output);
        mi.Caption := ExtractBaseName(sl[i]);
        mi.Hint := sl[i];
        mi.ImageIndex := 32;
        mi.OnClick := miPascalScriptsClick;
        mi_Output.Insert(mi_PluginDiv2.MenuIndex, mi);
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure Tfrm_UnCodeX.miPascalScriptsClick(sender: TObject);
begin
  ExecutePascalScript((Sender as TMenuItem).Hint);
end;

function Tfrm_UnCodeX.ExecutePascalScript(filename: string): boolean;
var
  i: integer;
begin
  result := false;
  if (ps_Main.Running) then begin
    log('Nested pascal script running not supported yet', ltError);
    exit;
  end;
  if (not fileexists(filename)) then begin
    log('UPS file does not exist: '+filename, ltError);
    exit;
  end;
  ClearLog;
  ps_Main.Script.LoadFromFile(filename);
  result := frm_UnCodeX.ps_Main.Compile;
  for i := 0 to frm_UnCodeX.ps_Main.CompilerMessageCount-1 do begin
    log(frm_UnCodeX.ps_Main.CompilerMessages[i].MessageToString);
  end;
  if (not result) then begin
    MessageBeep(MB_ICONHAND);
    log('UnCodeX PascalScript compile failed!', ltError);
    exit;
  end;
  ClearLog;
  result := ps_Main.Execute;
  if (not result) then begin
    log(ps_Main.ExecErrorToString, ltError);
    log(format('Execution failed @ %d:%d', [ps_Main.ExecErrorRow, ps_Main.ExecErrorCol]), ltError);
  end;
end;

{ Custom output modules -- END }

{ Inline search }

procedure Tfrm_UnCodeX.InlineSearchNext(skipcurrent: boolean = false);
var
  tv: TTreeView;
  i,j: integer;
begin
  if (InlineSearch = '') then exit;
  if (ActiveControl.ClassType <> TTreeView) then ActiveControl := tv_Classes;
  tv := TTreeView(ActiveControl);
  if (tv.Selected = nil) then tv.Selected := tv.TopItem;
  j := tv.Selected.AbsoluteIndex;
  if (skipcurrent) then Inc(j);
  for i := j to tv.Items.Count-1 do begin
    if (CompareText(Copy(tv.Items[i].Text, 1, Length(inlinesearch)), inlinesearch) = 0) then begin
      tv.Tag := TV_ALWAYSEXPAND;
      tv.Select(tv.Items[i]);
      tv.Tag := TV_NOEXPAND;
      exit;
    end
  end;
  Delete(InlineSearch, Length(InlineSearch), 1);
end;

procedure Tfrm_UnCodeX.InlineSearchPrevious(skipcurrent: boolean = false);
var
  tv: TTreeView;
  i,j: integer;
begin
  if (InlineSearch = '') then exit;
  if (ActiveControl.ClassType <> TTreeView) then ActiveControl := tv_Classes;
  tv := TTreeView(ActiveControl);
  j := tv.Selected.AbsoluteIndex;
  //if (skipcurrent) then Inc(j);
  for i := 0 to j do begin
    if (CompareText(Copy(tv.Items[i].Text, 1, Length(inlinesearch)), inlinesearch) = 0) then begin
      tv.Tag := TV_ALWAYSEXPAND;
      tv.Select(tv.Items[i]);
      tv.Tag := TV_NOEXPAND;
      exit;
    end
  end;
end;

procedure Tfrm_UnCodeX.InlineSearchComplete;
var
  tv: TTreeView;
  i: integer;
  sl: TStringList;
  common: string;
begin
  if (InlineSearch = '') then exit;
  if (ActiveControl.ClassType <> TTreeView) then ActiveControl := tv_Classes;
  tv := TTreeView(ActiveControl);
  sl := TStringList.Create;
  try
    // find all similar
    for i := tv.Selected.AbsoluteIndex+1 to tv.Items.Count-1 do begin
      if (CompareText(Copy(tv.Items[i].Text, 1, Length(inlinesearch)), inlinesearch) = 0) then begin
        sl.Add(LowerCase(tv.Items[i].Text));
      end
    end;
    sl.Sort;
    // find common part
    common := LowerCase(tv.Selected.Text);
    for i := 0 to sl.Count-1 do begin
      while ((Pos(common, sl[i]) = 0) and (common <> '')) do Delete(common, Length(common), 1);
      if (common = '') then break;
    end;
    if (common <> '') then InlineSearch := common;
  finally
    sl.Free;
  end;
end;

{ Inline search -- END }

{ Docking methods }

function clamp(min,mid,max: integer): integer;
begin
  if (mid < min) then result := min
  else if (mid > max) then result := max
  else result := mid;
end;

procedure Tfrm_UnCodeX.ShowDockPanel(DockHost: TControl; MakeVisible: Boolean; Client: TControl);
var
  makeHeight, makeWidth: integer;
  APanel: TPanel;
begin
  if (client <> nil) then Client.Visible := MakeVisible; // update client

  APanel := nil;
  if (DockHost <> nil) then
    if (DockHost.ClassType = TPanel) then
      APanel := TPanel(DockHost);

  // no panel, just make client visible or not
  if (APanel = nil) then exit;

  if not MakeVisible then begin
    if (client = nil) then begin
      // client undocked
      if (APanel.VisibleDockClientCount > 1) then Exit;
    end
    else begin
      // client hidden
      if (APanel.VisibleDockClientCount > 0) then Exit;
    end;
  end;

  // update splitters
  if APanel.Align = alLeft then
    splLeft.Visible := MakeVisible
  else if APanel.Align = alRight then
    splRight.Visible := MakeVisible
  else if APanel.Align = alTop then
    splTop.Visible := MakeVisible
  else if APanel.Align = alBottom then
    splBottom.Visible := MakeVisible;

  if (MakeVisible) then begin
    if (APanel.VisibleDockClientCount > 1) then begin
      APanel.DockManager.ResetBounds(false);
      exit;
    end;
    // find desired height\weight
    makeHeight := 0;
    makeWidth := 0;
    if (client <> nil) then begin
      if (Client.TBDockHeight > 0) then makeHeight := clamp(30, Client.TBDockHeight, ClientHeight div 4);
      if (Client.LRDockWidth > 0) then makeWidth := clamp(30, Client.LRDockWidth, ClientWidth div 4);
    end;
    if (makeHeight = 0) then makeHeight := ClientHeight div 4;
    if (makeWidth = 0) then makeWidth := ClientWidth div 4;

    if APanel.Align = alLeft then begin
      if (makeWidth > pnlCenter.Width) then makeWidth := pnlCenter.Width-splLeft.MinSize;
      if (makeWidth < splLeft.MinSize) then makeWidth := splLeft.MinSize;
      if (makeWidth > APanel.Width) then begin
        APanel.Width := makeWidth;
        splLeft.Left := APanel.Width + splLeft.Width;
      end;
    end
    else if APanel.Align = alRight then begin
      if (makeWidth > pnlCenter.Width) then makeWidth := pnlCenter.Width-splRight.MinSize;
      if (makeWidth < splRight.MinSize) then makeWidth := splRight.MinSize;
      if (makeWidth > APanel.Width) then begin
        APanel.Width := makeWidth;
        splRight.Left := APanel.Width - splRight.Width;
      end;
    end
    else if APanel.Align = alBottom then begin
    if (APanel.Height < makeHeight) then begin
        APanel.Height := makeHeight;
        APanel.Top := pb_Scan.Top-APanel.Height-1;
       splBottom.Top := APanel.Top - splBottom.Height-1;
      end;
    end
    else if APanel.Align = alTop then begin
      if (APanel.Height < makeHeight) then begin
        APanel.Height := makeHeight;
        splTop.Top := APanel.Top + APanel.Height;
      end;
    end
  end
  else begin
    if (APanel.Align = alLeft) or (APanel.Align = alRight) then
      APanel.Width := 0
    else if (APanel.Align = alTop) or (APanel.Align = alBottom) then
      APanel.Height := 0;
  end;
end;

procedure Tfrm_UnCodeX.OnDockVisChange(client: TControl; visible: boolean; var CanChange: boolean);
begin
  if (client = tv_Classes) then CanChange := visible = true
  {else if (client = tv_Packages) then begin
    //ac_VPackageTree.Checked := visible
    tv_Packages.Visible := false;
    ac_VPackageTree.Execute
  end;
  else if (client = lb_Log) then //ac_VLog.Checked := visible
    ac_VLog.Execute
  else if (client = re_SourceSnoop) then begin
    //ac_VSourceSnoop.Checked := visible;
    //mi_Browse.Visible := visible;
    ac_VSourceSnoop.Execute;
  end
  else if (client = fr_Props) then //ac_PropInspector.Checked := visible;
    ac_PropInspector.Execute;}
  
  {if (client.HostDockSite <> nil) then begin
    ShowDockPanel(client.HostDockSite, visible, client);
  end;}
end;

procedure Tfrm_UnCodeX.OnDockDragStart(client: TControl; var CanDrag: boolean);
begin
  CanDrag := client <> tv_Classes;
end;

{ Other stuff }
procedure Tfrm_UnCodeX.DeleteClass(uclass: TUClass; recurse: boolean = false);
var
  i: integer;
  fos: TSHFileOpStruct;
  s: string;
begin
  if (recurse) then begin
    for i := 0 to uclass.children.Count-1 do begin
      DeleteClass(uclass.children[i], recurse);
    end;
  end;
  Log('Deleting class to recycle bin: '+uclass.name);

  s := uclass.package.path+PATHDELIM+uclass.filename;
  SetLength(s,Length(s)+1);
  s[Length(s)]:=#0;
  FillChar(fos, sizeof(fos), 0);
  fos.wFunc := FO_DELETE;
  fos.pFrom := PChar(s);
  fos.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_NOERRORUI;
  if (ShFileOperation(fos) <> 0) then begin
    Log('Error deleting file: '+s, ltError);
    exit;
  end;
  uclass.package.classes.Remove(uclass);
  if (uclass.treenode <> nil) then TTreeNode(uclass.treenode).Delete;
  if (uclass.treenode2 <> nil) then TTreeNode(uclass.treenode2).Delete;
  ClassList.Remove(uclass);
  TreeUpdated := true;
end;

{ SourceSnoopOpen }

function Tfrm_UnCodeX.SourceSnoopOpenClass(filename: string; uclass: TUClass): boolean;
var
  ms: TMemoryStream;
  fs: TFileStream;
begin
  result := true;
  if (not fileExists(filename)) then begin
    Log('Could not open file '+filename, ltError);
    exit;
  end;
  if (re_SourceSnoop.filename = filename) then exit;
  if (uclass <> nil) then begin
    re_SourceSnoop.uclass := uclass;
    SetDockCaption(re_SourceSnoop, 'Class: '+uclass.FullName+' - '+filename);
  end
  else begin
    SetDockCaption(re_SourceSnoop, 'Class: ??? - '+filename);
  end;
  re_SourceSnoop.filename := filename;
  re_SourceSnoop.Hint := filename;
  fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
  ms := TMemoryStream.Create;
  try
    RTFHilightUScript(fs, ms, uclass);
    ac_GoToReplication.Enabled := uclass.replication.srcline > 0;
    ac_GoToDefaultproperties.Enabled := uclass.defaultproperties.srcline > 0;
    re_SourceSnoop.Lines.Clear;
    re_SourceSnoop.WordWrap := false;
    re_SourceSnoop.ScrollBars := ssBoth;
    ms.Position := 0;
    re_SourceSnoop.Lines.LoadFromStream(ms);
  finally
    ms.Free;
    fs.Free;
  end;
  result := true;
end;

function Tfrm_UnCodeX.SourceSnoopOpenPackage(upackage: TUPackage): boolean;
var
  ms: TMemoryStream;
begin
  result := false;
  if (upackage = nil) then exit;
  ms := TMemoryStream.Create;
  SetDockCaption(re_SourceSnoop, 'Package: '+upackage.name);
  re_SourceSnoop.filename := upackage.path;
  re_SourceSnoop.Hint := re_SourceSnoop.filename;
  re_SourceSnoop.uclass := nil;
  try
    RTFHilightUPackage(ms, upackage);
    ac_GoToReplication.Enabled := false;
    ac_GoToDefaultproperties.Enabled := false;
    re_SourceSnoop.Lines.Clear;
    re_SourceSnoop.WordWrap := true;
    re_SourceSnoop.ScrollBars := ssVertical;
    ms.Position := 0;
    re_SourceSnoop.Lines.LoadFromStream(ms);
  finally
    ms.Free;
  end;
  result := true;
end;

{procedure Tfrm_UnCodeX.SourceSnoopOpen(uclass: TUClass; udecl: TUDeclaration; upackage: TUPackage = nil);
var
  ms: TMemoryStream;
  fs: TFileStream;
  filename: string;
begin
  if (uclass <> nil) then begin
    filename := ResolveFilename(uclass, udecl);
    if (not fileExists(filename)) then begin
      Log('Could not open file '+filename);
      exit;
    end;
    if (re_SourceSnoop.filename = filename) then exit;
    re_SourceSnoop.uclass := uclass;
    re_SourceSnoop.udecl := udecl;
    re_SourceSnoop.filename := filename;
    re_SourceSnoop.Hint := filename;
    fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
    ms := TMemoryStream.Create;
    try
      RTFHilightUScript(fs, ms, uclass);
      re_SourceSnoop.Lines.Clear;
      re_SourceSnoop.WordWrap := false;
      re_SourceSnoop.ScrollBars := ssBoth;
      ms.Position := 0;
      re_SourceSnoop.Lines.LoadFromStream(ms);
    finally
      ms.Free;
      fs.Free;
    end;
  end;
end;}

{ Settings -- begin}

procedure Tfrm_UnCodeX.SaveSettings;
var
  ini: TMemIniFile;
  data: TStringList;
  i: integer;
begin
  ini := TMemIniFile.Create(ConfigFile);
  data := TStringList.Create;
  try
    ini.WriteString('Config', 'HTMLOutputDir', HTMLOutputDir);
    ini.WriteString('Config', 'TemplateDir', TemplateDir);
    ini.WriteString('Config', 'HTMLTargetExt', HTMLTargetExt);
    ini.WriteInteger('Config', 'TabsToSpaces', TabsToSpaces);
    ini.WriteString('Config', 'CPP', CPPApp);
    ini.WriteString('Config', 'HTMLDefaultTitle', HTMLdefaultTitle);
    ini.WriteString('Config', 'HHCPath', HHCPath);
    ini.WriteString('Config', 'HTMLHelpFile', HTMLHelpFile);
    ini.WriteString('Config', 'HHTitle', HHTitle);
    ini.WriteString('Config', 'ServerCmd', ServerCmd);
    ini.WriteInteger('Config', 'ServerPrio', ServerPrio);
    ini.WriteString('Config', 'ClientCmd', ClientCmd);
    ini.WriteString('Config', 'CompilerCmd', CompilerCmd);
    ini.WriteString('Config', 'OpenResultCmd', OpenResultCmd);
    ini.WriteString('Config', 'NewClassTemplate', NewClassTemplate);
    ini.WriteString('Config', 'StateFile', ExtractFileName(StateFile));
    ini.WriteBool('Config', 'AnalyseModified', AnalyseModified);
    ini.WriteInteger('Config', 'DefaultInheritanceDepth', DefaultInheritanceDepth);
    ini.WriteBool('Config', 'LoadOutputModules', LoadCustomOutputModules);
    ini.WriteString('Config', 'PascalScriptDir', PascalScriptDir);
    ini.WriteBool('Config', 'ClassPropertiesWindow', ClassPropertiesWindow);
    ini.WriteInteger('Config', 'InlineSearchTimeout', tmr_InlineSearch.Interval div 1000);
    ini.WriteString('Config', 'PackageDescriptionFile', GPDF);
    ini.WriteString('Config', 'ExternalCommentFile', ExtCommentFile);

    ini.WriteString('Layout', 'Log.Font.Name', lb_Log.Font.Name);
    ini.WriteInteger('Layout', 'Log.Font.Color', lb_Log.Font.Color);
    ini.WriteInteger('Layout', 'Log.Font.Size', lb_Log.Font.Size);
    ini.WriteInteger('Layout', 'Log.Color', lb_Log.Color);
    ini.WriteString('Layout', 'Tree.Font.Name', tv_Classes.Font.Name);
    ini.WriteInteger('Layout', 'Tree.Font.Color', tv_Classes.Font.Color);
    ini.WriteInteger('Layout', 'Tree.Font.Size', tv_Classes.Font.Size);
    ini.WriteInteger('Layout', 'Tree.Color', tv_Classes.Color);
    ini.WriteBool('Layout', 'ExpandObject', ExpandObject);
    ini.WriteBool('Layout', 'MinimizeOnClose', MinimizeOnClose);

    ini.WriteInteger('Layout', 'Source.Color', re_SourceSnoop.Color);
    ini.WriteInteger('Layout', 'Source.Keyword1.Color', unit_rtfhilight.fntKeyword1.Color);
    ini.WriteInteger('Layout', 'Source.Keyword1.Style', FontStylesToInt(unit_rtfhilight.fntKeyword1.Style));
    ini.WriteInteger('Layout', 'Source.Keyword2.Color', unit_rtfhilight.fntKeyword2.Color);
    ini.WriteInteger('Layout', 'Source.Keyword2.Style', FontStylesToInt(unit_rtfhilight.fntKeyword2.Style));
    ini.WriteInteger('Layout', 'Source.String.Color', unit_rtfhilight.fntString.Color);
    ini.WriteInteger('Layout', 'Source.String.Style', FontStylesToInt(unit_rtfhilight.fntString.Style));
    ini.WriteInteger('Layout', 'Source.Number.Color', unit_rtfhilight.fntNumber.Color);
    ini.WriteInteger('Layout', 'Source.Number.Style', FontStylesToInt(unit_rtfhilight.fntNumber.Style));
    ini.WriteInteger('Layout', 'Source.Macro.Color', unit_rtfhilight.fntMacro.Color);
    ini.WriteInteger('Layout', 'Source.Macro.Style', FontStylesToInt(unit_rtfhilight.fntMacro.Style));
    ini.WriteInteger('Layout', 'Source.Comment.Color', unit_rtfhilight.fntComment.Color);
    ini.WriteInteger('Layout', 'Source.Comment.Style', FontStylesToInt(unit_rtfhilight.fntComment.Style));
    ini.WriteInteger('Layout', 'Source.Name.Color', unit_rtfhilight.fntName.Color);
    ini.WriteInteger('Layout', 'Source.Name.Style', FontStylesToInt(unit_rtfhilight.fntName.Style));
    ini.WriteInteger('Layout', 'Source.ClassLink.Color', unit_rtfhilight.fntClassLink.Color);
    ini.WriteInteger('Layout', 'Source.ClassLink.Style', FontStylesToInt(unit_rtfhilight.fntClassLink.Style));
    ini.WriteString('Layout', 'Source.Font.Name', unit_rtfhilight.textfont.Name);
    ini.WriteInteger('Layout', 'Source.Font.Size', unit_rtfhilight.textfont.Size);
    ini.WriteInteger('Layout', 'Source.Tabs', unit_rtfhilight.tabs);

    for i := 0 to al_Main.ActionCount-1 do begin
      ini.WriteString('HotKeys', TAction(al_Main.Actions[i]).Caption, ShortCutToText(TAction(al_Main.Actions[i]).ShortCut));
    end;

    ini.EraseSection('SourcePaths');
    ini.EraseSection('PackagePriority');
    ini.EraseSection('IgnorePackages');
    ini.GetStrings(data);

    data.Add('[SourcePaths]');
    for i := 0 to SourcePaths.Count-1 do data.Add('Path='+SourcePaths[i]);

    data.Add('[PackagePriority]');
    for i := 0 to PackagePriority.Count-1 do data.Add('Packages='+PackagePriority[i]);
    for i := 0 to PackagePriority.Count-1 do begin
      if (PackagePriority.Objects[i] <> nil) then
        data.Add('Tag='+PackagePriority[i]);
    end;
    data.Add('[IgnorePackages]');
    for i := 0 to IgnorePackages.Count-1 do data.Add('Package='+IgnorePackages[i]);

    ini.SetStrings(data);
    ini.UpdateFile;
  finally
    Data.Free;
    ini.Free;
  end;
end;

procedure Tfrm_UnCodeX.SaveLayoutSettings;
var
  ini: TMemIniFile;
  dockData: TMemoryStream;
begin
  ini := TMemIniFile.Create(ConfigFile);
  dockData := TMemoryStream.Create;
  try
    { save dock hosts }

    ini.WriteString('DockHosts', 'tv_Classes', tv_Classes.Parent.Name);
    ini.WriteString('DockHosts', 'tv_Packages', tv_Packages.Parent.Name);
    ini.WriteString('DockHosts', 'lb_Log', lb_Log.Parent.Name);
    ini.WriteString('DockHosts', 're_SourceSnoop', re_SourceSnoop.Parent.Name);
    ini.WriteString('DockHosts', 'fr_Props', fr_Props.Parent.Name);

    { save dock maneger settings }
    dckTop.DockManager.SaveToStream(dockData);
    dockData.Position := 0;
    ini.WriteBinaryStream('dckTop.DockManager', 'data', dockData);
    ini.WriteInteger('dckTop.DockManager', 'height', dckTop.Height);
    dockData.Clear;
    dckBottom.DockManager.SaveToStream(dockData);
    dockData.Position := 0;
    ini.WriteBinaryStream('dckBottom.DockManager', 'data', dockData);
    ini.WriteInteger('dckBottom.DockManager', 'height', dckBottom.Height);
    dockData.Clear;
    dckLeft.DockManager.SaveToStream(dockData);
    dockData.Position := 0;
    ini.WriteBinaryStream('dckLeft.DockManager', 'data', dockData);
    ini.WriteInteger('dckLeft.DockManager', 'width', dckLeft.Width);
    dockData.Clear;
    dckRight.DockManager.SaveToStream(dockData);
    dockData.Position := 0;
    ini.WriteBinaryStream('dckRight.DockManager', 'data', dockData);
    ini.WriteInteger('dckRight.DockManager', 'width', dckRight.Width);
    dockData.Clear;
    pnlCenter.DockManager.SaveToStream(dockData);
    dockData.Position := 0;
    ini.WriteBinaryStream('pnlCenter.DockManager', 'data', dockData);

    { general layout settings }
    ini.WriteBool('Layout', 'MenuBar', mi_MenuBar.Checked);
    ini.WriteBool('Layout', 'Toolbar', mi_Toolbar.Checked);
    ini.WriteBool('Layout', 'PackageTree', mi_PackageTree.Checked);
    ini.WriteBool('Layout', 'Log', mi_Log.Checked);
    ini.WriteBool('Layout', 'SourceSnoop', mi_SourceSnoop.Checked);
    ini.WriteBool('Layout', 'PropertyInspector', mi_PropInspector.Checked);
    ini.WriteBool('Layout', 'StayOnTop', mi_StayOnTop.Checked);
    ini.WriteBool('Layout', 'SavePosition', mi_Saveposition.Checked);
    ini.WriteBool('Layout', 'SaveSize', mi_Savesize.Checked);
    if (mi_Saveposition.Checked) then begin
      if (IsAppBar) then begin
        ini.WriteInteger('Layout', 'Top', OldSize.Top);
        ini.WriteInteger('Layout', 'Left', OldSize.Left);
      end
      else if (WindowState = wsNormal) then begin
        ini.WriteInteger('Layout', 'Top', Top);
        ini.WriteInteger('Layout', 'Left', Left);
      end;
    end;
    if (mi_Savesize.Checked) then begin
      if (IsAppBar) then begin
        ini.WriteInteger('Layout', 'Width', OldSize.Right);
        ini.WriteInteger('Layout', 'Height', OldSize.Bottom);
      end
      else if (WindowState = wsMaximized) then begin
        ini.WriteBool('Layout', 'IsMaximized', true);
      end
      else if (WindowState = wsNormal) then begin
        ini.WriteBool('Layout', 'IsMaximized', false);
        ini.WriteInteger('Layout', 'Width', Width);
        ini.WriteInteger('Layout', 'Height', Height);
      end;
    end;
    ini.WriteInteger('Layout', 'ABWidth', ABWidth);
    ini.WriteBool('Layout', 'AutoHide', mi_AutoHide.Checked);
    ini.WriteBool('Layout', 'ABRight', mi_Right.Checked);
    ini.WriteBool('Layout', 'ABLeft', mi_Left.Checked);
    SaveSearchConfig(ini, 'search', DefaultSC);
    ini.UpdateFile;
  finally
    ini.Free;
    dockData.Free;
  end;
end;

procedure Tfrm_UnCodeX.LoadSettings;
var
  ini: TMemIniFile;
  tmp, tmp2: string;
  sl: TStringList;
  i: integer;
  dockData: TMemoryStream;
  dckHost: TPanel;
begin
  ini := TMemIniFile.Create(ConfigFile);
  sl := TStringList.Create;
  dockData := TMemoryStream.Create;
  try
    { Load layout }
    ac_VStayOnTop.Checked := ini.ReadBool('Layout', 'StayOnTop', ac_VStayOnTop.Checked);
    if (ac_VStayOnTop.Checked) then FormStyle := fsStayOnTop;
    ac_VSaveposition.Checked := ini.ReadBool('Layout', 'SavePosition', ac_VSaveposition.Checked);
    ac_VSavesize.Checked := ini.ReadBool('Layout', 'SaveSize', ac_VSavesize.Checked);
    if (ac_VSaveposition.Checked) then begin
      Position := poDesigned;
      Top := ini.ReadInteger('Layout', 'Top', Top);
      Left := ini.ReadInteger('Layout', 'Left', Left);
    end;
    if (ac_VSavesize.Checked) then begin
      Width := ini.ReadInteger('Layout', 'Width', Width);
      Height := ini.ReadInteger('Layout', 'Height', Height);
    end;
    if (ini.ReadBool('Layout', 'IsMaximized', false)) then WindowState := wsMaximized;
    ac_VMenuBar.Checked := ini.ReadBool('Layout', 'MenuBar', ac_VMenuBar.Checked);
    ac_VToolbar.Checked := ini.ReadBool('Layout', 'Toolbar', ac_VToolbar.Checked);
    mi_Toolbar.OnClick(nil);

    ac_VPackageTree.Checked := ini.ReadBool('Layout', 'PackageTree', ac_VPackageTree.Checked);
    ac_VLog.Checked := ini.ReadBool('Layout', 'Log', ac_VLog.Checked);
    ac_VSourceSnoop.Checked := ini.ReadBool('Layout', 'SourceSnoop', ac_VSourceSnoop.Checked);
    mi_Browse.Visible := ac_VSourceSnoop.Checked;
    ac_PropInspector.Checked := ini.ReadBool('Layout', 'PropertyInspector', ac_PropInspector.Checked);

    { load dock settings }
    ini.ReadBinaryStream('pnlCenter.DockManager', 'data', dockData);
    if (dockData.Size > 0) then pnlCenter.DockManager.LoadFromStream(dockData);
    dockData.Clear;

    ini.ReadBinaryStream('dckTop.DockManager', 'data', dockData);
    if (dockData.Size > 0) then dckTop.DockManager.LoadFromStream(dockData);
    dockData.Clear;
    dckTop.Height := ini.ReadInteger('dckTop.DockManager', 'height', dckTop.Height);

    ini.ReadBinaryStream('dckBottom.DockManager', 'data', dockData);
    if (dockData.Size > 0) then dckBottom.DockManager.LoadFromStream(dockData);
    dockData.Clear;
    dckBottom.Height := ini.ReadInteger('dckBottom.DockManager', 'height', dckBottom.Height);
    dckBottom.Top := pb_Scan.Top-dckBottom.Height;
    splBottom.Top := dckBottom.Top-1;

    ini.ReadBinaryStream('dckLeft.DockManager', 'data', dockData);
    if (dockData.Size > 0) then dckLeft.DockManager.LoadFromStream(dockData);
    dockData.Clear;
    dckLeft.Width := ini.ReadInteger('dckLeft.DockManager', 'width', dckLeft.Width);

    ini.ReadBinaryStream('dckRight.DockManager', 'data', dockData);
    if (dockData.Size > 0) then dckRight.DockManager.LoadFromStream(dockData);
    dockData.Clear;
    dckRight.Width := ini.ReadInteger('dckRight.DockManager', 'width', dckRight.Width);

    { find dock hosts }
    if (tv_Classes.HostDockSite = nil) then begin
      dckHost := (FindComponent(ini.ReadString('DockHosts', 'tv_Classes', 'pnlCenter')) as TPanel);
      tv_Classes.ManualDock(dckHost);
    end;
    if (tv_Packages.HostDockSite = nil) then begin
      dckHost := (FindComponent(ini.ReadString('DockHosts', 'tv_Packages', 'dckLeft')) as TPanel);
      tv_Packages.ManualDock(dckHost);
    end;
    if (lb_Log.HostDockSite = nil) then begin
      dckHost := (FindComponent(ini.ReadString('DockHosts', 'lb_Log', 'dckBottom')) as TPanel);
      lb_Log.ManualDock(dckHost);
    end;
    if (re_SourceSnoop.HostDockSite = nil) then begin
      dckHost := (FindComponent(ini.ReadString('DockHosts', 're_SourceSnoop', 'dckRight')) as TPanel);
      re_SourceSnoop.ManualDock(dckHost);
    end;
    if (fr_Props.HostDockSite = nil) then begin
      dckHost := (FindComponent(ini.ReadString('DockHosts', 'fr_Props', 'pnlCenter')) as TPanel);
      fr_Props.ManualDock(dckHost);
    end;

    if (not ac_VPackageTree.Checked) then tv_Packages.Visible := false;
    if (not ac_VLog.Checked) then lb_Log.Visible := false;
    if (not ac_VSourceSnoop.Checked) then re_SourceSnoop.Visible := false;
    if (not ac_PropInspector.Checked) then fr_Props.Visible := false;

    ABWidth := ini.ReadInteger('Layout', 'ABWidth', 150);
    ac_VAutoHide.Checked := ini.ReadBool('Layout', 'AutoHide', false);
    mi_AutoHide.OnClick(nil);
    ac_VTRight.Checked := ini.ReadBool('Layout', 'ABRight', false);
    if (ac_VTRight.Checked) then mi_Right.OnClick(nil);
    ac_VTLeft.Checked := ini.ReadBool('Layout', 'ABLeft', false);
    if (ac_VTLeft.Checked) then mi_Left.OnClick(nil);
    { Color and fonts }
    lb_Log.Font.Name := ini.ReadString('Layout', 'Log.Font.Name', lb_Log.Font.Name);
    lb_Log.Font.Color := ini.ReadInteger('Layout', 'Log.Font.Color', lb_Log.Font.Color);
    lb_Log.Font.Size := ini.ReadInteger('Layout', 'Log.Font.Size', lb_Log.Font.Size);
    lb_Log.Color := ini.ReadInteger('Layout', 'Log.Color', lb_Log.Color);
    tv_Classes.Font.Name := ini.ReadString('Layout', 'Tree.Font.Name', tv_Classes.Font.Name);
    tv_Classes.Font.Color := ini.ReadInteger('Layout', 'Tree.Font.Color', tv_Classes.Font.Color);
    tv_Classes.Font.Size := ini.ReadInteger('Layout', 'Tree.Font.Size', tv_Classes.Font.Size);
    tv_Classes.Color := ini.ReadInteger('Layout', 'Tree.Color', tv_Classes.Color);
    tv_Packages.Font.Name := ini.ReadString('Layout', 'Tree.Font.Name', tv_Packages.Font.Name);
    tv_Packages.Font.Color := ini.ReadInteger('Layout', 'Tree.Font.Color', tv_Packages.Font.Color);
    tv_Packages.Font.Size := ini.ReadInteger('Layout', 'Tree.Font.Size', tv_Packages.Font.Size);
    tv_Packages.Color := ini.ReadInteger('Layout', 'Tree.Color', tv_Packages.Color);
    ExpandObject := ini.ReadBool('Layout', 'ExpandObject', true);
    MinimizeOnClose := ini.ReadBool('Layout', 'MinimizeOnClose', MinimizeOnClose);
    
    re_SourceSnoop.Color := ini.ReadInteger('Layout', 'Source.Color', re_SourceSnoop.Color);
    unit_rtfhilight.fntKeyword1.Color := ini.ReadInteger('Layout', 'Source.Keyword1.Color', unit_rtfhilight.fntKeyword1.Color);
    unit_rtfhilight.fntKeyword1.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Keyword1.Style', FontStylesToInt(unit_rtfhilight.fntKeyword1.Style)));
    unit_rtfhilight.fntKeyword2.Color := ini.ReadInteger('Layout', 'Source.Keyword2.Color', unit_rtfhilight.fntKeyword2.Color);
    unit_rtfhilight.fntKeyword2.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Keyword2.Style', FontStylesToInt(unit_rtfhilight.fntKeyword2.Style)));
    unit_rtfhilight.fntString.Color := ini.ReadInteger('Layout', 'Source.String.Color', unit_rtfhilight.fntString.Color);
    unit_rtfhilight.fntString.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.String.Style', FontStylesToInt(unit_rtfhilight.fntString.Style)));
    unit_rtfhilight.fntNumber.Color := ini.ReadInteger('Layout', 'Source.Number.Color', unit_rtfhilight.fntNumber.Color);
    unit_rtfhilight.fntNumber.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Number.Style', FontStylesToInt(unit_rtfhilight.fntNumber.Style)));
    unit_rtfhilight.fntMacro.Color := ini.ReadInteger('Layout', 'Source.Macro.Color', unit_rtfhilight.fntMacro.Color);
    unit_rtfhilight.fntMacro.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Macro.Style', FontStylesToInt(unit_rtfhilight.fntMacro.Style)));
    unit_rtfhilight.fntComment.Color := ini.ReadInteger('Layout', 'Source.Comment.Color', unit_rtfhilight.fntComment.Color);
    unit_rtfhilight.fntComment.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Comment.Style', FontStylesToInt(unit_rtfhilight.fntComment.Style)));
    unit_rtfhilight.fntName.Color := ini.ReadInteger('Layout', 'Source.Name.Color', unit_rtfhilight.fntName.Color);
    unit_rtfhilight.fntName.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Name.Style', FontStylesToInt(unit_rtfhilight.fntName.Style)));
    unit_rtfhilight.fntClassLink.Color := ini.ReadInteger('Layout', 'Source.ClassLink.Color', unit_rtfhilight.fntClassLink.Color);
    unit_rtfhilight.fntClassLink.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.ClassLink.Style', FontStylesToInt(unit_rtfhilight.fntClassLink.Style)));
    { Color and fonts -- END }
    { Load layout -- END }
    { Program configuration }
    HTMLOutputDir := ini.ReadString('Config', 'HTMLOutputDir', ExtractFilePath(ParamStr(0))+'Output');
    ac_OpenOutput.Enabled := HTMLOutputDir <> '';
    TemplateDir := ini.ReadString('Config', 'TemplateDir', ExtractFilePath(ParamStr(0))+'Templates'+PATHDELIM+DEFTEMPLATE);
    HTMLTargetExt := ini.ReadString('Config', 'HTMLTargetExt', '');
    TabsToSpaces := ini.ReadInteger('Config', 'TabsToSpaces', 0);
    CPPApp := ini.ReadString('Config', 'CPP', '');
    HTMLdefaultTitle := ini.ReadString('Config', 'HTMLDefaultTitle', '');
    HHCPath := ini.ReadString('Config', 'HHCPath', '');
    ac_HTMLHelp.Enabled := HHCPath <> '';
    HTMLHelpFile := ini.ReadString('Config', 'HTMLHelpFile', ExtractFilePath(ParamStr(0))+'UnCodeX.chm');
    ac_OpenHTMLHelp.Enabled := FileExists(HTMLHelpFile);
    HHTitle := ini.ReadString('Config', 'HHTitle', '');
    ServerCmd := ini.ReadString('Config', 'ServerCmd', '');
    ac_RunServer.Enabled := ServerCmd <> '';
    ServerPrio := ini.ReadInteger('Config', 'ServerPrio', 1);
    ClientCmd := ini.ReadString('Config', 'ClientCmd', '');
    ac_JoinServer.Enabled := ClientCmd <> '';
    CompilerCmd := ini.ReadString('Config', 'CompilerCmd', '');
    ac_CompileClass.Enabled := CompilerCmd <> '';
    OpenResultCmd := ini.ReadString('Config', 'OpenResultCmd', '');
    //ac_OpenClass.Enabled := OpenResultCmd <> '';
    NewClassTemplate := ini.ReadString('Config', 'NewClassTemplate', ExtractFilePath(ParamStr(0))+TEMPLATEPATH+PathDelim+'NewClass.uc');
    ac_CreateSubClass.Enabled := FileExists(NewClassTemplate);
    StateFile := ini.ReadString('Config', 'StateFile', StateFile);
    if (StateFile = '') then begin
      StateFile := ChangeFileExt(ExtractFilename(ConfigFile), '.ucx');
    end;
    GPDF := ini.ReadString('Config', 'PackageDescriptionFile', ExtractFilePath(ParamStr(0))+DefaultPDF);
    ExtCommentFile := ini.ReadString('Config', 'ExternalCommentFile', ExtractFilePath(ParamStr(0))+DefaultECF);
    SetExtCommentFile(ExtCommentFile);
    AnalyseModified := ini.ReadBool('Config', 'AnalyseModified', true);
    DefaultInheritanceDepth := ini.ReadInteger('Config', 'DefaultInheritanceDepth', 0);
    if (ExtractFilePath(StateFile) = '') then StateFile := ExtractFilePath(ConfigFile)+StateFile;
    LoadCustomOutputModules := ini.ReadBool('config', 'LoadOutputModules', LoadCustomOutputModules);
    PascalScriptDir := ini.ReadString('Config', 'PascalScriptDir', ExtractFilePath(ParamStr(0))+UPSDIR+PathDelim);
    ClassPropertiesWindow := ini.ReadBool('config', 'ClassPropertiesWindow', ClassPropertiesWindow);
    tmr_InlineSearch.Interval := ini.ReadInteger('config', 'InlineSearchTimeout', (tmr_InlineSearch.Interval div 1000)) * 1000;
    { Program configuration -- END }
    for i := 0 to al_Main.ActionCount-1 do begin
      TAction(al_Main.Actions[i]).ShortCut := TextToShortCut(ini.ReadString('HotKeys', TAction(al_Main.Actions[i]).Caption, ShortCutToText(TAction(al_Main.Actions[i]).ShortCut)));
    end;
    { Unreal Packages }
    ini.ReadSectionValues('PackagePriority', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      tmp2 := Copy(tmp, 1, Pos('=', tmp));
      Delete(tmp, 1, Pos('=', tmp));
      if (LowerCase(tmp2) = 'packages=') then begin
        Log('Config: Package = '+tmp);
        PackagePriority.Add(LowerCase(tmp));
      end;
    end;
    // must be after Package= listing
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      tmp2 := Copy(tmp, 1, Pos('=', tmp));
      Delete(tmp, 1, Pos('=', tmp));
      if (LowerCase(tmp2) = 'tag=') then begin
        Log('Config: Tagged package = '+tmp);
        PackagePriority.Objects[PackagePriority.IndexOf(LowerCase(tmp))] := PackagePriority;
      end;
    end;
    ini.ReadSectionValues('IgnorePackages', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Config: Ignore = '+tmp);
      IgnorePackages.Add(LowerCase(tmp));
    end;
    { Unreal Packages -- END }
    { Source paths }
    ini.ReadSectionValues('SourcePaths', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Config: Path = '+tmp);
      SourcePaths.Add(LowerCase(tmp));
    end;
    { Source paths -- END }
    { Search history }
    LoadSearchConfig(ini, 'search', DefaultSC);
    { Search history -- END }
  finally
    ini.Free;
    sl.Free;
    dockData.Free;
  end;
end;

{ Settings -- END}
type
  TBrowseHistory = record
    uclass: TUClass;
    filename: string;
    line: integer;
  end;

var
   BrowseHistory: array[0..24] of TBrowseHistory;

procedure Tfrm_UnCodeX.AddBrowserHistory(uclass: TUClass; filename: string; line: integer; hint: string = '');
var
  i: integer;
  mi: TMenuItem;
  found: boolean;
begin
  if (uclass = nil) then exit;
  for i := 0 to mi_Browse.Count-1 do begin
    if (mi_Browse.Items[i].Tag < 25) then begin
      if ((BrowseHistory[mi_Browse.Items[i].Tag].uclass = uclass) and
      		(BrowseHistory[mi_Browse.Items[i].Tag].filename = filename) and
        (BrowseHistory[mi_Browse.Items[i].Tag].line = line)) then begin
        mi_Browse.Items[i].MenuIndex := 0;
        exit;
      end;
    end;
  end;
  found := false;
  for i := 0 to 24 do begin
    if (BrowseHistory[i].uclass = nil) then begin
      found := true;
      break;
    end;
  end;
  if (not found) then begin
    i := mi_Browse.Items[mi_Browse.Count-1].Tag;
    mi_Browse.Remove(mi_Browse.Items[mi_Browse.Count-1]);
  end;
  mi := TMenuItem.Create(mi_Browse);
  mi.Caption := uclass.FullName;
  if (line > 0) then mi.Caption := mi.Caption+' - line #'+IntToStr(line);
  mi.Tag := i;
  mi.Hint := StringReplace(hint, #9, '  ', [rfReplaceAll]);
  mi.OnClick := BrowseEntry;
  mi_Browse.Insert(0, mi);
  mi_Browse.Enabled := true;
  BrowseHistory[i].uclass := uclass;
  BrowseHistory[i].filename := filename;
  BrowseHistory[i].line := line;
end;

procedure Tfrm_UnCodeX.BrowseEntry(Sender: TObject);
begin
  if (TMenuItem(Sender) = nil) then exit;
  OpenSourceInLine(BrowseHistory[TMenuItem(Sender).Tag].filename, BrowseHistory[TMenuItem(Sender).Tag].line-1, 0, BrowseHistory[TMenuItem(Sender).Tag].uclass);
end;

{ Custom methods -- END}
{ Auto generated methods }

// Update the status message on timer
procedure Tfrm_UnCodeX.tmr_StatusTextTimer(Sender: TObject);
var
  tmp: string;
begin
  tmp := statustext;
  if (runningthread <> nil) then begin
    tmp := tmp+' ('+ShortCutToText(ac_Abort.ShortCut)+' to abort)';
  end;
  sb_Status.Panels[0].Text := tmp;
end;

// Create form and init
procedure Tfrm_UnCodeX.FormCreate(Sender: TObject);
begin
  OnChangeVisibility := OnDockVisChange;
  OnStartDockDrag := OnDockDragStart;
  
  Mouse.DragImmediate := false;
  Mouse.DragThreshold := 5;
  hh_Help := THookHelpSystem.Create(ExtractFilePath(ParamStr(0))+'UnCodeX-help.chm', '', htHHAPI);
  Caption := APPTITLE;
  if (ConfigFile = '') then ConfigFile := ExtractFilePath(ParamStr(0))+'UnCodeX.ini'
  else Caption := Caption+' ['+ExtractFileName(ConfigFile)+']';
  Caption := Caption+' - version '+APPVERSION;
  Application.Title := Caption;
  if (DEBUGBUILD) then Application.Title := Application.Title+' (debug)';
  InitialStartup := not FileExists(ConfigFile);
  { StringLists }
  PackagePriority := TStringList.Create;
  SourcePaths := TStringList.Create;
  IgnorePackages := TStringList.Create;
  DefaultSC.ftshistory := TStringList.Create;
  DefaultSC.history := TStringList.Create;
  OutputModules := TStringList.Create;
  { StringLists -- END }

  LoadSettings;
  if (StateFile = '') then StateFile := ExtractFilePath(ParamStr(0))+'UnCodeX.ucx';

  if (LoadCustomOutputModules) then begin
    LoadOutputModules;
    LoadPascalScripts;
  end;
  PackageList := TUPackageList.Create(true);
  ClassList := TUClassList.Create(true);
  UpdateSystemMenu;
  mi_MenuBar.OnClick(Sender); // has to be here or else it won't work
end;

// Analyse a signgle class, why is this not an action ?
procedure Tfrm_UnCodeX.mi_AnalyseclassClick(Sender: TObject);
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    with (ActiveControl as TTreeView) do begin
      if (TObject(Selected.Data).ClassType <> TUClass) then exit;
      if (ThreadCreate) then begin
        ClearLog;
        LastAnalyseTime := Now;
        runningthread := TClassAnalyser.Create(TUClass(Selected.Data), statusReport);
        runningthread.OnTerminate := ThreadTerminate;
        runningthread.Resume;
      end;
    end;
  end;
end;

// Show hint message when there is one
procedure Tfrm_UnCodeX.ae_AppEventHint(Sender: TObject);
begin
  sb_Status.SimpleText := GetLongHint(Application.Hint);
  sb_Status.SimplePanel := (trim(sb_Status.SimpleText) <> '');
end;

procedure Tfrm_UnCodeX.ac_RecreateTreeExecute(Sender: TObject);
var
  rec: TPackageScannerConfig;
  i: integer;
begin
  if (ThreadCreate) then begin
    ClearLog;
    TreeUpdated := true;

    SelectedUClass := nil;
    SelectedUPackage := nil;
    LastBuildTime := now;
    fr_Props.uclass := nil;
    if (fr_Props.Visible) then fr_Props.LoadClass;

    for i := 0 to High(BrowseHistory) do begin
      BrowseHistory[i].uclass := nil;
    end;
    re_SourceSnoop.uclass := nil;

    tv_Packages.Items.Clear;
    tv_Classes.Items.Clear;
    PackageList.Clear;
    ClassList.Clear;

    rec.paths := SourcePaths;
    rec.packagetree := tv_Packages.Items;
    rec.classtree := tv_Classes.items;
    rec.status := statusReport;
    rec.packagelist := PackageList;
    rec.classlist := ClassList;
    rec.PackagePriority := PackagePriority;
    rec.IgnorePackages := IgnorePackages;
    rec.CHash := unit_rtfhilight.ClassesHash;
    rec.PDFile := GPDF;

    runningthread := TPackageScanner.Create(rec);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.ac_FindOrphansExecute(Sender: TObject);
begin
  ClearLog;
  CountOrphans(ClassList);
  if ClassOrphanCount > 0 then begin
    Log(IntToStr(ClassOrphanCount)+' orphans found', ltWarn);
    MessageDlg(IntToStr(ClassOrphanCount)+' orphan classes found.'+#13+#10+
      'Check the log for more information.', mtWarning, [mbOK], 0);
  end
  else MessageDlg('No orphan classes detected.', mtInformation, [mbOK], 0);
end;

procedure Tfrm_UnCodeX.ac_AnalyseAllExecute(Sender: TObject);
begin
  if (ThreadCreate) then begin
    ClearLog;
    LastAnalyseTime := Now;

    fr_Props.uclass := nil;
    if (fr_Props.Visible) then fr_Props.LoadClass;

    runningthread := TClassAnalyser.Create(ClassList, statusReport, false,
                      unit_rtfhilight.ClassesHash);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.ac_CreateHTMLfilesExecute(Sender: TObject);
var
  htmlconfig: THTMLOutConfig;
begin
  if (ThreadCreate) then begin
    ClearLog;
    htmlconfig.PackageList := PackageList;
    htmlconfig.ClassList := ClassList;
    htmlconfig.outputdir := HTMLOutputDir;
    htmlconfig.TemplateDir := TemplateDir;
    htmlconfig.CreateSource := true; // TODO: make configurable
    htmlconfig.TargetExtention := HTMLTargetExt;
    htmlconfig.TabsToSpaces := TabsToSpaces;
    htmlconfig.CPP := CPPApp;
    htmlconfig.DefaultTitle := HTMLdefaultTitle;
    runningthread := THTMLoutput.Create(htmlconfig, StatusReport);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.ac_SettingsExecute(Sender: TObject);
var
  i, j: integer;
  newtag: boolean;
begin
  with Tfrm_Settings.Create(nil) do begin
    lb_Paths.Items := SourcePaths;
    { Packages }
    clb_PackagePriority.Items := PackagePriority;
    for i := 0 to PackagePriority.Count-1 do begin
      clb_PackagePriority.Checked[i] := PackagePriority.Objects[i] <> nil;
    end;
    lb_IgnorePackages.Items := IgnorePackages;
    { HTML output }
    ed_HTMLOutputDir.Text := HTMLOutputDir;
    ed_TemplateDir.Text := TemplateDir;
    ed_HTMLTargetExt.Text := HTMLTargetExt;
    ud_TabsToSpaces.Position := TabsToSpaces;
    ed_CPPApp.Text := CPPApp;
    ed_HTMLDefaultTitle.Text := HTMLdefaultTitle;
    { HTML Help }
    ed_WorkshopPath.Text := HHCPath;
    ed_HTMLHelpOutput.Text := HTMLHelpFile;
    ed_HHTitle.Text := HHTitle;
    { Run server }
    ed_ServerCommandline.Text := ServerCmd;
    cb_ServerPriority.ItemIndex := ServerPrio;
    ed_ClientCommandline.Text := ClientCmd;
    { Commandlines }
    ed_CompilerCommandline.Text := CompilerCmd;
    ed_OpenResultCmd.Text := OpenResultCmd;
    ed_NewClassTemplate.Text := NewClassTemplate;
    { Layout settings }
    lb_LogLayout.Color := lb_Log.Color;
    cb_LogColor.Selected := lb_Log.Color;
    lb_LogLayout.Font := lb_Log.Font;
    cb_LogFontColor.Selected := lb_Log.Font.Color;
    tv_TreeLayout.Color := tv_Classes.Color;
    cb_BGColor.Selected := tv_Classes.Color;
    tv_TreeLayout.Font := tv_Classes.Font;
    cb_FontColor.Selected := tv_Classes.Font.Color;
    cb_ExpandObject.Checked := ExpandObject;
    re_Preview.Color := re_SourceSnoop.Color;
    cb_Background.Selected := re_Preview.Color;
    { Program options }
    ed_StateFilename.Text := ExtractFilename(StateFile);
    cb_MinimzeOnClose.Checked := MinimizeOnClose;
    cb_ModifiedOnStartup.Checked := AnalyseModified;
    ud_DefInheritDepth.Position := DefaultInheritanceDepth;
    cb_LoadCustomModules.Checked := LoadCustomOutputModules;
    ed_UPSDIR.Text := PascalScriptDir;
    cb_CPAsWindow.Checked := ClassPropertiesWindow;
    ud_InlineSearchTimeout.Position := tmr_InlineSearch.Interval div 1000;
    ed_gpdf.text := GPDF;
    ed_ExtCmtFile.Text := ExtCommentFile;
    if (ShowModal = mrOk) then begin
      { HTML output }
      HTMLOutputDir := ed_HTMLOutputDir.Text;
      ac_OpenOutput.Enabled := HTMLOutputDir <> '';
      TemplateDir := ed_TemplateDir.Text;
      HTMLTargetExt := ed_HTMLTargetExt.Text;
      TabsToSpaces := ud_TabsToSpaces.Position;
      CPPApp := ed_CPPApp.Text;
      HTMLdefaultTitle := ed_HTMLDefaultTitle.Text;
      { HTML Help }
      HHCPath := ed_WorkshopPath.Text;
      ac_HTMLHelp.Enabled := HHCPath <> '';
      HTMLHelpFile := ed_HTMLHelpOutput.Text;
      HHTitle := ed_HHTitle.Text;
      ac_OpenHTMLHelp.Enabled := FileExists(HTMLHelpFile);
      { Run server }
      ServerCmd := ed_ServerCommandline.Text;
      ac_RunServer.Enabled := ServerCmd <> '';
      ServerPrio := cb_ServerPriority.ItemIndex;
      ClientCmd := ed_ClientCommandline.Text;
      ac_JoinServer.Enabled := ClientCmd <> '';
      { Commandlines }
      CompilerCmd := ed_CompilerCommandline.Text;
      ac_CompileClass.Enabled := CompilerCmd <> '';
      OpenResultCmd := ed_OpenResultCmd.Text;
      ac_OpenClass.Enabled := OpenResultCmd <> '';
      NewClassTemplate := ed_NewClassTemplate.Text;
      mi_CreateSubClass.Enabled := FileExists(NewClassTemplate);
      { Program options }
      StateFile := ed_StateFilename.Text;
      AnalyseModified := cb_ModifiedOnStartup.Checked;
      if (ExtractFilePath(StateFile) = '') then StateFile := ExtractFilePath(ConfigFile)+StateFile;
      ExpandObject := cb_ExpandObject.Checked;
      MinimizeOnClose := cb_MinimzeOnClose.Checked;
      DefaultInheritanceDepth := ud_DefInheritDepth.Position;
      LoadCustomOutputModules := cb_LoadCustomModules.Checked;
      PascalScriptDir := ed_UPSDIR.Text;
      ClassPropertiesWindow := cb_CPAsWindow.Checked;
      tmr_InlineSearch.Interval := ud_InlineSearchTimeout.Position * 1000;
      GPDF := ed_gpdf.Text;
      ExtCommentFile := ed_ExtCmtFile.Text;
      SetExtCommentFile(ExtCommentFile);
      { Source paths }
      SourcePaths.Clear;
      SourcePaths.AddStrings(lb_Paths.Items);
      { Packages }
      PackagePriority.Clear;
      PackagePriority.AddStrings(clb_PackagePriority.Items);
      for i := 0 to clb_PackagePriority.Items.Count-1 do begin
        if (clb_PackagePriority.Checked[i]) then
          PackagePriority.Objects[i] := PackagePriority
          else PackagePriority.Objects[i] := nil;
      end;
      IgnorePackages.Clear;
      IgnorePackages.AddStrings(lb_IgnorePackages.Items);
      { Layout settings }
      lb_Log.Color := lb_LogLayout.Color;
      lb_Log.Font := lb_LogLayout.Font;
      tv_Classes.Color := tv_TreeLayout.Color;
      tv_Classes.Font := tv_TreeLayout.Font;
      tv_Packages.Color := tv_TreeLayout.Color;
      tv_Packages.Font := tv_TreeLayout.Font;
      re_SourceSnoop.Color := re_Preview.Color;

      lb_PrimKey.Items.SaveToFile(ExtractFilePath(ParamStr(0))+'keywords1.list');
      lb_SecKey.Items.SaveToFile(ExtractFilePath(ParamStr(0))+'keywords2.list');
      ReloadKeywords;

      for i := 0 to lv_HotKeys.Items.Count-1 do begin
        TAction(lv_HotKeys.Items[i].Data).ShortCut := TextToShortCut(lv_HotKeys.Items[i].SubItems[0]);
      end;

      SaveSettings;

      if (TagChanged) then begin
        StatusReport('Retagging packages/classes ...');
        tv_Packages.Items.BeginUpdate;
        tv_Classes.Items.BeginUpdate;
        TreeUpdated := true;
        for i := 0 to PackageList.Count-1 do begin
          Application.ProcessMessages;
          if (clb_PackagePriority.Items.IndexOf(LowerCase(PackageList[i].name)) > -1) then
            newtag := clb_PackagePriority.Checked[clb_PackagePriority.Items.IndexOf(LowerCase(PackageList[i].name))]
            else newtag := false;
          PackageList[i].tagged := newtag;
          for j := 0 to PackageList[i].classes.Count-1 do begin
            Application.ProcessMessages;
            PackageList[i].classes[j].tagged := newtag;
            if (PackageList[i].classes[j].treenode <> nil) then begin
              if (newtag) then begin
                TTreeNode(PackageList[i].classes[j].treenode).ImageIndex := ICON_CLASS_TAGGED;
                TTreeNode(PackageList[i].classes[j].treenode).SelectedIndex := ICON_CLASS_TAGGED;
                TTreeNode(PackageList[i].classes[j].treenode).StateIndex := ICON_CLASS_TAGGED;
              end
              else begin
                TTreeNode(PackageList[i].classes[j].treenode).ImageIndex := ICON_CLASS;
                TTreeNode(PackageList[i].classes[j].treenode).SelectedIndex := ICON_CLASS;
                TTreeNode(PackageList[i].classes[j].treenode).StateIndex := ICON_CLASS;
              end;
            end;
          end;
          if (PackageList[i].treenode <> nil) then begin
            if (newtag) then begin
              TTreeNode(PackageList[i].treenode).ImageIndex := ICON_PACKAGE_TAGGED;
              TTreeNode(PackageList[i].treenode).SelectedIndex := ICON_PACKAGE_TAGGED;
              TTreeNode(PackageList[i].treenode).StateIndex := ICON_PACKAGE_TAGGED;
            end
            else begin
              TTreeNode(PackageList[i].treenode).ImageIndex := ICON_PACKAGE;
              TTreeNode(PackageList[i].treenode).SelectedIndex := ICON_PACKAGE;
              TTreeNode(PackageList[i].treenode).StateIndex := ICON_PACKAGE;
            end;
            for j := 0 to TTreeNode(PackageList[i].treenode).Count-1 do begin
              if (newtag) then begin
                TTreeNode(PackageList[i].treenode).Item[j].ImageIndex := ICON_CLASS_TAGGED;
                TTreeNode(PackageList[i].treenode).Item[j].SelectedIndex := ICON_CLASS_TAGGED;
                TTreeNode(PackageList[i].treenode).Item[j].StateIndex := ICON_CLASS_TAGGED;
              end
              else begin
                TTreeNode(PackageList[i].treenode).Item[j].ImageIndex := ICON_CLASS;
                TTreeNode(PackageList[i].treenode).Item[j].SelectedIndex := ICON_CLASS;
                TTreeNode(PackageList[i].treenode).Item[j].StateIndex := ICON_CLASS;
              end;
            end;
          end;
        end;
        StatusReport('Done retagging');
        tv_Packages.Items.EndUpdate;
        tv_Classes.Items.EndUpdate;
      end;
    end;
    Free;
  end;
end;

procedure Tfrm_UnCodeX.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (runningthread = nil); // can not close while a thread is running
end;

procedure Tfrm_UnCodeX.ac_AbortExecute(Sender: TObject);
begin
  if (runningthread <> nil) then begin
    ac_Abort.Enabled := false;
    runningthread.Terminate;
    Log('Aborted', ltError);
  end;
end;

procedure Tfrm_UnCodeX.ac_FindClassExecute(Sender: TObject);
begin
  if (ActiveControl.ClassType <> TTreeView) then begin
    ActiveControl := tv_Classes;
  end;
  InlineSearch := '';
  IsInlineSearch := false;
  SearchConfig.isFTS := false;
  SearchConfig.history := DefaultSC.history;
  SearchConfig.ftshistory := DefaultSC.ftshistory;
  // defaults
  SearchConfig.isFromTop := DefaultSC.isFromTop;
  SearchConfig.isStrict := DefaultSC.isStrict;
  SearchConfig.isRegex := DefaultSC.isRegex;
  SearchConfig.isFindFirst := DefaultSC.isFindFirst;
  SearchConfig.Scope := DefaultSC.Scope; 
  if (SearchForm(SearchConfig)) then begin
    if (SearchConfig.isFromTop and not SearchConfig.isFTS) then (ActiveControl as TTreeView).Selected := nil;
    ac_FindNext.Execute;
  end
  else SearchConfig.Wrapped := false;
end;

procedure Tfrm_UnCodeX.FormDestroy(Sender: TObject);
begin
  ClearLog;
  hh_Help.Free;
  HHCloseAll;
  UnregisterAppBar;
  PackagePriority.Free;
  PackageList.Free;
  ClassList.Free;
  SourcePaths.Free;
  IgnorePackages.Free;
  DefaultSC.ftshistory.Free;
  DefaultSC.history.Free;
  OutputModules.Free;
end;

procedure Tfrm_UnCodeX.ac_OpenClassExecute(Sender: TObject);
var
  filename: string;
  i: integer;
begin
  if (SelectedUPackage <> nil) then begin
    ExecuteProgram(SelectedUPackage.path);
    exit;
  end;
  if (SelectedUClass <> nil) then begin
    for i := 0 to lb_Log.Items.Count-1 do begin
      if (lb_Log.Items.Objects[i] <> nil) then begin
        if (TObject(lb_Log.Items.Objects[i]) = SelectedUClass) then begin
          lb_Log.ItemIndex := i;
          lb_Log.OnDblClick(Sender);
          exit;
        end;
      end;
    end;
    filename := SelectedUClass.package.path+PATHDELIM+SelectedUClass.filename;
    ExecuteProgram(filename);
  end;
end;

procedure Tfrm_UnCodeX.ac_OpenOutputExecute(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(HTMLOutputDir+PATHDELIM+'index.html'), nil, nil, 0);
end;

procedure Tfrm_UnCodeX.ac_SaveStateExecute(Sender: TObject);
begin
  SaveState;
  TreeUpdated := false;
end;

procedure Tfrm_UnCodeX.ac_LoadStateExecute(Sender: TObject);
begin
  LoadState;
end;

procedure Tfrm_UnCodeX.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (MinimizeOnClose) then begin
    Action := caNone;
    Application.Minimize;
  end
  else begin
    tmr_StatusText.Enabled := false;
    if (TreeUpdated) then SaveState;
    SaveLayoutSettings;
  end;
end;

procedure Tfrm_UnCodeX.ac_AboutExecute(Sender: TObject);
begin
  frm_About.ShowModal;
end;

procedure Tfrm_UnCodeX.ac_HTMLHelpExecute(Sender: TObject);
var
  tmp: string;
begin
  if (not FileExists(HHCPath+PATHDELIM+COMPILER)) then begin
    MessageDlg('You first have to define the path to the HTML Help Workshop in '+#13+#10+'the program settings.', mtError, [mbOK], 0);
    exit;
  end;
  if (ThreadCreate) then begin
    ClearLog;
    if (HHTitle <> '') then tmp := HHTitle
    else tmp := HHTitle;
    runningthread := TMSHTMLHelp.Create(HHCPath, HTMLOutputDir, HTMLHelpFile, tmp, PackageList, ClassList, StatusReport);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.mi_ExpandallClick(Sender: TObject);
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    ActiveControl.Tag := TV_ALWAYSEXPAND;
    (ActiveControl as TTreeView).FullExpand;
    ActiveControl.Tag := TV_NOEXPAND;
  end;
end;

procedure Tfrm_UnCodeX.mi_CollapseallClick(Sender: TObject);
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    ActiveControl.Tag := TV_ALWAYSEXPAND;
    (ActiveControl as TTreeView).FullCollapse;
    ActiveControl.Tag := TV_NOEXPAND;
  end;
end;

procedure Tfrm_UnCodeX.spl_Main2CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  Accept := lb_Log.Visible;
end;

procedure Tfrm_UnCodeX.FormResize(Sender: TObject);
begin
  if (IsAppBar) then ABResize;
end;

procedure Tfrm_UnCodeX.ac_RunServerExecute(Sender: TObject);
var
  lst: TStringList;
  exe: string;
begin
  lst := TStringList.Create;
  try
    lst.Delimiter := ' ';
    lst.QuoteChar := '"';
    lst.DelimitedText := ServerCmd;
    if (lst.Count > 0) then begin
      exe := lst[0];
      lst.Delete(0);
      ExecuteProgram(exe, lst, ServerPrio);
    end;
  finally
    lst.Free;
  end;
end;

procedure Tfrm_UnCodeX.ac_JoinServerExecute(Sender: TObject);
var
  lst: TStringList;
  exe: string;
begin
  lst := TStringList.Create;
  try
    lst.Delimiter := ' ';
    lst.QuoteChar := '"';
    lst.DelimitedText := ClientCmd;
    if (lst.Count > 0) then begin
      exe := lst[0];
      lst.Delete(0);
      ExecuteProgram(exe, lst);
    end;
  finally
    lst.Free;
  end;
end;

procedure Tfrm_UnCodeX.ac_CompileClassExecute(Sender: TObject);
var
  lst: TStringList;
  exe: string;
  i: integer;
begin
  if (CompilerCmd = '') then exit;
  if (ActiveControl.ClassType = TTreeView) then begin
    with (ActiveControl as TTreeView) do begin
      if ((Selected <> nil) and (TObject(Selected.Data).ClassType = TUClass)) then begin
        lst := TStringList.Create;
        try
          lst.Delimiter := ' ';
          lst.QuoteChar := '"';
          lst.DelimitedText := CompilerCmd;
          exe := lst[0];
          lst.Delete(0);
          for i := 0 to lst.Count-1 do begin
            if (CompareText(lst[i], '%classname%') = 0) then
              lst[i] := TUClass(Selected.Data).name
            else if (CompareText(lst[i], '%classfile%') = 0) then
              lst[i] := TUClass(Selected.Data).filename
            else if (CompareText(lst[i], '%classpath%') = 0) then
              lst[i] := TUClass(Selected.Data).package.path+PATHDELIM+TUClass(Selected.Data).filename
            else if (CompareText(lst[i], '%packagename%') = 0) then
              lst[i] := TUClass(Selected.Data).package.name
            else if (CompareText(lst[i], '%packagepath%') = 0) then
              lst[i] := TUClass(Selected.Data).package.path;
          end;
          ExecuteProgram(exe, lst);
        finally
          lst.Free;
        end;
      end;
    end;
  end;
end;

procedure Tfrm_UnCodeX.ac_FindNextExecute(Sender: TObject);
var
  i,j: integer;
  res: boolean;
begin
  if (InlineSearch <> '') then begin
    tmr_InlineSearch.Enabled := false;
    InlineSearchNext(true);
    exit;
  end;
  if (not SearchConfig.Wrapped) then begin
    ac_FindClass.Execute;
    exit;
  end;
  if (ActiveControl.ClassType <> TTreeView) then begin
    ActiveControl := tv_Classes;
  end;
  with (ActiveControl as TTreeView) do begin
    if (SearchConfig.isFTS) then begin
      if (ThreadCreate) then begin
        ClearLog;
        if (not lb_Log.Visible) then ac_VLog.Execute;
        SearchConfig.searchtree := (ActiveControl as TTreeView);
        runningthread := TSearchThread.Create(SearchConfig, StatusReport);
        runningthread.OnTerminate := SearchThreadTerminate;
        runningthread.Resume;
        if (SearchConfig.isFindFirst and (SearchConfig.Scope = 0)) then SearchConfig.Scope := 1;
        exit;
      end;
    end
    else begin
      if (Selected <> nil) then j := Selected.AbsoluteIndex+1
        else j := 0;
      for i := j to Items.Count-1 do begin
        if (SearchConfig.isStrict) then res := AnsiCompareText(items[i].Text, SearchConfig.query) = 0
          else res := AnsiContainsText(items[i].Text, SearchConfig.query);
        if (res) then begin
          Tag := TV_ALWAYSEXPAND;
          Select(items[i]);
          if (OpenFind) then ac_OpenClass.Execute;
          if (OpenTags) then ac_Tags.Execute;
          OpenFind := false;
          OpenTags := false;
          statustext := '';
          exit;
        end;
      end;
    end;
  end;
  OpenFind := false;
  statustext := 'No more classes matching '''+SearchConfig.query+''' found';
  SearchConfig.Wrapped := false;
  Beep;
end;

procedure Tfrm_UnCodeX.ac_FullTextSearchExecute(Sender: TObject);
begin
  if (ActiveControl.ClassType <> TTreeView) then begin
    ActiveControl := tv_Classes;
  end;
  InlineSearch := '';
  IsInlineSearch := false;
  SearchConfig.isFTS := true;
  SearchConfig.history := DefaultSC.history;
  SearchConfig.ftshistory := DefaultSC.ftshistory;
  // defaults
  SearchConfig.isFromTop := DefaultSC.isFromTop;
  SearchConfig.isStrict := DefaultSC.isStrict;
  SearchConfig.isRegex := DefaultSC.isRegex;
  SearchConfig.isFindFirst := DefaultSC.isFindFirst;
  SearchConfig.Scope := DefaultSC.Scope;
  if (SearchForm(SearchConfig)) then begin
    if (SearchConfig.isFromTop and not SearchConfig.isFTS) then (ActiveControl as TTreeView).Selected := nil;
    ac_FindNext.Execute;
  end
  else SearchConfig.Wrapped := false;
end;

procedure Tfrm_UnCodeX.lb_LogDblClick(Sender: TObject);
var
  entry: TLogEntry;
begin
  if (lb_Log.ItemIndex = -1) then exit;
  if (lb_Log.Items.Objects[lb_Log.ItemIndex] = nil) then exit;
  if (not IsA(lb_Log.Items.Objects[lb_Log.ItemIndex], TLogEntry)) then exit;

  entry := TLogEntry(lb_Log.Items.Objects[lb_Log.ItemIndex]);
  OpenSourceline(entry.filename, entry.line-1, entry.pos, TUClass(entry));
end;

procedure Tfrm_UnCodeX.lb_LogClick(Sender: TObject);
var
  entry: TLogEntry;
begin
  if (lb_Log.ItemIndex = -1) then exit;
  if (lb_Log.Items.Objects[lb_Log.ItemIndex] = nil) then exit;
  if (not IsA(lb_Log.Items.Objects[lb_Log.ItemIndex], TLogEntry)) then exit;

  entry := TLogEntry(lb_Log.Items.Objects[lb_Log.ItemIndex]);
  if (entry.filename = '') then exit; // no file; don't bother
  OpenSourceInline(entry.filename, entry.line-1, entry.pos, TUClass(entry.obj));
end;

procedure Tfrm_UnCodeX.FormShow(Sender: TObject);
begin
  try
    if (DoInit) then begin
      DoInit := false;
      LoadState;
      if (Application.ShowMainForm) then begin
        tv_Classes.Show;
        ActiveControl := tv_Classes;
      end;
      //if (tv_Classes.Items.Count > 0) then tv_Classes.Select(tv_Classes.Items[0]);
      if (SearchConfig.query <> '') then begin
        SearchConfig.isFTS := false;
        ActiveControl := tv_Classes;
        ac_FindNext.Execute;
      end
      else if (OpenFTS) then ac_FullTextSearch.Execute // TODO: fixed 'enter' bug
      else if (IsBatching) then NextBatchCommand
      else if (AnalyseModified) then begin
        if (runningthread = nil) then begin
          IsBatching := true;
          CmdStack.Clear;
          CmdStack.Add('findnew');
          CmdStack.Add('analysemodified');
          NextBatchCommand;
        end;
      end;
    end;
  finally
    if (frm_Splash <> nil) then begin
      frm_Splash.Close;
      frm_Splash := nil;
    end;
  end;
  if (InitialStartup) then begin
    if MessageDlg('This is the first time you start UnCodeX (with this config file),'+#13+#10+
      'it''s advised that you first configure the program.'+#13+#10+''+#13+#10+
      'Do you want to edit the settings now ?', mtConfirmation, [mbYes,mbNo], 0) = mrYes
      then ac_Settings.Execute; 
  end;
end;

procedure Tfrm_UnCodeX.tv_ClassesDblClick(Sender: TObject);
var
  pt: TPoint;
  ht: THitTests;
begin
  if (Sender.ClassType <> TTreeView) then exit;
  with (Sender as TTreeView) do begin
    pt := ScreenToClient(Mouse.CursorPos);
    ht := GetHitTestInfoAt(Pt.X, Pt.y);
    if (htOnItem in ht) or (htNowhere in ht) then begin
      ac_OpenClass.Execute;
    end;
  end;
end;

procedure Tfrm_UnCodeX.ac_TagsExecute(Sender: TObject);
var
  selclass: TUclass;
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    with (ActiveControl as TTreeView) do begin
      if (Selected <> nil) then begin
        if (TObject(Selected.Data).ClassType <> TUClass) then exit;
        selclass := TUclass(Selected.Data);
        with Tfrm_Tags.CreateWindow(nil, ClassPropertiesWindow) do begin
          RestoreHandle := Handle;
          fr_Main.uclass := selclass;
          fr_Main.ud_InheritanceLevel.Position := DefaultInheritanceDepth;
          if LoadClass then begin
            Show;
          end;
        end;
      end;
    end;
  end;
end;

procedure Tfrm_UnCodeX.ac_CopyNameExecute(Sender: TObject);
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    with (ActiveControl as TTreeView) do begin
      if (Selected <> nil) then
        Clipboard.SetTextBuf(PChar(Selected.Text));
    end;
  end;
end;

procedure Tfrm_UnCodeX.FormActivate(Sender: TObject);
begin
  if ((RestoreHandle <> Handle) and InitActivateFix) then begin
    if (RestoreHandle <> 0) then SetActiveWindow(RestoreHandle);
  end;
  InitActivateFix := false;
end;

procedure Tfrm_UnCodeX.ac_CloseExecute(Sender: TObject);
begin
  MinimizeOnClose := false;
  Close;
end;

procedure Tfrm_UnCodeX.ac_VMenuBarExecute(Sender: TObject);
begin
  if (mi_MenuBar.Checked) then begin
    Windows.SetMenu(Handle, mm_Main.Handle);
    mm_Main.WindowHandle := Handle;
  end
  else begin
    Windows.SetMenu(Handle, 0);
    mm_Main.WindowHandle := 0;
  end;
end;

procedure Tfrm_UnCodeX.ac_VToolbarExecute(Sender: TObject);
begin
  tb_Tools.Visible := mi_Toolbar.Checked;
end;

procedure Tfrm_UnCodeX.ac_VPackageTreeExecute(Sender: TObject);
begin
  //tv_Packages.Visible := mi_PackageTree.Checked;
  ShowDockPanel(tv_Packages.HostDockSite, mi_PackageTree.Checked, tv_Packages);
  if (not tv_Packages.Visible) then
    if (ActiveControl = nil) then ActiveControl := tv_Classes;
end;

procedure Tfrm_UnCodeX.ac_VLogExecute(Sender: TObject);
begin
  ShowDockPanel(lb_Log.HostDockSite, mi_Log.Checked, lb_Log);
end;

procedure Tfrm_UnCodeX.ac_VStayOnTopExecute(Sender: TObject);
begin
  // This prevents window recreation
  if (mi_Stayontop.Checked) then
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE)
    else SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

procedure Tfrm_UnCodeX.ac_VAutoHideExecute(Sender: TObject);
begin
  ABAutoHide := mi_AutoHide.Checked;
  if (IsAppBar) then begin
    if (ABAutoHide) then RegisterABAutoHide
      else UnregisterABAutoHide;
  end;
end;

procedure Tfrm_UnCodeX.ac_VTRightExecute(Sender: TObject);
begin
  UnregisterAppBar;
  if (ac_VTRight.Checked) then begin
    ac_VTLeft.Checked := false;
    abd.uEdge := ABE_RIGHT;
    RegisterAppBar;
  end;
  Refresh;
end;

procedure Tfrm_UnCodeX.ac_VTLeftExecute(Sender: TObject);
begin
  UnregisterAppBar;
  if (ac_VTLeft.Checked) then begin
    ac_VTRight.Checked := false;
    abd.uEdge := ABE_LEFT;
    RegisterAppBar;
  end;
  Refresh;
end;

procedure Tfrm_UnCodeX.ac_VSavePositionExecute(Sender: TObject);
begin
  // nop
end;

procedure Tfrm_UnCodeX.ac_VSaveSizeExecute(Sender: TObject);
begin
  // nop
end;

procedure Tfrm_UnCodeX.mi_Help2Click(Sender: TObject);
begin
  hh_Help.HelpTopic('');
end;

procedure Tfrm_UnCodeX.ac_HelpExecute(Sender: TObject);
begin
  if (ActiveControl <> nil) then hh_Help.HelpTopic(ActiveControl.HelpKeyword)
  else hh_Help.HelpTopic('');
end;

procedure Tfrm_UnCodeX.ac_AnalyseModifiedExecute(Sender: TObject);
begin
  if (ThreadCreate) then begin
    ClearLog;
    LastAnalyseTime := Now;
    runningthread := TClassAnalyser.Create(ClassList, statusReport, true, unit_rtfhilight.ClassesHash);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.tv_ClassesExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  pt: TPoint;
  ht: THitTests;
begin
  if (Sender.ClassType <> TTreeView) then exit;
  with (Sender as TTreeView) do begin
    if (Tag = TV_ALWAYSEXPAND) then begin
      AllowExpansion := true;
      exit;
    end;
    pt := ScreenToClient(Mouse.CursorPos);
    ht := GetHitTestInfoAt(Pt.X, Pt.y);
    if (htOnItem in ht) or (htNowhere in ht) then begin
      AllowExpansion := false;
    end;
  end;
end;

procedure Tfrm_UnCodeX.tv_ClassesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (IsInlineSearch and (Key = 8)) then Key := 0;
  (Sender as TComponent).Tag := TV_ALWAYSEXPAND;
end;

procedure Tfrm_UnCodeX.tv_ClassesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tn: TTreeNode;
begin
  (Sender as TComponent).Tag := TV_NOEXPAND;
  if (Button = mbRight) then begin
    with (Sender as TTreeView) do begin
      tn := GetNodeAt(X, Y);
      if (tn <> nil) then Select(tn);
    end;
  end;
end;

procedure Tfrm_UnCodeX.ac_SourceSnoopExecute(Sender: TObject);
begin
  if (SelectedUClass <> nil) then
    SourceSnoopOpenClass(ResolveFilename(SelectedUClass, nil), SelectedUClass)
  else if (SelectedUPackage <> nil) then
    SourceSnoopOpenPackage(SelectedUPackage);
end;

procedure Tfrm_UnCodeX.tv_ClassesChange(Sender: TObject; Node: TTreeNode);
begin
  if (Sender = nil) then exit;
  if (not (Sender as TWinControl).Visible) then exit;
  SelectedUClass := nil;
  SelectedUPackage := nil;
  if (Sender.ClassType = TTreeView) then begin
    with (Sender as TTreeView) do begin
      if (Selected <> nil) then begin
        if (Selected.Data = nil) then exit;
        if (TObject(Selected.Data).ClassType = TUClass) then SelectedUClass := TUClass(Selected.Data)
        else if (TObject(Selected.Data).ClassType = TUPackage) then SelectedUPackage := TUPackage(Selected.Data);
      end;
    end;
  end;
  if (re_SourceSnoop.Visible) then begin
    ac_SourceSnoop.Execute;
  end;
  if (fr_Props.Visible and (SelectedUClass <> nil)) then begin
    fr_Props.uclass := SelectedUClass;
    fr_Props.LoadClass;
  end;
end;

procedure Tfrm_UnCodeX.ac_VSourceSnoopExecute(Sender: TObject);
begin
  mi_Browse.Visible := mi_SourceSnoop.Checked;
  ShowDockPanel(re_SourceSnoop.HostDockSite, mi_SourceSnoop.Checked, re_SourceSnoop);
  if (mi_SourceSnoop.Checked and not DoInit) then ac_SourceSnoop.Execute;
end;

procedure Tfrm_UnCodeX.ac_CopySelectionExecute(Sender: TObject);
begin
  Clipboard.AsText := re_SourceSnoop.SelText;
end;

procedure Tfrm_UnCodeX.ac_SaveToRTFExecute(Sender: TObject);
begin
  if (sd_SaveToRTF.execute) then re_SourceSnoop.Lines.SaveToFile(sd_SaveToRTF.FileName);
end;

procedure Tfrm_UnCodeX.ac_SelectAllExecute(Sender: TObject);
begin
  re_SourceSnoop.SelectAll;
end;

procedure Tfrm_UnCodeX.re_SourceSnoopMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  curpos: integer;
  tr: TEXTRANGE;
  tmp: array[0..256] of char;
  tmpc: TUClass;
  tmps: string;
begin
  pt := Point(X, Y);
  curpos := re_SourceSnoop.Perform(EM_CHARFROMPOS, 0, Integer(@pt));
  tr.chrg.cpMin := re_SourceSnoop.Perform(EM_FINDWORDBREAK, WB_LEFT, curpos);
  tr.chrg.cpMax := re_SourceSnoop.Perform(EM_FINDWORDBREAK, WB_RIGHT, curpos);
  tr.lpstrText := tmp;
  if (re_SourceSnoop.Perform(EM_GETTEXTRANGE, 0, integer(@tr)) > 0) then begin
    if (unit_rtfhilight.ClassesHash.Exists(LowerCase(tmp)) and (not (ssCtrl in Shift))) then begin
      tmpc := TUClass(unit_rtfhilight.ClassesHash[LowerCase(tmp)]);
      if (tmpc <> nil) then begin
        re_SourceSnoop.Hint := tmpc.FullName+' - '+tmpc.FullFileName;
        re_SourceSnoop.ShowHint := true;
        re_SourceSnoop.Cursor := crHandPoint;
        Application.ActivateHint(Mouse.CursorPos);
        exit;
      end;
    end
    else if ((LowerCase(tmp) = '#include') and (not (ssCtrl in Shift))) then begin
      tmp[256] := #0;
      re_SourceSnoop.Perform(EM_GETLINE, re_SourceSnoop.Perform(EM_LINEFROMCHAR, curpos, 0), integer(@tmp));
      tmps := trim(copy(tmp, 1, 255));
      GetToken(tmps, ' ');
      tmps := GetToken(tmps, ' ', true);
      re_SourceSnoop.Hint := 'Open include file: '+tmps;
      re_SourceSnoop.ShowHint := true;
      re_SourceSnoop.Cursor := crHandPoint;
      Application.ActivateHint(Mouse.CursorPos);
      exit;
    end
    else begin
      if (SelectedUClass <> nil) then re_SourceSnoop.Hint := re_SourceSnoop.filename
      else re_SourceSnoop.Hint := '';
    end;
  end;
  re_SourceSnoop.Cursor := crDefault;
  re_SourceSnoop.ShowHint := false;
end;

procedure Tfrm_UnCodeX.mi_ClearHilightClick(Sender: TObject);
begin
  re_SourceSnoop.ClearBgColor;
end;

procedure Tfrm_UnCodeX.mi_FindSelectionClick(Sender: TObject);
var
  i: integer;
begin
  if (re_SourceSnoop.SelText = '') then exit;
  for i := 0 to tv_Classes.Items.Count-1 do begin
    if (AnsiCompareText(tv_Classes.items[i].Text, re_SourceSnoop.SelText) = 0) then begin
      tv_Classes.Tag := TV_ALWAYSEXPAND;
      tv_Classes.Select(tv_Classes.items[i]);
      exit;
    end;
  end;
end;

procedure Tfrm_UnCodeX.re_SourceSnoopMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  curpos: integer;
  tr: TEXTRANGE;
  tmp: array[0..256] of char;
  tmp2: array[0..255] of char;
  tmps: string;
  i, realline: integer;
begin
  if (Button = mbRight) then begin
    pt := re_SourceSnoop.ClientToScreen(Point(x,y));
    pm_SourceSnoop.Popup(pt.X, pt.Y);
  end;
  if ((re_SourceSnoop.Cursor = crHandPoint) and (button = mbLeft) and (not (ssCtrl in Shift))) then begin
    pt := Point(X, Y);
    curpos := re_SourceSnoop.Perform(EM_CHARFROMPOS, 0, Integer(@pt));
    tr.chrg.cpMin := re_SourceSnoop.Perform(EM_FINDWORDBREAK, WB_LEFT, curpos);
    tr.chrg.cpMax := re_SourceSnoop.Perform(EM_FINDWORDBREAK, WB_RIGHT, curpos);
    tr.lpstrText := tmp;
    if (re_SourceSnoop.Perform(EM_GETTEXTRANGE, 0, integer(@tr)) > 0) then begin
      if (LowerCase(tmp) = '#include') then begin
        realline := re_SourceSnoop.Perform(EM_LINEFROMCHAR, curpos, 0);
        tmp[256] := #0;
        re_SourceSnoop.Perform(EM_GETLINE, realline, integer(@tmp));
        tmps := trim(copy(tmp, 1, 255));
        if (re_SourceSnoop.uclass <> nil) then AddBrowserHistory(re_SourceSnoop.uclass, re_SourceSnoop.filename, realline+1, tmps);
        GetToken(tmps, ' ');
        tmps := GetToken(tmps, ' ', true); // to make sure everything after it is gone
        tmps := iFindFile(ExpandFileName(re_SourceSnoop.uclass.package.PackageDir+tmps));
        OpenSourceInline(tmps, 0, 0, re_SourceSnoop.uclass, true);
        exit;
      end;
      if (tmp <> '') then begin
        realline := re_SourceSnoop.Perform(EM_LINEFROMCHAR, curpos, 0);
        tmp2[0] := #255;
        re_SourceSnoop.Perform(EM_GETLINE, realline, integer(@tmp2));
        tmps := trim(copy(tmp, 1, 255));
        if (re_SourceSnoop.uclass <> nil) then AddBrowserHistory(re_SourceSnoop.uclass, re_SourceSnoop.filename, realline+1, tmps);
        for i := 0 to tv_Classes.Items.Count-1 do begin
          if (AnsiCompareText(tv_Classes.items[i].Text, tmp) = 0) then begin
            tv_Classes.Tag := TV_ALWAYSEXPAND;
            tv_Classes.Select(tv_Classes.items[i]);
            exit;
          end;
        end;
      end;
    end;
  end
end;

procedure Tfrm_UnCodeX.ae_AppEventException(Sender: TObject; E: Exception);
var
  name: string;
begin
  if (Assigned(Sender)) then name := Sender.ClassName
  else name := 'unknown';
  Log('['+name+'] Unhandled exception: ('+e.ClassName+') '+e.Message, ltError);
end;

procedure Tfrm_UnCodeX.tv_ClassesKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then begin   // ESC
    if (IsInlineSearch) then begin
      Key := #0; // reset key
      tmr_InlineSearch.OnTimer(Sender)
    end;
  end
  else if(Key = #8) then begin // Backspace
    if (IsInlineSearch) then begin
      tmr_InlineSearch.Enabled := false;
      tmr_InlineSearch.Enabled := true;
      Key := #0; // reset key
      Delete(InlineSearch, Length(InlineSearch), 1);
      if (InlineSearch = '') then begin
        tmr_InlineSearch.OnTimer(Sender);
        exit;
      end;
      InlineSearchPrevious;
      StatusReport('Inline search for: '+inlinesearch);
      tmr_StatusText.OnTimer(Sender);
    end;
  end
  else if ((Key >= #32) and (Key < #127)) then begin
    tmr_InlineSearch.Enabled := false;
    tmr_InlineSearch.Enabled := true;
    if (not IsInlineSearch) then begin
      IsInlineSearch := true;
      inlinesearch := '';
    end;
    inlinesearch := inlinesearch+Key;
    Key := #0; // reset key
    InlineSearchNext;
    StatusReport('Inline search for: '+inlinesearch);
    tmr_StatusText.OnTimer(Sender);
  end;
end;

procedure Tfrm_UnCodeX.tmr_InlineSearchTimer(Sender: TObject);
begin
  IsInlineSearch := false;
  StatusReport('Inline search cancelled');
  tmr_StatusText.OnTimer(Sender);
  tmr_InlineSearch.Enabled := false;
end;

procedure Tfrm_UnCodeX.tv_ClassesExit(Sender: TObject);
begin
  if (IsInlineSearch) then tmr_InlineSearch.OnTimer(Sender);
end;

procedure Tfrm_UnCodeX.ae_AppEventMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if (Msg.Message = WM_KEYDOWN) then begin
    // InlineSearch TAB completion
    if ((Msg.wParam = VK_TAB) and (IsInlineSearch)) then begin
      Handled := true;
      InlineSearchComplete;
      StatusReport('Inline search for: '+inlinesearch);
      tmr_StatusText.OnTimer(nil);
    end;
  end;
end;

procedure Tfrm_UnCodeX.cmdPokeData(Sender: TObject);
var
  lst: TStringList;
  i: integer;
begin
  Log('DDE Command: '+cmd.Text);
  lst := TStringList.Create;
  try
    lst.Delimiter := ' ';
    lst.QuoteChar := '"';
    lst.DelimitedText := cmd.Text;
    i := 0;
    if (lst.Count = 0) then BringToFront;
    while i < lst.Count do begin
      if ((CompareText(lst[i], '-find') = 0) or (CompareText(lst[i], '-open') = 0) or
        (CompareText(lst[i], '-tags') = 0)) then begin
        if (i < lst.Count-1) then begin
          OpenFind := (CompareText(lst[i], '-open') = 0);
          OpenTags := (CompareText(lst[i], '-tags') = 0);
          SearchConfig.query := trim(lst[i+1]);
          SearchConfig.isFTS := false;
          SearchConfig.Wrapped := true;
          if (not (OpenTags or OpenFind)) then BringToFront;
          if (SearchConfig.query <> '') then begin
            ac_FindNext.Execute;
            break;
          end;
        end;
      end
      else if (CompareText(lst[i], '-batch') = 0) then begin
        Inc(i);
        CmdStack.Clear;
        while i < lst.Count do begin
          if (lst[i] = '--') then break;
          CmdStack.Add(LowerCase(lst[i]));
          Inc(i);
        end;
        if (CmdStack.Count > 0) then begin
          BringToFront;
          IsBatching := true;
          NextBatchCommand;
          break;
        end;
      end
      else if (CompareText(lst[i], '-fts') = 0) then begin
        BringToFront;
        ac_FullTextSearch.Execute;
        break;
      end
      else if (CompareText(lst[i], '-handle') = 0) then begin
        StatusHandle := StrToIntDef(lst[i], -1);
      end;
      Inc(i);
    end
  finally
    lst.Free;
  end;
  cmd.Text := '';
end;

procedure Tfrm_UnCodeX.mi_ClassNameDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var
  capt: string;
begin
  ACanvas.Brush.Color := clActiveCaption;
  ACanvas.FillRect(ARect);
  ACanvas.Font.Style := [fsBold];
  ACanvas.Font.Color := clCaptionText;
  capt := (Sender as TMenuItem).Caption;
  capt := StringReplace(capt, '&', '', []);
  ACanvas.TextRect(ARect, ARect.Left + 5, ARect.Top+(ARect.Bottom-ARect.Top-ACanvas.TextHeight(capt)) div 2, capt);
end;

procedure Tfrm_UnCodeX.pm_ClassTreePopup(Sender: TObject);
begin
  with (ActiveControl as TTreeView) do begin
    if ((Selected = nil) or (Selected.Data = nil)) then begin
      mi_ClassName.Visible := false;
      mi_PackageName.Visible := false;
      mi_Analyseclass.Visible := false;
      mi_ShowProperties.Visible := false;
      mi_Compile.Visible := false;
      mi_DeleteClass.Visible := false;
      mi_MoveClass.Visible := false;
      mi_RenameClass.Visible := false;
      //mi_Properties.Visible := false;
      mi_SingleOutput.Visible := false;
    end
    else if (TObject(Selected.Data).ClassType = TUClass) then begin
      mi_ClassName.Visible := true;
      mi_ClassName.Caption := TUClass(Selected.Data).name;
      mi_PackageName.Caption := TUClass(Selected.Data).package.name;
      mi_Analyseclass.Visible := true;
      mi_ShowProperties.Visible := true;
      mi_Compile.Visible := true;
      mi_DeleteClass.Visible := true;
      mi_MoveClass.Visible := true;
      mi_RenameClass.Visible := true;
      //mi_Properties.Visible := false;
      mi_SingleOutput.Visible := true;
    end
    else if (TObject(Selected.Data).ClassType = TUPackage) then begin
      mi_ClassName.Visible := false;
      mi_PackageName.Caption := TUPackage(Selected.Data).name;
      mi_Analyseclass.Visible := false;
      mi_ShowProperties.Visible := false;
      mi_Compile.Visible := false;
      mi_DeleteClass.Visible := false;
      mi_MoveClass.Visible := false;
      mi_RenameClass.Visible := false;
      //mi_Properties.Visible := true;
      mi_SingleOutput.Visible := false;
    end;
    mi_SwitchTree.Visible := tv_Packages.Visible;
  end;
end;

procedure Tfrm_UnCodeX.mi_PackageNameDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var
  capt: string;
begin
  ACanvas.Brush.Color := clGradientInactiveCaption;
  ACanvas.FillRect(ARect);
  ACanvas.Font.Style := [fsBold];
  ACanvas.Font.Color := clInactiveCaptionText;
  capt := (Sender as TMenuItem).Caption;
  capt := StringReplace(capt, '&', '', []);
  ACanvas.TextRect(ARect, ARect.Left + 5, ARect.Top+(ARect.Bottom-ARect.Top-ACanvas.TextHeight(capt)) div 2, capt);
end;

procedure Tfrm_UnCodeX.ac_LicenseExecute(Sender: TObject);
begin
  frm_License.ShowModal();
end;

procedure Tfrm_UnCodeX.ac_RebuildAnalyseExecute(Sender: TObject);
begin
  if (runningthread <> nil) then exit;
  IsBatching := true;
  CmdStack.Clear;
  CmdStack.Add('rebuild');
  CmdStack.Add('orphanstop');
  CmdStack.Add('analyse');
  NextBatchCommand;
end;

procedure Tfrm_UnCodeX.ac_OpenHTMLHelpExecute(Sender: TObject);
begin
  if (FileExists(HTMLHelpFile)) then begin
    ShellExecute(0, nil, PChar(HTMLHelpFile), nil, nil, 0);
  end;
end;

procedure Tfrm_UnCodeX.dckLeftDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
  if (Sender as TPanel).VisibleDockClientCount > 0 then ShowDockPanel(Sender as TPanel, True, Source.Control)
  else if (visible) then ShowDockPanel(Sender as TPanel, True, Source.Control);
  if (visible) then (Sender as TPanel).DockManager.ResetBounds(True);
end;

procedure Tfrm_UnCodeX.dckLeftUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
  Allow := (NewTarget <> nil); // prevent floating
  if (not Allow) then exit;
  if (visible) then ShowDockPanel(Sender as TPanel, False, nil);
end;

procedure Tfrm_UnCodeX.ac_PropInspectorExecute(Sender: TObject);
begin
  fr_Props.Visible := mi_PropInspector.Checked;
  ShowDockPanel(fr_Props.HostDockSite, fr_Props.Visible, nil);
end;

procedure Tfrm_UnCodeX.tv_ClassesEnter(Sender: TObject);
begin
  if (TTreeView(Sender) = nil) then exit;
  if (TTreeView(Sender).Selected = nil) then exit;
  if ((SelectedUClass <> TTreeView(Sender).Selected.Data)
    and (SelectedUPackage <> TTreeView(Sender).Selected.Data)) then
    tv_ClassesChange(Sender, TTreeView(Sender).Selected);
end;

procedure Tfrm_UnCodeX.splRightCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  // HACK to fix incorrect sizing when the top splitter is not visible
  if (not splTop.Visible) then NewSize := NewSize-splRight.Left-splRight.Width;
  Accept := NewSize > splRight.MinSize;
  splRightHack := NewSize;
  if (splRightHack < splRight.MinSize) then splRightHack := splRight.MinSize;
end;

procedure Tfrm_UnCodeX.splRightMoved(Sender: TObject);
begin
  if (splRightHack <> 0) then dckRight.Width := splRightHack;
  splRightHack := 0;
end;

procedure Tfrm_UnCodeX.re_SourceSnoopEndDock(Sender, Target: TObject; X,
  Y: Integer);
begin
  re_SourceSnoop.UpdateWindowRect;
end;

procedure Tfrm_UnCodeX.pnlCenterUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
  Allow := (NewTarget <> nil) and (Client <> tv_Classes);
  if (visible) then (Sender as TPanel).DockManager.ResetBounds(True);
end;

procedure Tfrm_UnCodeX.pnlCenterDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
  if (visible) then begin
    Source.Control.Show;
    (Sender as TPanel).DockManager.ResetBounds(True);
  end;
end;

procedure Tfrm_UnCodeX.ac_SwitchTreeExecute(Sender: TObject);
var
  atree, ftree: TTreeview;
  i: integer;
begin
  if (ActiveControl.ClassType <> TTreeView) then exit;
  atree := (ActiveControl as TTreeView);
  if (atree.Selected = nil) then exit;
  if (atree = tv_Classes) then ftree := tv_Packages
  else ftree := tv_Classes;
  if (not ftree.Visible) then exit;
  for i := 0 to ftree.Items.Count-1 do begin
    if (ftree.Items[i].Data = atree.Selected.Data) then begin
      ftree.Select(ftree.Items[i]);
      ActiveControl := ftree;
      exit;
    end;
  end;
end;

procedure Tfrm_UnCodeX.ac_CreateSubClassExecute(Sender: TObject);
begin
  if (SelectedUClass <> nil) then CreateSubUClass(SelectedUClass)
  else CreateSubUClass(SelectedUPackage);
end;

procedure Tfrm_UnCodeX.ac_DeleteClassExecute(Sender: TObject);
var
  i: integer;
begin
  if (SelectedUClass = nil) then exit;
  if (MessageDlg('Are you sure you want to delete the class '''+SelectedUClass.name+''' ?', mtConfirmation, [mbYes,mbNo], 0) = mrYes) then begin
    i := 0;
    if (SelectedUClass.children.Count > 0) then begin
      i := MessageDlg('Do you also want to delete all subclasses ?', mtConfirmation, [mbYes,mbNo,mbCancel], 0);
      if (i = mrCancel) then exit;
    end;
    DeleteClass(SelectedUClass, i = mrYes);
  end;
end;

procedure Tfrm_UnCodeX.ac_PackagePropsExecute(Sender: TObject);
begin
  if (SelectedUPackage <> nil) then ShowPackageProps(SelectedUPackage)
  else if (SelectedUClass <> nil) then ShowPackageProps(SelectedUClass.package)
end;

procedure Tfrm_UnCodeX.mi_SaveToFile1Click(Sender: TObject);
begin
  if (sd_SaveLog.Execute) then lb_Log.Items.SaveToFile(sd_SaveLog.FileName);
end;

procedure Tfrm_UnCodeX.pm_LogPopup(Sender: TObject);
begin
  if (lb_Log.ItemIndex > -1) then begin
    mi_OpenClass1.Enabled := lb_Log.Items.Objects[lb_Log.ItemIndex] <> nil;
  end
  else mi_OpenClass1.Enabled := false;
end;

procedure Tfrm_UnCodeX.ac_MoveClassExecute(Sender: TObject);
begin
  if (SelectedUClass <> nil) then MoveUClass(SelectedUClass);
end;

procedure Tfrm_UnCodeX.ac_DefPropsExecute(Sender: TObject);
begin
  if (SelectedUClass <> nil) then ShowDefaultProperties(SelectedUClass);
end;

procedure Tfrm_UnCodeX.ac_RenameClassExecute(Sender: TObject);
begin
  if (SelectedUClass <> nil) then RenameUClass(SelectedUClass);
end;

procedure Tfrm_UnCodeX.mi_SortListClick(Sender: TObject);
begin
  lb_Log.Sorted := true;
  lb_Log.Sorted := false;
end;

procedure Tfrm_UnCodeX.mi_DonateClick(Sender: TObject);
begin
  hh_Help.HelpTopic('donation.html');
end;

procedure Tfrm_UnCodeX.ac_RunExecute(Sender: TObject);
var
  lst: TStringList;
begin
  with (Tfrm_Run.Create(Application)) do begin
    if (ShowModal = mrOk) then begin
      lst := TStringList.Create;
      try
        lst.Delimiter := ' ';
        lst.QuoteChar := '"';
        lst.DelimitedText := ed_Args.Text;
        ExecuteProgram(ed_Exe.Text, lst, cb_Priority.ItemIndex);
      finally;
        lst.Free;
      end;
    end;
    Free;
  end;
end;

procedure Tfrm_UnCodeX.ps_MainLine(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure Tfrm_UnCodeX.ps_MainCompile(Sender: TPSScript);
begin
  RegisterPS(Sender);
  RegisterPSGui(Sender);
  Sender.Comp.AllowNoBegin := true;
end;

procedure Tfrm_UnCodeX.ac_PSEditorExecute(Sender: TObject);
begin
  with Tfrm_PSEditor.Create(Application) do ShowModal;
end;

procedure Tfrm_UnCodeX.ps_MainExecute(Sender: TPSScript);
begin
  LinkPSGui(Sender);
end;

procedure Tfrm_UnCodeX.ac_PluginRefreshExecute(Sender: TObject);
begin
  LoadOutputModules;
  LoadPascalScripts;
end;

procedure Tfrm_UnCodeX.ac_FindNewClassesExecute(Sender: TObject);
begin
  if (ThreadCreate) then begin
    ClearLog;
    runningthread := TNewClassScanner.Create(PackageList, ClassList, StatusReport, ClassesHash);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.mi_ClearClick(Sender: TObject);
begin
  ClearLog;
end;

procedure Tfrm_UnCodeX.lb_LogDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  entry: TLogEntry;
  x: integer;
begin
  with TListBox(Control) do begin
    entry := TLogEntry(items.Objects[index]);
    x := Canvas.TextHeight(items[index]);
    Canvas.TextRect(Rect, Rect.Left+2+ItemHeight, Rect.Top+((ItemHeight-x) div 2), TListBox(Control).items[index]);
    if (entry <> nil) then begin
      il_LogEntries.Draw(Canvas, Rect.Left+1, Rect.Top+1, ord(entry.mt));
    end;
  end;
end;

procedure Tfrm_UnCodeX.ac_GoToReplicationExecute(Sender: TObject);
var
  tmp: string;
begin
  if (re_SourceSnoop.uclass = nil) then exit;
  if (re_SourceSnoop.uclass.replication.definedIn = '') then
    tmp := re_SourceSnoop.uclass.FullFileName
  else
    tmp := iFindFile(ExpandFileName(re_SourceSnoop.uclass.package.PackageDir+re_SourceSnoop.uclass.replication.definedIn));
  OpenSourceInLine(tmp, re_SourceSnoop.uclass.replication.srcline-1, 0, re_SourceSnoop.uclass, true);
end;

procedure Tfrm_UnCodeX.ac_GoToDefaultpropertiesExecute(Sender: TObject);
var
  tmp: string;
begin
  if (re_SourceSnoop.uclass = nil) then exit;
  if (re_SourceSnoop.uclass.defaultproperties.definedIn = '') then
    tmp := re_SourceSnoop.uclass.FullFileName
  else
    tmp := iFindFile(ExpandFileName(re_SourceSnoop.uclass.package.PackageDir+re_SourceSnoop.uclass.defaultproperties.definedIn));
  OpenSourceInLine(tmp, re_SourceSnoop.uclass.defaultproperties.srcline-1, 0, re_SourceSnoop.uclass, true);
end;

initialization
  DefaultDockTreeClass := TUCXDockTree;
  unit_definitions.Log := Log;
  unit_analyse.GetExternalComment := unit_definitions.RetExternalComment;
end.
