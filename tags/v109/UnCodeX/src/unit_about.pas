{-----------------------------------------------------------------------------
 Unit Name: unit_about
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   about UnCodeX dialog
 $Id: unit_about.pas,v 1.6 2003-06-11 18:56:22 elmuerte Exp $
-----------------------------------------------------------------------------}

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
