{-----------------------------------------------------------------------------
 Unit Name: unit_selector
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   GUI
 $Id: unit_selector.pas,v 1.9 2004-06-19 13:04:26 elmuerte Exp $
-----------------------------------------------------------------------------}

unit unit_selector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, unit_outputdefs, unit_uclasses, Buttons, unit_deplist,
  ComCtrls, ExtCtrls, Hashes, ImgList;

const
  DLLVERSION = '102';

type
  Tfrm_GraphViz = class(TForm)
    sd_Save: TSaveDialog;
    btn_Create: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    cb_Vars: TCheckBox;
    cb_Funcs: TCheckBox;
    cb_PackageBorder: TCheckBox;
    cb_Legenda: TCheckBox;
    pc_Config: TPageControl;
    ts_Packages: TTabSheet;
    lv_Packages: TListView;
    cb_Color: TComboBox;
    btn_Colorize: TBitBtn;
    btn_Deselect: TBitBtn;
    TabSheet1: TTabSheet;
    mm_Settings: TMemo;
    cl_Color: TColorBox;
    cb_OnlyPackages: TCheckBox;
    btn_SelectAll: TBitBtn;
    il_Tags: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure btn_CreateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lv_PackagesAdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure lv_PackagesDblClick(Sender: TObject);
    procedure cb_ColorExit(Sender: TObject);
    procedure cb_ColorChange(Sender: TObject);
    procedure btn_ColorizeClick(Sender: TObject);
    procedure btn_DeselectClick(Sender: TObject);
    procedure cl_ColorChange(Sender: TObject);
    procedure btn_SelectAllClick(Sender: TObject);
  private
    plist: TGraphUPAckageList;
    olist: TOrphanList;
    deplist: TDepList;
    ClassHash: TObjectHash;
    procedure CreateDeps(vars,funcs: boolean);
    procedure CreateDotFile(filename: string);
  public
    GInfo: TUCXOutputInfo;
    procedure Init;
  end;

var
  frm_GraphViz: Tfrm_GraphViz;

implementation

{$R *.dfm}

function ColorToDot(input: string): string;
begin
  {$IFDEF __USENAMES__}
  result := input;
  {$ELSE}
  result := IntToHex(StrToIntDef(input, 0), 6);
  result := '#'+Copy(result, 5, 2)+Copy(result, 3, 2)+Copy(result, 1, 2);
  {$ENDIF}
end;

procedure Tfrm_GraphViz.CreateDeps(vars,funcs: boolean);
var
  i,j,k,l: integer;
  dep: TDependency;
  orphan: TOrphan;
  tmp, tmp2: string;
begin
  deplist.Clear;
  olist.Clear;
  GInfo.AStatusReport('Creating type hash ...', 0);
  for i := 0 to GInfo.AClassList.Count-1 do begin
    if (not ClassHash.Exists(LowerCase(GInfo.AClassList[i].name))) then
      ClassHash[LowerCase(GInfo.AClassList[i].name)] := GInfo.AClassList[i];
  end;
  for i := 0 to plist.Count-1 do begin
    GInfo.AStatusReport('Calculating dependencies for: '+plist[i].name, round((i+1)/plist.Count*100));
    for j := 0 to plist[i].classes.Count-1 do begin
      if (plist[i].classes[j].parent <> nil) then begin
        dep := TDependency.Create(plist[i].classes[j], plist[i].classes[j].parent);
        deplist.Add(dep);
        orphan := TOrphan.Create(plist[i].classes[j].parent);
        olist.Add(orphan);
      end;
      tmp := LowerCase(plist[i].classes[j].modifiers);
      k := Pos('dependson', tmp);
      while (k > 0) do begin
        Delete(tmp, 1, k+9);
        k := Pos('(', tmp);
        Delete(tmp, 1, k);
        k := Pos(')', tmp);
        tmp2 := Trim(Copy(tmp, 1, k-1));
        Delete(tmp, 1, k);
        if (ClassHash.Exists(LowerCase(tmp2))) then begin
            dep := TDependency.Create(plist[i].classes[j], TUClass(ClassHash[LowerCase(tmp2)]), false);
            deplist.Add(dep);
            orphan := TOrphan.Create(dep.depends);
            olist.Add(orphan);
            break;
        end;
        k := Pos('dependson', tmp);
      end;
      if (vars) then begin
        for k := 0 to plist[i].classes[j].properties.Count-1 do begin
          tmp := LowerCase(plist[i].classes[j].properties[k].ptype);
          l := Pos('.', tmp);
          if (l > 0) then begin
            Delete(tmp, l, MaxInt);
          end;
          if (ClassHash.Exists(tmp)) then begin
            dep := TDependency.Create(plist[i].classes[j], TUClass(ClassHash[tmp]), false);
            if (dep.source <> dep.depends) then begin
              deplist.Add(dep);
              orphan := TOrphan.Create(dep.depends);
              olist.Add(orphan);
            end;
          end;
        end;
      end;
      if (funcs) then begin
        for k := 0 to plist[i].classes[j].functions.Count-1 do begin
          // first the return type
          tmp := LowerCase(plist[i].classes[j].functions[k].return);
          l := Pos('.', tmp);
          if (l > 0) then begin
            Delete(tmp, l, MaxInt);
          end;
          if (tmp <> '') then begin
            if (ClassHash.Exists(tmp)) then begin
              dep := TDependency.Create(plist[i].classes[j], TUClass(ClassHash[tmp]), false);
              if (dep.source <> dep.depends) then begin
                deplist.Add(dep);
                orphan := TOrphan.Create(dep.depends);
                olist.Add(orphan);
              end;
            end;
          end;
          // now the arguments
          // ??
        end;
      end;
    end;
  end;
  GInfo.AStatusReport('Sorting dependencies');
  deplist.SortOnPackage;
  olist.SortOnPackage;
  GInfo.AStatusReport('Filtering dependencies');
  if (cb_OnlyPackages.Checked) then deplist.FilterDuplicatePackages
    else deplist.FilterDuplicates;
  olist.FilterPackages(plist);
end;

procedure Tfrm_GraphViz.CreateDotFile(filename: string);
var
  i,j: integer;
  sl: TStringList;
  tmp: string;
  upack: TUPackage;
begin
  GInfo.AStatusReport('Compiling dependencies list');
  sl := TStringList.Create;
  try
    sl.Add('graph PackageDep {');
    if (not cb_PackageBorder.Checked) then sl.Add('  clusterrank=none;');
    for i := 0 to mm_Settings.Lines.Count-1 do begin
      sl.Add('  '+trim(mm_Settings.Lines[i]));
    end;

    if (cb_OnlyPackages.Checked) then begin
      { Only packages }
      for i := 0 to plist.Count-1 do begin
        tmp := plist[i].name;
        if (plist.colors[i] <> IntToStr(clNone)) then tmp := tmp+' [color="'+ColorToDot(plist.colors[i])+'"];';
        sl.Add('  '+tmp);
      end;
      for i := 0 to deplist.Count-1 do begin
        if (deplist[i].depends.package <> deplist[i].source.package) then begin
          tmp := deplist[i].depends.package.name+' -- '+deplist[i].source.package.name;
          if (not deplist[i].isChild) then tmp := tmp+' [arrowtail=diamond]';
          sl.Add('  '+tmp+';');
        end;
      end;
    end
    else begin
      { Full listing of all classes }
      for i := 0 to plist.Count-1 do begin
        sl.Add('  subgraph cluster_'+plist[i].name+' {');
        sl.Add('    label="'+plist[i].name+'";');
        if (plist.colors[i] <> IntToStr(clNone)) then sl.Add('    color="'+ColorToDot(plist.colors[i])+'";');
        if (plist.colors[i] <> IntToStr(clNone)) then sl.Add('    node [color="'+ColorToDot(plist.colors[i])+'"];');
        for j := 0 to plist[i].classes.count-1 do begin
         sl.Add('    '+plist[i].name+'_'+plist[i].classes[j].name+' [label="'+plist[i].classes[j].name+'"];');
        end;
        sl.Add('  }');
      end;

      upack := nil;
      for i := 0 to olist.Count-1 do begin
        if (upack <> olist[i].uclass.package) then begin
          if (upack <> nil) then sl.Add('  }');
          sl.Add('  subgraph cluster_'+olist[i].uclass.package.name+' {');
          sl.Add('    label="'+olist[i].uclass.package.name+'";');
          upack := olist[i].uclass.package;
        end;
        sl.Add('    '+olist[i].uclass.package.name+'_'+olist[i].uclass.name+' [label="'+olist[i].uclass.name+'"];');
      end;
      if (upack <> nil) then sl.Add('  }');

      for i := 0 to deplist.Count-1 do begin
        tmp := deplist[i].depends.package.name+'_'+deplist[i].depends.name+' -- '+deplist[i].source.package.name+'_'+deplist[i].source.name;
        if (not deplist[i].isChild) then tmp := tmp+' [arrowtail=diamond]';
        sl.Add('  '+tmp+';');
      end;
    end;

    sl.Add('  fontsize=9;');
    sl.Add('  labelloc=b;');
    sl.Add('  label="Created with UnCodeX\nout_graphviz.dll ('+DLLVERSION+')";');
    sl.Add('}');
    sl.SaveToFile(filename);
  finally
    sl.Free;
  end;
  GInfo.AStatusReport('DOT file created');
end;

procedure Tfrm_GraphViz.Init;
var
  i: integer;
  li: TListItem;
begin
  for i := 0 to GInfo.APackageList.Count-1 do begin
    li := lv_Packages.Items.Add;
    li.Caption := GInfo.APackageList[i].name;
    {$IFDEF __USENAMES__}
    li.SubItems.Add('black');
    {$ELSE}
    li.SubItems.Add(IntToStr(clNone));
    {$ENDIF}
    if (GInfo.APackageList[i].tagged) then li.ImageIndex := 0
      else li.ImageIndex := 1;
    li.Data := GInfo.APackageList[i];
  end;
end;


procedure Tfrm_GraphViz.FormCreate(Sender: TObject);
begin
  Caption := Caption+' '+DLLVERSION;
  plist := TGraphUPAckageList.Create(false);
  olist := TOrphanList.Create(true);
  deplist := TDepList.Create(true);
  ClassHash := TObjectHash.Create(false);
end;

procedure Tfrm_GraphViz.btn_CreateClick(Sender: TObject);
var
  i: integer;
begin
  if (sd_Save.Execute) then begin
    plist.Clear;
    plist.colors.Clear;
    for i := 0 to lv_Packages.Items.Count-1 do begin
      if (lv_Packages.Items[i].Checked) then begin
        plist.Add(TUPackage(lv_Packages.Items[i].Data));
        plist.colors.Add(lv_Packages.Items[i].SubItems[0]);
      end;
    end;
    try
      CreateDeps(cb_Vars.Checked, cb_Funcs.Checked);
      CreateDotFile(sd_Save.FileName);
    except;
    end;
  end;
end;

procedure Tfrm_GraphViz.FormDestroy(Sender: TObject);
begin
  plist.Free;
  olist.Free;
  deplist.Free;
  ClassHash.Free;
end;

procedure Tfrm_GraphViz.lv_PackagesAdvancedCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
{$IFNDEF __USENAMES__}
var
  R: TRect;
{$ENDIF}
begin
  {$IFNDEF __USENAMES__}
  Sender.Canvas.Brush.Color := StrToIntDef(Item.SubItems[0], clNone);
  R := Item.DisplayRect(drBounds);
  R.Left := Sender.Column[0].Width;
  Sender.Canvas.FillRect(R);
  {$ENDIF}
end;

procedure Tfrm_GraphViz.lv_PackagesDblClick(Sender: TObject);
var
  R: TRect;
begin
  if (lv_Packages.Selected = nil) then exit;
  R := lv_Packages.Selected.DisplayRect(drBounds);
  {$IFDEF __USENAMES__}
  cb_Color.Left := lv_Packages.Left+lv_Packages.Columns[0].Width;
  cb_Color.Width := lv_Packages.Columns[1].Width+2;
  cb_Color.Top := lv_Packages.Top+R.Top;
  cb_Color.Height := R.Bottom-R.Top;
  cb_Color.ItemIndex := cb_Color.Items.IndexOf(lv_Packages.Selected.SubItems[0]);
  cb_Color.Visible := true;
  ActiveControl := cb_Color;
  {$ELSE}
  cl_Color.Left := lv_Packages.Left+lv_Packages.Columns[0].Width;
  cl_Color.Width := lv_Packages.Columns[1].Width+2;
  cl_Color.Top := lv_Packages.Top+R.Top;
  cl_Color.Height := R.Bottom-R.Top;
  cl_Color.Selected := StrToIntDef(lv_Packages.Selected.SubItems[0], clNone);
  cl_Color.Visible := true;
  ActiveControl := cl_Color;
  {$ENDIF}
end;

procedure Tfrm_GraphViz.cb_ColorExit(Sender: TObject);
begin
  cb_Color.Visible := false;
  cl_Color.Visible := false;
end;

procedure Tfrm_GraphViz.cb_ColorChange(Sender: TObject);
begin
  if (lv_Packages.Selected = nil) then exit;
  if (cb_Color.Items[cb_Color.ItemIndex] = '') then exit;
  lv_Packages.Selected.SubItems[0] := cb_Color.Items[cb_Color.ItemIndex];
  cb_Color.Visible := false;
end;

procedure Tfrm_GraphViz.btn_ColorizeClick(Sender: TObject);
var
  i: integer;
  {$IFDEF __USENAMES__}
  j, cnt, size: integer;
  tmp: string;
  {$ELSE}
  clr: array[0..2] of byte;
  {$ENDIF}
begin
  {$IFDEF __USENAMES__}
  cnt := 0;
  {$ENDIF}
  for i := 0 to lv_Packages.Items.Count-1 do begin
    {$IFDEF __USENAMES__}
    if (lv_Packages.Items[i].Checked) then Inc(cnt);
    {$ELSE}
    lv_Packages.Items[i].SubItems[0] := IntToStr(clNone);
    {$ENDIF}
  end;
  {$IFDEF __USENAMES__}
  if (cnt = 0) then exit;
  {$ENDIF}
  Randomize;
  {$IFDEF __USENAMES__}
  size := cb_Color.Items.Count div cnt;
  {$ENDIF}
  for i := 0 to lv_Packages.Items.Count-1 do begin
    if (lv_Packages.Items[i].Checked) then begin
      {$IFDEF __USENAMES__}
      j := abs(size*cnt+random(10)-random(10)) mod cb_Color.Items.Count;
      Dec(cnt);
      tmp := cb_Color.Items[j];
      if (tmp = '') then tmp := cb_Color.Items[j+1];
      lv_Packages.Items[i].SubItems[0] := tmp;
      {$ELSE}
      clr[0] := Random($FF);
      clr[1] := Random($FF);
      clr[2] := Random($FF);
      while (((clr[0]+clr[1]+clr[2]) div 3) < $6f) do begin
        clr[0] := Random($FF);
        clr[1] := Random($FF);
        clr[2] := Random($FF);
      end;
      lv_Packages.Items[i].SubItems[0] := IntToStr(clr[0]*65536+clr[1]*256+clr[2]);
      {$ENDIF}
    end;
  end;
end;

procedure Tfrm_GraphViz.btn_DeselectClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lv_Packages.Items.Count-1 do begin
    lv_Packages.Items[i].Checked := false;
  end;
end;

procedure Tfrm_GraphViz.cl_ColorChange(Sender: TObject);
begin
  if (lv_Packages.Selected = nil) then exit;
  lv_Packages.Selected.SubItems[0] := IntToStr(cl_Color.Selected);
  cl_Color.Visible := false;
end;

procedure Tfrm_GraphViz.btn_SelectAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lv_Packages.Items.Count-1 do begin
    lv_Packages.Items[i].Checked := true;
  end;
end;

end.
