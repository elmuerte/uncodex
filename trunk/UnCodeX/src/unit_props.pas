{-----------------------------------------------------------------------------
 Unit Name: unit_props
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   property inspector frame
 $Id: unit_props.pas,v 1.5 2004-03-27 14:14:21 elmuerte Exp $
-----------------------------------------------------------------------------}
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

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, StdCtrls, Buttons, ComCtrls, unit_uclasses, Clipbrd,
  ExtCtrls, Tabs;

type
  Tfr_Properties = class(TFrame)
    lv_Properties: TListView;
    lbl_InheritanceLevel: TLabel;
    ed_InheritanceLevel: TEdit;
    ud_InheritanceLevel: TUpDown;
    btn_Refresh: TBitBtn;
    il_Types: TImageList;
    pm_Props: TPopupMenu;
    mi_CopyToClipboard: TMenuItem;
    mi_InsertText: TMenuItem;
    mi_OpenLocation: TMenuItem;
    bcl_Spacer: TBevel;
    procedure lv_PropertiesInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure lv_PropertiesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lv_PropertiesClick(Sender: TObject);
    procedure mi_OpenLocationClick(Sender: TObject);
    procedure lv_PropertiesCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure btn_RefreshClick(Sender: TObject);
    procedure lv_PropertiesResize(Sender: TObject);
  private
    { Private declarations }
  public
  	uclass: TUClass;
    function LoadClass: boolean;
  end;

implementation

uses unit_main;

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

function Tfr_Properties.LoadClass: boolean;
var
  i, j: integer;
  pclass : TUClass;
  li: TListItem;
  return: string;
  lasttag: string;
begin
  lv_Properties.Items.BeginUpdate;
  lv_Properties.Items.Clear;

  li := lv_Properties.Items.Add;
  li.Caption := '-';
  li.SubItems.Add('Constants');
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
  	if ((j > 0) and (pclass.consts.Count > 0)) then begin
	  	li := lv_Properties.Items.Add;
  		li.Caption := '=';
	  	li.SubItems.Add(pclass.name);
      li.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.consts.Count-1 do begin
      li := lv_Properties.Items.Add;
      li.Caption := 'const';
      {if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.consts[i].name)
        else} li.SubItems.Add(pclass.consts[i].name);
      li.SubItems.Add(IntToStr(pclass.consts[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(pclass.consts[i].name+' = '+pclass.consts[i].value);
      li.SubItems.Add(pclass.consts[i].comment);
      li.Data := pclass;
      li.ImageIndex := 0;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;

  li := lv_Properties.Items.Add;
  li.Caption := '-';
  li.SubItems.Add('Variables');
  j := 0;
  pclass := uclass;
  pclass.properties.SortOnTag;
  lasttag := '';
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
  	if ((j > 0) and (pclass.properties.Count > 0)) then begin
	  	li := lv_Properties.Items.Add;
  		li.Caption := '=';
	  	li.SubItems.Add(pclass.name);
      li.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
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
      li := lv_Properties.Items.Add;
      li.Caption := 'var';
      {if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.properties[i].name)
        else} li.SubItems.Add(pclass.properties[i].name);
      li.SubItems.Add(IntToStr(pclass.properties[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(pclass.properties[i].ptype+' '+pclass.properties[i].name);
      li.SubItems.Add(pclass.properties[i].comment);
      li.Data := pclass;
      li.ImageIndex := 1;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;

  li := lv_Properties.Items.Add;
  li.Caption := '-';
  li.SubItems.Add('Enumerations');
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
  	if ((j > 0) and (pclass.enums.Count > 0)) then begin
	  	li := lv_Properties.Items.Add;
  		li.Caption := '=';
	  	li.SubItems.Add(pclass.name);
      li.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.enums.Count-1 do begin
      li := lv_Properties.Items.Add;
      li.Caption := 'enum';
      {if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.enums[i].name)
        else} li.SubItems.Add(pclass.enums[i].name);
      li.SubItems.Add(IntToStr(pclass.enums[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(pclass.enums[i].name+' = '+StringReplace(pclass.enums[i].options, ',', ', ', [rfReplaceAll]));
      li.SubItems.Add(pclass.enums[i].comment);
      li.Data := pclass;
      li.ImageIndex := 2;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;

  li := lv_Properties.Items.Add;
  li.Caption := '-';
  li.SubItems.Add('Structs');
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
  	if ((j > 0) and (pclass.structs.Count > 0)) then begin
	  	li := lv_Properties.Items.Add;
  		li.Caption := '=';
	  	li.SubItems.Add(pclass.name);
      li.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.structs.Count-1 do begin
      li := lv_Properties.Items.Add;
      li.Caption := 'struct';
      {if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.structs[i].name)
        else} li.SubItems.Add(pclass.structs[i].name);
      li.SubItems.Add(IntToStr(pclass.structs[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(pclass.structs[i].name);
      li.SubItems.Add(pclass.structs[i].comment);
      li.Data := pclass;
      li.ImageIndex := 3;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;

  li := lv_Properties.Items.Add;
  li.Caption := '-';
  li.SubItems.Add('Functions');
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
  	if ((j > 0) and (pclass.functions.Count > 0)) then begin
	  	li := lv_Properties.Items.Add;
  		li.Caption := '=';
	  	li.SubItems.Add(pclass.name);
      li.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.functions.Count-1 do begin
      li := lv_Properties.Items.Add;
      li.Caption := 'function';
      {if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.functions[i].name)
        else}
      lasttag := pclass.functions[i].name;
      if (pclass.functions[i].state <> nil) then begin
        lasttag := lasttag+' (state:'+pclass.functions[i].state.name+')';
      end;
      li.SubItems.Add(lasttag);
      li.SubItems.Add(IntToStr(pclass.functions[i].srcline));
      li.SubItems.Add(IntToStr(j));
      if ((pclass.functions[i].ftype = uftFunction) or (pclass.functions[i].ftype = uftEvent) or (pclass.functions[i].ftype = uftDelegate)) then begin
        if (pclass.functions[i].return = '') then return := ''
          else return := pclass.functions[i].return+' = ';
        li.SubItems.Add(return+pclass.functions[i].name+'( '+pclass.functions[i].params+' )');
        //li.SubItems.Add(pclass.functions[i].name+'('+pclass.functions[i].params+')');
      end
      else if (pclass.functions[i].ftype = uftPreOperator) then begin
        li.SubItems.Add(pclass.functions[i].return+' = '+pclass.functions[i].name+' '+ShiftString(pclass.functions[i].params, 2));
      end
      else if (pclass.functions[i].ftype = uftPostOperator) then begin
        li.SubItems.Add(pclass.functions[i].return+' = '+ShiftString(pclass.functions[i].params, 2)+' '+pclass.functions[i].name);
      end
      else if (pclass.functions[i].ftype = uftOperator) then begin
        li.SubItems.Add(pclass.functions[i].return+' = '+ShiftString(ShiftString(pclass.functions[i].params, 2, ','), 3)+' '+pclass.functions[i].name+' '+ShiftString(pclass.functions[i].params, 2));
      end;
      li.SubItems.Add(pclass.functions[i].comment);
      li.Data := pclass;
      if (pclass.functions[i].ftype = uftFunction) then li.ImageIndex := 4
      else if (pclass.functions[i].ftype = uftEvent) then li.ImageIndex := 5
      else if (pclass.functions[i].ftype = uftDelegate) then li.ImageIndex := 5 // delegate is an event
      else li.ImageIndex := 6;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  lv_Properties.Items.EndUpdate;

  lv_Properties.Columns.BeginUpdate;
  //if (Visible) then lv_Properties.Columns[1].Width := lv_Properties.ClientWidth-lv_Properties.Columns[0].Width
  //else if (lv_Properties.Items.Count > lv_Properties.VisibleRowCount) then lv_Properties.Columns[1].Width := lv_Properties.ClientWidth-lv_Properties.Columns[0].Width-GetSystemMetrics(SM_CXVSCROLL);
  lv_Properties.Columns.EndUpdate;
  result := true;
end;

procedure Tfr_Properties.lv_PropertiesInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: String);
begin
	if ((Item.Caption = '-') or (Item.Caption = '+')) then InfoTip := '';
  if (Item.Caption = '=') then InfoTip := Item.SubItems[1];
  if (Item.SubItems.Count < 5) then exit;
  InfoTip := Item.SubItems[3];
  if (Item.SubItems[4] <> '') then InfoTip := InfoTip+#13#10#13#10+StringReplace(Item.SubItems[4], #9, '', [rfReplaceAll]);
end;

procedure Tfr_Properties.lv_PropertiesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
	if (not Selected) then exit;
  if ((Item.Caption <> '-') and (Item.Caption <> '=')) then begin
    if (Item.SubItems.Count > 4) then Clipboard.SetTextBuf(PChar(Item.SubItems[4]))
    else Clipboard.SetTextBuf(PChar(Item.SubItems[0]));
  end;
end;

procedure Tfr_Properties.lv_PropertiesClick(Sender: TObject);
begin
	if (lv_Properties.Selected = nil) then exit;
  if (lv_Properties.Selected.Data = nil) then exit;
  if (frm_UnCodeX.Visible and frm_UnCodeX.mi_SourceSnoop.Checked) then
    frm_UnCodeX.OpenSourceInline(TUClass(lv_Properties.Selected.Data), StrToIntDef(lv_Properties.Selected.SubItems[1], 1)-1, 0);
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
    DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[0]), Length(Item.SubItems[0]), Rect, DT_CENTER or DT_VCENTER or DT_NOCLIP or DT_SINGLELINE	);
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
    DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[0]), Length(Item.SubItems[0]), Rect, DT_CENTER or DT_VCENTER or DT_NOCLIP or DT_SINGLELINE	);
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
    DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[0]), Length(Item.SubItems[0]), Rect, DT_CENTER or DT_VCENTER or DT_NOCLIP or DT_SINGLELINE	);
    SetBkMode(Sender.Canvas.Handle, oldMode);
  end
  else DefaultDraw := true;
end;

procedure Tfr_Properties.btn_RefreshClick(Sender: TObject);
begin
	LoadClass;
end;

procedure Tfr_Properties.lv_PropertiesResize(Sender: TObject);
begin
	lv_Properties.Columns[1].Width := lv_Properties.ClientWidth-lv_Properties.Columns[0].Width
end;

end.
