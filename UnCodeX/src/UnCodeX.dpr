program UnCodeX;

uses
  Windows,
  Messages,
  SysUtils,
  Forms,
  Dialogs,
  Classes,
  unit_main in 'unit_main.pas' {frm_UnCodeX},
  unit_packages in 'unit_packages.pas',
  unit_parser in 'unit_parser.pas',
  unit_htmlout in 'unit_htmlout.pas',
  unit_uclasses in 'unit_uclasses.pas',
  unit_settings in 'unit_settings.pas' {frm_Settings},
  unit_definitions in 'unit_definitions.pas',
  unit_analyse in 'unit_analyse.pas',
  unit_copyparser in 'unit_copyparser.pas',
  Hashes in 'Hashes.pas',
  unit_treestate in 'unit_treestate.pas',
  unit_about in 'unit_about.pas' {frm_About},
  unit_mshtmlhelp in 'unit_mshtmlhelp.pas',
  unit_fulltextsearch in 'unit_fulltextsearch.pas',
  RegExpr in 'RegExpr.pas',
  unit_tags in 'unit_tags.pas' {frm_Tags},
  hh_funcs in 'hh_funcs.pas',
  hh in 'hh.pas';

{$R *.res}

var
  HasPrevInst: boolean = false;
  PrevInst: HWND;
  RedirectData: TRedirectStruct;

function StringHash(input: string): integer;
var
  i: integer;
begin
  result := 297;
  for i := 1 to Length(input) do result := result+Ord(input[i]);
end;

procedure EnumWindowCallBack(Handle: HWND; Param: LParam); stdcall;
var
  ClassName : array[0..30] of Char;
  iAppID    : integer;
begin
  GetClassName(Handle, ClassName, 30);
  iAppID := SendMessage(Handle, UM_APP_ID_CHECK, 0, 0); // get app id
  if (CompareText(ClassName, Tfrm_UnCodeX.ClassName) = 0) and (iAppID = AppInstanceId) then begin
    PrevInst:= handle; // previous instance
  end;
end;

procedure FindOtherWindow;
var
  CopyData: TCopyDataStruct;
  RestoreHandle: HWND;
begin
  EnumWindows(@EnumWindowCallBack, 0);
  if (PrevInst <> 0) then begin
    CopyData.cbData := SizeOf(RedirectData);
    CopyData.dwData := PrevInst;
    CopyData.lpData := @RedirectData;
    SendMessage(PrevInst, WM_COPYDATA, PrevInst, Integer(@CopyData));
    HasPrevInst := true;
    RestoreHandle := SendMessage(PrevInst, UM_RESTORE_APPLICATION, PrevInst, 0);
    SetForegroundWindow(RestoreHandle);
    BringWindowToTop(RestoreHandle);
    SetActiveWindow(RestoreHandle);
  end;
end;

procedure ProcessCommandline;
var
  i,j: integer;
  reuse: boolean;
  tmp: string;
begin
  j := 1;
  reuse := false;
  while (j <= ParamCount) do begin
    if (LowerCase(ParamStr(j)) = '-help') then begin
      MessageDlg(CMD_HELP, mtInformation, [mbOK], 0);
    end
    else if (LowerCase(ParamStr(j)) = '-batch') then begin
      IsBatching := true;
      CmdStack := TStringList.Create;
      for i := j+1 to ParamCount do begin
        Inc(j);
        if (ParamStr(i) = '--') then break;
        CmdStack.Add(LowerCase(ParamStr(i)));
        RedirectData.Batch := RedirectData.Batch+LowerCase(ParamStr(i))+' ';
      end;
    end
    else if (LowerCase(ParamStr(j)) = '-hide') then begin
      // FIXME:
      //Visible := false;
      //Application.ShowMainForm := false;
    end
    else if (LowerCase(ParamStr(j)) = '-config') then begin
      Inc(j);
      ConfigFile := ParamStr(j);
      if (ExtractFilePath(ConfigFile) = '') then ConfigFile := ExtractFilePath(ParamStr(0))+ConfigFile;
      StateFile := ExtractFilePath(ConfigFile)+ExtractFilename(ConfigFile)+'.ucx';
    end
    else if (LowerCase(ParamStr(j)) = '-handle') then begin
      Inc(j);
      StatusHandle := StrToIntDef(ParamStr(j), -1);
      RedirectData.NewHandle := StatusHandle;
    end
    else if (LowerCase(ParamStr(j)) = '-reuse') then begin
      reuse := true;
    end
    else if (LowerCase(ParamStr(j)) = '-find') or (LowerCase(ParamStr(j)) = '-open')
      or (LowerCase(ParamStr(j)) = '-tags') then begin
      OpenFind := LowerCase(ParamStr(j)) = '-open';
      OpenTags := LowerCase(ParamStr(j)) = '-tags';
      Inc(j);
      tmp := ParamStr(j);
      i := Pos('.', tmp);
      if (i > 0) then Delete(tmp, i, MaxInt);
      searchclass := tmp;
      RedirectData.Find := tmp;
      if (OpenFind or OpenTags) then CSprops[2] := true;
      RedirectData.OpenFind := OpenFind;
      RedirectData.OpenTags := OpenTags;
    end;
    Inc(j);
  end;
  if (reuse) then begin
    AppInstanceId := StringHash(ConfigFile);
    FindOtherWindow;
  end;
end;

begin
  if (ParamCount() > 0) then ProcessCommandline;
  if (HasPrevInst) then begin
    if (CmdStack <> nil) then CmdStack.Free;
    exit;
  end
  else begin
    Application.Initialize;
    Application.Title := 'UnCodeX';
    Application.CreateForm(Tfrm_UnCodeX, frm_UnCodeX);
  Application.CreateForm(Tfrm_About, frm_About);
  Application.Run;
  end;
end.
