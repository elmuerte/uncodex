{-----------------------------------------------------------------------------
 Unit Name: unit_about
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   about UnCodeX dialog
 $Id: unit_about.pas,v 1.7 2003-11-04 19:35:27 elmuerte Exp $
-----------------------------------------------------------------------------}
{
    UnCodeX - UnrealScript source browser & documenter
    Copyright (C) 2003  Michiel Hendriks

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

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  Tfrm_About = class(TForm)
    img_Icons: TImage;
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
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_About: Tfrm_About;

implementation

uses unit_definitions {$IFDEF MSWINDOWS}, ImageHlp{$ENDIF};

{$R *.dfm}

{$IFDEF MSWINDOWS}
// read TimeDateStamp from PE header, thanks to Petr Vones (PetrV)

function LinkerTimeStamp: TDateTime;
var
  LI: TLoadedImage;
begin
  Win32Check(MapAndLoad(PChar(ParamStr(0)), nil, @LI, False, True));
  Result := LI.FileHeader.FileHeader.TimeDateStamp / SecsPerDay + UnixDateDelta;
  UnMapAndLoad(@LI);
end;
{$ENDIF}

procedure Tfrm_About.FormCreate(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  lbl_TimeStamp.Caption := FormatDateTime('dd-mm-yyyy hh:nn:ss',LinkerTimeStamp);
  {$ENDIF}
  lbl_TimeStamp.Visible := lbl_TimeStamp.Caption <> '';
  lbl_Version.Caption := 'version '+APPVERSION;
  img_Icons.Picture.Assign(Application.Icon);
end;

end.
