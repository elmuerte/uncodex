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
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_About: Tfrm_About;

implementation

uses unit_definitions;

{$R *.dfm}

procedure Tfrm_About.FormCreate(Sender: TObject);
begin
  lbl_Version.Caption := APPVERSION;
end;

end.
