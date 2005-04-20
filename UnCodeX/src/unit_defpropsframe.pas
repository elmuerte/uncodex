unit unit_defpropsframe;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, unit_uclasses, Menus;

type
  Tfr_DefPropsBrowser = class(TFrame)
    spl_Main: TSplitter;
    gb_Property: TGroupBox;
    lbl_EffValue: TLabel;
    lbl_DefinedIn: TLabel;
    lbl_Type: TLabel;
    lv_SelProperty: TListView;
    ed_EffValue: TEdit;
    ed_DefIn: TEdit;
    ed_type: TEdit;
    tv_Properties: TTreeView;
    mi_defprop: TPopupMenu;
    mi_Findavariable1: TMenuItem;
    procedure tv_PropertiesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure spl_MainMoved(Sender: TObject);
    procedure tv_PropertiesChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure tv_PropertiesChange(Sender: TObject; Node: TTreeNode);
    procedure tv_PropertiesAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure lv_SelPropertyDblClick(Sender: TObject);
    procedure mi_Findavariable1Click(Sender: TObject);
  protected
  public
    uclass: TUClass;
    procedure LoadDefProps;
    procedure AddVariable(vname,vvalue: string; dclass: TUClass);
    procedure AddProperty(uprop: TUProperty);
    function RegisterProperty(name: string; base: TUClass): boolean;
    procedure Clear;
  end;

  TDefPropEntry = class
    Name: string;
    Tag: string;
    Prop: TUProperty;
    Dimension: integer;
    Values: TStringList;
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses unit_definitions, unit_defprops, strutils;

{$R *.dfm}

constructor TDefPropEntry.Create;
begin
  Values := TStringList.Create;
  inherited Create;
end;

destructor TDefPropEntry.Destroy;
begin
  FreeAndNil(Values);
  inherited Destroy;
end;

procedure Tfr_DefPropsBrowser.AddVariable(vname,vvalue: string; dclass: TUClass);
var
  i, index: integer;
  tmp: string;
  tn: TTreeNode;
  pass: integer;
begin
  index := -1;
  i := Pos('[', vname);
  if (i = 0) then i := Pos('[', vname);
  if (i <> 0) then begin
    tmp := Copy(vname, 1, i-1);
    index := StrToIntDef(Copy(vname, i+1, length(vname)-i-1), -1);
  end
  else tmp := vname;

  pass := 0;     
  tn := nil;
  while (tn = nil) do begin
    Inc(pass);
    for i := 0 to tv_Properties.Items.Count-1 do begin
      if (SameText(tv_Properties.Items[i].Text, tmp) and (tv_Properties.Items[i].Level = 1)) then begin
        tn := tv_Properties.Items[i];
        if ((index > -1) and (index < tn.Count)) then begin
          tn := tn.Item[index];
        end;
        break;
      end;
    end;
    if (tn = nil) then begin
      if (pass = 1) then begin
        if (not RegisterProperty(tmp, dclass)) then exit;
      end
      else begin
        //MessageDlg('Unknown defaultproperty entry: '''+vname+'''', mtError, [mbOK], 0);
        // mostlikely deleted because of hide categories
        exit;
      end;
    end;
  end;
  
  with TDefPropEntry(tn.data) do begin
    Values.AddObject(vvalue, dclass);
  end;
end;

procedure Tfr_DefPropsBrowser.AddProperty(uprop: TUProperty);
var
  i: integer;
  tn, tns: TTreeNode;
begin
  // get category
  tn := nil;
  for i := 0 to tv_Properties.Items.Count-1 do begin
    if (SameText(tv_Properties.Items[i].Text, uprop.tag) and (tv_Properties.Items[i].Level = 0)) then begin
      tn := tv_Properties.Items[i];
      break;
    end;
  end;
  if (tn = nil) then begin
    tn := tv_Properties.Items.Add(nil, uprop.tag);
  end;

  tn := tv_Properties.Items.AddChild(tn, uprop.CleanName);
  tn.Data := TDefPropEntry.Create;
  with TDefPropEntry(tn.Data) do begin
    Name := uprop.Name;
    Tag := uprop.tag;
    Dimension := uprop.GetDimension;
    Prop := uprop;
    // add dimensions
    for i := 0 to Dimension-1 do begin
      tns := tv_Properties.Items.AddChild(tn, '['+IntToStr(i)+']');
      tns.Data := TDefPropEntry.Create;
    end;
  end;
end;

function Tfr_DefPropsBrowser.RegisterProperty(name: string; base: TUClass): boolean;
var
  uprop: TUProperty;
  i: integer;
begin
  result := false;
  i := Pos('[', name);
  if (i = 0) then i := Pos('[', name);
  if (i <> 0) then begin
    Delete(Name, i, MaxInt);
  end;

  while (base <> nil) do begin
    uprop := base.properties.FindEx(name);
    if (uprop <> nil) then begin
      AddProperty(uprop);
      result := true;
      exit;
    end;
    base := base.parent;
  end;
end;

procedure Tfr_DefPropsBrowser.LoadDefProps;
var
  i: integer;
  sl: TStringList;
  pclass: TUClass;
  s: string;
begin
  xguard('Tfrm_DefPropsBrowser.LoadDefProps');
  sl := TStringList.Create;
  tv_Properties.Items.BeginUpdate;
  Clear;
  tv_Properties.Items.Clear;
  try
    pclass := uclass;
    while (pclass <> nil) do begin
      sl.Clear;
      sl.Text := pclass.defaultproperties.data;
      i := 0;
      while (i < sl.Count) do begin
        s := trim(sl.Names[i]);
        // if begin object -> remove
        if (SameText('begin ', Copy(s, 1, 6))) then begin
          repeat
            Inc(i);
            s := trim(sl.Names[i]);
          until (SameText('end ', Copy(s, 1, 4)) or (i >= sl.Count-1));
          Inc(i);
          continue;
        end;
        if (s <> '') then begin
          AddVariable(s, sl.Values[sl.Names[i]], pclass);
        end;
        Inc(i);
      end;
      pclass := pclass.parent;
    end;
    tv_Properties.AlphaSort(true);
    if (tv_Properties.Items.Count > 1) then tv_Properties.Select(tv_Properties.TopItem.getFirstChild);
  finally
    sl.Free;
    tv_Properties.Items.EndUpdate;
  end;
  xunguard;
end;

procedure Tfr_DefPropsBrowser.Clear;
var
  i: integer;
begin
  xguard('Tfrm_DefPropsBrowser.Clear');
  tv_Properties.Items.BeginUpdate;
  for i := tv_Properties.Items.Count-1 downto 0 do begin
    if (tv_Properties.Items[i].Data <> nil) then begin
      TDefPropEntry(tv_Properties.Items[i].Data).Free;
      tv_Properties.Items[i].Data := nil;
    end;
  end;
  tv_Properties.Items.EndUpdate;
  xunguard;
end;

procedure Tfr_DefPropsBrowser.tv_PropertiesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  prev: TTreeNode;
begin
  if (Key = VK_UP) then begin
    if (tv_Properties.Selected.Parent <> nil) then begin
      if (tv_Properties.Selected.Parent.getFirstChild = tv_Properties.Selected) then begin
        Key := 0;
        if (tv_Properties.Selected.Parent.Level = 0) then begin
          prev := tv_Properties.Selected.Parent.getPrevSibling;
          if (prev <> nil) then tv_Properties.Select(prev.GetLastChild);
        end
        else if (tv_Properties.Selected.Parent.Level = 1) then begin
          prev := tv_Properties.Selected.Parent.getPrevSibling;
          if (prev <> nil) then tv_Properties.Select(prev);
        end;
      end
      else begin
        prev := tv_Properties.Selected.getPrevSibling;
        if (prev <> nil) then begin
          if (prev.Count > 0) then begin
            Key := 0;
            tv_Properties.Select(prev.GetLastChild);
          end;
        end;
      end
    end;
  end;
end;

procedure Tfr_DefPropsBrowser.spl_MainMoved(Sender: TObject);
begin
  tv_Properties.Invalidate;
end;

procedure Tfr_DefPropsBrowser.tv_PropertiesChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  if (tv_Properties.Selected = nil) then exit;
  if (Node <> tv_Properties.Selected) then begin
    if (tv_Properties.Selected.Parent <> Node.Parent) then begin
      if (tv_Properties.Selected.Parent <> nil) then tv_Properties.Selected.Parent.Collapse(true)
    end
    else if (tv_Properties.Selected.Parent <> Node) then tv_Properties.Selected.Collapse(false);
  end;
end;

procedure Tfr_DefPropsBrowser.tv_PropertiesChange(Sender: TObject;
  Node: TTreeNode);
var
  i: integer;
  li: TListItem;
  data: TDefPropEntry;
begin
  if (tv_Properties.Selected = nil) then exit;
  if (Node = tv_Properties.Selected) then Node.Expand(false);
  if (tv_Properties.Selected.Level = 0) then begin
    tv_Properties.Select(tv_Properties.Selected.getFirstChild);
    exit;
  end;
  if (tv_Properties.Selected.Level = 1) then begin
    if (tv_Properties.Selected.Count > 0) then begin
      tv_Properties.Select(tv_Properties.Selected.getFirstChild);
      exit;
    end;
  end;
  if (tv_Properties.Selected.Data = nil) then exit;
  xguard('Tfrm_DefPropsBrowser.tv_PropertiesClick');
  lv_SelProperty.Items.BeginUpdate;
  lv_SelProperty.Items.Clear;
  data := TDefPropEntry(tv_Properties.Selected.Data);
  ed_EffValue.Text := '';
  for i := 0 to data.Values.Count-1 do begin
    li := lv_SelProperty.Items.Add;
    li.Caption := data.Values[i];
    if (i = 0) then ed_EffValue.Text := data.Values[i];
    li.SubItems.Add(TUClass(data.Values.Objects[i]).FullName);
    li.Data := data.Values.Objects[i];
  end;
  if (tv_Properties.Selected.Level = 2) then data := TDefPropEntry(tv_Properties.Selected.Parent.Data);
  gb_Property.Caption := Data.Prop.Name;
  ed_type.Text := Data.Prop.ptype;
  ed_DefIn.Text := TUClass(Data.prop.owner).FullName;
  lv_SelProperty.Items.EndUpdate;
  xunguard;
end;

procedure Tfr_DefPropsBrowser.tv_PropertiesAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
var
  capt: string;
  rect: TRect;
begin
  if (Stage <> cdPostPaint) then exit;
  if (Node.Level = 0) then begin
    DefaultDraw := false;
    Rect := Node.DisplayRect(false);    
    if (Node.Expanded) then DrawFrameControl(Sender.Canvas.Handle, Rect, DFC_BUTTON, DFCS_BUTTONPUSH or DFCS_FLAT)
    else DrawFrameControl(Sender.Canvas.Handle, Rect, DFC_BUTTON, DFCS_BUTTONPUSH or DFCS_INACTIVE);
    capt := Node.Text;
    if (capt = '') then begin
      capt := 'No category';
      Sender.Canvas.Font.Style := [fsItalic]; //TODO: doesn't work fit it
    end;
    Sender.Canvas.Brush.Color := clBtnFace;
    SetTextColor(Sender.Canvas.Handle, ColorToRGB(clWindowText));
    SetBkColor(Sender.Canvas.Handle, ColorToRGB(clBtnFace));
    DrawText(Sender.Canvas.Handle, PChar(capt), Length(capt), Rect, DT_CENTER or DT_VCENTER or DT_NOCLIP or DT_SINGLELINE );
    DefaultDraw := false;
  end
  else if ((Node.Level = 1) and (Node.Count > 0)) then begin
    Rect := Node.DisplayRect(false);
    capt := '»';
    Rect.Left := Rect.Left+2;
    Rect.Bottom := Rect.Bottom-2;
    DrawText(Sender.Canvas.Handle, PChar(capt), Length(capt), Rect, DT_VCENTER or DT_NOCLIP or DT_SINGLELINE );
  end
end;

procedure Tfr_DefPropsBrowser.lv_SelPropertyDblClick(Sender: TObject);
var
  p: TControl;
begin
  if (lv_SelProperty.Selected = nil) then exit;
  p := parent;
  while ((p <> nil) and (not IsA(p, Tfrm_DefPropsBrowser))) do p := p.parent;
  if (p <> nil) then Tfrm_DefPropsBrowser(p).AddPropertyPage(TUClass(lv_SelProperty.Selected.Data));
end;

procedure Tfr_DefPropsBrowser.mi_Findavariable1Click(Sender: TObject);
var
  propname: string;
  i: integer;
begin
  if (InputQuery('Find a property', 'Enter the (partial name) of the property to find.', propname)) then begin
    if (propname = '') then exit;
    for i := 0 to tv_Properties.Items.Count-1 do begin
      if (tv_Properties.Items[i].Level <> 1) then continue;
      if (AnsiContainsText(tv_Properties.Items[i].Text, propname)) then begin
        tv_Properties.Select(tv_Properties.Items[i]);
        exit;
      end;
    end;
    Beep;
  end;
end;

end.
