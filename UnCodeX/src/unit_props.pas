{*******************************************************************************
  Name:
    unit_props.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    UnrealScript Class property inpector frame

  $Id: unit_props.pas,v 1.37 2005/11/25 10:20:32 elmuerte Exp $
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
  ExtCtrls;

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
    mi_N2: TMenuItem;
    mi_Constants1: TMenuItem;
    mi_Variables1: TMenuItem;
    mi_Enumerations1: TMenuItem;
    mi_Structures1: TMenuItem;
    mi_Functions1: TMenuItem;
    mi_States1: TMenuItem;
    mi_Delegates1: TMenuItem;
    procedure lv_PropertiesInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure lv_PropertiesClick(Sender: TObject);
    procedure mi_OpenLocationClick(Sender: TObject);
    procedure btn_RefreshClick(Sender: TObject);
    procedure lv_PropertiesResize(Sender: TObject);
    procedure btn_ShotBarClick(Sender: TObject);
    procedure mi_Editexternalcomment1Click(Sender: TObject);
    procedure mi_CopyToClipboardClick(Sender: TObject);
    procedure mi_Constants1Click(Sender: TObject);
    procedure mi_Variables1Click(Sender: TObject);
    procedure mi_Enumerations1Click(Sender: TObject);
    procedure mi_Structures1Click(Sender: TObject);
    procedure mi_Delegates1Click(Sender: TObject);
    procedure mi_Functions1Click(Sender: TObject);
    procedure mi_States1Click(Sender: TObject);
    procedure lv_PropertiesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  protected
    liConst: TListItem;
    liVar: TListItem;
    liEnum: TListItem;
    liStruct: TListItem;
    liDelegate: TListItem;
    liFunction: TListItem;
    liState: TListItem;
    halfColor: string;
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

uses
  {$IFDEF FULLGUI}
  unit_main, unit_ucxdocktree,
  {$ENDIF}
  {$IFDEF VSADDIN}
  unit_ucxdotnetcore,
  {$ENDIF}
  unit_analyse, unit_definitions, unit_utils, unit_ucxinifiles,
  unit_comment2doc;

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

constructor TTagEntry.Create(uc: TUClass; up: TUDeclaration);
begin
  uclass := uc;
  uprop := up;
end;

function Tfr_Properties.LoadClass: boolean;

  procedure CreateHalfColor();
  var
    r,g,b: cardinal;
  begin
    r := ((GetSysColor(COLOR_WINDOW) and $ff0000) + (GetSysColor(COLOR_BTNFACE) and $ff0000)) div 2 div $ffff;
    g := ((GetSysColor(COLOR_WINDOW) and $ff00) +   (GetSysColor(COLOR_BTNFACE) and $ff00)) div 2 div $ff;
    b := ((GetSysColor(COLOR_WINDOW) and $ff) +     (GetSysColor(COLOR_BTNFACE) and $ff)) div 2;
    halfColor := '#'+IntToHex(r, 2)+IntToHex(g, 2)+IntToHex(b, 2);
  end;

var
  i, j: integer;
  pclass: TUClass;
  li, lib, lic: TListItem;
  cnt: integer;
  lasttag, tmp: string;
begin
  result := false;
  lv_Properties.Items.BeginUpdate;

  liConst:= nil;
  liVar:= nil;
  liEnum:= nil;
  liStruct:= nil;
  liDelegate:= nil;
  liFunction:= nil;
  liState:= nil;

  lv_Properties.Items.Clear;

  if (uclass = nil) then begin
    lv_Properties.Items.EndUpdate;
    {$IFDEF FULLGUI}
    SetDockCaption(self, '');
    {$ENDIF}
    exit;
  end;
  xguard('Tfr_Properties.LoadClass');
  {$IFDEF FULLGUI}
  SetDockCaption(self, uclass.FullName);
  {$ENDIF}

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Constants');
  lib.ImageIndex := -1;
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.consts.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.ImageIndex := -1;
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.consts.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := pclass.consts[i].name;
      li.SubItems.AddObject('const', pclass.consts[i]);

      li.SubItems.Add(IntToStr(pclass.consts[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(''); // copy to clipboard
      li.SubItems.Add(pclass.consts[i].comment);
      li.SubItems.Add('');
      li.Data := pclass;
      li.ImageIndex := 0;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete
  else liConst := lib;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Variables');
  lib.ImageIndex := -1;
  cnt := 0;
  j := 0;
  pclass := uclass;
  pclass.properties.SortOnTag;
  lasttag := '';
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.properties.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.ImageIndex := -1;
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
      pclass.properties.SortOnTag;
      lasttag := '';
    end;
    for i := 0 to pclass.properties.Count-1 do begin
      if (CompareText(lasttag, pclass.properties[i].tag) <> 0) then begin
        li := lv_Properties.Items.Add;
        li.Caption := '+';
        li.ImageIndex := -1;
        li.SubItems.Add(pclass.properties[i].tag);
        lasttag := pclass.properties[i].tag;
      end;
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := pclass.properties[i].name;
      li.SubItems.AddObject('var', pclass.properties[i]);

      li.SubItems.Add(IntToStr(pclass.properties[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(''); // copy to clipboard
      li.SubItems.Add(pclass.properties[i].comment);
      tmp := pclass.properties[i].name;
      li.SubItems.Add(pclass.GetReplication(GetToken(tmp, '[', true)));
      li.Data := pclass;
      li.ImageIndex := 1;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete
  else liVar := lib;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Enumerations');
  lib.ImageIndex := -1;
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.enums.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.ImageIndex := -1;
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.enums.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := pclass.enums[i].name;
      li.SubItems.AddObject('enum', pclass.enums[i]);

      li.SubItems.Add(IntToStr(pclass.enums[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add('');  // copy to clipboard
      li.SubItems.Add(pclass.enums[i].comment);
      li.SubItems.Add('');
      li.Data := pclass;
      li.ImageIndex := 2;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete
  else liEnum := lib;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Structs');
  lib.ImageIndex := -1;
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.structs.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.ImageIndex := -1;
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.structs.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := pclass.structs[i].name;
      li.SubItems.AddObject('struct', pclass.structs[i]);

      li.SubItems.Add(IntToStr(pclass.structs[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add('');  // copy to clipboard
      li.SubItems.Add(pclass.structs[i].comment);
      li.SubItems.Add('');
      li.Data := pclass;
      li.ImageIndex := 3;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete
  else liStruct := lib;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Delegates');
  lib.ImageIndex := -1;
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.delegates.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.ImageIndex := -1;
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.delegates.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := pclass.delegates[i].name;
      li.SubItems.AddObject('delegate', pclass.delegates[i]);

      li.SubItems.Add(IntToStr(pclass.delegates[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(pclass.delegates[i].name+'()');  // copy to clipboard
      li.SubItems.Add(pclass.delegates[i].comment);
      li.SubItems.Add('');
      li.Data := pclass;
      li.ImageIndex := 7 // delegate is an event
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete
  else liDelegate := lib;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('Functions');
  lib.ImageIndex := -1;
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.functions.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.ImageIndex := -1;
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.functions.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      lasttag := pclass.functions[i].name;
      if (pclass.functions[i].state <> nil) then begin
        lasttag := lasttag+' (state:'+pclass.functions[i].state.name+')';
      end;
      li.Caption := lasttag;
      li.SubItems.AddObject('function', pclass.functions[i]);
      li.SubItems.Add(IntToStr(pclass.functions[i].srcline));
      li.SubItems.Add(IntToStr(j));
      if ((pclass.functions[i].ftype = uftFunction) or (pclass.functions[i].ftype = uftEvent))
        then li.SubItems.Add(pclass.functions[i].name+'()')  // copy to clipboard
      else li.SubItems.Add('');
      li.SubItems.Add(pclass.functions[i].comment);
      li.SubItems.Add(pclass.GetReplication(pclass.functions[i].name));
      li.Data := pclass;
      if (pclass.functions[i].ftype = uftFunction) then li.ImageIndex := 4
      else if (pclass.functions[i].ftype = uftEvent) then li.ImageIndex := 5
      else if (pclass.functions[i].ftype = uftDelegate) then li.ImageIndex := 7 // delegate is an event
      else li.ImageIndex := 6;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete
  else liFunction := lib;

  lib := lv_Properties.Items.Add;
  lib.Caption := '-';
  lib.SubItems.Add('States');
  lib.ImageIndex := -1;
  cnt := 0;
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    if ((j > 0) and (pclass.states.Count > 0)) then begin
      lic := lv_Properties.Items.Add;
      lic.Caption := '=';
      lic.ImageIndex := -1;
      lic.SubItems.Add(pclass.name);
      lic.SubItems.Add(pclass.package.path+PathDelim+pclass.filename);
    end;
    for i := 0 to pclass.states.Count-1 do begin
      Inc(cnt);
      li := lv_Properties.Items.Add;
      li.Caption := pclass.states[i].name;
      li.SubItems.AddObject('state', pclass.states[i]);
      li.SubItems.Add(IntToStr(pclass.states[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.SubItems.Add(''); // copy to clipboard
      li.SubItems.Add(pclass.states[i].comment);
      li.SubItems.Add('');
      li.Data := pclass;
      li.ImageIndex := 8;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  if (cnt = 0) then lib.Delete
  else liState := lib;

  mi_Constants1.Visible := liConst <> nil;
  mi_Variables1.Visible := liVar <> nil;
  mi_Enumerations1.Visible := liEnum <> nil;
  mi_Structures1.Visible := liStruct <> nil;
  mi_Delegates1.Visible := liDelegate <> nil;
  mi_Functions1.Visible := liFunction <> nil;
  mi_States1.Visible := liState <> nil;

  lv_Properties.Items.EndUpdate;

  //if (visible) then lv_Properties.Columns[0].Width := abs(lv_Properties.ClientWidth);
  if (Visible) then lv_Properties.Refresh;

  CreateHalfColor();

  result := true;
  xunguard;
end;

procedure Tfr_Properties.lv_PropertiesInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: String);
begin
  if (Item.ImageIndex = -1) then begin
    if ((Item.Caption = '-') or (Item.Caption = '+')) then InfoTip := '';
    if (Item.Caption = '=') then InfoTip := Item.SubItems[1];
  end;
  if (Item.SubItems.Count < 6) then exit;
  InfoTip := '<div style="padding-left: 20px; text-indent: -18px; margin-left: -2px"><code>'+TUDeclaration(Item.SubItems.Objects[0]).HTMLdeclaration+'</code></div>';
  if (Item.SubItems[4] <> '') then InfoTip :=
    InfoTip+'<div style="background-color: ButtonFace; padding: 2px; margin-top: 5px; margin-left: -2px">'+
    StringReplace(convertComment(Item.SubItems[4]), #9, ' ', [rfReplaceAll])+'</div>';
  if (Item.SubItems[5] <> '') then InfoTip :=
    InfoTip + '<div style="padding-left: 20px; text-indent: -18px; margin-left: -2px; background-color: '+halfColor+';"><em>Replication:</em><br /><code>'+Item.SubItems[5]+'</code></div>';
end;

procedure Tfr_Properties.lv_PropertiesClick(Sender: TObject);
begin
  if (lv_Properties.Selected = nil) then exit;
  if (lv_Properties.Selected.Data = nil) then exit;
  {$IFDEF FULLGUI}
  if (frm_UnCodeX.Visible and frm_UnCodeX.mi_SourceSnoop.Checked) then begin
    frm_UnCodeX.OpenSourceInline(ResolveFilename(TUClass(lv_Properties.Selected.Data), TUDeclaration(lv_Properties.Selected.SubItems.Objects[0])),
        StrToIntDef(lv_Properties.Selected.SubItems[1], 1)-1, 0, TUClass(lv_Properties.Selected.Data));
  end;
  {$ENDIF}
  //TODO: addin version
end;

procedure Tfr_Properties.mi_OpenLocationClick(Sender: TObject);
begin
  if (lv_Properties.Selected = nil) then exit;
  if (lv_Properties.Selected.Data = nil) then exit;
  {$IFDEF FULLGUI}
  frm_UnCodeX.OpenSourceLine(ResolveFilename(TUClass(lv_Properties.Selected.Data), TUDeclaration(lv_Properties.Selected.SubItems.Objects[0])),
      StrToIntDef(lv_Properties.Selected.SubItems[1], 0), 0, TUClass(lv_Properties.Selected.Data));
  {$ENDIF}
  //TODO: addin version
end;

procedure Tfr_Properties.btn_RefreshClick(Sender: TObject);
begin
  if (uclass <> nil) then LoadClass;
end;

procedure Tfr_Properties.lv_PropertiesResize(Sender: TObject);
begin
  try
    lv_Properties.Columns[0].Width := abs(lv_Properties.ClientWidth);
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
  ini: TUCXIniFile;
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

  {$IFDEF FULLGUI}
  ini := TUCXIniFile.Create(config.Comments.Declarations);
  {$ENDIF}
  {$IFDEF VSADDIN}
  ini := TUCXIniFile.Create(ucxcore.config.Comments.Declarations);
  {$ENDIF}
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
      lst.Text := comment;
      ini.WriteSectionRaw(ref, lst);
      ini.UpdateFile;
      if ((uobj.comment = '') or (uobj.CommentType = ctExtern)) then begin
        uobj.comment := comment;
        uobj.CommentType := ctExtern;
      end;
      TreeUpdated := true;
      {$IFDEF FULLGUI}
      SetExtCommentFile(config.Comments.Declarations);
      {$ENDIF}
      {$IFDEF VSADDIN}
      SetExtCommentFile(ucxcore.config.Comments.Declarations);
      {$ENDIF}
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
    if (lv_Properties.Selected.SubItems[3] <> '') then Clipboard.SetTextBuf(PChar(lv_Properties.Selected.SubItems[3]))
    else Clipboard.SetTextBuf(PChar(lv_Properties.Selected.Caption));
  end;
end;

procedure Tfr_Properties.mi_Constants1Click(Sender: TObject);
begin
  if (liConst <> nil) then liConst.MakeVisible(false);
end;

procedure Tfr_Properties.mi_Variables1Click(Sender: TObject);
begin
  if (liVar <> nil) then liVar.MakeVisible(false);
end;

procedure Tfr_Properties.mi_Enumerations1Click(Sender: TObject);
begin
  if (liEnum <> nil) then liEnum.MakeVisible(false);
end;

procedure Tfr_Properties.mi_Structures1Click(Sender: TObject);
begin
  if (liStruct <> nil) then liStruct.MakeVisible(false);
end;

procedure Tfr_Properties.mi_Delegates1Click(Sender: TObject);
begin
  if (liDelegate <> nil) then liDelegate.MakeVisible(false);
end;

procedure Tfr_Properties.mi_Functions1Click(Sender: TObject);
begin
  if (liFunction <> nil) then liFunction.MakeVisible(false);
end;

procedure Tfr_Properties.mi_States1Click(Sender: TObject);
begin
  if (liState <> nil) then liState.MakeVisible(false);
end;

procedure Tfr_Properties.lv_PropertiesCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  Rect: TRect;
  oldMode: integer;
begin
  if (Item.ImageIndex = -1) then begin
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
    end;
  end
  else DefaultDraw := true;
end;

end.
