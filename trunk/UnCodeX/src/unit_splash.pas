unit unit_splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  Tfrm_Splash = class(TForm)
    img_Logo: TImage;
    tmr_Show: TTimer;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmr_ShowTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Splash: Tfrm_Splash;

implementation

{$R *.dfm}

procedure Tfrm_Splash.FormCreate(Sender: TObject);
begin
  img_Logo.Picture.Bitmap.LoadFromResourceName(HInstance, 'LOGOIMG');
  ClientWidth := img_Logo.Width;
  ClientHeight := img_Logo.Height;
  Left := 0;
  if (Screen.MonitorCount > 0) then Top := Screen.Monitors[0].WorkareaRect.Bottom-Screen.Monitors[0].WorkareaRect.Top-ClientHeight
  else Top := Screen.DesktopHeight-ClientHeight;
end;

procedure Tfrm_Splash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmr_Show.Enabled := false;
  Action := caFree;
end;

procedure Tfrm_Splash.tmr_ShowTimer(Sender: TObject);
begin
  tmr_Show.Enabled := false;
  Show;
  Update;
end;

end.
