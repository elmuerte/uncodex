{-----------------------------------------------------------------------------
 Unit Name: unit_ctags
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   setup dialog + actual file creation
 						http://ctags.sourceforge.net/FORMAT
 $Id: unit_ctags.pas,v 1.2 2004-05-13 07:08:28 elmuerte Exp $
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
    GroupBox1: TGroupBox;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    lbtest: TListBox;
    procedure btn_TaggedClick(Sender: TObject);
    procedure btn_UnTaggedClick(Sender: TObject);
    procedure btn_CheckClick(Sender: TObject);
    procedure btn_UnCheckClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
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

implementation

{$R *.dfm}

procedure Tfrm_CTAGS.Init;
var
	i: integer;
  li: TListItem;
begin
	if (info.ASelectedClass = nil) then begin
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
  end;
end;

procedure Tfrm_CTAGS.CreateCTAGSfile;
var
	i,j: integer;
  pkg: TUPackage;
begin
	lbtest.Clear;
	for i := 0 to lv_Packages.Items.Count-1 do begin
    if (lv_Packages.Items[i].Checked) then begin
      pkg := TUPackage(lv_Packages.Items[i].Data);
      for j := 0 to pkg.classes.Count-1 do begin
				AddClassToCTAGS(pkg.classes[j], lbtest.Items);
      end;
    end;
  end;
  lbtest.Sorted := true;
  lbtest.Sorted := false;
  lbtest.Items.Insert(0, '!_TAG_FILE_FORMAT	2	/extended format; --format=1 will not append ;" to lines/');
  lbtest.Items.Insert(1, '!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/');
  lbtest.Items.Insert(2, '!_TAG_PROGRAM_AUTHOR	Michiel Hendriks	/elmuerte@drunksnipers.com/');
  lbtest.Items.Insert(3, '!_TAG_PROGRAM_NAME	UnCodeX	//');
  lbtest.Items.Insert(4, '!_TAG_PROGRAM_URL	http://wiki.beyondunreal.com/wiki/UnCodeX	/official site/');
  lbtest.Items.Insert(5, '!_TAG_PROGRAM_VERSION	5.5.4	//');
  lbtest.Items.SaveToFile('c:\test.lst');
end;

procedure Tfrm_CTAGS.AddClassToCTAGS(uclass: TUClass; lst: TStrings);
var
	i: integer;
begin
	for i := 0 to uclass.properties.Count-1 do begin
		lst.Add(uclass.properties[i].name+#9+uclass.FullFileName()+#9+IntToStr(uclass.properties[i].srcline)+';"'#9'v');
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
	CreateCTAGSfile;
end;

end.
