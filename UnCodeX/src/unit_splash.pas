{-----------------------------------------------------------------------------
 Unit Name: unit_splash
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   splash screen
 $Id: unit_splash.pas,v 1.4 2004-10-18 11:31:47 elmuerte Exp $
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

unit unit_splash;

{$I defines.inc}

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
