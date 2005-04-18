{*******************************************************************************
  Name:
    UnCodeX.dpr
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Program unit for the GUI

  $Id: UnCodeX.dpr,v 1.70 2005-04-18 15:48:55 elmuerte Exp $
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
program UnCodeX;

{$R 'hilight_preview.res' 'hilight_preview.rc'}
{$I defines.inc}

uses
  FastShareMem in 'FastShareMem.pas',
  {$IFDEF DETECT_MEM_LEAK}
  MemCheck in 'MemCheck.pas',
  {$ENDIF}
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
  hh in 'hh.pas',
  unit_outputdefs in 'unit_outputdefs.pas',
  unit_sourceparser in 'unit_sourceparser.pas',
  unit_rtfhilight in 'unit_rtfhilight.pas',
  unit_richeditex in 'unit_richeditex.pas',
  unit_utils in 'unit_utils.pas',
  unit_searchform in 'unit_searchform.pas' {frm_SearchForm},
  unit_clpipe in 'unit_clpipe.pas',
  unit_license in 'unit_license.pas' {frm_License},
  unit_splash in 'unit_splash.pas' {frm_Splash},
  unit_props in 'unit_props.pas' {fr_Properties: TFrame},
  unit_ucxdocktree in 'unit_ucxdocktree.pas',
  unit_ucops in 'unit_ucops.pas' {frm_CreateNewClass},
  unit_pkgprops in 'unit_pkgprops.pas' {frm_PackageProps},
  unit_moveclass in 'unit_moveclass.pas' {frm_MoveClass},
  unit_defprops in 'unit_defprops.pas' {frm_DefPropsBrowser},
  unit_renameclass in 'unit_renameclass.pas' {frm_RenameClass},
  unit_rungame in 'unit_rungame.pas' {frm_Run},
  unit_multilinequery in 'unit_multilinequery.pas' {frm_MultiLineQuery},
  unit_pascalscript in 'unit_pascalscript.pas',
  unit_pascalscript_gui in 'unit_pascalscript_gui.pas',
  unit_pseditor in 'unit_pseditor.pas' {frm_PSEditor},
  unit_pascalscript_ex in 'unit_pascalscript_ex.pas',
  uPSI_unit_uclasses in 'uPSI_unit_uclasses.pas',
  unit_config in 'unit_config.pas',
  unit_ucxinifiles in 'unit_ucxinifiles.pas',
  unit_ucxthread in 'unit_ucxthread.pas';

{$R *.res}

var
  HasPrevInst: boolean = false;
  PrevInst: HWND;
  RedirectData: TRedirectStruct;

const  
  CMD_HELP =  'Commandline options:'+#13+#10+
              '-config'#9#9#9'loads a diffirent config file (next argument)'+#13+#10+
              '-batch'#9#9#9'start UnCodeX in batch processing mode, the next'+#13+#10+
              #9#9#9'arguments must contain the batch order, '+#13+#10+
              #9#9#9'which can be on of the following:'+#13+#10+
              #9'rebuild'#9#9'rebuild class tree'+#13+#10+
              #9'analyse'#9#9'analyse all classes'+#13+#10+
              #9'analysemodified'#9'analyse only modified classes'+#13+#10+
              #9'findnew'#9#9'find new classes in existing packages'+#13+#10+
              #9'createhtml'#9'create HTML output'+#13+#10+
              #9'htmlhelp'#9#9'create MS HTML Help file'+#13+#10+
              #9'close'#9#9'close UnCodeX'+#13+#10+
              #9'ext:<name>'#9'call an custom output module'+#13+#10+
              #9'ps:<name>'#9'execute a PascalScript'+#13+#10+
              #9'--'#9#9'end of batch commands'+#13+#10+
              '-find'#9#9#9'find a class'+#13+#10+
              '-fts'#9#9#9'show full text search dialog'+#13+#10+
              '-help'#9#9#9'display this message'+#13+#10+
              '-hide'#9#9#9'hides UnCodeX'+#13+#10+
              '-handle'#9#9#9'Window handle'+#13+#10+
              '-nosplash'#9#9'Do not display splash screen'+#13+#10+
              '-open'#9#9#9'find and open a class'+#13+#10+
              '-reuse'#9#9#9'reuse a previous window'+#13+#10+
              '-tags'#9#9#9'display class properties';

procedure EnumWindowCallBack(Handle: HWND; Param: LParam); stdcall;
var
  ClassName: array[0..30] of Char;
  iAppID: integer;
begin
  GetClassName(Handle, ClassName, 30);
  iAppID := SendMessage(Handle, UM_APP_ID_CHECK, 0, 0); // get app id
  if (CompareText(ClassName, Tfrm_UnCodeX.ClassName) = 0) and (iAppID = GlobalGUIVars.AppInstanceId) then begin
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
      GlobalGUIVars.IsBatching := true;
      for i := j+1 to ParamCount do begin
        Inc(j);
        if (ParamStr(i) = '--') then break;
        GlobalGUIVars.CmdStack.Add(LowerCase(ParamStr(i)));
        RedirectData.Batch := RedirectData.Batch+LowerCase(ParamStr(i))+' ';
      end;
    end
    else if (LowerCase(ParamStr(j)) = '-hide') then begin
      Application.ShowMainForm := false;
    end
    else if (LowerCase(ParamStr(j)) = '-config') then begin
      Inc(j);
      ConfigFile := ParamStr(j);
      if (ExtractFilePath(ConfigFile) = '') then ConfigFile := ExtractFilePath(ParamStr(0))+ConfigFile;
    end
    else if (LowerCase(ParamStr(j)) = '-handle') then begin
      Inc(j);
      GlobalGUIVars.StatusHandle := StrToIntDef(ParamStr(j), -1);
      RedirectData.NewHandle := GlobalGUIVars.StatusHandle;
    end
    else if (LowerCase(ParamStr(j)) = '-reuse') then begin
      reuse := true;
    end
    else if (LowerCase(ParamStr(j)) = '-fts') then begin
      GlobalGUIVars.OpenFTS := true;
      RedirectData.OpenFTS := true;
    end
    else if (LowerCase(ParamStr(j)) = '-find') or (LowerCase(ParamStr(j)) = '-open')
      or (LowerCase(ParamStr(j)) = '-tags') then begin
      GlobalGUIVars.OpenFind := LowerCase(ParamStr(j)) = '-open';
      GlobalGUIVars.OpenTags := LowerCase(ParamStr(j)) = '-tags';
      Inc(j);
      tmp := ParamStr(j);
      i := Pos('.', tmp);
      if (i > 0) then Delete(tmp, i, MaxInt);
      GlobalGUIVars.SearchConfig.query := tmp;
      GlobalGUIVars.SearchConfig.isFTS := false;
      GlobalGUIVars.SearchConfig.Wrapped := true;
      if (GlobalGUIVars.OpenFind or GlobalGUIVars.OpenTags) then GlobalGUIVars.SearchConfig.isStrict := true;
      RedirectData.Find := tmp;
      RedirectData.OpenFind := GlobalGUIVars.OpenFind;
      RedirectData.OpenTags := GlobalGUIVars.OpenTags;
    end;
    Inc(j);
  end;
  if (reuse) then begin
    GlobalGUIVars.AppInstanceId := StringHash(ConfigFile);
    FindOtherWindow;
  end;
end;

begin
  if (FindCmdLineSwitch('findmemleak')) then begin
    {$IFDEF DETECT_MEM_LEAK}
    MemChk;
    {$ELSE}
    ShowMessage('Not compiled with DETECT_MEM_LEAK');
    {$ENDIF}
  end;

  if (not (FindCmdLineSwitch('nosplash') or FindCmdLineSwitch('hide'))) then frm_Splash := Tfrm_Splash.Create(nil);
  if (GlobalGUIVars = nil) then GlobalGUIVars := TUCXGUIVars.Create;   
  if (ParamCount() > 0) then ProcessCommandline;
  if (not HasPrevInst) then begin
    Application.Initialize;
    Application.Title := 'Loading UnCodeX ...';
    Application.CreateForm(Tfrm_UnCodeX, frm_UnCodeX);
    Application.CreateForm(Tfrm_About, frm_About);
    Application.CreateForm(Tfrm_License, frm_License);
    if (not Application.ShowMainForm) then frm_UnCodeX.OnShow(nil);
    Application.Run;
  end
  else if (frm_Splash <> nil) then frm_Splash.Close;
  if (GlobalGUIVars <> nil) then FreeAndNil(GlobalGUIVars);
end.
