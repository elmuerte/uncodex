{*******************************************************************************
	Name:
        unit_about.pas
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        About UnCodeX dialog

	$Id: unit_about.pas,v 1.18 2004-10-20 13:00:40 elmuerte Exp $
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

unit unit_about;

{$I defines.inc}

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ExtCtrls, Buttons;

type
	Tfrm_About = class(TForm)
		lbl_Title: TLabel;
		lbl_TitleShadow: TLabel;
		lbl_TitleHighlight: TLabel;
		bvl_Border: TBevel;
		lbl_Version: TLabel;
		lbl_Author: TLabel;
		lbl_Author2: TLabel;
		mm_LegalShit: TMemo;
		ed_Email: TEdit;
		ed_Homepage: TEdit;
		lbl_Homepage: TLabel;
		lbl_TimeStamp: TLabel;
		lbl_Platform: TLabel;
		img_Logo: TImage;
		btn_EmailGo: TBitBtn;
		btn_HPGo: TBitBtn;
		ed_Homepage2: TEdit;
		btn_HPGo2: TBitBtn;
		procedure FormCreate(Sender: TObject);
		procedure btn_EmailGoClick(Sender: TObject);
		procedure btn_HPGoClick(Sender: TObject);
		procedure btn_HPGo2Click(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	frm_About: Tfrm_About;

implementation

uses unit_definitions {$IFDEF MSWINDOWS}, ImageHlp{$ENDIF}, unit_main;

{$R *.dfm}

{$IFDEF MSWINDOWS}
// read TimeDateStamp from PE header, thanks to Petr Vones (PetrV)
function LinkerTimeStamp: TDateTime;
var
	LI: TLoadedImage;
begin
	{$WARN SYMBOL_PLATFORM OFF}
	Win32Check(MapAndLoad(PChar(ParamStr(0)), nil, @LI, False, True));
	{$WARN SYMBOL_PLATFORM ON}
	Result := LI.FileHeader.FileHeader.TimeDateStamp / SecsPerDay + UnixDateDelta;
	UnMapAndLoad(@LI);
end;
{$ENDIF}

procedure Tfrm_About.FormCreate(Sender: TObject);
var
	buildtime: TDateTime;
begin
	img_Logo.Picture.Bitmap.LoadFromResourceName(HInstance, 'LOGOIMG');
	{$IFDEF MSWINDOWS}
	buildtime := LinkerTimeStamp;
	if (buildtime > UnixDateDelta) then lbl_TimeStamp.Caption := 'Build time: '+FormatDateTime('dd-mm-yyyy hh:nn:ss',buildtime);
	{$ENDIF}
	lbl_TimeStamp.Visible := lbl_TimeStamp.Caption <> '';
	lbl_Version.Caption := 'version '+APPVERSION;
	lbl_Platform.Caption := APPPLATFORM;
end;

procedure Tfrm_About.btn_EmailGoClick(Sender: TObject);
begin
	frm_UnCodeX.ExecuteProgram('mailto:'+ed_Email.Text);
end;

procedure Tfrm_About.btn_HPGoClick(Sender: TObject);
begin
	frm_UnCodeX.ExecuteProgram(ed_Homepage.Text);
end;

procedure Tfrm_About.btn_HPGo2Click(Sender: TObject);
begin
	frm_UnCodeX.ExecuteProgram(ed_Homepage2.Text);
end;

end.
