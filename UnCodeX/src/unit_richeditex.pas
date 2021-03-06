{*******************************************************************************
  Name:
    unit_richeditex.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    TRichEdit control that uses version 2

  $Id: unit_richeditex.pas,v 1.32 2008/01/05 11:06:18 elmuerte Exp $
*******************************************************************************}
{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003-2006  Michiel Hendriks

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
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  2111-1307  USA
}

unit unit_richeditex;

{$I defines.inc}

{$DEFINE HIGHLIGHT_TOKEN 1}

interface

uses
  Windows, Controls, Classes, RichEdit, ComCtrls, Graphics, Messages, SysUtils,
  unit_uclasses;

type
  TRichEditEx = class(TRichEdit)
  private
    xCanvas: TCanvas;
    FGutterWidth: integer;
    ffilename: TFilename;
    fhighlightcolor: TColor;
    HighlightLines: array of integer;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMPaint( var Msg : TWMPaint ); message WM_PAINT;
    procedure WMSetFocus(var Msg: TMessage); message WM_SetFocus;
    procedure WMNCHitTest(var Msg: TMessage); message WM_NCHitTest;
    function IsHighlighted(i: integer): boolean;
  public
    uclass: TUClass;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateWnd(); override;
    procedure SetSelBgColor(color: TColor);
    procedure ClearBgColor();
    procedure makeurl();
    procedure UpdateWindowRect;
    procedure ClearHighlights;
    procedure HighlightLine(i: integer; updateView: boolean = true);
  published
    property GutterWidth: integer read FGutterWidth write FGutterWidth;
    property filename: Tfilename read ffilename write ffilename;
    property HighlightColor: TColor read fhighlightcolor write fhighlightcolor;
  end;

  procedure Register;

implementation

uses
  Forms, Math;

const
  RichEditModuleName = 'RICHED20.DLL';

var
  FRichEditModule: THandle = 0;
  OldWordBreakProc: integer;

procedure Register;
begin
  RegisterComponents('UnCodeX', [TRichEditEx]);
end;

function EditWordBreak(lpch: LPWSTR; index: integer; cch: integer; code: integer): integer; stdcall;
const
  SPACE = [' ', #0 .. #31];
  DELIM = ['@', '$', '.', '-', '+', '/', '=', ';', '*', '(', ')', '|', ',', '{', '}', '[', ']', '<', '>', ':', '''', '"'];
  ADELIM = SPACE+DELIM;
var
  ichCurrent: integer;
begin
  ichCurrent := index;
  result := 0;
  case code of
    WB_ISDELIMITER: result := ord(Char(lpch[ichCurrent]) in ADELIM);
    WB_CLASSIFY:  begin
                    if (Char(lpch[ichCurrent]) in SPACE) then result := WBF_ISWHITE;
                    if (Char(lpch[ichCurrent]) in DELIM) then result := WBF_BREAKLINE;
                  end;
    WB_LEFT,
    WB_LEFTBREAK,
    WB_MOVEWORDLEFT:  begin
                        //while (ichCurrent >= 0) and (not (Char(lpch[ichCurrent]) in ADELIM)) do dec(ichCurrent);
                        while (ichCurrent > 0) and (not (Char(lpch[ichCurrent-1]) in ADELIM)) do dec(ichCurrent);
                        //if (ichCurrent <> index) then Inc(ichCurrent);
                        Result := ichCurrent;
                      end;
    WB_RIGHT,
    WB_RIGHTBREAK,
    WB_MOVEWORDRIGHT: begin
                        while (ichCurrent <= cch) and (not (Char(lpch[ichCurrent]) in ADELIM)) do inc(ichCurrent);
                        Result := ichCurrent;
                      end;
  end;
end;

constructor TRichEditEx.Create(AOwner: TComponent);
begin
  inherited;
  xCanvas := TControlCanvas.Create;
  TControlCanvas(xCanvas).Control := Self;
  FGutterWidth := 50;
  fhighlightcolor := clYellow;
end;

destructor TRichEditEx.Destroy;
begin
  inherited;
  xCanvas.Free;
end;

procedure TRichEditEx.CreateWnd();
begin
  inherited;
  UpdateWindowRect;
  OldWordBreakProc := Perform(EM_GETWORDBREAKPROC, 0, 0);
  Perform(EM_SETWORDBREAKPROC, 0, LPARAM(@EditWordBreak));
  Perform(EM_EXLIMITTEXT, 0, $7FFFFFF0); // set max text limit to 500kb
end;

procedure TRichEditEx.WMSetFocus;
begin
  inherited;
  HideCaret(Handle);
end;

procedure TRichEditEx.WMNCHitTest;
begin
  inherited;
  HideCaret(Handle);
end;

procedure TRichEditEx.CreateParams(var Params: TCreateParams);
const
  HideScrollBars: array[Boolean] of DWORD = (ES_DISABLENOSCROLL, 0);
  HideSelections: array[Boolean] of DWORD = (ES_NOHIDESEL, 0);
begin
  if FRichEditModule = 0 then
  begin
    FRichEditModule := LoadLibrary(RichEditModuleName);
    if FRichEditModule <= HINSTANCE_ERROR then FRichEditModule := 0;
  end;
  inherited CreateParams(Params);
  CreateSubClass(Params, RICHEDIT_CLASS);
  with Params do
  begin
    Style := Style or HideScrollBars[false] or HideSelections[HideSelection];
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TRichEditEx.UpdateWindowRect;
var
  R: TRect;
begin
  R := RECT( FGutterWidth+5, 0, Self.Width-GetSystemMetrics(SM_CXVSCROLL)-7, Self.Height);
  Perform(EM_SETRECT, 0, Integer(@R));
end;

procedure TRichEditEx.SetSelBgColor(color: TColor);
var
  Format: CHARFORMAT2;
begin
  FillChar(Format, SizeOf(Format), 0);
  with Format do begin
    cbSize := SizeOf(Format);
    dwMask := CFM_BACKCOLOR or CFM_ANIMATION;
    crBackColor := ColorToRGB(color);
    bAnimation := 1;
    Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
  end;
end;

procedure TRichEditEx.ClearBgColor();
var
  Format: CHARFORMAT2;
begin
  FillChar(Format, SizeOf(Format), 0);
  with Format do begin
    cbSize := SizeOf(Format);
    dwMask := CFM_BACKCOLOR;
    dwEffects := CFE_AUTOBACKCOLOR;
    Perform(EM_SETCHARFORMAT, SCF_ALL, Longint(@Format));
  end;
end;

procedure TRichEditEx.makeurl();
var
  Format: CHARFORMAT2;
begin
  FillChar(Format, SizeOf(Format), 0);
  with Format do begin
    cbSize := SizeOf(Format);
    dwMask := CFM_LINK;
    dwEffects := CFE_LINK;
    Perform(EM_SETCHARFORMAT, SCF_WORD or SCF_SELECTION, Longint(@Format));
  end;
end;

function TRichEditEx.IsHighlighted(i: integer): boolean;
var
  n: integer;
begin
  result := false;
  for n := 0 to Length(HighlightLines)-1 do begin
    if (HighlightLines[n] = i) then begin
      result := true;
      exit;
    end;
  end;
end;

procedure TRichEditEx.ClearHighlights;
begin
  SetLength(HighlightLines, 0);
end;

procedure TRichEditEx.HighlightLine(i: integer; updateView: boolean = true);
begin
  SetLength(HighlightLines, Length(HighlightLines)+1);
  HighlightLines[Length(HighlightLines)-1] := i;
  if (not updateView) then exit;
  if ((i > Perform(EM_GETFIRSTVISIBLELINE, 0, 0))
    {TODO: last visible line})
  then Invalidate;
end;

procedure TRichEditEx.WMPaint( var Msg : TWMPaint );
var
  offset, lh, i, x: integer;
  r: TRect;
  pt, pt2: TPoint;
  l: string;
  bmp, bmp2: TBitmap;
begin
  HideCaret(Handle);
  inherited;

  with xCanvas do begin
    bmp := TBitmap.Create;
    bmp.Width := ClientWidth;
    bmp2 := TBitmap.Create;
    bmp2.Width := ClientWidth;
    bmp2.Canvas.Brush.Color := clWhite;

    Brush.Color := Color;
    FillRect(Rect(FGutterWidth, 0, FGutterWidth+4, height));
    Brush.Color := clBtnFace;
    Pen.Color := clBtnFace;
    Rectangle(FGutterWidth-10, 0, FGutterWidth, Height);
    Pen.Width := 1;
    Pen.Color := clBtnHighlight;
    MoveTo(FGutterWidth-2, 0);
    LineTo(FGutterWidth-2, Height);
    Pen.Color := clBtnShadow;
    MoveTo(FGutterWidth-1, 0);
    LineTo(FGutterWidth-1, Height);
    Font.Name := 'Courier New';
    Font.Size := 8;
    offset := Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
    l := '1234567890';
    DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_SINGLELINE or DT_CALCRECT );
    lh := r.Bottom-r.Top+2;
    r.Top := 0;
    Perform(EM_POSFROMCHAR, Integer(@pt), Perform(EM_LINEINDEX, offset, 0));
    r.Bottom := 0;
    FillRect(Rect(0, 0, FGutterWidth-10, lh));
    while (offset < lines.Count-1) and (r.Top < Height) do begin
      Perform(EM_POSFROMCHAR, Integer(@pt2), Perform(EM_LINEINDEX, offset+1, 0));
      if (pt2.Y < pt.Y) then pt2.Y := pt.Y + 16;
      {$IFNDEF HIGHLIGHT_TOKEN}
      if (IsHighlighted(offset)) then begin
        bmp.Canvas.FillRect(Rect(0, 0, ClientWidth, pt2.Y-pt.Y));
        bmp.Height := pt2.Y-pt.Y;
        bmp2.Height := pt2.Y-pt.Y;
        bmp.Transparent := true;
        bmp.TransparentColor := Color;
        BitBlt(bmp.Canvas.Handle, 0, 0, ClientWidth, pt2.Y-pt.Y, Handle, FGutterWidth, pt.Y, SRCCOPY);
        bmp2.Canvas.Brush.Color := fhighlightcolor;
        bmp2.Canvas.FillRect(Rect(0, 0, ClientWidth, pt2.Y-pt.Y));
        bmp2.Canvas.Draw(0, 0, bmp);
        bmp.Transparent := false;
        bmp.Canvas.Brush.Color := fhighlightcolor;
        bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
        bmp.Canvas.CopyMode := cmSrcAnd;
        bmp.Canvas.Draw(0, 0, bmp2);
        Draw(FGutterWidth, pt.Y, bmp);

        //Brush.Color := fhighlightcolor;
        //FillRect(Rect(FGutterWidth, pt.Y, ClientWidth, pt2.Y));
        //CopyMode := cmSrcAnd;
        //Draw(FGutterWidth, pt.Y, bmp2);
        //Brush.Color := clBtnFace;

        {R2 := Rect(FGutterWidth, pt.Y, ClientWidth, pt2.Y-pt.Y);
        InvalidateRect(Handle, @R2, false);}
      end;
      {$ENDIF}
      r := Rect(0, pt.y, FGutterWidth-10, pt2.y);
      l := format('%10d', [offset+1]);
      DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_RIGHT or DT_SINGLELINE);
      DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_RIGHT or DT_SINGLELINE or DT_CALCRECT);
      FillRect(Rect(0, r.Bottom, FGutterWidth-10, pt2.Y+1));

      {$IFDEF HIGHLIGHT_TOKEN}
      if (IsHighlighted(offset)) then begin
        Font.Name := 'Marlett';
        Font.Size := 12;
        Font.Color := fhighlightcolor;
        l := '4';
        SetBkMode(Handle, TRANSPARENT);
        r.Left := FGutterWidth-15;
        DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_SINGLELINE);
        SetBkMode(Handle, OPAQUE);
        Font.Name := 'Courier New';
        Font.Size := 8;
        Font.Color := clWindowText;
      end;
      {$ENDIF}

      Inc(offset);
      pt := pt2;
    end;
    if (offset = lines.Count-1) then begin   // bottom part
      {$IFNDEF HIGHLIGHT_TOKEN}
      Perform(EM_POSFROMCHAR, Integer(@pt2), Perform(EM_LINEINDEX, offset+1, 0));
      if (pt2.Y < pt.Y) then pt2.Y := pt.Y + 16;
      if (IsHighlighted(offset)) then begin
        bmp.Canvas.FillRect(Rect(0, 0, ClientWidth, pt2.Y-pt.Y));
        bmp.Height := pt2.Y-pt.Y;
        bmp2.Height := pt2.Y-pt.Y;
        bmp.Transparent := true;
        bmp.TransparentColor := Color;
        BitBlt(bmp.Canvas.Handle, 0, 0, ClientWidth, pt2.Y-pt.Y, Handle, FGutterWidth, pt.Y, SRCCOPY);
        bmp2.Canvas.FillRect(Rect(0, 0, ClientWidth, pt2.Y-pt.Y));

        Brush.Color := fhighlightcolor;
        FillRect(Rect(FGutterWidth, pt.Y, ClientWidth, pt2.Y));
        bmp2.Canvas.Draw(0, 0, bmp);
        CopyMode := cmSrcAnd;
        Draw(FGutterWidth, pt.Y, bmp2);
        Brush.Color := clBtnFace;
      end;
      {$ENDIF}
      r := Rect(0, pt.y, FGutterWidth-10, pt.y+lh);
      l := format('%10d', [offset+1]);
      DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_RIGHT or DT_SINGLELINE);
      DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_RIGHT or DT_SINGLELINE or DT_CALCRECT);
      FillRect(Rect(0, r.Bottom, FGutterWidth-10, height));

      {$IFDEF HIGHLIGHT_TOKEN}
      if (IsHighlighted(offset)) then begin
        Font.Name := 'Marlett';
        Font.Size := 12;
        Font.Color := fhighlightcolor;
        l := '4';
        SetBkMode(Handle, TRANSPARENT);
        r.Left := FGutterWidth-15;
        DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_SINGLELINE);
        SetBkMode(Handle, OPAQUE);
        Font.Name := 'Courier New';
        Font.Size := 8;
        Font.Color := clWindowText;
      end;
      {$ENDIF}
    end
    else if (lines.Count = 0) then begin
      FillRect(Rect(0, 0, FGutterWidth-10, height));
    end;
    bmp.Free;
    bmp2.Free;

    {$IFDEF HIGHLIGHT_TOKEN}
    if (Length(HighlightLines) > 0) then begin
      x := GetSystemMetrics(SM_CXHSCROLL);
      lh := round((ClientHeight-x*2) / Lines.Count);
      if (lh < 5) then lh := 5;
      r.top := 0;
      r.Bottom := ClientHeight;
      r.Left := ClientWidth-2;
      r.Right := ClientWidth;
      Brush.Color := clWindow;
      FillRect(r);
      for i := 0 to Length(HighlightLines)-1 do begin
        Brush.Color := fhighlightcolor;
        offset := round((ClientHeight-2*x) / Lines.Count * HighlightLines[i]);
        r.Top := offset+x;
        r.Bottom := r.Top+lh;
        FillRect(r);
      end;
    end;
    {$ENDIF}
  end;
end;

initialization
finalization
  if FRichEditModule <> 0 then begin
    FreeLibrary(FRichEditModule);
    FRichEditModule := 0;
  end;
end.
