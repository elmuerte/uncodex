{*******************************************************************************
  Name:
    unit_ucxdocktree.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Replacement docktree

  $Id: unit_ucxdocktree.pas,v 1.9 2004-12-19 16:39:50 elmuerte Exp $
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

unit unit_ucxdocktree;

{$I defines.inc}

interface

uses
  Types, Controls, Messages, Windows, Graphics;

type
  TOnChangeVisibility = procedure(client: TControl; visible: boolean; var CanChange: boolean) of object;
  TOnDockStartDrag = procedure(client: TControl; var CanDrag: boolean) of object;

  TUCXDockTree = class(TDockTree)
  private
    FOldWindowProc: TWndMethod;
    procedure NewWindowProc(var Message: TMessage);
  protected
    procedure PaintDockFrame(Canvas: TCanvas; Control: TControl;
      const ARect: TRect); override;
    function HitTest(const MousePos: TPoint; out HTFlag: Integer): TControl; override;
  public
    constructor Create(DockSite: TWinControl); override;
    destructor Destroy; override;
  end;

var
  OnChangeVisibility: TOnChangeVisibility;
  OnStartDockDrag: TOnDockStartDrag;


implementation

constructor TUCXDockTree.Create(DockSite: TWinControl);
begin
  inherited;
  FOldWindowProc := DockSite.WindowProc;
  DockSite.WindowProc := NewWindowProc;
end;

destructor TUCXDockTree.Destroy;
begin
  if @FOldWindowProc <> nil then
  begin
    DockSite.WindowProc := FOldWindowProc;
    FOldWindowProc := nil;
  end;
  inherited Destroy;
end;

procedure TUCXDockTree.NewWindowProc(var Message: TMessage);
var
  CanChange: boolean;
  P: TPoint;
  client: TControl;
  HitTestValue: Integer;
begin
  {if (Message.Msg = CM_DOCKNOTIFICATION) then begin
    with TCMDockNotification(Message) do begin
      if (NotifyRec.ClientMsg = CM_VISIBLECHANGED) then begin
        CanChange := true;
        if (Assigned(OnChangeVisibility)) then OnChangeVisibility(client, boolean(NotifyRec.MsgWParam) , CanChange);
        if (CanChange) then FOldWindowProc(Message)
        else Client.Visible := not boolean(NotifyRec.MsgWParam);
      end
    end;
  end
  // fix dragging
  else} if (Message.Msg = WM_LBUTTONDOWN) then begin
    P := SmallPointToPoint(TWMMouse(Message).Pos);
    client := HitTest(P, HitTestValue);
    if (client <> nil) then begin
      if HitTestValue = HTCAPTION then begin
        CanChange := true;
        if (Assigned(OnStartDockDrag)) then OnStartDockDrag(client, CanChange);
        if (CanChange) then client.BeginDrag(False);
      end
      else FOldWindowProc(Message);
    end
    else FOldWindowProc(Message);
  end
  // prevent close button
  else if (Message.Msg = WM_LBUTTONUP) then begin
    P := SmallPointToPoint(TWMMouse(Message).Pos);
    client := HitTest(P, HitTestValue);
    if (client <> nil) and (HitTestValue = HTCAPTION) then begin
      // workaround for double click close button (internalhittest)
    end
    else FOldWindowProc(Message);
  end
  else if (Message.Msg = WM_LBUTTONDBLCLK) then begin
    // don't do anything
  end
  {
  // disable floating
  else if (Message.Msg = WM_LBUTTONUP) then begin
    client := HitTest(SmallPointToPoint(TWMMouse(Message).Pos), HitTestValue);
    if client <> nil then CancelDrag;
  en
  }
  else FOldWindowProc(Message);
end;

procedure TUCXDockTree.PaintDockFrame(Canvas: TCanvas; Control: TControl; const ARect: TRect);

  procedure DrawGrabberLine(Left, Top, Right, Bottom: Integer);
  begin
    with Canvas do
    begin
      Pen.Color := clBtnHighlight;
      MoveTo(Right, Top);
      LineTo(Left, Top);
      LineTo(Left, Bottom);
      Pen.Color := clBtnShadow;
      LineTo(Right, Bottom);
      LineTo(Right, Top-1);
    end;
  end;

begin
  with ARect do begin
    if (DockSite.Align in [alTop, alBottom]) then
    begin
      DrawGrabberLine(Left+3, Top+1, Left+5, Bottom-2);
      DrawGrabberLine(Left+6, Top+1, Left+8, Bottom-2);
    end
    else
    begin
      DrawGrabberLine(Left+2, Top+3, Right-2, Top+5);
      DrawGrabberLine(Left+2, Top+6, Right-2, Top+8);
    end;
    //Canvas.TextOut(Left, Top, Control.Name);
  end;
end;

function TUCXDockTree.HitTest(const MousePos: TPoint; out HTFlag: Integer): TControl;
begin
  result := inherited HitTest(MousePos, HTFlag);
  if (HTFlag = HTCLOSE) then HTFlag := HTCAPTION; 
end;

end.
