unit unit_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, unit_packages, ExtCtrls, unit_uclasses,
  IniFiles, ShellApi, AppEvnts, ImgList, ActnList, ToolWin;

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
    il_Large: TImageList;
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
    il_LargeDisabled: TImageList;
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
    mi_Find: TMenuItem;
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
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure mi_RightClick(Sender: TObject);
    procedure ac_RunServerExecute(Sender: TObject);
    procedure ac_JoinServerExecute(Sender: TObject);
    procedure ac_CompileClassExecute(Sender: TObject);
  private
    OldStyleEx: Cardinal;
    OldStyle: Cardinal;
    IsAppBar: boolean;
    abd: APPBARDATA;
    function ThreadCreate: boolean;
    procedure ThreadTerminate(Sender: TObject);
    procedure SaveState;
    procedure LoadState;
    procedure UpdateSystemMenu;
    procedure WMSysCommand (var Msg : TMessage); message WM_SysCommand;
    procedure WMAppBar(var Msg : TMessage); message WM_AppBar;
    procedure RegisterAppBar;
    procedure UnregisterAppBar;
    procedure ABResize;
  public
    statustext : string;
    procedure StatusReport(msg: string; progress: byte = 255);
  end;

  procedure Log(msg: string);

var
  frm_UnCodeX: Tfrm_UnCodeX;
  runningthread: TThread;
  DoInit: boolean = true;
  PackageList: TUPackageList;
  ClassList: TUClassList;

// config vars
var
  HTMLOutputDir, TemplateDir, HHCPath, HTMLHelpFile, ServerCmd, CompilerCmd,
    ClientCmd: string;
  ServerPrio: integer;
  SourcePaths: TStringList;
  PackagePriority: TStringList;

implementation

uses unit_settings, unit_definitions, unit_analyse, unit_htmlout,
  unit_treestate, unit_about, unit_mshtmlhelp;

const
  PROCPRIO: array[0..3] of Cardinal = (IDLE_PRIORITY_CLASS, NORMAL_PRIORITY_CLASS,
                                       HIGH_PRIORITY_CLASS, REALTIME_PRIORITY_CLASS);

{$R *.dfm}

procedure Log(msg: string);
begin
  if (msg='') then exit;
  frm_UnCodeX.lb_Log.Items.Add(msg);
  frm_UnCodeX.lb_Log.ItemIndex := frm_UnCodeX.lb_Log.Items.Count-1;
end;

//

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

procedure Tfrm_UnCodeX.RegisterAppBar;
begin
  if (IsAppBar) then exit;
  OldStyleEx := GetWindowLong(Handle, GWL_EXSTYLE);
  OldStyle := GetWindowLong(Handle, GWL_STYLE);
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  //SetWindowLong(Handle, GWL_Style, WS_VISIBLE or WS_DLGFRAME or ws_thickframe);

  abd.cbSize := SizeOf(APPBARDATA);
  abd.hWnd := Handle;
  abd.uCallbackMessage := WM_APPBAR;
  SHAppBarMessage(ABM_NEW, abd);
  
  abd.uEdge := ABE_RIGHT;
  abd.rc := Rect(GetSystemMetrics(SM_CXSCREEN)-150, 0, GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));
  Left := abd.rc.Left;
  Top := abd.rc.Top;
  Width := abd.rc.Right-abd.rc.Left;
  Height := abd.rc.Bottom-abd.rc.Top;
  shAppBarMessage(ABM_setPos, abd);
  shAppBarMessage(ABM_ACTIVATE, abd);
  IsAppBar := true;
end;

procedure Tfrm_UnCodeX.UnregisterAppBar;
begin
  if (IsAppBar) then begin
    SHAppBarMessage(ABM_REMOVE, abd);
    IsAppBar := false;
    SetWindowLong(Handle, GWL_EXSTYLE, OldStyleEx);
    SetWindowLong(Handle, GWL_Style, OldStyle);
  end;
end;

procedure Tfrm_UnCodeX.ABResize;
begin
  if (IsAppBar) then begin
    abd.rc.Left := GetSystemMetrics(SM_CXSCREEN)-Width;
    SHAppBarMessage(ABM_setPos, abd);
  end;
end;

//

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
  try
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
      frm_UnCodeX.Position := poDesigned;
      frm_UnCodeX.Top := ini.ReadInteger('Layout', 'Top', frm_UnCodeX.Top);
      frm_UnCodeX.Left := ini.ReadInteger('Layout', 'Left', frm_UnCodeX.Left);
    end;
    if (mi_Savesize.Checked) then begin
      frm_UnCodeX.Width := ini.ReadInteger('Layout', 'Width', frm_UnCodeX.Width);
      frm_UnCodeX.Height := ini.ReadInteger('Layout', 'Height', frm_UnCodeX.Height);
    end;

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
  finally
    ini.Free;
    sl.Free;
  end;
  PackageList := TUPackageList.Create(true);
  ClassList := TUClassList.Create(false);
  UpdateSystemMenu;
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
    runningthread := TPackageScanner.Create(SourcePaths, tv_Packages, tv_Classes, statusReport, PackageList, PackagePriority, ClassList);
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
  searchclass: string;
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    if (InputQuery('Find a class', 'Enter the name of the class you want to find', searchclass)) then begin
      with (ActiveControl as TTreeView) do begin
        for i := 0 to Items.Count-1 do begin
          if (CompareText(items[i].Text, searchclass) = 0) then begin
            Select(items[i]);
            exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure Tfrm_UnCodeX.FormDestroy(Sender: TObject);
begin
  UnregisterAppBar;
  PackagePriority.Free;
  PackageList.Free;
  ClassList.Free;
  SourcePaths.Free;
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
        case (ShellExecute(0, nil, PChar(filename), nil, nil, 0)) of
          ERROR_FILE_NOT_FOUND: statustext := 'File not found: '+filename;
          ERROR_PATH_NOT_FOUND: statustext := 'Path not found: '+filename;
          SE_ERR_ACCESSDENIED : statustext := 'Access denied: '+filename;
        end;
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
      ini.WriteInteger('Layout', 'Top', Top);
      ini.WriteInteger('Layout', 'Left', Left);
    end;
    if (mi_Savesize.Checked) then begin
      ini.WriteInteger('Layout', 'Width', Width);
      ini.WriteInteger('Layout', 'Height', Height);
    end;
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
var
  node: TTreeNode;
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    node := (ActiveControl as TTreeView).Items.GetFirstNode;
    while (node <> nil) do begin
      Node.Expand(true);
      Node := Node.getNextSibling;
    end;
  end;
end;

procedure Tfrm_UnCodeX.mi_CollapseallClick(Sender: TObject);
var
  node: TTreeNode;
begin
  if (ActiveControl.ClassType = TTreeView) then begin
    node := (ActiveControl as TTreeView).Items.GetFirstNode;
    while (node <> nil) do begin
      Node.Collapse(true);
      Node := Node.getNextSibling;
    end;
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

procedure Tfrm_UnCodeX.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if (IsAppBar) then begin
    // FIXME: prevent resizing
    NewHeight := Height;
  end;
end;

procedure Tfrm_UnCodeX.mi_RightClick(Sender: TObject);
begin
  if (mi_Right.Checked) then RegisterAppBar
    else UnregisterAppBar;
end;

procedure Tfrm_UnCodeX.ac_RunServerExecute(Sender: TObject);
var
  se: SHELLEXECUTEINFO;
  lst: TStringList;
begin
  lst := TStringList.Create;
  try
    lst.Delimiter := ' ';
    lst.QuoteChar := '"';
    lst.DelimitedText := ServerCmd;
    if (lst.Count > 0) then begin
      se.cbSize := SizeOf(SHELLEXECUTEINFO);
      se.Wnd := Handle;
      se.lpVerb := nil;
      se.lpFile := PChar(lst[0]);
      lst.Delete(0);
      se.lpParameters := PChar(lst.DelimitedText);
      se.nShow := SW_SHOW;
      se.fMask := SEE_MASK_NOCLOSEPROCESS;
      if (not ShellExecuteEx(@se)) then begin
        case (GetLastError) of
          ERROR_FILE_NOT_FOUND: statustext := 'File not found: '+se.lpFile;
          ERROR_PATH_NOT_FOUND: statustext := 'Path not found: '+se.lpFile;
          SE_ERR_ACCESSDENIED : statustext := 'Access denied: '+se.lpFile;
        end;
      end
      else begin
        SetPriorityClass(se.hProcess, PROCPRIO[ServerPrio]);
      end;
    end;
  finally
    lst.Free;
  end;
end;

procedure Tfrm_UnCodeX.ac_JoinServerExecute(Sender: TObject);
var
  se: SHELLEXECUTEINFO;
  lst: TStringList;
begin
  lst := TStringList.Create;
  try
    lst.Delimiter := ' ';
    lst.QuoteChar := '"';
    lst.DelimitedText := ClientCmd;
    if (lst.Count > 0) then begin
      se.cbSize := SizeOf(SHELLEXECUTEINFO);
      se.Wnd := Handle;
      se.lpVerb := nil;
      se.lpFile := PChar(lst[0]);
      lst.Delete(0);
      se.lpParameters := PChar(lst.DelimitedText);
      se.nShow := SW_SHOW;
      se.fMask := SEE_MASK_NOCLOSEPROCESS;
      if (not ShellExecuteEx(@se)) then begin
        case (GetLastError) of
          ERROR_FILE_NOT_FOUND: statustext := 'File not found: '+se.lpFile;
          ERROR_PATH_NOT_FOUND: statustext := 'Path not found: '+se.lpFile;
          SE_ERR_ACCESSDENIED : statustext := 'Access denied: '+se.lpFile;
        end;
      end;
    end;
  finally
    lst.Free;
  end;
end;

procedure Tfrm_UnCodeX.ac_CompileClassExecute(Sender: TObject);
var
  se: SHELLEXECUTEINFO;
  lst: TStringList;
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
          se.cbSize := SizeOf(SHELLEXECUTEINFO);
          se.Wnd := Handle;
          se.lpVerb := nil;
          se.lpFile := PChar(lst[0]);
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
          se.lpParameters := PChar(lst.DelimitedText);
          se.nShow := SW_SHOW;
          se.fMask := SEE_MASK_NOCLOSEPROCESS;
          if (not ShellExecuteEx(@se)) then begin
            case (GetLastError) of
              ERROR_FILE_NOT_FOUND: statustext := 'File not found: '+se.lpFile;
              ERROR_PATH_NOT_FOUND: statustext := 'Path not found: '+se.lpFile;
              SE_ERR_ACCESSDENIED : statustext := 'Access denied: '+se.lpFile;
            end;
          end;
        finally
          lst.Free;
        end;
      end;
    end;
  end;
end;

end.
