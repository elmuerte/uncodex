{*******************************************************************************
    Name:
        unit_rungame.pas
    Author(s):
        Michiel 'El Muerte' Hendriks
    Purpose:
        Run dialog for the game\server

    $Id: unit_rungame.pas,v 1.8 2004-10-20 14:19:29 elmuerte Exp $
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
unit unit_rungame;

{$I defines.inc}

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, CheckLst, ComCtrls, unit_uclasses, ExtCtrls;

type
    Tfrm_Run = class(TForm)
        pc_Args: TPageControl;
        ts_Switches: TTabSheet;
        ts_URL: TTabSheet;
        clb_MainSwitches: TCheckListBox;
        cb_INI: TCheckBox;
        ed_INI: TEdit;
        mm_AddSwitches: TMemo;
        cb_Gametype: TComboBox;
        ed_Map: TEdit;
        ed_Loc: TEdit;
        cb_USERINI: TCheckBox;
        ed_USERINI: TEdit;
        cb_LOG: TCheckBox;
        ed_LOG: TEdit;
        cb_MultiHome: TCheckBox;
        ed_MULTIHOME: TEdit;
        lbl_MainSwitch: TLabel;
        lbl_AdditionalSwitches: TLabel;
        lbl_Exe: TLabel;
        ed_Exe: TEdit;
        ed_Args: TEdit;
        lbl_Args: TLabel;
        btn_Exe: TBitBtn;
        ts_Commandline: TTabSheet;
        lbl_Format: TLabel;
        ed_Format: TEdit;
        btn_Map: TBitBtn;
        rb_Map: TRadioButton;
        rb_Location: TRadioButton;
        lbl_Gametype: TLabel;
        gb_Mutators: TGroupBox;
        lb_AvailMut: TListBox;
        lb_SelMut: TListBox;
        mm_AddOptions: TMemo;
        lbl_AddOptions: TLabel;
        lbl_AvailMut: TLabel;
        lbl_SelectedMut: TLabel;
        btn_ok: TBitBtn;
        btn_Cancel: TBitBtn;
        cb_PreSets: TComboBox;
        btn_AddPre: TBitBtn;
        btn_DelPre: TBitBtn;
        lbl_Presets: TLabel;
        btn_AddMut: TBitBtn;
        btn_DelMut: TBitBtn;
        lbl_FormatExe: TLabel;
        cb_READINI: TCheckBox;
        ed_READINI: TEdit;
        cb_MOD: TCheckBox;
        ed_MOD: TEdit;
        cb_PORT: TCheckBox;
        ed_PORT: TEdit;
        lbl_ConfigurationSwitches: TLabel;
        lbl_ServerSwitches: TLabel;
        lbl_MiscSwitches: TLabel;
        btn_INI: TBitBtn;
        btn_READINI: TBitBtn;
        btn_USERINI: TBitBtn;
        btn_LOG: TBitBtn;
        btn_MutPlus: TBitBtn;
        bvl_sep1: TBevel;
        lbl_GTOptName: TLabel;
        ed_GameTypeOptionName: TEdit;
        lbl_MutOptname: TLabel;
        ed_MutOptName: TEdit;
        cb_MutCSL: TCheckBox;
        Label1: TLabel;
        ed_Mapfilter: TEdit;
        od_SelectMap: TOpenDialog;
        od_IniFiles: TOpenDialog;
        od_Exe: TOpenDialog;
        od_Log: TOpenDialog;
        cb_Priority: TComboBox;
        Label2: TLabel;
        btn_Default: TBitBtn;
        TabSheet1: TTabSheet;
        mm_Replacements: TMemo;
        procedure FormCreate(Sender: TObject);
        procedure ed_MapChange(Sender: TObject);
        procedure btn_AddMutClick(Sender: TObject);
        procedure btn_DelMutClick(Sender: TObject);
        procedure btn_MutPlusClick(Sender: TObject);
        procedure btn_MapClick(Sender: TObject);
        procedure btn_INIClick(Sender: TObject);
        procedure btn_READINIClick(Sender: TObject);
        procedure btn_USERINIClick(Sender: TObject);
        procedure btn_ExeClick(Sender: TObject);
        procedure ed_ExeChange(Sender: TObject);
        procedure btn_LOGClick(Sender: TObject);
        procedure btn_AddPreClick(Sender: TObject);
        procedure cb_PreSetsChange(Sender: TObject);
        procedure btn_DelPreClick(Sender: TObject);
        procedure btn_DefaultClick(Sender: TObject);
        procedure btn_okClick(Sender: TObject);
    private
        procedure FillGameInfo(uclass: TUClass);
        procedure FillMutator(uclass: TUClass);
        procedure UpdateCommandLine();
        procedure LoadPreSet(sectionName: string; ininame: string);
        procedure SavePreSet(sectionName: string; ininame: string);
    public
        relpath: string;
        function IsAbstract(props: string): boolean;
        function RelativeFileArg(fn: string): string;
    end;

var
    frm_Run: Tfrm_Run;

implementation

uses unit_main, inifiles;

var
    IncI: integer = 0;

{$R *.dfm}

function Tfrm_Run.IsAbstract(props: string): boolean;
begin
    props := ' '+LowerCase(props)+' ';
    result := Pos(' abstract ', props) > 0;
end;

function Tfrm_Run.RelativeFileArg(fn: string): string;
begin
    result := trim(fn);
    result := StringReplace(result, relpath, '', [rfIgnoreCase]);
    if (Pos(' ', result) > 0) then
        if (result[1] <> '"') then result := '"'+result+'"';
end;

procedure Tfrm_Run.FormCreate(Sender: TObject);
var
    i:      integer;
    ini:    TMemIniFile;
begin
    pc_Args.ActivePage := ts_URL;
    for i := 0 to ClassList.Count-1 do begin
        if (CompareText(ClassList[i].name, 'gameinfo') = 0) then FillGameInfo(ClassList[i]);
        if (CompareText(ClassList[i].name, 'mutator') = 0) then FillMutator(ClassList[i])
    end;
    ini := TMemIniFile.Create(ExtractFilePath(ParamStr(0))+'\runpresets.ini');
    try
        cb_PreSets.Items.Clear;
        ini.ReadSections(cb_PreSets.Items);
        cb_PreSets.Items.Insert(0, '');
    finally
        ini.Free;
    end;
    LoadPreSet('Default Run', ConfigFile);
end;

procedure Tfrm_Run.FillGameInfo(uclass: TUClass);
var
    i: integer;
begin
    if (not IsAbstract(uclass.modifiers)) then cb_Gametype.Items.Add(uclass.FullName);
    for i := 0 to uclass.children.Count-1 do begin
        FillGameInfo(uclass.children[i]);
    end;
end;

procedure Tfrm_Run.FillMutator(uclass: TUClass);
var
    i: integer;
begin
    if (not IsAbstract(uclass.modifiers)) then lb_AvailMut.Items.Add(uclass.FullName);
    for i := 0 to uclass.children.Count-1 do begin
        FillMutator(uclass.children[i]);
    end;
end;

procedure Tfrm_Run.UpdateCommandLine();
var
    arg,
    arg2,
    tmp:    string;
    i:      integer;
begin
    if (rb_Map.Checked) then arg := ed_Map.Text
    else if (rb_Location.Checked) then arg := ed_Loc.Text;
    cb_Gametype.Text := trim(cb_Gametype.Text);
    ed_GameTypeOptionName.Text := trim(ed_GameTypeOptionName.Text);
    if (ed_GameTypeOptionName.Text = '') then ed_GameTypeOptionName.Text := 'Game';
    if (cb_Gametype.Text <> '') then begin
        arg := arg+'?'+ed_GameTypeOptionName.Text+'='+cb_Gametype.Text;
    end;
    if (lb_SelMut.Items.Count > 0) then begin
        ed_MutOptName.Text := trim(ed_MutOptName.Text);
        if (ed_MutOptName.Text = '') then ed_MutOptName.Text := 'Mutator';
        tmp := '';
        if (cb_MutCSL.Checked) then begin
            tmp := '?'+ed_MutOptName.Text+'='+lb_SelMut.Items.CommaText;
        end
        else begin
            for i := 0 to lb_SelMut.Items.Count-1 do begin
                tmp := tmp+'?'+ed_MutOptName.Text+'='+lb_SelMut.items[i];
            end;
        end;
        if (tmp <> '') then arg := arg+tmp;
    end;

    tmp := trim(mm_AddOptions.Lines.Text);
    arg := arg+tmp;

    for i := 0 to clb_MainSwitches.Items.Count-1 do begin
        if (clb_MainSwitches.Checked[i]) then arg2 := arg2+' -'+clb_MainSwitches.Items[i];
    end;
    tmp := RelativeFileArg(ed_INI.Text);
    if (cb_INI.Checked and (tmp <> '')) then arg2 := arg2+' -INI='+tmp;
    tmp := RelativeFileArg(ed_READINI.Text);
    if (cb_READINI.Checked and (tmp <> '')) then arg2 := arg2+' -READINI='+tmp;
    tmp := RelativeFileArg(ed_USERINI.Text);
    if (cb_USERINI.Checked and (tmp <> '')) then arg2 := arg2+' -USERINI='+tmp;

    tmp := trim(ed_MULTIHOME.Text);
    if (cb_MULTIHOME.Checked and (tmp <> '')) then arg2 := arg2+' -MULTIHOME='+tmp;
    tmp := trim(ed_Port.Text);
    if (cb_PORT.Checked and (tmp <> '')) then arg2 := arg2+' -PORT='+tmp;

    tmp := RelativeFileArg(ed_LOG.Text);
    if (cb_LOG.Checked and (tmp <> '')) then arg2 := arg2+' -LOG='+tmp;
    tmp := trim(ed_MOD.Text);
    if (cb_MOD.Checked and (tmp <> '')) then arg2 := arg2+' -MOD='+tmp;

    ed_Args.Text := ed_Format.Text; //fixme
    ed_Args.Text := StringReplace(ed_Args.Text, '%url%', arg, [rfReplaceAll, rfIgnoreCase]);
    ed_Args.Text := StringReplace(ed_Args.Text, '%switch%', arg2, [rfReplaceAll, rfIgnoreCase]);
    Randomize;
    ed_Args.Text := StringReplace(ed_Args.Text, '%rand%', IntToStr(Random(MaxInt)), [rfReplaceAll, rfIgnoreCase]);
    ed_Args.Text := StringReplace(ed_Args.Text, '%inc%', IntToStr(IncI), [rfReplaceAll, rfIgnoreCase]);
end;

procedure Tfrm_Run.LoadPreSet(sectionName: string; ininame: string);
var
    ini:    TMemIniFile;
    lst:    TStringList;
    i:      integer;
begin
    if (sectionName = '') then exit;
    ini := TMemIniFile.Create(ininame);
    lst := TStringList.Create;
    try
        // commandline
        ed_Exe.Text := ini.ReadString(sectionname, 'cmd.Exe', '');
        cb_Priority.ItemIndex := ini.ReadInteger(sectionname, 'cmd.Priority', 1);
        ed_Format.Text := ini.ReadString(sectionname, 'cmd.Format', '%url% %switch%');
        ed_Mapfilter.Text := ini.ReadString(sectionname, 'cmd.MapFilter', '*.unr;*.ut2');
        ed_GameTypeOptionName.Text := ini.ReadString(sectionname, 'cmd.GameTypeOption', 'Game');
        ed_MutOptName.Text := ini.ReadString(sectionname, 'cmd.MutatorOption', 'Mutator');
        cb_MutCSL.Checked := ini.ReadBool(sectionname, 'cmd.MutCSL', true);
        // switches
        cb_INI.Checked := ini.ReadBool(sectionname, 'switch.INI', false);
        ed_INI.Text := ini.ReadString(sectionname, 'switch.INI.value', '');
        cb_READINI.Checked := ini.ReadBool(sectionname, 'switch.READINI', false);
        ed_READINI.Text := ini.ReadString(sectionname, 'switch.READINI.value', '');
        cb_USERINI.Checked := ini.ReadBool(sectionname, 'switch.USERINI', false);
        ed_USERINI.Text := ini.ReadString(sectionname, 'switch.USERINI.value', '');
        cb_MULTIHOME.Checked := ini.ReadBool(sectionname, 'switch.MULTIHOME', false);
        ed_MULTIHOME.Text := ini.ReadString(sectionname, 'switch.MULTIHOME.value', '');
        cb_PORT.Checked := ini.ReadBool(sectionname, 'switch.PORT', false);
        ed_PORT.Text := ini.ReadString(sectionname, 'switch.PORT.value', '');
        cb_MOD.Checked := ini.ReadBool(sectionname, 'switch.MOD', false);
        ed_MOD.Text := ini.ReadString(sectionname, 'switch.MOD.value', '');
        cb_LOG.Checked := ini.ReadBool(sectionname, 'switch.LOG', false);
        ed_LOG.Text := ini.ReadString(sectionname, 'switch.LOG.value', '');
        lst.Clear;
        lst.CommaText := ini.ReadString(sectionname,    'switches', '');
        for i := 0 to clb_MainSwitches.Items.Count-1 do begin
            clb_MainSwitches.Checked[i] := false
        end;
        for i := 0 to lst.Count-1 do begin
            if (clb_MainSwitches.Items.IndexOf(lst[i]) = -1) then clb_MainSwitches.Items.Add(lst[i]);
            clb_MainSwitches.Checked[clb_MainSwitches.Items.IndexOf(lst[i])] := true; 
        end;
        mm_AddSwitches.Lines.Text := ini.ReadString(sectionname,    'switch.Additional', '');
        // url
        rb_Map.Checked := ini.ReadBool(sectionname, 'url.UseMap', true);
        if (not rb_Map.Checked) then rb_Location.Checked := true;
        ed_Map.Text := ini.ReadString(sectionname, 'url.Map', '');
        ed_Loc.Text := ini.ReadString(sectionname, 'url.Location', '');
        cb_Gametype.Text := ini.ReadString(sectionname, 'url.Gametype', '');
        lb_SelMut.Items.CommaText := ini.ReadString(sectionname, 'url.Mutators', '');
        mm_AddOptions.Lines.Text := ini.ReadString(sectionname, 'url.Additional', '');
        UpdateCommandLine;
    finally
        lst.Free;
        ini.Free;
    end;
end;

procedure Tfrm_Run.SavePreSet(sectionName: string; ininame: string);
var
    ini:    TMemIniFile;
    i:      integer;
    lst:    TStringList;
begin
    if (sectionname = '') then exit;
    ini := TMemIniFile.Create(ininame);
    lst := TStringList.Create;
    try
        ini.EraseSection(sectionname);
        // commandline
        ini.WriteString(sectionname,    'cmd.Exe', ed_Exe.Text);
        ini.WriteInteger(sectionname, 'cmd.Priority', cb_Priority.ItemIndex);
        ini.WriteString(sectionname,    'cmd.Format', ed_Format.Text);
        ini.WriteString(sectionname,    'cmd.MapFilter', ed_Mapfilter.Text);
        ini.WriteString(sectionname,    'cmd.GameTypeOption', ed_GameTypeOptionName.Text);
        ini.WriteString(sectionname,    'cmd.MutatorOption', ed_MutOptName.Text);
        ini.WriteBool(sectionname,      'cmd.MutCSL', cb_MutCSL.Checked);
        // switches
        ini.WriteBool(sectionname,      'switch.INI', cb_INI.Checked);
        ini.WriteString(sectionname,    'switch.INI.value', ed_INI.Text);
        ini.WriteBool(sectionname,      'switch.READINI', cb_READINI.Checked);
        ini.WriteString(sectionname,    'switch.READINI.value', ed_READINI.Text);
        ini.WriteBool(sectionname,      'switch.USERINI', cb_USERINI.Checked);
        ini.WriteString(sectionname,    'switch.USERINI.value', ed_USERINI.Text);
        ini.WriteBool(sectionname,      'switch.MULTIHOME', cb_MULTIHOME.Checked);
        ini.WriteString(sectionname,    'switch.MULTIHOME.value', ed_MULTIHOME.Text);
        ini.WriteBool(sectionname,      'switch.PORT', cb_PORT.Checked);
        ini.WriteString(sectionname,    'switch.PORT.value', ed_PORT.Text);
        ini.WriteBool(sectionname,      'switch.MOD', cb_MOD.Checked);
        ini.WriteString(sectionname,    'switch.MOD.value', ed_MOD.Text);
        ini.WriteBool(sectionname,      'switch.LOG', cb_LOG.Checked);
        ini.WriteString(sectionname,    'switch.LOG.value', ed_LOG.Text);
        lst.Clear;
        for i := 0 to clb_MainSwitches.Items.Count-1 do begin
            if (clb_MainSwitches.Checked[i]) then lst.Add(clb_MainSwitches.Items[i]);
        end;
        ini.WriteString(sectionname,    'switches', lst.CommaText);
        ini.WriteString(sectionname,    'switch.Additional', mm_AddSwitches.Lines.Text);
        // url
        ini.WriteBool(sectionname,      'url.UseMap', rb_Map.Checked);
        ini.WriteString(sectionname,    'url.Map', ed_Map.Text);
        ini.WriteString(sectionname,    'url.Location', ed_Loc.Text);
        ini.WriteString(sectionname,    'url.Gametype', cb_Gametype.Text);
        ini.WriteString(sectionname,    'url.Mutators', lb_SelMut.Items.CommaText);
        ini.WriteString(sectionname,    'url.Additional', mm_AddOptions.Lines.Text);


        ini.UpdateFile;
        if (ininame <> ConfigFile) then begin
            cb_PreSets.Items.Clear;
            ini.ReadSections(cb_PreSets.Items);
            cb_PreSets.Items.Insert(0, '');
            cb_PreSets.ItemIndex := cb_PreSets.Items.IndexOf(sectionname);
        end;
    finally
        ini.Free;
        lst.Free;
    end;
end;

procedure Tfrm_Run.ed_MapChange(Sender: TObject);
begin
    UpdateCommandLine;
end;

procedure Tfrm_Run.btn_AddMutClick(Sender: TObject);
begin
    if (lb_AvailMut.ItemIndex = -1) then exit;
    if (lb_SelMut.Items.IndexOf(lb_AvailMut.Items[lb_AvailMut.ItemIndex]) = -1) then begin
        lb_SelMut.Items.Add(lb_AvailMut.Items[lb_AvailMut.ItemIndex]);
        UpdateCommandLine;
    end;
end;

procedure Tfrm_Run.btn_DelMutClick(Sender: TObject);
begin
    if (lb_SelMut.ItemIndex = -1) then exit;
    lb_SelMut.Items.Delete(lb_SelMut.ItemIndex);
    UpdateCommandLine;
end;

procedure Tfrm_Run.btn_MutPlusClick(Sender: TObject);
var
    newmut: string;
begin
    if (InputQuery('Add mutator', 'Add a mutator with the name: package.class', newmut)) then begin
        lb_SelMut.Items.Add(newmut);
        UpdateCommandLine;
    end;
end;

procedure Tfrm_Run.btn_MapClick(Sender: TObject);
var
    i: integer;
begin
    for i := 0 to SourcePaths.Count-1 do begin
        if (DirectoryExists(SourcePaths[i]+'\Maps')) then begin
            od_SelectMap.InitialDir := SourcePaths[i]+'\Maps';
            Break;
        end;
    end;
    od_SelectMap.Filter := 'Maps|'+trim(ed_Mapfilter.Text)+'|All Files|*.*';
    if (od_SelectMap.Execute) then begin
        ed_Map.Text := ExtractFileName(od_SelectMap.FileName);
    end;
end;

procedure Tfrm_Run.btn_INIClick(Sender: TObject);
var
    i: integer;
begin
    for i := 0 to SourcePaths.Count-1 do begin
        if (DirectoryExists(SourcePaths[i]+'\System')) then begin
            od_IniFiles.InitialDir := SourcePaths[i]+'\System';
            Break;
        end;
    end;
    if (od_IniFiles.Execute) then begin
        ed_INI.Text := RelativeFileArg(od_IniFiles.FileName);
        cb_INI.Checked := ed_INI.Text <> '';
        UpdateCommandLine;
    end;
end;

procedure Tfrm_Run.btn_READINIClick(Sender: TObject);
var
    i: integer;
begin
    for i := 0 to SourcePaths.Count-1 do begin
        if (DirectoryExists(SourcePaths[i]+'\System')) then begin
            od_IniFiles.InitialDir := SourcePaths[i]+'\System';
            Break;
        end;
    end;
    if (od_IniFiles.Execute) then begin
        ed_READINI.Text := RelativeFileArg(od_IniFiles.FileName);
        cb_READINI.Checked := ed_READINI.Text <> '';
        UpdateCommandLine;
    end;
end;

procedure Tfrm_Run.btn_USERINIClick(Sender: TObject);
var
    i: integer;
begin
    for i := 0 to SourcePaths.Count-1 do begin
        if (DirectoryExists(SourcePaths[i]+'\System')) then begin
            od_IniFiles.InitialDir := SourcePaths[i]+'\System';
            Break;
        end;
    end;
    if (od_IniFiles.Execute) then begin
        ed_USERINI.Text := RelativeFileArg(od_IniFiles.FileName);
        cb_USERINI.Checked := ed_USERINI.Text <> '';
        UpdateCommandLine;
    end;
end;

procedure Tfrm_Run.btn_ExeClick(Sender: TObject);
var
    i: integer;
begin
    for i := 0 to SourcePaths.Count-1 do begin
        if (DirectoryExists(SourcePaths[i]+'\System')) then begin
            od_Exe.InitialDir := SourcePaths[i]+'\System';
            Break;
        end;
    end;
    od_Exe.FileName := ed_Exe.Text;
    if (od_Exe.Execute) then begin
        ed_Exe.Text := od_Exe.FileName;
    end;
end;

procedure Tfrm_Run.ed_ExeChange(Sender: TObject);
begin
    relpath := ExtractFilePath(ed_Exe.Text);
    btn_ok.Enabled := FileExists(ed_Exe.Text);
end;

procedure Tfrm_Run.btn_LOGClick(Sender: TObject);
var
    i: integer;
begin
    for i := 0 to SourcePaths.Count-1 do begin
        if (DirectoryExists(SourcePaths[i]+'\System')) then begin
            od_SelectMap.InitialDir := SourcePaths[i]+'\System';
            Break;
        end;
    end;
    if (od_Log.Execute) then begin
        ed_LOG.Text := RelativeFileArg(od_Log.FileName);
        cb_LOG.Checked := ed_LOG.Text <> '';
        UpdateCommandLine;
    end;
end;

procedure Tfrm_Run.btn_AddPreClick(Sender: TObject);
var
    sectionName: string;
begin
    if (cb_PreSets.ItemIndex <> -1) then sectionName := cb_PreSets.Items[cb_PreSets.itemindex];
    if (not InputQuery('Enter a name', 'Enter the name of the preset', sectionname)) then exit;
    if (sectionname = '') then exit;
    if (cb_PreSets.Items.IndexOf(sectionName) > 0) then begin
        if (MessageDlg('A preset with this name already exists.'+#13+#10+'Do you want to overwrite it?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;
    end;
    SavePreSet(sectionname, ExtractFilePath(ParamStr(0))+'\runpresets.ini');
end;

procedure Tfrm_Run.cb_PreSetsChange(Sender: TObject);
var
    sectionName: string;
begin
    if (cb_PreSets.ItemIndex = -1) then exit;
    sectionName := cb_PreSets.Items[cb_PreSets.itemindex];
    if (sectionName = '') then exit;
    LoadPreSet(sectionName, ExtractFilePath(ParamStr(0))+'\runpresets.ini');
end;

procedure Tfrm_Run.btn_DelPreClick(Sender: TObject);
var
    ini:            TMemIniFile;
    sectionName:    string;
begin
    if (cb_PreSets.ItemIndex <> -1) then sectionName := cb_PreSets.Items[cb_PreSets.itemindex];
    if (MessageDlg('Are you sure you want to delete the preset '''+sectionname+'''?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;

    ini := TMemIniFile.Create(ExtractFilePath(ParamStr(0))+'\runpresets.ini');
    try
        ini.EraseSection(sectionname);
        ini.UpdateFile;
        cb_PreSets.Items.Clear;
        ini.ReadSections(cb_PreSets.Items);
        cb_PreSets.Items.Insert(0, '');
    finally
        ini.Free;
    end;
end;

procedure Tfrm_Run.btn_DefaultClick(Sender: TObject);
begin
    SavePreSet('Default Run', ConfigFile);
end;

procedure Tfrm_Run.btn_okClick(Sender: TObject);
begin
    Inc(IncI);
end;

end.
