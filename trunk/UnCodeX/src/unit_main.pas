{-----------------------------------------------------------------------------
 Unit Name: unit_main
 Author:    elmuerte
 Purpose:   Main windows
 History:
-----------------------------------------------------------------------------}

unit unit_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, Menus, StdCtrls, unit_packages, ExtCtrls,
  unit_uclasses, IniFiles, ShellApi, AppEvnts, ImgList, ActnList, StrUtils,
  Clipbrd, hh, hh_funcs, ToolWin;

const
  // custom window messages
  WM_APPBAR                      = WM_USER+$100;
  UM_APP_ID_CHECK                = WM_APP + 101;
  UM_RESTORE_APPLICATION         = WM_APP + 102;
  // misc constants
  TV_ALWAYSEXPAND                = 0;
  TV_NOEXPAND                    = 1;

type
  Tfrm_UnCodeX = class(TForm)
    tv_Classes: TTreeView;
    tv_Packages: TTreeView;
    sb_Status: TStatusBar;
    pb_Scan: TProgressBar;
    mm_Main: TMainMenu;
    mi_Tree: TMenuItem;
    mi_ScanPackages: TMenuItem;
    spl_Main1: TSplitter;
    spl_Main2: TSplitter;
    lb_Log: TListBox;
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
    re_SourceSnoop: TRichEdit;
    spl_Main3: TSplitter;
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
  private
    // AppBar vars
    OldStyleEx: Cardinal;
    OldStyle: Cardinal;
    OldSize: TRect;
    IsAppBar: boolean;
    ABAutoHide: boolean;
    abd: APPBARDATA;
    WorkArea: TRect;
    ABWidth: integer;
    // AppBar vars -- end;
    function ThreadCreate: boolean;
    procedure ThreadTerminate(Sender: TObject);
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
    procedure NextBatchCommand;
    // -reuse methods
    procedure UMAppIDCheck(var Message : TMessage); message UM_APP_ID_CHECK;
    procedure WMCopyData(var msg: TWMCopyData); message WM_COPYDATA;
    procedure UMRestoreApplication(var msg: TMessage); message UM_RESTORE_APPLICATION;
    // Custom output modules
    procedure LoadOutputModules;
    procedure miCustomOutputClick(sender: TObject);
  public
    statustext : string; // current status text
    procedure StatusReport(msg: string; progress: byte = 255);
    procedure ExecuteProgram(exe: string; params: TStringList = nil; prio: integer = -1; show: integer = SW_SHOW);
    procedure OpenSourceLine(uclass: TUClass; line, caret: integer);    
  end;

  // status redirecting
  TCodeXStatusType = (cxstLog, cxstStatus);

  TCodeXStatus = packed record
    Msg: string[255];
    mType: TCodeXStatusType;
    Progress: byte;
  end;

  // logging
  procedure Log(msg: string);
  procedure LogClass(msg: string; uclass: TUClass = nil);

var
  frm_UnCodeX: Tfrm_UnCodeX;
  DoInit: boolean = true; // perform initialization on startup
  runningthread: TThread = nil;
  InitActivateFix: Boolean = true; // fix initial form activation
  ConfigFile: string; // current config file
  InitialStartup: boolean; // is first run
  TreeUpdated: boolean = false; // prevent useless saving
  hh_Help: THookHelpSystem; // help system
  OutputModules: TStringList; // custom output modules
  // UScript data
  PackageList: TUPackageList;
  ClassList: TUClassList;
  // class search vars
  searchclass: string;
  CSprops: array[0..2] of boolean;
  OpenFind: boolean = false; // only on startup
  OpenTags: boolean = false; // only on startup
  // batch vars
  IsBatching: boolean = false; // is batch executing
  CmdStack: TStringList; // command stack
  // -handle argument
  StatusHandle: integer = -1;
  // used for -reuse
  PrevInst, RestoreHandle: HWND;
  AppInstanceId: integer = 0;

// config vars
var
  // general
  StateFile: string;
  SourcePaths: TStringList;
  PackagePriority: TStringList;
  IgnorePackages: TStringList;
  MinimizeOnClose: boolean = false;
  // startup
  ExpandObject: boolean;
  AnalyseModified: boolean;
  LoadCustomOutputModules: boolean = true;
  // HTML out
  HTMLOutputDir, TemplateDir: string;
  // HTML Help out
  HHCPath, HTMLHelpFile, HHTitle: string;
  // Start server
  ServerCmd, ClientCmd: string;
  ServerPrio: integer;
  // Commandlines
  CompilerCmd, OpenResultCmd: string;
  // Search
  FTSRegexp: boolean;
  FTSHistory: TStringList;
  CSHistory: TStringList;
  // class properties
  DefaultInheritanceDepth: integer = 0;

implementation

uses unit_settings, unit_analyse, unit_htmlout, unit_definitions,
  unit_treestate, unit_about, unit_mshtmlhelp, unit_fulltextsearch,
  unit_tags, unit_outputdefs;

const
  PROCPRIO: array[0..3] of Cardinal = (IDLE_PRIORITY_CLASS, NORMAL_PRIORITY_CLASS,
                                       HIGH_PRIORITY_CLASS, REALTIME_PRIORITY_CLASS);
  AUTOHIDEEXPOSURE = 4; // number of pixel to show of the app bar

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

procedure Log(msg: string);
begin
  if (msg='') then exit;
  frm_UnCodeX.lb_Log.Items.Add(msg);
  frm_UnCodeX.lb_Log.ItemIndex := frm_UnCodeX.lb_Log.Items.Count-1;
  if (StatusHandle <> -1) then SendStatusMsg(msg, cxstLog);
end;

procedure LogClass(msg: string; uclass: TUClass = nil);
begin
  if (msg='') then exit;
  frm_UnCodeX.lb_Log.Items.AddObject(msg, uclass);
  frm_UnCodeX.lb_Log.ItemIndex := frm_UnCodeX.lb_Log.Items.Count-1;
   if (StatusHandle <> -1) then SendStatusMsg(msg, cxstLog);
end;

{ Logging -- END }
{ Tfrm_UnCodeX }
{ Custom methods }

// update status
procedure Tfrm_UnCodeX.StatusReport(msg: string; progress: byte = 255);
begin
  statustext := msg;
  if (progress <> 255) then pb_Scan.Position := progress;
  // redirect status if set
  if (StatusHandle <> -1) then SendStatusMsg(msg, cxstStatus, progress);
end;

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
  runningthread := nil;
  ac_Abort.Enabled := false;
  if (IsBatching) then NextBatchCommand;
end;

{ Package\Class Tree state }

procedure Tfrm_UnCodeX.SaveState;
var
  fs: TFileStream;
begin
  StatusReport('Saving state to '+StateFile);
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
begin
  if (not FileExists(StateFile)) then exit;
  StatusReport('Loading state from '+StateFile);
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
      if (ExpandObject and (tv_Classes.Items.Count > 0)) then
        tv_Classes.Items.GetFirstNode.Expand(false);
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
  SysMenu : HMenu;
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
  log(IntToStr(Msg.WParam));
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
  se: SHELLEXECUTEINFO;
begin
  se.cbSize := SizeOf(SHELLEXECUTEINFO);
  se.Wnd := Handle;
  se.lpVerb := nil;
  se.lpFile := PChar(exe);
  if (params <> nil) then se.lpParameters := PChar(params.DelimitedText);
  se.nShow := show;
  se.fMask := SEE_MASK_NOCLOSEPROCESS;
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
procedure Tfrm_UnCodeX.OpenSourceLine(uclass: TUClass; line, caret: integer);
var
  lst: TStringList;
  i: integer;
  exe: string;
begin
  if (OpenResultCmd = '') then begin
    ExecuteProgram(uclass.package.path+PATHDELIM+CLASSDIR+PATHDELIM+uclass.filename);
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
      if (CompareText(lst[i], '%classname%') = 0) then
        lst[i] := uclass.name
      else if (CompareText(lst[i], '%classfile%') = 0) then
        lst[i] := uclass.filename
      else if (CompareText(lst[i], '%classpath%') = 0) then
        lst[i] := uclass.package.path+PATHDELIM+CLASSDIR+PATHDELIM+uclass.filename
      else if (CompareText(lst[i], '%packagename%') = 0) then
        lst[i] := uclass.package.name
      else if (CompareText(lst[i], '%packagepath%') = 0) then
        lst[i] := uclass.package.path;
      lst[i] := AnsiReplaceStr(lst[i], '%resultline%', IntToStr(line));
      lst[i] := AnsiReplaceStr(lst[i], '%resultpos%', IntToStr(caret));
    end;
    ExecuteProgram(exe, lst);
  finally
    lst.Free;
  end;
end;

{ Program execution -- END }

// Execute next batch command
procedure Tfrm_UnCodeX.NextBatchCommand;
var
  cmd: string;
begin
  if (not IsBatching) then exit;
  if (CmdStack.Count = 0) then begin
    IsBatching := false;
    Caption := APPTITLE+' - '+APPVERSION;
    exit;
  end;
  cmd := CmdStack[0];
  Caption := APPTITLE+' - '+APPVERSION+' - Batch process: '+cmd;
  CmdStack.Delete(0);
  if (cmd = 'rebuild') then ac_RecreateTree.Execute
  else if (cmd = 'analyse') then ac_AnalyseAll.Execute
  else if (cmd = 'createhtml') then ac_CreateHTMLfiles.Execute
  else if (cmd = 'htmlhelp') then ac_HTMLHelp.Execute
  else if (cmd = 'close') then Close;
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
      searchclass := data.Find;
      CSprops[0] := false;
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
        NextBatchCommand;
      finally
        lst.Free;
      end;
    end;
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
  info: TUCXOutputDetails;
  dfunc: TUCX_Details;
  mi: TMenuItem;
begin
  if FindFirst(ExtractFilePath(ParamStr(0))+'out_*.dll', 0, rec) = 0 then begin
    repeat
      omod := LoadLibrary(PChar(rec.Name));
      if (omod <> 0) then begin
        try
          @dfunc := nil;
          @dfunc := GetProcAddress(omod, 'UCX_Details');
          if (@dfunc <> nil) then begin
            if dfunc(info) then begin
              Log('Output module: '+rec.Name+' '+info.AName);
              mi_Output.Visible := true;
              mi := TMenuItem.Create(mi_Output);
              mi.Tag := OutputModules.Add(rec.Name); // add to list
              mi.Caption := info.AName;
              mi.Hint := info.ADescription;
              mi.OnClick := miCustomOutputClick;
              mi_Output.Add(mi);
            end;
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
var
  omod: THandle;
  dfunc: TUCX_Output;
  info: TUCXOutputInfo;
begin
  omod := LoadLibrary(PChar(OutputModules[(Sender as TMenuItem).Tag]));
  if (omod <> 0) then begin
    try
      @dfunc := nil;
      @dfunc := GetProcAddress(omod, 'UCX_Output');
      if (@dfunc <> nil) then begin
        info.AClassList := ClassList;
        info.APackageList := PackageList;
        info.AStatusReport := StatusReport;
        info.AThreadTerminated := ThreadTerminate;
        info.WaitForTerminate := false;
        info.AThread := nil;
        if dfunc(info) then begin
          if (info.WaitForTerminate) then begin
            lb_Log.Items.Clear;
            runningthread := info.AThread;
            runningthread.Resume;
          end;
        end;
      end;
    finally
      FreeLibrary(omod);
    end;
  end;
end;

{ Custom output modules -- END }
{ Custom methods -- END}
{ Auto generated methods }

// Update the status message on timer
procedure Tfrm_UnCodeX.tmr_StatusTextTimer(Sender: TObject);
begin
  sb_Status.Panels[0].Text := statustext;
end;

// Create form and init
procedure Tfrm_UnCodeX.FormCreate(Sender: TObject);
var
  ini: TMemIniFile;
  tmp, tmp2: string;
  sl: TStringList;
  i: integer;
begin
  hh_Help := THookHelpSystem.Create(ExtractFilePath(ParamStr(0))+'UnCodeX-help.chm', '', htHHAPI);
  Caption := APPTITLE+' - '+APPVERSION;
  Application.Title := Caption;
  if (ConfigFile = '') then ConfigFile := ExtractFilePath(ParamStr(0))+'UnCodeX.ini';
  if (StateFile = '') then StateFile := ExtractFilePath(ParamStr(0))+'UnCodeX.ucx';
  InitialStartup := not FileExists(ConfigFile);
  ini := TMemIniFile.Create(ConfigFile);
  sl := TStringList.Create;
  { StringLists }
  PackagePriority := TStringList.Create;
  SourcePaths := TStringList.Create;
  IgnorePackages := TStringList.Create;
  FTSHistory := TStringList.Create;
  CSHistory := TStringList.Create;
  OutputModules := TStringList.Create;
  { StringLists -- END }
  try
    { Load layout }
    mi_MenuBar.Checked := ini.ReadBool('Layout', 'MenuBar', true);
    mi_Toolbar.Checked := ini.ReadBool('Layout', 'Toolbar', true);
    mi_Toolbar.OnClick(Sender);
    mi_PackageTree.Checked := ini.ReadBool('Layout', 'PackageTree', true);
    mi_PackageTree.OnClick(Sender);
    tv_Packages.Width := ini.ReadInteger('Layout', 'PackageTreeWidth', tv_Packages.Width);
    //mi_ClassTree.Checked := ini.ReadBool('Layout', 'ClassTree', true);
    //mi_ClassTree.OnClick(Sender);
    lb_Log.Height := ini.ReadInteger('Layout', 'LogHeight', lb_Log.Height);
    mi_Log.Checked := ini.ReadBool('Layout', 'Log', true);
    mi_Log.OnClick(Sender);
    mi_StayOnTop.Checked := ini.ReadBool('Layout', 'StayOnTop', false);
    if (mi_StayOnTop.Checked) then FormStyle := fsStayOnTop;
    mi_Saveposition.Checked := ini.ReadBool('Layout', 'SavePosition', false);
    mi_Savesize.Checked := ini.ReadBool('Layout', 'SaveSize', false);
    if (mi_Saveposition.Checked) then begin
      Position := poDesigned;
      Top := ini.ReadInteger('Layout', 'Top', Top);
      Left := ini.ReadInteger('Layout', 'Left', Left);
    end;
    if (mi_Savesize.Checked) then begin
      Width := ini.ReadInteger('Layout', 'Width', Width);
      Height := ini.ReadInteger('Layout', 'Height', Height);
    end;
    ABWidth := ini.ReadInteger('Layout', 'ABWidth', 150);
    mi_AutoHide.Checked := ini.ReadBool('Layout', 'AutoHide', false);
    mi_AutoHide.OnClick(Sender);
    mi_Right.Checked := ini.ReadBool('Layout', 'ABRight', false);
    if (mi_Right.Checked) then mi_Right.OnClick(Sender);
    mi_Left.Checked := ini.ReadBool('Layout', 'ABLeft', false);
    if (mi_Left.Checked) then mi_Left.OnClick(Sender);
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
    { Color and fonts -- END }
    { Load layout -- END }
    { Program configuration }
    HTMLOutputDir := ini.ReadString('Config', 'HTMLOutputDir', ExtractFilePath(ParamStr(0))+'Output');
    TemplateDir := ini.ReadString('Config', 'TemplateDir', ExtractFilePath(ParamStr(0))+'Templates'+PATHDELIM+'UnrealWiki');
    HHCPath := ini.ReadString('Config', 'HHCPath', '');
    HTMLHelpFile := ini.ReadString('Config', 'HTMLHelpFile', ExtractFilePath(ParamStr(0))+'UnCodeX.chm');
    HHTitle := ini.ReadString('Config', 'HHTitle', '');
    ServerCmd := ini.ReadString('Config', 'ServerCmd', '');
    ServerPrio := ini.ReadInteger('Config', 'ServerPrio', 1);
    ClientCmd := ini.ReadString('Config', 'ClientCmd', '');
    CompilerCmd := ini.ReadString('Config', 'CompilerCmd', '');
    OpenResultCmd := ini.ReadString('Config', 'OpenResultCmd', '');
    FTSRegexp := ini.ReadBool('Config', 'FullTextSearchRegExp', false);
    StateFile := ini.ReadString('Config', 'StateFile', StateFile);
    AnalyseModified := ini.ReadBool('Config', 'AnalyseModified', true);
    DefaultInheritanceDepth := ini.ReadInteger('Config', 'DefaultInheritanceDepth', 0);
    if (ExtractFilePath(StateFile) = '') then StateFile := ExtractFilePath(ConfigFile)+StateFile;
    LoadCustomOutputModules := ini.ReadBool('[config]', 'LoadOutputModules', LoadCustomOutputModules);
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
    ini.ReadSectionValues('FullTextSearch', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      FTSHistory.Add(tmp);
    end;
    ini.ReadSectionValues('ClassSearch', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      CSHistory.Add(tmp);
    end;
    { Search history -- END }
  finally
    ini.Free;
    sl.Free;
  end;
  if (LoadCustomOutputModules) then LoadOutputModules;
  PackageList := TUPackageList.Create(true);
  ClassList := TUClassList.Create(false);
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
  sb_Status.SimplePanel := (sb_Status.SimpleText <> '');
end;

procedure Tfrm_UnCodeX.ac_RecreateTreeExecute(Sender: TObject);
begin
  if (ThreadCreate) then begin
    TreeUpdated := true;
    lb_Log.Items.Clear;
    tv_Packages.Items.Clear;
    tv_Classes.Items.Clear;
    PackageList.Clear;
    ClassList.Clear;
    runningthread := TPackageScanner.Create(SourcePaths, tv_Packages, tv_Classes,
          statusReport, PackageList, ClassList, PackagePriority, IgnorePackages);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.ac_FindOrphansExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ClassList.Count-1 do begin
    if (ClassList[i].treenode = nil) then begin
      log('Orphan detected: '+ClassList[i].package.name+'.'+ClassList[i].name);
    end;
  end;
end;

procedure Tfrm_UnCodeX.ac_AnalyseAllExecute(Sender: TObject);
begin
  if (ThreadCreate) then begin
    lb_Log.Items.Clear;
    runningthread := TClassAnalyser.Create(ClassList, statusReport);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.ac_CreateHTMLfilesExecute(Sender: TObject);
var
  htmlconfig: THTMLOutConfig;
begin
  if (ThreadCreate) then begin
    lb_Log.Items.Clear;
    htmlconfig.PackageList := PackageList;
    htmlconfig.ClassList := ClassList;
    htmlconfig.ClassTree := tv_Classes;
    htmlconfig.outputdir := HTMLOutputDir;
    htmlconfig.TemplateDir := TemplateDir;
    runningthread := THTMLoutput.Create(htmlconfig, StatusReport);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.ac_SettingsExecute(Sender: TObject);
var
  ini: TMemIniFile;
  data: TStringList;
  i: integer;
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
    { Search settings }
    cb_FTSRegExp.Checked := FTSRegexp;
    { Layout settings }
    lb_LogLayout.Color := lb_Log.Color;
    lb_LogLayout.Font := lb_Log.Font;
    tv_TreeLayout.Color := tv_Classes.Color;
    tv_TreeLayout.Font := tv_Classes.Font;
    cb_ExpandObject.Checked := ExpandObject;
    { Program options }
    ed_StateFilename.Text := ExtractFilename(StateFile);
    cb_MinimzeOnClose.Checked := MinimizeOnClose;
    cb_ModifiedOnStartup.Checked := AnalyseModified;
    ud_DefInheritDepth.Position := DefaultInheritanceDepth;
    cb_LoadCustomModules.Checked := LoadCustomOutputModules;
    if (ShowModal = mrOk) then begin
      { HTML output }
      HTMLOutputDir := ed_HTMLOutputDir.Text;
      TemplateDir := ed_TemplateDir.Text;
      { HTML Help }
      HHCPath := ed_WorkshopPath.Text;
      HTMLHelpFile := ed_HTMLHelpOutput.Text;
      HHTitle := ed_HHTitle.Text;
      { Run server }
      ServerCmd := ed_ServerCommandline.Text;
      ServerPrio := cb_ServerPriority.ItemIndex;
      ClientCmd := ed_ClientCommandline.Text;
      { Commandlines }
      CompilerCmd := ed_CompilerCommandline.Text;
      OpenResultCmd := ed_OpenResultCmd.Text;
      { Search settings }
      FTSRegexp := cb_FTSRegExp.Checked;
      { Program options }
      StateFile := ed_StateFilename.Text;
      AnalyseModified := cb_ModifiedOnStartup.Checked;
      if (ExtractFilePath(StateFile) = '') then StateFile := ExtractFilePath(ConfigFile)+StateFile;
      ExpandObject := cb_ExpandObject.Checked;
      MinimizeOnClose := cb_MinimzeOnClose.Checked;
      DefaultInheritanceDepth := ud_DefInheritDepth.Position;
      LoadCustomOutputModules := cb_LoadCustomModules.Checked;
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

      ini := TMemIniFile.Create(ConfigFile);
      data := TStringList.Create;
      try
        data.Add('[Config]');
        data.Add('HTMLOutputDir='+HTMLOutputDir);
        data.Add('TemplateDir='+TemplateDir);
        data.Add('HHCPath='+HHCPath);
        data.Add('HTMLHelpFile='+HTMLHelpFile);
        data.Add('HHTitle='+HHTitle);
        data.Add('ServerCmd='+ServerCmd);
        data.Add('ServerPrio='+IntToStr(ServerPrio));
        data.Add('ClientCmd='+ClientCmd);
        data.Add('CompilerCmd='+CompilerCmd);
        data.Add('OpenResultCmd='+OpenResultCmd);
        data.Add('FullTextSearchRegExp='+IntToStr(Ord(FTSRegexp)));
        data.Add('StateFile='+ed_StateFilename.Text);
        data.Add('AnalyseModified='+IntToStr(Ord(AnalyseModified)));
        data.Add('DefaultInheritanceDepth='+IntToStr(DefaultInheritanceDepth));
        data.Add('LoadOutputModules='+IntToStr(Ord(LoadCustomOutputModules)));

        data.Add('[Layout]');
        data.Add('Log.Font.Name='+lb_Log.Font.Name);
        data.Add('Log.Font.Color='+IntToStr(lb_Log.Font.Color));
        data.Add('Log.Font.Size='+IntToStr(lb_Log.Font.Size));
        data.Add('Log.Color='+IntToStr(lb_Log.Color));
        data.Add('Tree.Font.Name='+tv_Classes.Font.Name);
        data.Add('Tree.Font.Color='+IntToStr(tv_Classes.Font.Color));
        data.Add('Tree.Font.Size='+IntToStr(tv_Classes.Font.Size));
        data.Add('Tree.Color='+IntToStr(tv_Classes.Color));
        Data.Add('ExpandObject='+IntToStr(Ord(ExpandObject)));
        data.Add('MinimizeOnClose='+BoolToStr(MinimizeOnClose));

        data.Add('[HotKeys]');
        for i := 0 to lv_HotKeys.Items.Count-1 do begin
          data.Add(lv_HotKeys.Items[i].Caption+'='+lv_HotKeys.Items[i].SubItems[0]);
          TAction(lv_HotKeys.Items[i].Data).ShortCut := TextToShortCut(lv_HotKeys.Items[i].SubItems[0]);
        end;

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
  end;
end;

procedure Tfrm_UnCodeX.ac_FindClassExecute(Sender: TObject);
begin
  if (ActiveControl.ClassType <> TTreeView) then begin
    ActiveControl := tv_Classes;
  end;
  CSprops[1] := FTSRegexp;
  if (SearchQuery('Find a class', 'Enter the name of the class you want to find', searchclass, CSprops, CSHistory, ['&Search class body', '&Regular expression (only with body search)', '&Compare strict (not with body search)'])) then begin
    (ActiveControl as TTreeView).Selected := nil;
    ac_FindNext.Execute;
  end;
end;

procedure Tfrm_UnCodeX.FormDestroy(Sender: TObject);
begin
  hh_Help.Free;
  HHCloseAll;
  UnregisterAppBar;
  PackagePriority.Free;
  PackageList.Free;
  ClassList.Free;
  SourcePaths.Free;
  IgnorePackages.Free;
  FTSHistory.Free;
  CSHistory.Free;
  OutputModules.Free;
end;

procedure Tfrm_UnCodeX.ac_OpenClassExecute(Sender: TObject);
var
  filename: string;
  i: integer;
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    with (ActiveControl as TTreeView) do begin
      if (Selected <> nil) then begin
        if (TObject(Selected.Data).ClassType <> TUClass) then exit;
        for i := 0 to lb_Log.Items.Count-1 do begin
          if (lb_Log.Items.Objects[i] <> nil) then begin
            if (TObject(lb_Log.Items.Objects[i]) = TObject(Selected.Data)) then begin
              lb_Log.ItemIndex := i;
              lb_Log.OnDblClick(Sender);
              exit;
            end;
          end;
        end;
        filename := TUClass(Selected.Data).package.path+PATHDELIM+CLASSDIR+PATHDELIM+TUClass(Selected.Data).filename;
        ExecuteProgram(filename);
      end;
    end;
  end;
end;

procedure Tfrm_UnCodeX.ac_OpenOutputExecute(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(HTMLOutputDir+PATHDELIM+'index.html'), nil, nil, 0);
end;

procedure Tfrm_UnCodeX.ac_SaveStateExecute(Sender: TObject);
begin
  SaveState;
end;

procedure Tfrm_UnCodeX.ac_LoadStateExecute(Sender: TObject);
begin
  LoadState;
end;

procedure Tfrm_UnCodeX.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ini: TMemIniFile;
  i: integer;
begin
  if (MinimizeOnClose) then begin
    Action := caMinimize;
  end
  else begin
    if (TreeUpdated) then SaveState;
    ini := TMemIniFile.Create(ConfigFile);
    try
      ini.WriteBool('Layout', 'MenuBar', mi_MenuBar.Checked);
      ini.WriteBool('Layout', 'Toolbar', mi_Toolbar.Checked);
      ini.WriteBool('Layout', 'PackageTree', mi_PackageTree.Checked);
      ini.WriteInteger('Layout', 'PackageTreeWidth', tv_Packages.Width);
      //ini.WriteBool('Layout', 'ClassTree', mi_ClassTree.Checked);
      ini.WriteBool('Layout', 'Log', mi_Log.Checked);
      ini.WriteInteger('Layout', 'LogHeight', lb_Log.Height);
      ini.WriteBool('Layout', 'StayOnTop', mi_StayOnTop.Checked);
      ini.WriteBool('Layout', 'SavePosition', mi_Saveposition.Checked);
      ini.WriteBool('Layout', 'SaveSize', mi_Savesize.Checked);
      if (mi_Saveposition.Checked) then begin
        if (IsAppBar) then begin
          ini.WriteInteger('Layout', 'Top', OldSize.Top);
          ini.WriteInteger('Layout', 'Left', OldSize.Left);
        end
        else begin
          ini.WriteInteger('Layout', 'Top', Top);
          ini.WriteInteger('Layout', 'Left', Left);
        end;
      end;
      if (mi_Savesize.Checked) then begin
        if (IsAppBar) then begin
          ini.WriteInteger('Layout', 'Width', OldSize.Right);
          ini.WriteInteger('Layout', 'Height', OldSize.Bottom);
        end
        else begin
          ini.WriteInteger('Layout', 'Width', Width);
          ini.WriteInteger('Layout', 'Height', Height);
        end;
      end;
      ini.WriteInteger('Layout', 'ABWidth', ABWidth);
      ini.WriteBool('Layout', 'AutoHide', mi_AutoHide.Checked);
      ini.WriteBool('Layout', 'ABRight', mi_Right.Checked);
      ini.WriteBool('Layout', 'ABLeft', mi_Left.Checked);
      for i := 0 to FTSHistory.Count-1 do begin
        ini.WriteString('FullTextSearch', IntToStr(i), FTSHistory[i]);
      end;
      for i := 0 to CSHistory.Count-1 do begin
        ini.WriteString('ClassSearch', IntToStr(i), CSHistory[i]);
      end;
      ini.UpdateFile;
    finally
      ini.Free;
    end;
  end;
end;

procedure Tfrm_UnCodeX.ac_AboutExecute(Sender: TObject);
begin
  frm_About.ShowModal;
end;

procedure Tfrm_UnCodeX.ac_HTMLHelpExecute(Sender: TObject);
begin
  if (not FileExists(HHCPath+PATHDELIM+COMPILER)) then begin
    MessageDlg('You first have to define the path to the HTML Help Workshop in '+#13+#10+'the program settings.', mtError, [mbOK], 0);
    exit;
  end;
  if (ThreadCreate) then begin
    lb_Log.Items.Clear;
    runningthread := TMSHTMLHelp.Create(HHCPath, HTMLOutputDir, HTMLHelpFile, HHTitle, PackageList, tv_Classes, StatusReport);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.mi_ExpandallClick(Sender: TObject);
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    Tag := TV_ALWAYSEXPAND;
    (ActiveControl as TTreeView).FullExpand;
  end;
end;

procedure Tfrm_UnCodeX.mi_CollapseallClick(Sender: TObject);
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    Tag := TV_ALWAYSEXPAND;
    (ActiveControl as TTreeView).FullCollapse;
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
              lst[i] := TUClass(Selected.Data).package.path+PATHDELIM+CLASSDIR+PATHDELIM+TUClass(Selected.Data).filename
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
  if (searchclass = '') then begin
    ac_FindClass.Execute;
    exit;
  end;
  if (ActiveControl.ClassType <> TTreeView) then begin
    ActiveControl := tv_Classes;
  end;
  with (ActiveControl as TTreeView) do begin
    if (CSprops[0]) then begin
      if (ThreadCreate) then begin
        lb_Log.Items.Clear;
        runningthread := TSearchThread.Create((ActiveControl as TTreeView), StatusReport, searchclass, CSprops[1]);
        runningthread.OnTerminate := ThreadTerminate;
        runningthread.Resume;
        exit;
      end;
    end
    else begin
      if (Selected <> nil) then j := Selected.AbsoluteIndex+1
        else j := 0;
      for i := j to Items.Count-1 do begin
        if (CSprops[2]) then res := AnsiCompareText(items[i].Text, searchclass) = 0
          else res := AnsiContainsText(items[i].Text, searchclass);
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
  statustext := 'No more classes matching '''+searchclass+''' found';
  searchclass := '';
end;

procedure Tfrm_UnCodeX.ac_FullTextSearchExecute(Sender: TObject);
var
  query: string;
  isregex: array[0..0] of boolean;
begin
  if (ThreadCreate) then begin
    isregex[0] := FTSRegexp;
    if (SearchQuery('Full text search', 'Enter your search query', query, isregex, FTSHistory, ['&Regular expression'])) then begin
      mi_Log.Checked := true;
      mi_Log.OnClick(Sender);
      lb_Log.Items.Clear;
      runningthread := TSearchThread.Create(PackageList, StatusReport, query, isregex[0], ClassList.Count);
      runningthread.OnTerminate := ThreadTerminate;
      runningthread.Resume;
    end
    else ac_Abort.Enabled := false;
  end;
end;

procedure Tfrm_UnCodeX.lb_LogDblClick(Sender: TObject);
var
  i, j: integer;
  linenr, curpos: string;
begin
  if (lb_Log.ItemIndex = -1) then exit;
  if (lb_Log.Items.Objects[lb_Log.ItemIndex] = nil) then exit;
  if (TObject(lb_Log.Items.Objects[lb_Log.ItemIndex]).ClassType <> TUClass) then exit;

  linenr := lb_Log.Items[lb_Log.ItemIndex];
  i := Pos(FTS_LN_BEGIN, linenr);
  j := Pos(FTS_LN_END, linenr);
  linenr := Copy(linenr, i+Length(FTS_LN_BEGIN), j-i-Length(FTS_LN_BEGIN));
  i := Pos(FTS_LN_SEP, linenr);
  curpos := Copy(linenr, i+Length(FTS_LN_SEP), MaxInt);
  Delete(linenr, i, MaxInt);

  OpenSourceLine(TUClass(lb_Log.Items.Objects[lb_Log.ItemIndex]), StrToIntDef(linenr, 0), StrToIntDef(curpos, 0));
end;

procedure Tfrm_UnCodeX.lb_LogClick(Sender: TObject);
var
  i: integer;
begin
  if (lb_Log.ItemIndex = -1) then exit;
  if (lb_Log.Items.Objects[lb_Log.ItemIndex] = nil) then exit;
  if (TObject(lb_Log.Items.Objects[lb_Log.ItemIndex]).ClassType <> TUClass) then exit;
  for i := 0 to tv_Classes.Items.Count-1 do begin
    if (tv_Classes.Items[i].Data = lb_Log.Items.Objects[lb_Log.ItemIndex]) then begin
      tv_Classes.Select(tv_Classes.Items[i]);
      exit;
    end;
  end;
end;

procedure Tfrm_UnCodeX.FormShow(Sender: TObject);
begin
  if (DoInit) then begin
    DoInit := false;
    LoadState;
    if (searchclass <> '') then begin
      CSprops[0] := false;
      ActiveControl := tv_Classes;
      ac_FindNext.Execute;
    end
    else if (IsBatching) then NextBatchCommand
    else if (AnalyseModified) then ac_AnalyseModified.Execute;
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
        with Tfrm_Tags.Create(nil) do begin
          RestoreHandle := Handle;
          uclass := selclass;
          ud_InheritanceLevel.Position := DefaultInheritanceDepth;
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
    InitActivateFix := false;
  end;
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
  spl_Main1.Visible := mi_PackageTree.Checked;
  tv_Packages.Visible := mi_PackageTree.Checked;
end;

procedure Tfrm_UnCodeX.ac_VLogExecute(Sender: TObject);
begin
  lb_Log.Top := 0;
  spl_Main2.Top := 1;
  lb_Log.Visible := mi_Log.Checked;
  spl_Main2.Visible := mi_Log.Checked;
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
  if (mi_Right.Checked) then begin
    mi_Left.Checked := false;
    mi_Left.OnClick(Sender);
    abd.uEdge := ABE_RIGHT;
    RegisterAppBar
  end
  else UnregisterAppBar;
end;

procedure Tfrm_UnCodeX.ac_VTLeftExecute(Sender: TObject);
begin
  if (mi_Left.Checked) then begin
    mi_Right.Checked := false;
    mi_Right.OnClick(Sender);
    abd.uEdge := ABE_LEFT;
    RegisterAppBar
  end
  else UnregisterAppBar;
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
  if (ActiveControl <> nil) then hh_Help.HelpTopic('window_main.html#'+ActiveControl.HelpKeyword)
  else hh_Help.HelpTopic('');
end;

procedure Tfrm_UnCodeX.ac_AnalyseModifiedExecute(Sender: TObject);
begin
  if (ThreadCreate) then begin
    lb_Log.Items.Clear;
    runningthread := TClassAnalyser.Create(ClassList, statusReport, true);
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
  (Sender as TComponent).Tag := TV_ALWAYSEXPAND;
end;

procedure Tfrm_UnCodeX.tv_ClassesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TComponent).Tag := TV_NOEXPAND;
end;

end.
