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
  RegExpr in 'RegExpr.pas';

{$R *.res}

var
  HasPrevInst: boolean = false;
  PrevInst: HWND;

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
  aAtom: TAtom;
begin
  EnumWindows(@EnumWindowCallBack, 0);
  if (PrevInst <> 0) then begin
    PostMessage(PrevInst, UM_RESTORE_APPLICATION, 0, 0); // bring to front
    if (ParamCount > 0) then begin
      aAtom := GlobalAddAtom(PChar('test test test test test'));
      if (aAtom <> 0) then begin
        SendMessage(PrevInst, UM_PREVIOUS_INST_PARAMS, aAtom, 0);
        GlobalDeleteAtom(aAtom);
      end;
    end;
    HasPrevInst := true;
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
      MessageDlg('Commandline options:'+#13+#10+
                 '-help'#9#9#9'display this message'+#13+#10+
                 '-hide'#9#9#9'hides UnCodeX'+#13+#10+
                 '-config'#9#9#9'loads a diffirent config file (next argument)'+#13+#10+
                 '-batch'#9#9#9'start UnCodeX in batch processing mode, the next'+#13+#10+
                 #9#9#9'arguments must contain the batch order, '+#13+#10+
                 #9#9#9'which can be on of the following:'+#13+#10+
                 #9'rebuild'#9#9'rebuild class tree'+#13+#10+
                 #9'analyse'#9#9'analyse all classes'+#13+#10+
                 #9'createhtml'#9'create HTML output'+#13+#10+
                 #9'htmlhelp'#9#9'create MS HTML Help file'+#13+#10+
                 #9'close'#9#9'close UnCodeX'+#13+#10+
                 #9'--'#9#9'end of batch commands'
                 , mtInformation, [mbOK], 0);
    end
    else if (LowerCase(ParamStr(j)) = '-batch') then begin
      IsBatching := true;
      CmdStack := TStringList.Create;
      for i := j+1 to ParamCount do begin
        Inc(j);
        if (ParamStr(i) = '--') then break;
        CmdStack.Add(LowerCase(ParamStr(i)));
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
      StateFile := ExtractFilePath(ConfigFile)+ExtractFilename(ConfigFile)+'.state';
    end
    else if (LowerCase(ParamStr(j)) = '-handle') then begin
      Inc(j);
      StatusHandle := StrToIntDef(ParamStr(j), -1);
    end
    else if (LowerCase(ParamStr(j)) = '-reuse') then begin
      reuse := true;
    end
    else if (LowerCase(ParamStr(j)) = '-find') then begin
      Inc(j);
      tmp := ParamStr(j);
      i := Pos('.', tmp);
      if (i > 0) then Delete(tmp, i, MaxInt);
      searchclass := tmp;
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
