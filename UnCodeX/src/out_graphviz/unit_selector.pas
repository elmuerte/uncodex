unit unit_selector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, unit_outputdefs, unit_uclasses, Buttons, unit_deplist,
  ComCtrls, ExtCtrls;

type
  Tfrm_GraphViz = class(TForm)
    sd_Save: TSaveDialog;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    lv_Packages: TListView;
    cb_Color: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    cb_Vars: TCheckBox;
    cb_Funcs: TCheckBox;
    cb_Own: TCheckBox;
    cb_Other: TCheckBox;
    cb_PackageBorder: TCheckBox;
    cb_Legenda: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lv_PackagesAdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure lv_PackagesDblClick(Sender: TObject);
    procedure cb_ColorExit(Sender: TObject);
    procedure cb_ColorChange(Sender: TObject);
  private
    plist: TGraphUPAckageList;
    deplist: TDepList;
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

procedure Tfrm_GraphViz.CreateDeps(vars,funcs: boolean);
var
  i,j,k,m: integer;
  dep: TDependency;
  tmp, tmp2: string;
begin
  deplist.Clear;
  for i := 0 to plist.Count-1 do begin
    GInfo.AStatusReport('Calculating dependencies for: '+plist[i].name, round((i+1)/plist.Count*100));
    for j := 0 to plist[i].classes.Count-1 do begin
      if (plist[i].classes[j].parent <> nil) then begin
        dep := TDependency.Create(plist[i].classes[j], plist[i].classes[j].parent);
        deplist.Add(dep);
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
        for m := 0 to GInfo.AClassList.Count-1 do begin
          if (CompareText(tmp2, GInfo.AClassList[m].name) = 0) then begin
            dep := TDependency.Create(plist[i].classes[j], GInfo.AClassList[m], false);
            deplist.Add(dep);
            break;
          end;
        end;
        k := Pos('dependson', tmp);
      end;
      if (vars) then begin
        // TODO:
      end;
      if (funcs) then begin
        // TODO:
      end;
    end;
  end;
  GInfo.AStatusReport('Sorting dependencies');
  deplist.SortOnPackage;
end;

procedure Tfrm_GraphViz.CreateDotFile(filename: string);
var
  i,j: integer;
  sl: TStringList;
  tmp: string;
begin
  GInfo.AStatusReport('Compiling dependencies list');
  sl := TStringList.Create;
  try
    sl.Add('graph PackageDep {');
    if (not cb_PackageBorder.Checked) then sl.Add('  clusterrank=none;');
    sl.Add('  node [shape=box];');
    sl.Add('  edge [dir=back];');

    for i := 0 to plist.Count-1 do begin
      sl.Add('  subgraph cluster_'+plist[i].name+' {');
      sl.Add('    label="'+plist[i].name+'";');
      sl.Add('    color='+plist.colors[i]+';');
      sl.Add('    node [color='+plist.colors[i]+'];');
      for j := 0 to plist[i].classes.count-1 do begin
       sl.Add('    '+plist[i].name+'_'+plist[i].classes[j].name+' [label="'+plist[i].classes[j].name+'"];');
      end;
      sl.Add('  }');
    end;
    for i := 0 to deplist.Count-1 do begin
      tmp := deplist[i].depends.package.name+'_'+deplist[i].depends.name+' -- '+deplist[i].source.package.name+'_'+deplist[i].source.name;
      if (not deplist[i].isChild) then tmp := tmp+' [arrowtail=odot]';
      sl.Add('  '+tmp+';');
    end;
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
    li.SubItems.Add('black');
    li.Data := GInfo.APackageList[i];
  end;
end;

{ ------------------- }

procedure Tfrm_GraphViz.FormCreate(Sender: TObject);
begin
  plist := TGraphUPAckageList.Create(false);
  deplist := TDepList.Create(true);
end;

procedure Tfrm_GraphViz.BitBtn1Click(Sender: TObject);
var
  i: integer;
begin
  if (sd_Save.Execute) then begin
    plist.Clear;
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
  deplist.Free;
end;

procedure Tfrm_GraphViz.lv_PackagesAdvancedCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
{var
  R: TRect;}
begin
  {Sender.Canvas.Brush.Color := StrToIntDef(Item.SubItems[0], clBlack);
  R := Item.DisplayRect(drBounds);
  R.Left := Sender.Column[0].Width;
  Sender.Canvas.FillRect(R);}
end;

procedure Tfrm_GraphViz.lv_PackagesDblClick(Sender: TObject);
var
  R: TRect;
begin
  if (lv_Packages.Selected = nil) then exit;
  R := lv_Packages.Selected.DisplayRect(drBounds);
  cb_Color.Left := lv_Packages.Left+lv_Packages.Columns[0].Width;
  cb_Color.Width := lv_Packages.Columns[1].Width+2;
  cb_Color.Top := lv_Packages.Top+R.Top;
  cb_Color.Height := R.Bottom-R.Top;
  cb_Color.ItemIndex := cb_Color.Items.IndexOf(lv_Packages.Selected.SubItems[0]);
  cb_Color.Visible := true;
  ActiveControl := cb_Color;
end;

procedure Tfrm_GraphViz.cb_ColorExit(Sender: TObject);
begin
  cb_Color.Visible := false;
end;

procedure Tfrm_GraphViz.cb_ColorChange(Sender: TObject);
begin
  if (lv_Packages.Selected = nil) then exit;
  if (cb_Color.Items[cb_Color.ItemIndex] = '') then exit;
  lv_Packages.Selected.SubItems[0] := cb_Color.Items[cb_Color.ItemIndex];
  cb_Color.Visible := false;
end;

end.
