unit unit_tags;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unit_uclasses, ComCtrls, StdCtrls, Buttons, ImgList, Clipbrd;

type
  Tfrm_Tags = class(TForm)
    lv_Properties: TListView;
    ed_InheritanceLevel: TEdit;
    ud_InheritanceLevel: TUpDown;
    lbl_InheritanceLevel: TLabel;
    btn_Refresh: TBitBtn;
    il_Types: TImageList;
    btn_MakeWindow: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_RefreshClick(Sender: TObject);
    procedure lv_PropertiesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lv_PropertiesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_PropertiesClick(Sender: TObject);
  private
    procedure WMActivate(var Message: TWMActivate); message WM_Activate;
  public
    isWindow: boolean;
    uclass: TUClass;
    function LoadClass: boolean;
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frm_Tags: Tfrm_Tags;

implementation

uses unit_main;

{$R *.dfm}

function GetCaretPosition(var APoint: TPoint): Boolean;
var
  w: HWND;
  aID, mID: DWORD;
begin
  Result:= False;
  w:= GetForegroundWindow;
  if w <> 0 then
  begin
    aID:= GetWindowThreadProcessId(w, nil);
    mID:= GetCurrentThreadid;
    if aID <> mID then
    begin
      if AttachThreadInput(mID, aID, True) then
      begin
        w:= GetFocus;
        if w <> 0 then
        begin
          Result:= GetCaretPos(APoint);
          Windows.ClientToScreen(w, APoint);
        end;
        AttachThreadInput(mID, aID, False);
      end;
    end;
  end;
end;

function Tfrm_Tags.LoadClass: boolean;
var
  i, j: integer;
  pclass : TUClass;
  li: TListItem;
begin
  if (uclass = nil) then begin
    Self.Free;
    result := false;
    exit;
  end;
  Caption := uclass.name;

  lv_Properties.Items.BeginUpdate;
  lv_Properties.Items.Clear;

  li := lv_Properties.Items.Add;
  li.Caption := '-';
  li.SubItems.Add('Constants');
  j := 0;
  pclass := uclass;
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    for i := 0 to pclass.consts.Count-1 do begin
      li := lv_Properties.Items.Add;
      li.Caption := 'const';
      if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.consts[i].name)
        else li.SubItems.Add(pclass.consts[i].name);
      li.SubItems.Add(IntToStr(pclass.consts[i].srcline));
      li.SubItems.Add(IntToStr(j));
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
  while (j <= ud_InheritanceLevel.Position) and (pclass <> nil) do begin
    for i := 0 to pclass.properties.Count-1 do begin
      li := lv_Properties.Items.Add;
      li.Caption := 'var';
      if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.properties[i].name)
        else li.SubItems.Add(pclass.properties[i].name);
      li.SubItems.Add(IntToStr(pclass.properties[i].srcline));
      li.SubItems.Add(IntToStr(j));
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
    for i := 0 to pclass.enums.Count-1 do begin
      li := lv_Properties.Items.Add;
      li.Caption := 'enum';
      if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.enums[i].name)
        else li.SubItems.Add(pclass.enums[i].name);
      li.SubItems.Add(IntToStr(pclass.enums[i].srcline));
      li.SubItems.Add(IntToStr(j));
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
    for i := 0 to pclass.structs.Count-1 do begin
      li := lv_Properties.Items.Add;
      li.Caption := 'struct';
      if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.structs[i].name)
        else li.SubItems.Add(pclass.structs[i].name);
      li.SubItems.Add(IntToStr(pclass.structs[i].srcline));
      li.SubItems.Add(IntToStr(j));
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
    for i := 0 to pclass.functions.Count-1 do begin
      li := lv_Properties.Items.Add;
      li.Caption := 'function';
      if (j > 0) then li.SubItems.Add(pclass.name+'.'+pclass.functions[i].name)
        else li.SubItems.Add(pclass.functions[i].name);
      li.SubItems.Add(IntToStr(pclass.functions[i].srcline));
      li.SubItems.Add(IntToStr(j));
      li.Data := pclass;
      if (pclass.functions[i].ftype = uftFunction) then li.ImageIndex := 4
      else if (pclass.functions[i].ftype = uftEvent) then li.ImageIndex := 5
      else li.ImageIndex := 6;
    end;
    pclass := pclass.parent;
    Inc(j);
  end;
  lv_Properties.Items.EndUpdate;

  lv_Properties.Columns.BeginUpdate;
  if (Visible) then lv_Properties.Columns[1].Width := lv_Properties.ClientWidth-lv_Properties.Columns[0].Width
  else if (lv_Properties.Items.Count > lv_Properties.VisibleRowCount) then lv_Properties.Columns[1].Width := lv_Properties.ClientWidth-lv_Properties.Columns[0].Width-GetSystemMetrics(SM_CXVSCROLL);
  lv_Properties.Columns.EndUpdate;

  Caption := IntToStr(lv_Properties.Columns[1].Width);
  result := true;
end;

procedure Tfrm_Tags.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := WS_EX_TOOLWINDOW or WS_EX_NOPARENTNOTIFY or WS_EX_APPWINDOW;
  Params.Style := WS_POPUPWINDOW or WS_SYSMENU or WS_SIZEBOX;
  Params.WndParent := GetDesktopWindow;
end;

procedure Tfrm_Tags.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if (Message.Active = WA_INACTIVE) then begin
    if (not isWindow) then begin
      if (Message.ActiveWindow = frm_UnCodeX.Handle) then begin
        if (not InitActivateFix) then Close;
      end
      else close;
    end;
  end;
end;

procedure Tfrm_Tags.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tfrm_Tags.btn_RefreshClick(Sender: TObject);
begin
  LoadClass;
end;

procedure Tfrm_Tags.lv_PropertiesCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Rect: TRect;
  oldMode: integer;
begin
  if (Item.Caption = '-') then begin
    DefaultDraw := false;
    Rect := Item.DisplayRect(drBounds);
    Rect.Left := Rect.Left+1;
    DrawButtonFace(Sender.Canvas, Rect, 2, bsNew, false, false, false);
    Sender.Canvas.Font := Self.Font;
    oldMode := GetBkMode(Sender.Canvas.Handle);
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
    DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[0]), Length(Item.SubItems[0]), Rect, DT_CENTER or DT_VCENTER or DT_NOCLIP or DT_SINGLELINE	);
    SetBkMode(Sender.Canvas.Handle, oldMode);
  end
  else DefaultDraw := true;
end;

procedure Tfrm_Tags.lv_PropertiesDblClick(Sender: TObject);
begin
  if (lv_Properties.Selected = nil) then exit;
  if (lv_Properties.Selected.Data = nil) then exit;
  frm_UnCodeX.OpenSourceLine(TUClass(lv_Properties.Selected.Data), StrToIntDef(lv_Properties.Selected.SubItems[1], 0), 0);
end;

procedure Tfrm_Tags.FormCreate(Sender: TObject);
var
  pt: TPoint;
begin
  isWindow := false;
  if (GetCaretPosition(pt)) then begin
    Left := pt.X;
    Top := pt.Y;
  end
  else begin
    Left := Mouse.CursorPos.X-16;
    Top := Mouse.CursorPos.Y-16;
    if (Left+Width > Screen.Width) then Left := Screen.Width-Width;
    if (Top+Height > Screen.Height) then Top := Screen.Height-Height;
  end;
end;

procedure Tfrm_Tags.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then Close;
end;

procedure Tfrm_Tags.FormDblClick(Sender: TObject);
begin
  isWindow := true;
  SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or WS_CAPTION);
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_DRAWFRAME or SWP_NOMOVE or SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;

procedure Tfrm_Tags.FormShow(Sender: TObject);
begin
  SetActiveWindow(Handle);
end;

procedure Tfrm_Tags.lv_PropertiesClick(Sender: TObject);
begin
  if (lv_Properties.Selected.Caption <> '-') then
    Clipboard.SetTextBuf(PChar(lv_Properties.Selected.SubItems[0]));
end;

end.
