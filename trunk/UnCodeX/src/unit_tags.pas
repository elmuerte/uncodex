{-----------------------------------------------------------------------------
 Unit Name: unit_tags
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   class properties window
 $Id: unit_tags.pas,v 1.16 2004-02-23 12:20:47 elmuerte Exp $
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

unit unit_tags;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unit_uclasses, unit_props, StdCtrls, Buttons;

type
  Tfrm_Tags = class(TForm)
    btn_MakeWindow: TBitBtn;
    fr_Main: Tfr_Properties;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FAsWindow: boolean;
    procedure WMActivate(var Message: TWMActivate); message WM_Activate;
  public
    isWindow: boolean;
    function LoadClass: boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    constructor CreateWindow(Parent: TComponent; AsWindow: boolean); 
  end;

var
  frm_Tags: Tfrm_Tags;

implementation

uses unit_main;

{$R *.dfm}

function GetCaretPosition(var APoint: TPoint): Boolean;
var
  w: HWND;
  aID, mID: DWORD;
begin
  Result:= False;
  w:= GetForegroundWindow;
  if w <> 0 then
  begin
    aID:= GetWindowThreadProcessId(w, nil);
    mID:= GetCurrentThreadid;
    if aID <> mID then
    begin
      if AttachThreadInput(mID, aID, True) then
      begin
        w:= GetFocus;
        if w <> 0 then
        begin
          Result:= GetCaretPos(APoint);
          Windows.ClientToScreen(w, APoint);
        end;
        AttachThreadInput(mID, aID, False);
      end;
    end;
  end;
end;

{ Tfrm_Tags }

constructor Tfrm_Tags.CreateWindow(Parent: TComponent; AsWindow: boolean);
begin
  inherited Create(Parent);
  FAsWindow := AsWindow;
end;

function Tfrm_Tags.LoadClass: boolean;
begin
	if (fr_Main.uclass = nil) then begin
    Self.Free;
    result := false;
    exit;
  end;
  Caption := fr_Main.uclass.package.name+'.'+fr_Main.uclass.name;

  result := fr_Main.LoadClass;
end;

procedure Tfrm_Tags.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := WS_EX_TOOLWINDOW or WS_EX_NOPARENTNOTIFY or WS_EX_APPWINDOW;
  Params.Style := WS_POPUPWINDOW or WS_SYSMENU or WS_SIZEBOX;
  Params.WndParent := GetDesktopWindow;

end;

procedure Tfrm_Tags.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if (Message.Active = WA_INACTIVE) then begin
    if (not isWindow) then begin
      if (Message.ActiveWindow = frm_UnCodeX.Handle) then begin
        if (not InitActivateFix) then Close;
      end
      else close;
    end;
  end;
end;

procedure Tfrm_Tags.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tfrm_Tags.FormCreate(Sender: TObject);
var
  pt: TPoint;
begin
  isWindow := FAsWindow;
  if (FAsWindow) then FormDblClick(Sender);
  if (GetCaretPosition(pt)) then begin
    Left := pt.X;
    Top := pt.Y;
  end
  else begin
    Left := Mouse.CursorPos.X-16;
    Top := Mouse.CursorPos.Y-16;
    if (Left+Width > Screen.Width) then Left := Screen.Width-Width;
    if (Top+Height > Screen.Height) then Top := Screen.Height-Height;
  end;
end;

procedure Tfrm_Tags.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then Close;
end;

procedure Tfrm_Tags.FormDblClick(Sender: TObject);
begin
  btn_MakeWindow.Hide;
  isWindow := true;
  SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or WS_CAPTION);
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_DRAWFRAME or SWP_NOMOVE or SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;

procedure Tfrm_Tags.FormShow(Sender: TObject);
begin
  SetActiveWindow(Handle);
end;

end.
