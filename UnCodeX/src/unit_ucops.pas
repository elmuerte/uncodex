unit unit_ucops;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons
  {$WARN UNIT_PLATFORM OFF}
  {$IFDEF MSWINDOWS}
  , FileCtrl
  {$ENDIF}
  {$WARN UNIT_PLATFORM ON}
  , unit_uclasses, ExtCtrls, ComCtrls;

type
  Tfrm_CreateNewClass = class(TForm)
    lbl_Package: TLabel;
    cb_Package: TComboBox;
    lbl_ParentClass: TLabel;
    cb_ParentClass: TComboBox;
    lbl_NewClass: TLabel;
    btn_Ok: TBitBtn;
    btn_Cancel: TBitBtn;
    bvl_MsgBorder: TBevel;
    ed_Filename: TEdit;
    Label1: TLabel;
    cb_NewPackage: TCheckBox;
    lbl_Duplicate: TLabel;
    ed_NewClass: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ed_NewClassChange(Sender: TObject);
    procedure ed_NewClassKeyPress(Sender: TObject; var Key: Char);
    procedure cb_NewPackageClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
  private
  	upackage: TUPackage;
    uclass: TUClass;
    function replace(var replacement: string): boolean;
  public
    { Public declarations }
  end;

  procedure CreateSubUClass(uparent: TObject);

var
  frm_CreateNewClass: Tfrm_CreateNewClass;

implementation

uses unit_main, unit_copyparser, unit_definitions, unit_analyse,
  unit_rtfhilight;

{$R *.dfm}

procedure CreateSubUClass(uparent: TObject);
var
	i: integer;
begin
	with (Tfrm_CreateNewClass.Create(Application)) do begin
    cb_Package.Clear;
    for i := 0 to PackageList.Count-1 do begin
      cb_Package.Items.AddObject(PackageList[i].name, PackageList[i]);
    end;
    cb_ParentClass.Clear;
    for i := 0 to ClassList.Count-1 do begin
      cb_ParentClass.Items.AddObject(ClassList[i].name, ClassList[i]);
    end;
    if (uparent <> nil) then begin
	    if (uparent.ClassType = TUPackage) then begin
  	    cb_Package.ItemIndex := cb_Package.Items.IndexOf(TUPackage(uparent).name);
    	  cb_ParentClass.ItemIndex := cb_ParentClass.Items.IndexOf('Object');
	    end
  	  else if (uparent.ClassType = TUClass) then begin
    	  cb_Package.ItemIndex := cb_Package.Items.IndexOf(TUClass(uparent).package.name);
      	cb_ParentClass.ItemIndex := cb_ParentClass.Items.IndexOf(TUClass(uparent).name);
	    end;
    end;
    ed_NewClassChange(nil);
    ShowModal;
  end;
end;

procedure Tfrm_CreateNewClass.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tfrm_CreateNewClass.ed_NewClassChange(Sender: TObject);
var
	i: integer;
begin
  btn_Ok.Enabled := ed_NewClass.Text <> '';
  i := cb_Package.Items.IndexOf(cb_Package.Text);
  cb_NewPackage.Checked := i = -1;
  lbl_Duplicate.Visible := cb_ParentClass.Items.IndexOf(trim(ed_NewClass.Text)) <> -1;
  if (i <> -1)	then begin
  	upackage := TUPackage(cb_Package.Items.Objects[i]);
  	ed_Filename.Text := upackage.path;
  end
  else begin
  	upackage := nil;
  	ed_Filename.Text := '...'+PathDelim+cb_Package.Text;
  end;
  i := cb_ParentClass.Items.IndexOf(cb_ParentClass.Text);
  if (i <> -1) then begin
		uclass := TUClass(cb_ParentClass.Items.Objects[i])
  end
  else uclass := nil;
  ed_Filename.Text := ed_Filename.Text+PathDelim+trim(ed_NewClass.Text)+'.uc';
end;

procedure Tfrm_CreateNewClass.ed_NewClassKeyPress(Sender: TObject;
  var Key: Char);
begin
	if ((Key >= #48) and (Key <= #57)) then exit; // 0 - 9
  if ((Key >= #65) and (Key <= #90)) then exit; // A - Z
  if ((Key >= #97) and (Key <= #122)) then exit; // a - z
	if (Key = #95) then exit; // _
  if (Key = #8) then exit; // BS
  if (Key = #127) then exit; // DEL
  Key := #0;
end;

procedure Tfrm_CreateNewClass.cb_NewPackageClick(Sender: TObject);
begin
  cb_NewPackage.Checked := cb_Package.Items.IndexOf(cb_Package.Text) = -1;
end;

procedure Tfrm_CreateNewClass.btn_OkClick(Sender: TObject);
var
  seldir: string;
  i: integer;
  fs, ft: TFileStream;
  p: TCopyParser;
  replacement: string;
  newclass: TUClass;
begin
	if (cb_NewPackage.Checked) then begin
		for i := 0 to SourcePaths.Count-1 do begin
			if (FileExists(SourcePaths[i]+PathDelim+'System'+PathDelim+'ucc.exe')) then begin
        seldir := SourcePaths[i];
        break;
      end;
    end;
    if (seldir = '') then seldir := SourcePaths[0];
    if (SelectDirectory('Select the base directory for the new package: '+cb_Package.Text, '', seldir)) then begin
    	seldir := seldir+PathDelim+cb_Package.Text+PathDelim+'Classes';
      if (not ForceDirectories(seldir)) then begin
        MessageDlg('Could not create package directory:'+#13+#10+seldir, mtError, [mbOK], 0);
        exit;
      end;
    end
    else exit;
  end
  else seldir := TUPackage(cb_Package.Items.Objects[cb_Package.Items.IndexOf(cb_Package.Text)]).path;
  if (FileExists(seldir+PathDelim+ed_NewClass.Text+UCEXT)) then begin
		MessageDlg('File already exists:'+#13+#10+seldir+PathDelim+ed_NewClass.Text+UCEXT, mtError, [mbOK], 0);
    exit;
  end;
  if (not FileExists(NewClassTemplate)) then begin
		MessageDlg('New class template does not exist'+#13+#10+NewClassTemplate, mtError, [mbOK], 0);
    exit;
  end;
  fs := TFileStream.Create(NewClassTemplate, fmOpenRead or fmShareDenyWrite);
  ft := TFileStream.Create(seldir+PathDelim+ed_NewClass.Text+UCEXT, fmCreate or fmShareExclusive);
  p := TCopyParser.Create(fs, ft);
  try
    while (p.Token <> toEOF) do begin
      if (p.Token = '%') then begin
        replacement := p.SkipToToken('%');
        if (replacement = '') then begin // %% = %
          replacement := '%';
          p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
        end
        else if (replace(replacement)) then begin
          p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
        end
        else begin // put back old
          replacement := '%'+replacement+'%';
          p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
        end;
      end
      else begin
        p.CopyTokenToOutput;
      end;
      p.SkipToken(true);
    end;
  finally
    fs.Free;
    ft.Free;
  end;
  frm_UnCodeX.ExecuteProgram(seldir+PathDelim+ed_NewClass.Text+UCEXT);
  if ((upackage <> nil) and (uclass <> nil)) then begin
  	newclass := TUClass.Create;
  	newclass.name := ed_NewClass.Text;
  	newclass.filename := newclass.name+UCEXT;
  	newclass.package := upackage;
    upackage.classes.Add(newclass);
  	newclass.parent := uclass;
    newclass.parentname := uclass.name;
    uclass.children.Add(newclass);
    ClassList.Add(newclass);
    newclass.priority := upackage.priority;
    newclass.tagged := upackage.tagged;

    newclass.treenode := frm_UnCodeX.tv_Packages.Items.AddChildObject(TTreeNode(upackage.treenode), newclass.name, newclass);
    if (newclass.tagged) then TTreeNode(newclass.treenode).ImageIndex := ICON_CLASS_TAGGED
    else TTreeNode(newclass.treenode).ImageIndex := ICON_CLASS;
    TTreeNode(newclass.treenode).SelectedIndex := TTreeNode(newclass.treenode).ImageIndex;
    TTreeNode(newclass.treenode).StateIndex := TTreeNode(newclass.treenode).ImageIndex;

    newclass.treenode := frm_UnCodeX.tv_Classes.Items.AddChildObject(TTreeNode(uclass.treenode), newclass.name, newclass);
    if (newclass.tagged) then TTreeNode(newclass.treenode).ImageIndex := ICON_CLASS_TAGGED
    else TTreeNode(newclass.treenode).ImageIndex := ICON_CLASS;
    TTreeNode(newclass.treenode).SelectedIndex := TTreeNode(newclass.treenode).ImageIndex;
    TTreeNode(newclass.treenode).StateIndex := TTreeNode(newclass.treenode).ImageIndex;

    ClassesHash.Items[newclass.name] := '-';
    
    TreeUpdated := true;
  end
  else MessageDlg('You have to rebuild the class tree before your new class will '+#13+#10+'show up.', mtInformation, [mbOK], 0);
  ModalResult := mrOk;
end;

function Tfrm_CreateNewClass.replace(var replacement: string): boolean;
var
  size: cardinal;
  tmp: array[0..255] of char;
begin
  result := false;
  if (CompareText(replacement, 'class') = 0) then begin
		result := true;
    replacement := ed_NewClass.Text;
  end
  else if (CompareText(replacement, 'parent') = 0) then begin
		result := true;
    replacement := cb_ParentClass.Text;
  end
  else if (CompareText(replacement, 'package') = 0) then begin
		result := true;
    replacement := cb_Package.Text;
  end
  else if (CompareText(Copy(replacement, 1, 5), 'date ') = 0) then begin
		result := true;
    replacement := FormatDateTime(Copy(replacement, 6, length(replacement)-5), now);
  end
  else if (CompareText(replacement, 'username') = 0) then begin
  	size := sizeof(tmp);
    GetUserName(tmp, size);
    replacement := tmp;
		result := true;
  end
end;

end.
