{*******************************************************************************
  Name:
    unit_props.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    UnrealScript Class property inpector frame

  $Id: unit_props.pas,v 1.25 2004-12-23 22:18:27 elmuerte Exp $
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

unit unit_props;

{$I defines.inc}

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, StdCtrls, Buttons, ComCtrls, unit_uclasses, Clipbrd,
  ExtCtrls, Tabs, Inifiles;

type
  Tfr_Properties = class(TFrame)
    lv_Properties: TListView;
    il_Types: TImageList;
    pm_Props: TPopupMenu;
    mi_CopyToClipboard: TMenuItem;
    mi_InsertText: TMenuItem;
    mi_OpenLocation: TMenuItem;
    pnl_Ctrls: TPanel;
    lbl_InheritanceLevel: TLabel;
    ed_InheritanceLevel: TEdit;
    ud_InheritanceLevel: TUpDown;
    bvl_Nothing: TBevel;
    btn_ShowBar: TBitBtn;
    mi_N1: TMenuItem;
    mi_Editexternalcomment1: TMenuItem;
    procedure lv_PropertiesInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure lv_PropertiesClick(Sender: TObject);
    procedure mi_OpenLocationClick(Sender: TObject);
    procedure lv_PropertiesCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure btn_RefreshClick(Sender: TObject);
    procedure lv_PropertiesResize(Sender: TObject);
    procedure btn_ShotBarClick(Sender: TObject);
    procedure mi_Editexternalcomment1Click(Sender: TObject);
    procedure mi_CopyToClipboardClick(Sender: TObject);
  private
    { Private declarations }
  public
    uclass: TUClass;
    function LoadClass: boolean;
  end;

  TTagEntry = class(TObject)
    uclass: TUClass;
    uprop: TUDeclaration;
    constructor Create(uc: TUClass; up: TUDeclaration);
  end;

implementation

uses unit_main, unit_analyse, unit_definitions, unit_utils,
  unit_ucxdocktree;

{$R *.dfm}

function ShiftString(input: string; piece: integer = 1; delims: string = ' '): string;
var
  i: integer;
begin
  while (piece > 0) do begin
    i := LastDelimiter(delims, input);
    Result := copy(input, i+1, MaxInt);
    Delete(input, i, MaxInt);
    Dec(piece);
  end;
end;

function MakeHint(hnt: string): string;
begin
  result := StringReplace(hnt, '<', '&lt;', [rfReplaceAll]);
  result := StringReplace(result, '>', '&gt;', [rfReplaceAll]);
end;

constructor TTagEntry.Create(uc: TUClass; up: TUDeclaration);
begin
  uclass := uc;
  uprop := up;
end;

function Tfr_Properties.LoadClass: boolean;
var
  i, j: integer;
  pclass: TUClass;
  li, lib, lic: TListItem;
  cnt: integer;
  return: string;
  lasttag: string;
begin
  result := false;
  lv_Properties.Items.BeginUpdate;
  lv_Properties.Items.Clear;

  if (uclass = nil) then begin
    lv_Properties.Items.EndUpdate;
    SetDockCaption(self, '');
    exit;
  end;
  SetDockCaption(self, uclass.FullName);

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Constants');
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.consts.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.consts.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := 'const';
      li.SubItems.AddObject(pclass.consts[i].name, pclass.consts[i]);

      li.SubItems.Add(IntToStr(pclass.consts[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(MakeHint(pclass.consts[i].name+' = '+pclass.consts[i].value));
      li.SubItems.Add(pclass.consts[i].comment);
      li.Data := pclass;
      li.ImageIndex := 0;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Variables');
  cnt := 0;
  j := 0;
  pclass := uclass;
  pclass.properties.SortOnTag;
  lasttag := '';
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.properties.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
      pclass.properties.SortOnTag;
      lasttag := '';
    end;
    for i := 0 to pclass.properties.Count-1 do begin
      if (CompareText(lasttag, pclass.properties[i].tag) <> 0) then begin
        li := lv_Properties.Items.Add;
        li.Caption := '+';
        li.SubItems.Add(pclass.properties[i].tag);
        lasttag := pclass.properties[i].tag;
      end;
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := 'var';
      li.SubItems.AddObject(pclass.properties[i].name, pclass.properties[i]);
      li.SubItems.Add(IntToStr(pclass.properties[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(MakeHint(pclass.properties[i].ptype+' '+pclass.properties[i].name));
      li.SubItems.Add(pclass.properties[i].comment);
      li.Data := pclass;
      li.ImageIndex := 1;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Enumerations');
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.enums.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.enums.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := 'enum';
      li.SubItems.AddObject(pclass.enums[i].name, pclass.enums[i]);
      li.SubItems.Add(IntToStr(pclass.enums[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(MakeHint(pclass.enums[i].name+' = '+StringReplace(pclass.enums[i].options, ',', ', ', [rfReplaceAll])));
      li.SubItems.Add(pclass.enums[i].comment);
      li.Data := pclass;
      li.ImageIndex := 2;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Structs');
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.structs.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.structs.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := 'struct';
      li.SubItems.AddObject(pclass.structs[i].name, pclass.structs[i]);
      li.SubItems.Add(IntToStr(pclass.structs[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(MakeHint(pclass.structs[i].name));
      li.SubItems.Add(pclass.structs[i].comment);
      li.Data := pclass;
      li.ImageIndex := 3;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Delegates');
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.delegates.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.delegates.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := 'delegate';
      li.SubItems.AddObject(pclass.delegates[i].name, pclass.delegates[i]);
      li.SubItems.Add(IntToStr(pclass.delegates[i].srcline));
      li.SubItems.Add(IntToStr(j));
      if (pclass.delegates[i].return = '') then return := ''
        else return := pclass.delegates[i].return+' = ';
      li.SubItems.Add(MakeHint(return+pclass.delegates[i].name+'( '+pclass.delegates[i].params+' )'));
      li.SubItems.Add(pclass.delegates[i].comment);
      li.Data := pclass;
      li.ImageIndex := 7 // delegate is an event
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Functions');
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.functions.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.functions.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := 'function';
      lasttag := pclass.functions[i].name;
      if (pclass.functions[i].state <> nil) then begin
        lasttag := lasttag+' (state:'+pclass.functions[i].state.name+')';
      end;
      li.SubItems.AddObject(lasttag, pclass.functions[i]);
      li.SubItems.Add(IntToStr(pclass.functions[i].srcline));
      li.SubItems.Add(IntToStr(j));
      if ((pclass.functions[i].ftype = uftFunction) or (pclass.functions[i].ftype = uftEvent) or (pclass.functions[i].ftype = uftDelegate)) then begin
        if (pclass.functions[i].return = '') then return := ''
          else return := pclass.functions[i].return+' = ';
        li.SubItems.Add(MakeHint(return+pclass.functions[i].name+'( '+pclass.functions[i].params+' )'));
        //li.SubItems.Add(pclass.functions[i].name+'('+pclass.functions[i].params+')');
      end
      else if (pclass.functions[i].ftype = uftPreOperator) then begin
        li.SubItems.Add(MakeHint(pclass.functions[i].return+' = '+pclass.functions[i].name+' '+ShiftString(pclass.functions[i].params, 2)));
      end
      else if (pclass.functions[i].ftype = uftPostOperator) then begin
        li.SubItems.Add(MakeHint(pclass.functions[i].return+' = '+ShiftString(pclass.functions[i].params, 2)+' '+pclass.functions[i].name));
      end
      else if (pclass.functions[i].ftype = uftOperator) then begin
        li.SubItems.Add(MakeHint(pclass.functions[i].return+' = '+ShiftString(ShiftString(pclass.functions[i].params, 2, ','), 3)+' '+pclass.functions[i].name+' '+ShiftString(pclass.functions[i].params, 2)));
      end;
      li.SubItems.Add(pclass.functions[i].comment);
      li.Data := pclass;
      if (pclass.functions[i].ftype = uftFunction) then li.ImageIndex := 4
      else if (pclass.functions[i].ftype = uftEvent) then li.ImageIndex := 5
      else if (pclass.functions[i].ftype = uftDelegate) then li.ImageIndex := 7 // delegate is an event
      else li.ImageIndex := 6;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('States');
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.states.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.states.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := 'state';
      lasttag := pclass.states[i].name;
      li.SubItems.AddObject(lasttag, pclass.states[i]);
      li.SubItems.Add(IntToStr(pclass.states[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(MakeHint(pclass.states[i].declaration));
      li.SubItems.Add(pclass.states[i].comment);
      li.Data := pclass;
      //li.ImageIndex := 6;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete;

  lv_Properties.Items.EndUpdate;
  result := true;
end;

procedure Tfr_Properties.lv_PropertiesInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: String);
begin
  if ((Item.Caption = '-') or (Item.Caption = '+')) then InfoTip := '';
  if (Item.Caption = '=') then InfoTip := Item.SubItems[1];
  if (Item.SubItems.Count < 5) then exit;
  InfoTip := '<div style="padding-left: 20px; text-indent: -18px; margin-left: -2px"><code>'+Item.SubItems[3]+'</code></div>';
  if (Item.SubItems[4] <> '') then InfoTip :=
    InfoTip+'<div style="background-color: ButtonFace; padding: 2px; margin-top: 5px; margin-left: -2px">'+
    StringReplace(Item.SubItems[4], #9, '', [rfReplaceAll])+'</div>';
end;

procedure Tfr_Properties.lv_PropertiesClick(Sender: TObject);
begin
  if (lv_Properties.Selected = nil) then exit;
  if (lv_Properties.Selected.Data = nil) then exit;
  if (frm_UnCodeX.Visible and frm_UnCodeX.mi_SourceSnoop.Checked) then begin
    frm_UnCodeX.OpenSourceInline(ResolveFilename(TUClass(lv_Properties.Selected.Data), TUDeclaration(lv_Properties.Selected.SubItems.Objects[0])),
      StrToIntDef(lv_Properties.Selected.SubItems[1], 1)-1, 0, TUClass(lv_Properties.Selected.Data));
  end;
end;

procedure Tfr_Properties.mi_OpenLocationClick(Sender: TObject);
begin
  if (lv_Properties.Selected = nil) then exit;
  if (lv_Properties.Selected.Data = nil) then exit;
  frm_UnCodeX.OpenSourceLine(TUClass(lv_Properties.Selected.Data), StrToIntDef(lv_Properties.Selected.SubItems[1], 0), 0);
end;

procedure Tfr_Properties.lv_PropertiesCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Rect: TRect;
  oldMode: integer;
begin
  if (Item.Caption = '-') then begin
    DefaultDraw := false;
    Rect := Item.DisplayRect(drBounds);
    Rect.Left := Rect.Left+1;
    DrawButtonFace(Sender.Canvas, Rect, 1, bsNew, false, false, false);
    Sender.Canvas.Font := Self.Font;
    oldMode := GetBkMode(Sender.Canvas.Handle);
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
    DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[0]), Length(Item.SubItems[0]), Rect, DT_CENTER or DT_VCENTER or DT_NOCLIP or DT_SINGLELINE   );
    SetBkMode(Sender.Canvas.Handle, oldMode);
  end
  else if (Item.Caption = '=') then begin
    DefaultDraw := false;
    Rect := Item.DisplayRect(drBounds);
    Rect.Left := Rect.Left+1;
    //DrawButtonFace(Sender.Canvas, Rect, 1, bsNew, false, false, false);
    Sender.Canvas.Brush.Color := clWindow;
    Sender.Canvas.FillRect(Rect);
    Sender.Canvas.Font := Self.Font;
    Sender.Canvas.Font.Color := clInfoText;
    DrawButtonFace(Sender.Canvas, Rect, 1, bsWin31, false, false, false);
    oldMode := GetBkMode(Sender.Canvas.Handle);
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
    DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[0]), Length(Item.SubItems[0]), Rect, DT_CENTER or DT_VCENTER or DT_NOCLIP or DT_SINGLELINE   );
    SetBkMode(Sender.Canvas.Handle, oldMode);
  end
  else if (Item.Caption = '+') then begin
    DefaultDraw := false;
    Rect := Item.DisplayRect(drBounds);
    Rect.Left := Rect.Left+1;
    //DrawButtonFace(Sender.Canvas, Rect, 1, bsNew, false, false, false);
    Sender.Canvas.Brush.Color := clInfoBk;
    Sender.Canvas.FillRect(Rect);
    Sender.Canvas.Font := Self.Font;
    Sender.Canvas.Font.Color := clInfoText;
    oldMode := GetBkMode(Sender.Canvas.Handle);
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
    DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[0]), Length(Item.SubItems[0]), Rect, DT_CENTER or DT_VCENTER or DT_NOCLIP or DT_SINGLELINE   );
    SetBkMode(Sender.Canvas.Handle, oldMode);
  end
  else DefaultDraw := true;
end;

procedure Tfr_Properties.btn_RefreshClick(Sender: TObject);
begin
  if (uclass <> nil) then LoadClass;
end;

procedure Tfr_Properties.lv_PropertiesResize(Sender: TObject);
begin
  try
    lv_Properties.Columns[1].Width := abs(lv_Properties.ClientWidth-lv_Properties.Columns[0].Width);
  except;
  end;
end;

procedure Tfr_Properties.btn_ShotBarClick(Sender: TObject);
begin
  pnl_Ctrls.Visible := not pnl_Ctrls.Visible;
  bvl_Nothing.Visible := not pnl_Ctrls.Visible;
end;

procedure Tfr_Properties.mi_Editexternalcomment1Click(Sender: TObject);
var
  ini: TMemIniFile;
  ref, comment: string;
  pclass: TUClass;
  uobj: TUObject;
  lst: TStringList;
begin
  try
    if (lv_Properties.Selected = nil) then exit;
    if (lv_Properties.Selected.Data = nil) then exit;
    pclass := TUClass(lv_Properties.Selected.Data);
    if (pclass = nil) then exit;
    uobj := TUObject(lv_Properties.Selected.SubItems.Objects[0]);
    if (uobj = nil) then exit;
  except
    exit;
  end;
  
  ini := TMemIniFile.Create(ExtCommentFile);
  ref := pclass.FullName+'.'+uobj.name;
  if (uobj.ClassType = TUFunction) then begin
    if (TUFunction(uobj).state <> nil) then ref := ref+' '+TUFunction(uobj).state.name;
  end;
  lst := TStringList.Create;
  try
    if ((uobj.CommentType = ctSource) and (uobj.comment <> '')) then begin
      if (MessageDlg('There already is a comment for this entity defined in the source code.'+#13+#10+
        'Setting an external comment will have no effect.'+#13+#10+
        'Are you sure you want to set an external comment?', mtWarning, [mbYes, mbNo], 0) = mrNo) then Exit;
    end;
    comment := uobj.comment;
    if (MInputQuery('Comment for '+ref, 'Please enter a comment (HTML can be used)', comment)) then begin
      ini.EraseSection(ref);
      ini.GetStrings(lst);
      lst.Add('['+ref+']');
      lst.Add(comment);
      ini.SetStrings(lst);
      ini.UpdateFile;
      if ((uobj.comment = '') or (uobj.CommentType = ctExtern)) then begin
        uobj.comment := comment;
        uobj.CommentType := ctExtern;
      end;
      TreeUpdated := true;
      SetExtCommentFile(ExtCommentFile);
    end;
  finally
    lst.Free;
    ini.Free;
  end;
end;

procedure Tfr_Properties.mi_CopyToClipboardClick(Sender: TObject);
begin
  if (lv_Properties.Selected = nil) then exit;
  if ((lv_Properties.Selected.Caption <> '-') and (lv_Properties.Selected.Caption <> '=')) then begin
    if (lv_Properties.Selected.SubItems.Count > 4) then Clipboard.SetTextBuf(PChar(lv_Properties.Selected.SubItems[4]))
    else Clipboard.SetTextBuf(PChar(lv_Properties.Selected.SubItems[0]));
  end;
end;

end.
