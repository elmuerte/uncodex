{*******************************************************************************
  Name:
    unit_utils.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Utility functions that have a GUI dependency

  $Id: unit_utils.pas,v 1.21 2005/05/13 10:20:19 elmuerte Exp $
*******************************************************************************}
{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003-2005  Michiel Hendriks

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

unit unit_utils;

{$I defines.inc}

interface

uses
  Types, Forms, StdCtrls, Classes, Graphics, Windows, Consts, Controls, Messages,
  OleCtrls, SHDocVw;

type
  // Newest hint window
  THTMLHintWindow = class(THintWindow)
  private
    HTMLView: TWebBrowser;
    LastHint: string;
    bInitialized: boolean;
    procedure HTMLOnDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
  public
    MaxHintWidth: integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
    procedure Paint; override;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  end;

  function MInputQuery(const ACaption, APrompt: string; var Value: string): Boolean;

implementation

uses
  unit_multilinequery, Variants, ActiveX, SysUtils, ShlObj;

{ SearchQuery -- END }

constructor THTMLHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  MaxHintWidth := 400;
  BorderWidth := 0;
  HTMLView := TWebBrowser.Create(self);
  HTMLView.Top := 0;
  HTMLView.Left := 0;
  HTMLView.ParentWindow := Handle;
  bInitialized := false;
  HTMLView.OnDocumentComplete := HTMLOnDocumentComplete;
  HTMLView.Align := alClient;
  HTMLView.Offline := true;
  HTMLView.RegisterAsBrowser := false;
  HTMLView.RegisterAsDropTarget := false;
  HTMLView.Silent := true;
  HTMLView.Navigate('about:blank');
end;

procedure THTMLHintWindow.HTMLOnDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  try
    if (not bInitialized) then begin
      bInitialized := true;
      exit;
    end;
    Height := HTMLView.OleObject.Document.Body.ScrollHeight + 2;
    if (not VarIsNull(HTMLView.OleObject.Document.all.item('sizespan'))) then begin
      if (HTMLView.OleObject.Document.all.item('sizespan').ScrollWidth < MaxHintWidth) then begin
        Width := HTMLView.OleObject.Document.all.item('sizespan').ScrollWidth+6;
      end
      else begin
        Width := HTMLView.OleObject.Document.all.item('sizespan').ScrollWidth+16;
      end;
    end;
    HTMLView.Width := Width-2;
    HTMLView.Height := Height-1;
    Perform(WM_NCPAINT, 0, 0);
  except
  end;
end;

destructor THTMLHintWindow.Destroy;
begin
  HTMLView.OnDocumentComplete := nil;
  if (Assigned(HTMLView)) then FreeAndNil(HTMLView);
  inherited Destroy;
end;

procedure THTMLHintWindow.ActivateHint(Rect: TRect; const AHint: string);
begin
  UpdateBoundsRect(Rect);

  if Rect.Top + Height > Screen.DesktopHeight then Rect.Top := Screen.DesktopHeight - Height;
  if Rect.Left + Width > Screen.DesktopWidth then Rect.Left := Screen.DesktopWidth - Width;
  if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
  if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;

  SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height, SWP_NOACTIVATE);
  ShowWindow(Handle, SW_SHOWNOACTIVATE);
end;

function THTMLHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
var
  sl: TStringList;
  ms: TMemoryStream;
begin
  if (AHint = LastHint) then begin
    result := Rect(0,0,Width,Height);
    exit;
  end;
  LastHint := AHint;
  
  HTMLView.Width := MaxHintWidth;
  if Assigned(HTMLView.Document) then
  begin
    bInitialized := true;
    sl := TStringList.Create;
    try
      ms := TMemoryStream.Create;
      try
        sl.Text := '<html><head><style>'+
                    'BODY { color: windowtext; background-color: window; margin: 1px; padding: 0px; border: none; cursor: default; overflow: hidden; }'+
                    'TD { padding: 0px; font-family: sans-serif; font-size: 9pt; }</style><body>'+
                    '<table id="sizespan" style="border: 0px solid black; border-collapse: collapse;"><tr>'+
                    '<td style="background-color: #E6E6FA; border: 1px solid #9D9EEC; width: 16px; text-align: center; font-weight: bold; vertical-align: top; padding: 0px;">?</td>'+
                    '<td style="padding-left: 2px;">'+AHint+'</td>'+
                    '</tr></table></body></html>';
        sl.SaveToStream(ms);
        ms.Seek(0, 0);
        (HTMLView.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms));
      finally
        ms.Free;
      end;
    finally
      sl.Free;
    end;
  end;
  Result := Rect(0,0,1,1);
end;

procedure THTMLHintWindow.Paint;
begin
end;

procedure THTMLHintWindow.CMTextChanged(var Message: TMessage);
begin
end;

{ TPropertyHintWindow -- END }

function MInputQuery(const ACaption, APrompt: string; var Value: string): Boolean;
begin
  result := false;
  with (Tfrm_MultiLineQuery.Create(nil)) do begin
    Caption := ACaption;
    lbl_Prompt.Caption := APrompt;
    mm_Input.Lines.Text := Value;
    if (ShowModal = IDOK) then begin
      Value := mm_Input.Lines.Text;
      result := true;
    end;
    Free;
  end;
end;

initialization
  Application.HintColor := clWindow;
  {$IFNDEF VSADDIN} // broken for vs.net ?!
  HintWindowClass := THTMLHintWindow;
  {$ENDIF}
end.
