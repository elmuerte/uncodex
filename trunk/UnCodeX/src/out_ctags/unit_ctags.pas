{-----------------------------------------------------------------------------
 Unit Name: unit_ctags
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   setup dialog + actual file creation
 						http://ctags.sourceforge.net/FORMAT
 $Id: unit_ctags.pas,v 1.3 2004-05-13 20:03:45 elmuerte Exp $
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

unit unit_ctags;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, ImgList, unit_outputdefs,
  unit_uclasses;

type
  Tfrm_CTAGS = class(TForm)
    lbl_OutputFile: TLabel;
    ed_OutputFile: TEdit;
    bvl_Splt: TBevel;
    btn_Browse: TBitBtn;
    lbl_Package: TLabel;
    lv_Packages: TListView;
    bvl_Ctrls: TBevel;
    bvl_Packages: TBevel;
    btn_Cancel: TSpeedButton;
    btn_Ok: TSpeedButton;
    btn_Check: TSpeedButton;
    btn_UnCheck: TSpeedButton;
    btn_Tagged: TSpeedButton;
    btn_UnTagged: TSpeedButton;
    il_Packages: TImageList;
    gb_Offset: TGroupBox;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    pnl_SingleClass: TPanel;
    lbl_Single: TLabel;
    ed_Single: TEdit;
    gb_Export: TGroupBox;
    cb_IVar: TCheckBox;
    cb_IConst: TCheckBox;
    cb_IFunc: TCheckBox;
    cb_IClass: TCheckBox;
    cb_IStruct: TCheckBox;
    cb_IDelegates: TCheckBox;
    cb_IEnum: TCheckBox;
    sd_Save: TSaveDialog;
    procedure btn_TaggedClick(Sender: TObject);
    procedure btn_UnTaggedClick(Sender: TObject);
    procedure btn_CheckClick(Sender: TObject);
    procedure btn_UnCheckClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure ed_OutputFileChange(Sender: TObject);
    procedure btn_BrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    Info: TUCXOutputInfo2;
    procedure Init;
    procedure CreateCTAGSfile;
    procedure AddClassToCTAGS(uclass: TUClass; lst: TStrings);
  end;

var
  frm_CTAGS: Tfrm_CTAGS;

const
  DLLVERSION = '100';

implementation

{$R *.dfm}

procedure Tfrm_CTAGS.Init;
var
	i: integer;
  li: TListItem;
begin
	if (not info.ASingleClass) then begin
		for i := 0 to info.APackageList.Count-1 do begin
			li := lv_Packages.Items.Add;
    	li.Caption := info.APackageList[i].name;
	    li.Data := info.APackageList[i];
  	  li.Checked := true;
    	if (info.APackageList[i].tagged) then li.ImageIndex := 0
	    else li.ImageIndex := 1;
  	end;
	  lv_Packages.AlphaSort;
  end
  else begin
    lv_Packages.Visible := false;
    lbl_Package.Visible := false;
    pnl_SingleClass.Visible := true;
    ed_Single.Text := Info.ASelectedClass.FullName;
  end;
end;

procedure Tfrm_CTAGS.CreateCTAGSfile;
var
	i,j: integer;
  pkg: TUPackage;
  lst: TStringList;
begin
	lst := TStringList.Create;
  try
  	if (info.ASingleClass) then begin
      AddClassToCTAGS(info.ASelectedClass, lst);
    end
    else begin
			for i := 0 to lv_Packages.Items.Count-1 do begin
  		  if (lv_Packages.Items[i].Checked) then begin
	  	    pkg := TUPackage(lv_Packages.Items[i].Data);
  	  	  for j := 0 to pkg.classes.Count-1 do begin
						AddClassToCTAGS(pkg.classes[j], lst);
		      end;
  		  end;
	  	end;
    end;
  	lst.Sort;
	  lst.Insert(0, '!_TAG_FILE_FORMAT	2	/extended format; --format=1 will not append ;" to lines/');
  	lst.Insert(1, '!_TAG_FILE_SORTED	2	/0=unsorted, 1=sorted, 2=foldcase/');
	  lst.Insert(2, '!_TAG_PROGRAM_AUTHOR	Michiel Hendriks	/elmuerte@drunksnipers.com/');
  	lst.Insert(3, '!_TAG_PROGRAM_NAME	UnCodeX	CTAGS output module//');
	  lst.Insert(4, '!_TAG_PROGRAM_URL	http://wiki.beyondunreal.com/wiki/UnCodeX	/official site/');
  	lst.Insert(5, '!_TAG_PROGRAM_VERSION	'+DLLVERSION+'	//');
	  lst.SaveToFile(ed_OutputFile.Text);
  finally
	  lst.Free;
  end;
end;

procedure Tfrm_CTAGS.AddClassToCTAGS(uclass: TUClass; lst: TStrings);
var
	i,j: integer;
begin
	if (cb_IClass.Checked) then begin
		lst.Add(uclass.name+#9+uclass.FullFileName()+#9'0;"'#9'c');
  end;
  if (cb_IVar.Checked) then begin
		for i := 0 to uclass.properties.Count-1 do begin
			lst.Add(uclass.properties[i].name+#9+uclass.FullFileName()+#9+IntToStr(uclass.properties[i].srcline)+';"'#9'v'#9+'class:'+uclass.name);
	  end;
  end;
	if (cb_IConst.Checked) then begin
	  for i := 0 to uclass.consts.Count-1 do begin
			lst.Add(uclass.consts[i].name+#9+uclass.FullFileName()+#9+IntToStr(uclass.consts[i].srcline)+';"'#9'd'#9+'class:'+uclass.name);
	  end;
  end;
	if (cb_IStruct.Checked) then begin
	  for i := 0 to uclass.structs.Count-1 do begin
			lst.Add(uclass.structs[i].name+#9+uclass.FullFileName()+#9+IntToStr(uclass.structs[i].srcline)+';"'#9's'#9+'class:'+uclass.name);
			if (cb_IVar.Checked) then begin
				for j := 0 to uclass.structs[i].properties.Count-1 do begin
					lst.Add(uclass.structs[i].properties[j].name+#9+uclass.FullFileName()+#9+IntToStr(uclass.structs[i].properties[j].srcline)+';"'#9'v'#9+'class:'+uclass.name+#9'struct:'+uclass.structs[i].name);
			  end;
		  end;
	  end;
  end;
	if (cb_IEnum.Checked) then begin
	  for i := 0 to uclass.enums.Count-1 do begin
			lst.Add(uclass.enums[i].name+#9+uclass.FullFileName()+#9+IntToStr(uclass.enums[i].srcline)+';"'#9'e'#9+'class:'+uclass.name);
	  end;
  end;
	if (cb_IFunc.Checked) then begin
	  for i := 0 to uclass.functions.Count-1 do begin
			lst.Add(uclass.functions[i].name+#9+uclass.FullFileName()+#9+IntToStr(uclass.functions[i].srcline)+';"'#9'f'#9+'class:'+uclass.name);
	  end;
  end;
	if (cb_IDelegates.Checked) then begin
	  for i := 0 to uclass.delegates.Count-1 do begin
			lst.Add(uclass.delegates[i].name+#9+uclass.FullFileName()+#9+IntToStr(uclass.delegates[i].srcline)+';"'#9'f'#9+'class:'+uclass.name);
	  end;
  end;
end;

procedure Tfrm_CTAGS.btn_TaggedClick(Sender: TObject);
var
	i: integer;
begin
  for i := 0 to lv_Packages.Items.Count-1 do begin
		lv_Packages.Items[i].Checked := (TUPackage(lv_Packages.Items[i].Data).tagged);
  end;
end;

procedure Tfrm_CTAGS.btn_UnTaggedClick(Sender: TObject);
var
	i: integer;
begin
  for i := 0 to lv_Packages.Items.Count-1 do begin
		lv_Packages.Items[i].Checked := not (TUPackage(lv_Packages.Items[i].Data).tagged);
  end;
end;

procedure Tfrm_CTAGS.btn_CheckClick(Sender: TObject);
var
	i: integer;
begin
  for i := 0 to lv_Packages.Items.Count-1 do begin
		lv_Packages.Items[i].Checked := true;
  end;
end;

procedure Tfrm_CTAGS.btn_UnCheckClick(Sender: TObject);
var
	i: integer;
begin
  for i := 0 to lv_Packages.Items.Count-1 do begin
		lv_Packages.Items[i].Checked := false;
  end;
end;

procedure Tfrm_CTAGS.btn_CancelClick(Sender: TObject);
begin
	Close;
end;

procedure Tfrm_CTAGS.btn_OkClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
	CreateCTAGSfile;
  Screen.Cursor := crDefault;
  Close;
end;

procedure Tfrm_CTAGS.ed_OutputFileChange(Sender: TObject);
begin
  btn_Ok.Enabled := DirectoryExists(ExtractFilePath(ed_OutputFile.Text)) and
  	(ExtractFilePath(ed_OutputFile.Text) <> ed_OutputFile.Text);
end;

procedure Tfrm_CTAGS.btn_BrowseClick(Sender: TObject);
begin
	sd_Save.FileName := ed_OutputFile.Text;
	if (sd_Save.Execute) then ed_OutputFile.Text := sd_Save.FileName;
end;

end.
