unit unit_selector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, unit_outputdefs, unit_uclasses, Buttons, unit_deplist;

type
  Tfrm_GraphViz = class(TForm)
    lb_Packages: TListBox;
    sd_Save: TSaveDialog;
    Label1: TLabel;
    Label2: TLabel;
    cb_Vars: TCheckBox;
    cb_Funcs: TCheckBox;
    Label3: TLabel;
    cb_Own: TCheckBox;
    cb_Other: TCheckBox;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    plist: TUPackageList;
    deplist: TDepList;
    procedure CreateDeps(vars,funcs: boolean);
    procedure CreateDotFile(filename: string; own,other: boolean);
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

procedure Tfrm_GraphViz.CreateDotFile(filename: string; own,other: boolean);
var
  i,j: integer;
  sl: TStringList;
  tmp: string;
begin
  GInfo.AStatusReport('Compiling dependencies list');
  sl := TStringList.Create;
  try
    sl.Add('graph PackageDep {');
    sl.Add('  clusterrank=none;');
    sl.Add('  node [shape=box];');
    sl.Add('  edge [dir=back];');

    for i := 0 to plist.Count-1 do begin
      sl.Add('  subgraph package_'+plist[i].name+' {');
      sl.Add('    label="'+plist[i].name+'";');
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
begin
  for i := 0 to GInfo.APackageList.Count-1 do begin
    lb_Packages.Items.AddObject(GInfo.APackageList[i].name, GInfo.APackageList[i]);
  end;
end;

{ ------------------- }

procedure Tfrm_GraphViz.FormCreate(Sender: TObject);
begin
  plist := TUPackageList.Create(false);
  deplist := TDepList.Create(true);
end;

procedure Tfrm_GraphViz.BitBtn1Click(Sender: TObject);
var
  i: integer;
begin
  if (sd_Save.Execute) then begin
    plist.Clear;
    for i := 0 to lb_Packages.Items.Count-1 do begin
      if (lb_Packages.Selected[i]) then begin
        plist.Add(TUPackage(lb_Packages.Items.Objects[i]));
      end;
    end;
    try
      CreateDeps(cb_Vars.Checked, cb_Funcs.Checked);
      CreateDotFile(sd_Save.FileName, cb_Own.Checked, cb_Other.Checked);
    except;
    end;
  end;
end;

procedure Tfrm_GraphViz.FormDestroy(Sender: TObject);
begin
  plist.Free;
  deplist.Free;
end;

end.
