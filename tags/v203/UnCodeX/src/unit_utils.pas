{-----------------------------------------------------------------------------
 Unit Name: unit_utils
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   General function/utils that require Forms
 $Id: unit_utils.pas,v 1.6 2004-03-20 20:58:27 elmuerte Exp $
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

unit unit_utils;

interface

uses
  Types, Forms, StdCtrls, Classes, Graphics, Windows, Consts, Controls, Messages;

type
  // New hint window
  TPropertyHintWindow = class(THintWindow)
    constructor Create(AOwner: TComponent); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
  protected
    prevCaption: string;
    procedure Paint; override;
    procedure WMEraseBkgnd(var msg: TMessage); message WM_ERASEBKGND;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  published
    property Caption;
  end;

implementation

{ SearchQuery }

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;
{ SearchQuery -- END }
{ TPropertyHintWindow }

constructor TPropertyHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := clWindow;
  Canvas.Brush.Color := Color;
end;

procedure TPropertyHintWindow.Paint;
var
  R, R2: TRect;
  TmpCaption: String;
begin
	Canvas.Font.Name := 'Arial';

  R := ClientRect;
  with Canvas do begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;
    Pen.Color   := clBtnShadow;
    Pen.Width   := 1;
    Rectangle(R.Top, R.Left, R.Left+18, R.Bottom);
    //Canvas.Font.Name := 'Marlett';
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Color := clWindowText;
    R2 := Rect(R.Left+1, R.Top+2, R.Left+18, R.Bottom-2);
    TmpCaption := '?';
    DrawText(Canvas.Handle, PChar(TmpCaption), 1, R2, DT_LEFT or DT_NOPREFIX or DT_VCENTER or DT_CENTER or DrawTextBiDiModeFlagsReadingOnly);
  end;

  Canvas.Font.Style := [fsBold];
  Canvas.Font.Color := clWindowText;
  Canvas.Brush.Color := Color;

  //Canvas.Brush.Style := bsClear;
  R.Top := R.Top+2;
  R.Left := R.Left+22;
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly or DT_VCENTER);
  prevCaption := Caption;
end;

procedure TPropertyHintWindow.ActivateHint(Rect: TRect; const AHint: string);
begin
  inherited;
end;

function TPropertyHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
begin
  Result := Rect(0, 0, MaxWidth*2, 0);
  DrawText(Canvas.Handle, PChar(AHint), -1, Result, DT_CALCRECT or DT_LEFT or
    DT_WORDBREAK or DT_NOPREFIX or DrawTextBiDiModeFlagsReadingOnly);
  Inc(Result.Right, 32);
  Inc(Result.Bottom, 2);
end;

procedure TPropertyHintWindow.WMEraseBkgnd(var msg: TMessage);
begin
  {if (prevCaption = Caption) then msg.Result := 1
  else} inherited;
end;

procedure TPropertyHintWindow.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Width := Canvas.TextWidth(Caption) + 32;
  Height := Canvas.TextHeight(Caption) + 4;
end;

{ TPropertyHintWindow -- END }

initialization
  Application.HintColor := clWindow;
  HintWindowClass := TPropertyHintWindow;
end.