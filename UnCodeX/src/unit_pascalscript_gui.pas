{*******************************************************************************
    Name:
        unit_pascalscript_gui.pas
    Author(s):
        Michiel 'El Muerte' Hendriks
    Purpose:
        Additional GUI only PascalScript routines

    $Id: unit_pascalscript_gui.pas,v 1.9 2004-10-20 14:19:29 elmuerte Exp $
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
unit unit_pascalscript_gui;

{$I defines.inc}

interface

uses
    Classes, uPSComponent, Dialogs, windows, forms, SysUtils, Controls;

    procedure RegisterPSGui(ps: TPSScript);
    procedure LinkPSGui(ps: TPSScript);

implementation

uses unit_main, unit_uclasses, unit_utils, unit_rungame;

{ Actions -- begin}
{ Class Tree }
function acRecreateTree: boolean;
begin
    result := frm_UnCodeX.ac_RecreateTree.Execute;
end;

function acFindOrphans: boolean;
begin
    result := frm_UnCodeX.ac_FindOrphans.Execute;
end;

function acAnalyseAll: boolean;
begin
    result := frm_UnCodeX.ac_AnalyseAll.Execute;
end;

function acAnalyseModified: boolean;
begin
    result := frm_UnCodeX.ac_AnalyseModified.Execute;
end;

function acOpenClass: boolean;
begin
    result := frm_UnCodeX.ac_OpenClass.Execute;
end;

function acTags: boolean;
begin
    result := frm_UnCodeX.ac_Tags.Execute;
end;

function acCopyName: boolean;
begin
    result := frm_UnCodeX.ac_CopyName.Execute;
end;

function acSourceSnoop: boolean;
begin
    result := frm_UnCodeX.ac_SourceSnoop.Execute;
end;

function acRebuildAnalyse: boolean;
begin
    result := frm_UnCodeX.ac_RebuildAnalyse.Execute;
end;

function acCreateSubClass: boolean;
begin
    result := frm_UnCodeX.ac_CreateSubClass.Execute;
end;

function acDeleteClass: boolean;
begin
    result := frm_UnCodeX.ac_DeleteClass.Execute;
end;

function acMoveClass: boolean;
begin
    result := frm_UnCodeX.ac_MoveClass.Execute;
end;

function acRenameClass: boolean;
begin
    result := frm_UnCodeX.ac_RenameClass.Execute;
end;

function acPackageProps: boolean;
begin
    result := frm_UnCodeX.ac_PackageProps.Execute;
end;

{ Compiler }
function acCompileClass: boolean;
begin
    result := frm_UnCodeX.ac_CompileClass.Execute;
end;

{ Find }
function acFindClass: boolean;
begin
    result := frm_UnCodeX.ac_FindClass.Execute;
end;

function acFindNext: boolean;
begin
    result := frm_UnCodeX.ac_FindNext.Execute;
end;

function acFullTextSearch: boolean;
begin
    result := frm_UnCodeX.ac_FullTextSearch.Execute;
end;

function acSwitchTree: boolean;
begin
    result := frm_UnCodeX.ac_SwitchTree.Execute;
end;

{ Game Server }
function acRunServer: boolean;
begin
    result := frm_UnCodeX.ac_RunServer.Execute;
end;

function acJoinServer: boolean;
begin
    result := frm_UnCodeX.ac_JoinServer.Execute;
end;

function acRun: boolean;
begin
    result := frm_UnCodeX.ac_Run.Execute;
end;

// open run dialog with profile preselected
function acRunEx(profile: string; autorun: boolean): boolean;
var
    i:      integer;
    found:  boolean;
    lst:    TStringList;
begin
    result := false;
    found := false;
    with (Tfrm_Run.Create(Application)) do begin
        for i := 0 to cb_PreSets.Items.Count-1 do begin
            if (CompareText(cb_PreSets.Items[i], profile) = 0) then begin
                cb_PreSets.ItemIndex := i;
                cb_PreSets.OnChange(cb_PreSets);
                found := true;
                break;
            end;
        end;
        if (not autorun) then begin
            result := ShowModal = mrOk;
        end
        else begin
            if (not found) then exit;
            lst := TStringList.Create;
            try
                lst.Delimiter := ' ';
                lst.QuoteChar := '"';
                lst.DelimitedText := ed_Args.Text;
                frm_UnCodeX.ExecuteProgram(ed_Exe.Text, lst, cb_Priority.ItemIndex);
                result := true;
            finally;
                lst.Free;
            end;
        end;
    end;
end;

{ HTML }
function acCreateHTMLFiles: boolean;
begin
    result := frm_UnCodeX.ac_CreateHTMLFiles.Execute;
end;

function acOpenOutput: boolean;
begin
    result := frm_UnCodeX.ac_OpenOutput.Execute;
end;

function acCreateHTMLHelp: boolean;
begin
    result := frm_UnCodeX.ac_HTMLHelp.Execute;
end;

function acOpenHTMLHelp: boolean;
begin
    result := frm_UnCodeX.ac_OpenHTMLHelp.Execute;
end;

{ Program }
function acSettings: boolean;
begin
    result := frm_UnCodeX.ac_Settings.Execute;
end;

function acSaveState: boolean;
begin
    result := frm_UnCodeX.ac_SaveState.Execute;
end;

function acLoadState: boolean;
begin
    result := frm_UnCodeX.ac_LoadState.Execute;
end;

function acAbout: boolean;
begin
    result := frm_UnCodeX.ac_About.Execute;
end;

function acClose: boolean;
begin
    result := frm_UnCodeX.ac_Close.Execute;
end;

function acAbort: boolean;
begin
    result := frm_UnCodeX.ac_Abort.Execute;
end;

{ Actions -- end }

function ExecuteCommandStack: boolean;
begin
    result := false;
    if (unit_main.IsBatching) then exit;
    result := true;
    frm_UnCodeX.NextBatchCommand;
end;

function IsBatching: boolean;
begin
    result := unit_main.IsBatching;
end;

procedure OpenSourceLine(uclass: TUClass; line, caret: integer);
begin
    frm_UnCodeX.OpenSourceLine(uclass, line, caret);
end;

procedure OpenSourceInLine(uclass: TUClass; line, caret: integer);
begin
    frm_UnCodeX.OpenSourceInLine(uclass, line, caret);
end;

procedure Sleep(time: cardinal);
var
    i: Cardinal;
begin
    i := GetTickCount;
    while (i > GetTickCount-time) do Application.ProcessMessages;
end;

procedure RegisterPSGui(ps: TPSScript);
begin
    if (frm_UnCodeX = nil) then exit;
    { Actions }
    ps.AddFunction(@acAbort, 'function acAbort: boolean;');
    ps.AddFunction(@acAbout, 'function acAbout: boolean;');
    ps.AddFunction(@acAnalyseAll, 'function acAnalyseAll: boolean;');
    ps.AddFunction(@acAnalyseModified, 'function acAnalyseModified: boolean;');
    ps.AddFunction(@acClose, 'function acClose: boolean;');
    ps.AddFunction(@acCompileClass, 'function acCompileClass: boolean;');
    ps.AddFunction(@acCopyName, 'function acCopyName: boolean;');
    ps.AddFunction(@acCreateHTMLFiles, 'function acCreateHTMLFiles: boolean;');
    ps.AddFunction(@acCreateHTMLHelp, 'function acCreateHTMLHelp: boolean;');
    ps.AddFunction(@acCreateSubClass, 'function acCreateSubClass: boolean;');
    ps.AddFunction(@acDeleteClass, 'function acDeleteClass: boolean;');
    ps.AddFunction(@acFindClass, 'function acFindClass: boolean;');
    ps.AddFunction(@acFindNext, 'function acFindNext: boolean;');
    ps.AddFunction(@acFindOrphans, 'function acFindOrphans: boolean;');
    ps.AddFunction(@acFullTextSearch, 'function acFullTextSearch: boolean;');
    ps.AddFunction(@acJoinServer, 'function acJoinServer: boolean;');
    ps.AddFunction(@acLoadState, 'function acLoadState: boolean;');
    ps.AddFunction(@acMoveClass, 'function acMoveClass: boolean;');
    ps.AddFunction(@acOpenClass, 'function acOpenClass: boolean;');
    ps.AddFunction(@acOpenHTMLHelp, 'function acOpenHTMLHelp: boolean;');
    ps.AddFunction(@acOpenOutput, 'function acOpenOutput: boolean;');
    ps.AddFunction(@acPackageProps, 'function acPackageProps: boolean;');
    ps.AddFunction(@acRebuildAnalyse, 'function acRebuildAnalyse: boolean;');
    ps.AddFunction(@acRecreateTree, 'function acRecreateTree: boolean;');
    ps.AddFunction(@acRenameClass, 'function acRenameClass: boolean;');
    ps.AddFunction(@acRun, 'function acRun: boolean;');
    ps.AddFunction(@acRunEx, 'function acRunEx(profile: string; autorun: boolean): boolean;');
    ps.AddFunction(@acRunServer, 'function acRunServer: boolean;');
    ps.AddFunction(@acSaveState, 'function acSaveState: boolean;');
    ps.AddFunction(@acSettings, 'function acSettings: boolean;');
    ps.AddFunction(@acSourceSnoop, 'function acSourceSnoop: boolean;');
    ps.AddFunction(@acSwitchTree, 'function acSwitchTree: boolean;');
    ps.AddFunction(@acTags, 'function acTags: boolean;');
    { Other gui things }
    ps.AddFunction(@ShowMessage, 'procedure ShowMessage(const Msg: string);');
    ps.AddFunction(@ShowMessageFmt, 'procedure ShowMessageFmt(const Msg: string; Params: array of const);');
    ps.AddFunction(@MInputQuery, 'function MInputQuery(const ACaption, APrompt: string; var Value: string): Boolean;');
    ps.AddFunction(@InputQuery, 'function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;');
    ps.AddFunction(@InputBox, 'function InputBox(const ACaption, APrompt, ADefault: string): string;');
    { Batch routines/etc. }
    ps.AddFunction(@ExecuteCommandStack, 'function ExecuteCommandStack: boolean;');
    ps.AddFunction(@IsBatching, 'function IsBatching: boolean;');
    //ps.AddFunction(@.., 'procedure ExecutePascalScript(const filename: string);');
    //check if running, then clone, return compile errors, return execution errors

    //procedure ExecuteProgram(exe: string; params: TStringList = nil; prio: integer = -1; show: integer = SW_SHOW);
    ps.AddFunction(@OpenSourceLine, 'procedure OpenSourceLine(uclass: TUClass; line, caret: integer);');
    ps.AddFunction(@OpenSourceInline, 'procedure OpenSourceInline(uclass: TUClass; line, caret: integer);');
    ps.AddFunction(@Sleep, 'procedure Sleep(time: cardinal);');

    { Variables }
    ps.AddRegisteredPTRVariable('SelectedUClass', 'TUClass');
    ps.AddRegisteredPTRVariable('SelectedUPackage', 'TUPackage');
    ps.AddRegisteredPTRVariable('ClassList', 'TUClassList');
    ps.AddRegisteredPTRVariable('PackageList', 'TUPackageList');
    ps.AddRegisteredPTRVariable('CommandStack', 'TStringList');
end;

procedure LinkPSGui(ps: TPSScript);
begin
    ps.SetPointerToData('SelectedUClass', @unit_main.SelectedUClass, ps.FindNamedType('TUClass'));
    ps.SetPointerToData('SelectedUPackage', @unit_main.SelectedUPackage, ps.FindNamedType('TUPackage'));
    ps.SetPointerToData('ClassList', @unit_main.ClassList, ps.FindNamedType('TUClassList'));
    ps.SetPointerToData('PackageList', @unit_main.PackageList, ps.FindNamedType('TUPackageList'));
    ps.SetPointerToData('CommandStack', @unit_main.CmdStack, ps.FindNamedType('TStringList'));
end;

end.
