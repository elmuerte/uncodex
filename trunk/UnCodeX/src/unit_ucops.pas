{*******************************************************************************
	Name:
        unit_ucops.pas
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        UnrealScript class operations (implements subclassing, moving, ...)

	$Id: unit_ucops.pas,v 1.11 2004-10-20 13:00:42 elmuerte Exp $
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
unit unit_ucops;

{$I defines.inc}

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
		lbl_FileName: TLabel;
		cb_NewPackage: TCheckBox;
		lbl_Duplicate: TLabel;
		ed_NewClass: TEdit;
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure ed_NewClassChange(Sender: TObject);
		procedure ed_NewClassKeyPress(Sender: TObject; var Key: Char);
		procedure cb_NewPackageClick(Sender: TObject);
		procedure btn_OkClick(Sender: TObject);
		procedure FormKeyUp(Sender: TObject; var Key: Word;
			Shift: TShiftState);
	private
		upackage: TUPackage;
		uclass: TUClass;
		function replace(var replacement: string): boolean;
	public
		{ Public declarations }
	end;

	procedure CreateSubUClass(uparent: TObject);
	procedure MoveUClass(mclass: TUClass);
	procedure RenameUClass(mclass: TUClass);

var
	frm_CreateNewClass: Tfrm_CreateNewClass;

implementation

uses unit_main, unit_copyparser, unit_definitions, unit_analyse,
	unit_rtfhilight, unit_moveclass, shellapi, unit_renameclass,
	unit_sourceparser;

{$R *.dfm}

function CreatePackageDir(name: string; var seldir: string): boolean;
var
	i: integer;
begin
	result := false;
	for i := 0 to SourcePaths.Count-1 do begin
		if (FileExists(SourcePaths[i]+PathDelim+'System'+PathDelim+'ucc.exe')) then begin
			seldir := SourcePaths[i];
			break;
		end;
	end;
	if (seldir = '') then seldir := SourcePaths[0];
	if (SelectDirectory('Select the base directory for the new package: '+name, '', seldir)) then begin
		seldir := seldir+PathDelim+name+PathDelim+'Classes';
		if (not ForceDirectories(seldir)) then begin
			MessageDlg('Could not create package directory:'+#13+#10+seldir, mtError, [mbOK], 0);
			exit;
		end;
		result := true;
	end
end;

function CreateUPackage(name, seldir: string): TUPackage;
begin
	result := TUPackage.Create;
	result.name := name;
	result.priority := PackageList.Count;
	result.path := seldir;
	result.treenode := frm_UnCodeX.tv_Packages.Items.AddObject(nil, result.name, result);
	PackageList.Add(result);
	PackagePriority.Add(result.name);
	frm_UnCodeX.tv_Packages.AlphaSort();
	Log('Adding new package '''+result.name+''' to priority list, check the package priority list');
end;

function moveFile(filename, dest: string): boolean;
var
	fos: TSHFileOpStruct;
begin
	Log('Moving file "'+filename+'" to "'+dest+'"');
	FillChar(fos, sizeof(fos), 0);
	fos.wFunc := FO_MOVE;
	SetLength(filename,Length(filename)+1);
	filename[Length(filename)] := #0;
	fos.pFrom := PChar(filename);
	SetLength(dest,Length(dest)+1);
	dest[Length(dest)] := #0;
	fos.pTo := PChar(dest);
	fos.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_NOERRORUI;
	result := ShFileOperation(fos) = 0;
end;

function renameFile(filename, dest: string): boolean;
var
	fos: TSHFileOpStruct;
begin
	Log('Renaming file "'+filename+'" to "'+dest+'"');
	FillChar(fos, sizeof(fos), 0);
	fos.wFunc := FO_RENAME;
	SetLength(filename,Length(filename)+1);
	filename[Length(filename)] := #0;
	fos.pFrom := PChar(filename);
	SetLength(dest,Length(dest)+1);
	dest[Length(dest)] := #0;
	fos.pTo := PChar(dest);
	fos.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_NOERRORUI;
	result := ShFileOperation(fos) = 0;
end;

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

procedure MoveUClass(mclass: TUClass);
var
	i: 		integer;
	seldir: string;
	upkg,
    opkg: 	TUPackage;
begin
	with (Tfrm_MoveClass.Create(Application)) do begin
		cb_NewPkg.Items.Clear;
		for i := 0 to PackageList.Count-1 do begin
			cb_NewPkg.Items.AddObject(PackageList[i].name, PackageList[i]);
		end;
		ed_Class.Text := mclass.name;
		ed_OldPkg.Text := mclass.package.name;
		uclass := mclass;
		if (ShowModal = mrOk) then begin
			if (cb_NewPackage.Checked) then begin
				if (not CreatePackageDir(cb_NewPkg.Text, seldir)) then exit;
				upkg := CreateUPackage(cb_NewPkg.Text, seldir);
			end
			else begin
				upkg := TUPackage(cb_NewPkg.Items.Objects[cb_NewPkg.Items.IndexOf(cb_NewPkg.Text)]);
				seldir := upkg.path;
			end;
			opkg := uclass.package;
			moveFile(opkg.path+PathDelim+uclass.filename, seldir);
			uclass.package := upkg;
			upkg.classes.Add(uclass);
			upkg.classes.Sort;
			opkg.classes.Remove(uclass);
			TTreeNode(uclass.treenode2).MoveTo(TTreeNode(upkg.treenode), naAddChild);
			TTreeNode(upkg.treenode).AlphaSort();
			TreeUpdated := true;
			if MessageDlg('Do you want to search all classes for references to the old '+#13+#10+'location of this class?'+#13+#10+'e.g.: '+opkg.name+'.'+uclass.name, mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
				SearchConfig.query := opkg.name+'.'+uclass.name;
				SearchConfig.Wrapped := true;
				SearchConfig.isFTS := true;
				SearchConfig.isRegex := false;
				SearchConfig.Scope := 0;
				SearchConfig.searchtree := frm_UnCodeX.tv_Classes;
				frm_UnCodeX.ac_FindNext.Execute;
			end;
		end;
	end;
end;

procedure RenameUClass(mclass: TUClass);
var
	i: 		integer;
	fsin,
    fsout: 	TFileStream;
	sin,
    sout: 	string;
	p: 		TSourceParser;
begin
	with Tfrm_RenameClass.Create(Application) do begin
		ed_Class.Text := mclass.name;
		uclass := mclass;
		uclasslist := ClassList;
		if (ShowModal = mrOk) then begin
		 	sin := uclass.name;
			sout := ed_NewClass.Text;
			fsin := TFileStream.Create(uclass.package.path+PathDelim+uclass.filename, fmOpenRead or fmShareDenyWrite);
			fsout := TFileStream.Create(uclass.package.path+PathDelim+sout+UCEXT, fmCreate or fmShareExclusive);
			try
				p := TSourceParser.Create(fsin, fsout, false);
				while (p.Token <> toEOF) do begin
					if ((p.Token = toSymbol) and (CompareText(p.TokenString, sin) = 0)) then begin
						p.OutputStream.WriteBuffer(PChar(sout)^, Length(sout));
					end
					else begin
						p.CopyTokenToOutput;
					end;
					p.SkipToken(true);
				end;
				p.Free;
				FreeAndNil(fsin);
				FreeAndNil(fsout);
				DeleteFile(uclass.package.path+PathDelim+uclass.filename);

				TreeUpdated := true;
				uclass.name := ed_NewClass.Text;
				uclass.filename := ed_NewClass.Text+UCEXT;
				if (uclass.treenode <> nil) then TTreeNode(uclass.treenode).Text := uclass.name;
				TTreeNode(uclass.treenode2).Text := uclass.name;
				for i := 0 to uclass.children.Count-1 do begin
					LogClass('Class '+uclass.children[i].FullName+' needs to be updated', uclass.children[i]);
					uclass.children[i].parentname := uclass.name;
				end;

				if MessageDlg('Do you want to search all classes for references to the old name of this class?'+#13+#10+'e.g.: '+ed_Class.Text, mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
					SearchConfig.query := ed_Class.Text;
					SearchConfig.Wrapped := true;
					SearchConfig.isFTS := true;
					SearchConfig.isRegex := false;
					SearchConfig.Scope := 0;
					SearchConfig.searchtree := frm_UnCodeX.tv_Classes;
					frm_UnCodeX.ac_FindNext.Execute;
				end;
			finally
				if (fsin <> nil) then fsin.Free;
				if (fsout <> nil) then fsout.Free;
			end
		end;
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
	if (Key < #31) then exit; // BS
	Key := #0;
end;

procedure Tfrm_CreateNewClass.cb_NewPackageClick(Sender: TObject);
begin
	cb_NewPackage.Checked := cb_Package.Items.IndexOf(cb_Package.Text) = -1;
end;

procedure Tfrm_CreateNewClass.btn_OkClick(Sender: TObject);
var
	seldir: 		string;
	fs, ft: 		TFileStream;
	p: 				TCopyParser;
	replacement: 	string;
	newclass: 		TUClass;
begin
	if (cb_NewPackage.Checked) then begin
		if (not CreatePackageDir(cb_Package.Text, seldir)) then exit;
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

	if ((uclass <> nil) and (upackage = nil)) then begin // new package
		upackage := CreateUPackage(cb_Package.Text, seldir);
	end;

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

		newclass.treenode2 := frm_UnCodeX.tv_Packages.Items.AddChildObject(TTreeNode(upackage.treenode), newclass.name, newclass);
		if (newclass.tagged) then TTreeNode(newclass.treenode2).ImageIndex := ICON_CLASS_TAGGED
		else TTreeNode(newclass.treenode2).ImageIndex := ICON_CLASS;
		TTreeNode(newclass.treenode2).SelectedIndex := TTreeNode(newclass.treenode2).ImageIndex;
		TTreeNode(newclass.treenode2).StateIndex := TTreeNode(newclass.treenode2).ImageIndex;
		TTreeNode(newclass.treenode2).Parent.AlphaSort();

		newclass.treenode := frm_UnCodeX.tv_Classes.Items.AddChildObject(TTreeNode(uclass.treenode), newclass.name, newclass);
		if (newclass.tagged) then TTreeNode(newclass.treenode).ImageIndex := ICON_CLASS_TAGGED
		else TTreeNode(newclass.treenode).ImageIndex := ICON_CLASS;
		TTreeNode(newclass.treenode).SelectedIndex := TTreeNode(newclass.treenode).ImageIndex;
		TTreeNode(newclass.treenode).StateIndex := TTreeNode(newclass.treenode).ImageIndex;
		TTreeNode(newclass.treenode).Parent.AlphaSort();

		ClassesHash.Items[newclass.name] := uclass;
		
		TreeUpdated := true;
	end
	else MessageDlg('You have to rebuild the class tree before your new class will '+#13+#10+'show up.', mtInformation, [mbOK], 0);
	ModalResult := mrOk;
end;

function Tfrm_CreateNewClass.replace(var replacement: string): boolean;
var
	size: 	cardinal;
	tmp: 	array[0..255] of char;
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

procedure Tfrm_CreateNewClass.FormKeyUp(Sender: TObject; var Key: Word;
	Shift: TShiftState);
begin
	if (Key = VK_F1) then hh_Help.HelpTopic('window_createsubclass.html');
end;

end.
