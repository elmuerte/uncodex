unit unit_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, unit_packages, ExtCtrls, unit_uclasses,
  IniFiles, ShellApi, AppEvnts, ImgList, ActnList, ToolWin, StrUtils;

const
  WM_APPBAR = WM_USER+$100;

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
    ToolButton2: TToolButton;
    tb_RunServer: TToolButton;
    tb_JoinServer: TToolButton;
    ToolButton4: TToolButton;
    procedure tmr_StatusTextTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mi_OpenClassClick(Sender: TObject);
    procedure mi_AnalyseclassClick(Sender: TObject);
    procedure ae_AppEventHint(Sender: TObject);
    procedure ac_RecreateTreeExecute(Sender: TObject);
    procedure ac_FindOrphansExecute(Sender: TObject);
    procedure ac_AnalyseAllExecute(Sender: TObject);
    procedure ac_CreateHTMLfilesExecute(Sender: TObject);
    procedure ac_SettingsExecute(Sender: TObject);
    procedure mi_QuitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ac_AbortExecute(Sender: TObject);
    procedure ac_FindClassExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ac_OpenClassExecute(Sender: TObject);
    procedure ac_OpenOutputExecute(Sender: TObject);
    procedure ac_SaveStateExecute(Sender: TObject);
    procedure ac_LoadStateExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure ac_AboutExecute(Sender: TObject);
    procedure ac_HTMLHelpExecute(Sender: TObject);
    procedure mi_ExpandallClick(Sender: TObject);
    procedure mi_CollapseallClick(Sender: TObject);
    procedure mi_ToolbarClick(Sender: TObject);
    procedure mi_PackageTreeClick(Sender: TObject);
    procedure mi_LogClick(Sender: TObject);
    procedure mi_StayontopClick(Sender: TObject);
    procedure spl_Main2CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure FormResize(Sender: TObject);
    procedure mi_RightClick(Sender: TObject);
    procedure ac_RunServerExecute(Sender: TObject);
    procedure ac_JoinServerExecute(Sender: TObject);
    procedure ac_CompileClassExecute(Sender: TObject);
    procedure mi_AutohideClick(Sender: TObject);
    procedure mi_MenubarClick(Sender: TObject);
    procedure mi_LeftClick(Sender: TObject);
    procedure ac_FindNextExecute(Sender: TObject);
    procedure ac_FullTextSearchExecute(Sender: TObject);
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
    procedure WMAppBar(var Msg : TMessage); message WM_AppBar;
    procedure WMNCLBUTTONDOWN(var Msg: TWMNCLBUTTONDOWN); message WM_NCLBUTTONDOWN;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure RegisterAppBar;
    procedure UnregisterAppBar;
    procedure RegisterABAutoHide;
    procedure UnregisterABAutoHide;
    procedure ABResize;
  public
    statustext : string;
    procedure StatusReport(msg: string; progress: byte = 255);
    procedure ExecuteProgram(exe: string; params: TStringList = nil; prio: integer = -1; show: integer = SW_SHOW);
  end;

  procedure Log(msg: string);

var
  frm_UnCodeX: Tfrm_UnCodeX;
  runningthread: TThread = nil;
  DoInit: boolean = true;
  PackageList: TUPackageList;
  ClassList: TUClassList;
  searchclass: string;

// config vars
var
  HTMLOutputDir, TemplateDir, HHCPath, HTMLHelpFile, ServerCmd, CompilerCmd,
    ClientCmd: string;
  ServerPrio: integer;
  SourcePaths: TStringList;
  PackagePriority: TStringList;
  IgnorePackages: TStringList;

implementation

uses unit_settings, unit_analyse, unit_htmlout, unit_definitions,
  unit_treestate, unit_about, unit_mshtmlhelp, unit_fulltextsearch;

const
  PROCPRIO: array[0..3] of Cardinal = (IDLE_PRIORITY_CLASS, NORMAL_PRIORITY_CLASS,
                                       HIGH_PRIORITY_CLASS, REALTIME_PRIORITY_CLASS);
  AUTOHIDEEXPOSURE = 4; // number of pixel to show of the app bar

{$R *.dfm}

procedure Log(msg: string);
begin
  if (msg='') then exit;
  frm_UnCodeX.lb_Log.Items.Add(msg);
  frm_UnCodeX.lb_Log.ItemIndex := frm_UnCodeX.lb_Log.Items.Count-1;
end;

////////////////////////////////////////////////////////////////////////////////
// Custom methods

procedure Tfrm_UnCodeX.StatusReport(msg: string; progress: byte = 255);
begin
  statustext := msg;
  if (progress <> 255) then pb_Scan.Position := progress;
end;

function Tfrm_UnCodeX.ThreadCreate: boolean;
begin
  if (runningthread <> nil) then Result := false
  else begin
    ac_Abort.Enabled := true;
    Result := True;
  end;
end;

procedure Tfrm_UnCodeX.ThreadTerminate(Sender: TObject);
begin
  runningthread := nil;
  ac_Abort.Enabled := false;
end;

procedure Tfrm_UnCodeX.SaveState;
var
  fs: TFileStream;
begin
  StatusReport('Saving state to classes.state');
  fs := TFileStream.Create(ExtractFilePath(ParamStr(0))+'classes.state', fmCreate or fmShareExclusive);
  try
    with TPackageState.Create(PackageList) do begin
      SaveStateToStream(fs);
    end;
    with TClassTreeState.Create(tv_Classes) do begin
      SaveTreeToStream(fs);
    end;
  finally
    fs.Free;
  end;
  StatusReport('State saved');
end;

procedure Tfrm_UnCodeX.LoadState;
var
  fs: TFileStream;
begin
  if (not FileExists(ExtractFilePath(ParamStr(0))+'classes.state')) then exit;
  StatusReport('Loading state from classes.state');
  fs := TFileStream.Create(ExtractFilePath(ParamStr(0))+'classes.state', fmOpenRead or fmShareExclusive);
  try
    with TPackageState.Create(PackageList, tv_Packages) do begin
      LoadStateFromStream(fs);
    end;
    fs.Position := 0;
    with TClassTreeState.Create(ClassList, tv_Classes, PackageList, tv_Packages) do begin
      LoadTreeFromStream(fs);
    end;
    PackageList.Sort;
    tv_Packages.Items.AlphaSort(true);
    ClassList.Sort;
    tv_Classes.Items.AlphaSort(true);
  finally
    fs.Free;
  end;
  StatusReport('State loaded');
end;

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

procedure Tfrm_UnCodeX.WMSysCommand (var Msg : TMessage);
begin
  if mm_Main.DispatchCommand(Msg.WParam) then Exit;
  Inherited;
end;

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

procedure Tfrm_UnCodeX.RegisterAppBar;
begin
  if (IsAppBar) then exit;
  OldStyleEx := GetWindowLong(Handle, GWL_EXSTYLE);
  OldStyle := GetWindowLong(Handle, GWL_STYLE);
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  SetWindowLong(Handle, GWL_STYLE, OldStyle);
  OldSize.Left := Left;
  OldSize.Top := Top;
  OldSize.Right := Width;
  OldSize.Bottom := Height;
  SystemParametersInfo(SPI_GETWORKAREA, 0, @WorkArea, 0);

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

////////////////////////////////////////////////////////////////////////////////
// Auto generated methods

procedure Tfrm_UnCodeX.tmr_StatusTextTimer(Sender: TObject);
begin
  sb_Status.Panels[0].Text := statustext;
end;

procedure Tfrm_UnCodeX.FormCreate(Sender: TObject);
var
  ini: TMemIniFile;
  tmp: string;
  sl: TStringList;
  i: integer;
begin
  Caption := APPTITLE+' - '+APPVERSION;
  Application.Title := Caption;
  ini := TMemIniFile.Create(ExtractFilePath(ParamStr(0))+'\UnCodeX.ini');
  sl := TStringList.Create;
  PackagePriority := TStringList.Create;
  SourcePaths := TStringList.Create;
  IgnorePackages := TStringList.Create;
  try
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

    HTMLOutputDir := ini.ReadString('Config', 'HTMLOutputDir', ExtractFilePath(ParamStr(0))+'Output');
    TemplateDir := ini.ReadString('Config', 'TemplateDir', ExtractFilePath(ParamStr(0))+'Templates\UnrealWiki');
    HHCPath := ini.ReadString('Config', 'HHCPath', '');
    HTMLHelpFile := ini.ReadString('Config', 'HTMLHelpFile', ExtractFilePath(ParamStr(0))+'UnCodeX.chm');
    ServerCmd := ini.ReadString('Config', 'ServerCmd', '');
    ServerPrio := ini.ReadInteger('Config', 'ServerPrio', 1);
    ClientCmd := ini.ReadString('Config', 'ClientCmd', '');
    CompilerCmd := ini.ReadString('Config', 'CompilerCmd', '');

    ini.ReadSectionValues('PackagePriority', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Config: Package = '+tmp);
      PackagePriority.Add(LowerCase(tmp));
    end;
    ini.ReadSectionValues('SourcePaths', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Config: Path = '+tmp);
      SourcePaths.Add(LowerCase(tmp));
    end;
    ini.ReadSectionValues('IgnorePackages', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Config: Ignore = '+tmp);
      IgnorePackages.Add(LowerCase(tmp));
    end;
  finally
    ini.Free;
    sl.Free;
  end;
  PackageList := TUPackageList.Create(true);
  ClassList := TUClassList.Create(false);
  UpdateSystemMenu;
  mi_MenuBar.OnClick(Sender); // has to be here or else it won't work
end;

procedure Tfrm_UnCodeX.mi_OpenClassClick(Sender: TObject);
var
  filename: string;
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    with (ActiveControl as TTreeView) do begin
      if (Selected <> nil) then begin
        filename := TUClass(Selected.Data).package.path+PATHDELIM+CLASSDIR+PATHDELIM+TUClass(Selected.Data).filename;
        case (ShellExecute(0, nil, PChar(filename), nil, nil, 0)) of
          ERROR_FILE_NOT_FOUND: statustext := 'File not found: '+filename;
          ERROR_PATH_NOT_FOUND: statustext := 'Path not found: '+filename;
          SE_ERR_ACCESSDENIED : statustext := 'Access denied: '+filename;
        end;
      end;
    end;
  end;
end;

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

procedure Tfrm_UnCodeX.ae_AppEventHint(Sender: TObject);
begin
  sb_Status.SimpleText := GetLongHint(Application.Hint);
  sb_Status.SimplePanel := (sb_Status.SimpleText <> '');
end;

procedure Tfrm_UnCodeX.ac_RecreateTreeExecute(Sender: TObject);
begin
  if (ThreadCreate) then begin
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
    lb_PackagePriority.Items := PackagePriority;
    ed_HTMLOutputDir.Text := HTMLOutputDir;
    ed_TemplateDir.Text := TemplateDir;
    ed_WorkshopPath.Text := HHCPath;
    ed_HTMLHelpOutput.Text := HTMLHelpFile;
    ed_ServerCommandline.Text := ServerCmd;
    cb_ServerPriority.ItemIndex := ServerPrio;
    ed_ClientCommandline.Text := ClientCmd;
    ed_CompilerCommandline.Text := CompilerCmd;
    lb_IgnorePackages.Items := IgnorePackages;
    if (ShowModal = mrOk) then begin
      HTMLOutputDir := ed_HTMLOutputDir.Text;
      TemplateDir := ed_TemplateDir.Text;
      HHCPath := ed_WorkshopPath.Text;
      HTMLHelpFile := ed_HTMLHelpOutput.Text;
      ServerCmd := ed_ServerCommandline.Text;
      ServerPrio := cb_ServerPriority.ItemIndex;
      ClientCmd := ed_ClientCommandline.Text;
      CompilerCmd := ed_CompilerCommandline.Text;
      SourcePaths.Clear;
      SourcePaths.AddStrings(lb_Paths.Items);
      PackagePriority.Clear;
      PackagePriority.AddStrings(lb_PackagePriority.Items);
      IgnorePackages.Clear;
      IgnorePackages.AddStrings(lb_IgnorePackages.Items);
      ini := TMemIniFile.Create(ExtractFilePath(ParamStr(0))+'\UnCodeX.ini');
      data := TStringList.Create;
      try
        data.Add('[Config]');
        data.Add('HTMLOutputDir='+HTMLOutputDir);
        data.Add('TemplateDir='+TemplateDir);
        data.Add('HHCPath='+HHCPath);
        data.Add('HTMLHelpFile='+HTMLHelpFile);
        data.Add('ServerCmd='+ServerCmd);
        data.Add('ServerPrio='+IntToStr(ServerPrio));
        data.Add('ClientCmd='+ClientCmd);
        data.Add('CompilerCmd='+CompilerCmd);
        data.Add('[SourcePaths]');
        for i := 0 to SourcePaths.Count-1 do data.Add('Path='+SourcePaths[i]);
        data.Add('[PackagePriority]');
        for i := 0 to PackagePriority.Count-1 do data.Add('Packages='+PackagePriority[i]);
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

procedure Tfrm_UnCodeX.mi_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_UnCodeX.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (runningthread = nil);
end;

procedure Tfrm_UnCodeX.ac_AbortExecute(Sender: TObject);
begin
  if (runningthread <> nil) then begin
    ac_Abort.Enabled := false;
    runningthread.Terminate;
  end;
end;

procedure Tfrm_UnCodeX.ac_FindClassExecute(Sender: TObject);
var
  i: integer;
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    if (InputQuery('Find a class', 'Enter the name of the class you want to find', searchclass)) then begin
      with (ActiveControl as TTreeView) do begin
        for i := 0 to Items.Count-1 do begin
          if (AnsiContainsText(items[i].Text, searchclass)) then begin
            Select(items[i]);
            exit;
          end;
        end;
      end;
    end;
  end;
  statustext := 'No class with name '''+searchclass+''' found';
end;

procedure Tfrm_UnCodeX.FormDestroy(Sender: TObject);
begin
  UnregisterAppBar;
  PackagePriority.Free;
  PackageList.Free;
  ClassList.Free;
  SourcePaths.Free;
  IgnorePackages.Free;
end;

procedure Tfrm_UnCodeX.ac_OpenClassExecute(Sender: TObject);
var
  filename: string;
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    with (ActiveControl as TTreeView) do begin
      if (Selected <> nil) then begin
        if (TObject(Selected.Data).ClassType <> TUClass) then exit;
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
begin
  SaveState;
  ini := TMemIniFile.Create(ExtractFilePath(ParamStr(0))+'\UnCodeX.ini');
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
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

procedure Tfrm_UnCodeX.FormActivate(Sender: TObject);
begin
  if (DoInit) then begin
    DoInit := false;
    LoadState;
  end;
end;

procedure Tfrm_UnCodeX.ac_AboutExecute(Sender: TObject);
begin
  frm_About.ShowModal;
end;

procedure Tfrm_UnCodeX.ac_HTMLHelpExecute(Sender: TObject);
begin
  if (not FileExists(HHCPath+PATHDELIM+COMPILER)) then begin
    MessageDlg('Yu first have to define the path to the HTML Help Workshop in '+#13+#10+'the program settings.', mtError, [mbOK], 0);
    exit;
  end;
  if (ThreadCreate) then begin
    lb_Log.Items.Clear;
    runningthread := TMSHTMLHelp.Create(HHCPath, HTMLOutputDir, HTMLHelpFile, PackageList, tv_Classes, StatusReport);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

procedure Tfrm_UnCodeX.mi_ExpandallClick(Sender: TObject);
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    (ActiveControl as TTreeView).FullExpand;
  end;
end;

procedure Tfrm_UnCodeX.mi_CollapseallClick(Sender: TObject);
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    (ActiveControl as TTreeView).FullCollapse;
  end;
end;

procedure Tfrm_UnCodeX.mi_ToolbarClick(Sender: TObject);
begin
  tb_Tools.Visible := mi_Toolbar.Checked;
end;

procedure Tfrm_UnCodeX.mi_PackageTreeClick(Sender: TObject);
begin
  spl_Main1.Visible := mi_PackageTree.Checked;
  tv_Packages.Visible := mi_PackageTree.Checked;
end;

procedure Tfrm_UnCodeX.mi_LogClick(Sender: TObject);
begin
  lb_Log.Top := 0;
  spl_Main2.Top := 1;
  lb_Log.Visible := mi_Log.Checked;
  spl_Main2.Visible := mi_Log.Checked;
end;

procedure Tfrm_UnCodeX.mi_StayontopClick(Sender: TObject);
begin
  // This prevents window recreation
  if (mi_Stayontop.Checked) then
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE)
    else SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
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

procedure Tfrm_UnCodeX.mi_RightClick(Sender: TObject);
begin
  if (mi_Right.Checked) then begin
    mi_Left.Checked := false;
    mi_Left.OnClick(Sender);
    abd.uEdge := ABE_RIGHT;
    RegisterAppBar
  end
  else UnregisterAppBar;
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
    ExecuteProgram(exe, lst, ServerPrio);
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

procedure Tfrm_UnCodeX.mi_AutohideClick(Sender: TObject);
begin
  ABAutoHide := mi_AutoHide.Checked;
  if (IsAppBar) then begin
    if (ABAutoHide) then RegisterABAutoHide
      else UnregisterABAutoHide;
  end;
end;

procedure Tfrm_UnCodeX.mi_MenubarClick(Sender: TObject);
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

procedure Tfrm_UnCodeX.mi_LeftClick(Sender: TObject);
begin
  if (mi_Left.Checked) then begin
    mi_Right.Checked := false;
    mi_Right.OnClick(Sender);
    abd.uEdge := ABE_LEFT;
    RegisterAppBar
  end
  else UnregisterAppBar;
end;

procedure Tfrm_UnCodeX.ac_FindNextExecute(Sender: TObject);
var
  i: integer;
begin
  if (searchclass = '') then exit;
  if (ActiveControl.ClassType = TTreeView) then begin
    with (ActiveControl as TTreeView) do begin
      if (Selected = nil) then exit;
      for i := Selected.AbsoluteIndex+1 to Items.Count-1 do begin
        if (AnsiContainsText(items[i].Text, searchclass)) then begin
          Select(items[i]);
          exit;
        end;
      end;
    end;
  end;
  statustext := 'No more classes containing '''+searchclass+''' found';
end;

procedure Tfrm_UnCodeX.ac_FullTextSearchExecute(Sender: TObject);
begin
  if (ThreadCreate) then begin
    lb_Log.Items.Clear;
    runningthread := TSearchThread.Create(PackageList, StatusReport);
    runningthread.OnTerminate := ThreadTerminate;
    runningthread.Resume;
  end;
end;

end.
