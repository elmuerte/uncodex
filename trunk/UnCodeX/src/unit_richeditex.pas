{-----------------------------------------------------------------------------
 Unit Name: unit_richeditex
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   we need RichEdit control version 2
-----------------------------------------------------------------------------}

unit unit_richeditex;

interface

uses
  Windows, Controls, Classes, RichEdit, ComCtrls, Graphics, Messages, SysUtils;

type
  TRichEditEx = class(TRichEdit)
  private
    xCanvas: TCanvas;
    FGutterWidth: integer;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMPaint( var Msg : TWMPaint ); message WM_PAINT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateWnd(); override;
    procedure SetSelBgColor(color: TColor);
    procedure ClearBgColor();
    procedure makeurl();
  end;

  procedure Register;

implementation

const
  RichEditModuleName = 'RICHED20.DLL';

var
  FRichEditModule: THandle = 0;

procedure Register;
begin
  RegisterComponents('UnCodeX', [TRichEditEx]);
end;

function EditWordBreak(lpch: LPWSTR; index: integer; cch: integer; code: integer): integer; stdcall;
const
  SPACE = [' ', #9, #10, #13];
  DELIM = ['@', '$', '.', '-', '+', '/', '=', ';', '*', '(', ')', '|', ',', '{', '}', '[', ']', '<', '>', ':', '''', '"'];
  ADELIM = SPACE+DELIM;
var
  ichCurrent: integer;
begin
  ichCurrent := index;
  result := 0;
  case code of
    WB_ISDELIMITER: result := ord(Char(lpch[ichCurrent]) in ADELIM);
    WB_CLASSIFY:    begin
                      if (Char(lpch[ichCurrent]) in  SPACE) then result := WBF_ISWHITE;
                    end;
    WB_LEFT,
    WB_MOVEWORDLEFT:begin
                      while (ichCurrent > 0) and (not (Char(lpch[ichCurrent-1]) in ADELIM)) do dec(ichCurrent);
                      Result := ichCurrent;
                    end;
    WB_RIGHT,
    WB_MOVEWORDRIGHT:begin
                      while (ichCurrent < cch) and (not (Char(lpch[ichCurrent]) in ADELIM)) do inc(ichCurrent);
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
end;

destructor TRichEditEx.Destroy;
begin
  inherited;
  xCanvas.Free;
end;

procedure TRichEditEx.CreateWnd();
var
  R: TRect;
begin
  inherited;
  R := RECT( FGutterWidth+5, 0, Self.Width, Self.Height);
  Perform(EM_SETRECT, 0, Integer(@R));
  Perform(EM_SETWORDBREAKPROC, 0, LPARAM(@EditWordBreak));
  Perform(EM_EXLIMITTEXT, 0, 512000); // set max text limit to 500kb
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

procedure TRichEditEx.SetSelBgColor(color: TColor);
var
  Format: CHARFORMAT2;
begin
  FillChar(Format, SizeOf(Format), 0);
  with Format do begin
    cbSize := SizeOf(Format);
    dwMask := CFM_BACKCOLOR or CFM_ANIMATION;
    crBackColor := color;
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
    Perform(EM_SETCHARFORMAT, SCF_ALL, Longint(@Format));
  end;
end;

procedure TRichEditEx.WMPaint( var Msg : TWMPaint );
var
  offset, lh: integer;
  r: TRect;
  pt, pt2: TPoint;
  l: string;
begin
  inherited;
  with xCanvas do begin
    Brush.Color := clBtnFace;
    Pen.Color := clBtnFace;
    Rectangle(FGutterWidth-10, 0, FGutterWidth, Height);
    Pen.Width := 1;
    Pen.Color := cl3DLight;
    MoveTo(FGutterWidth-3, 0);
    LineTo(FGutterWidth-3, Height);
    Pen.Color := clBtnShadow;
    MoveTo(FGutterWidth-1, 0);
    LineTo(FGutterWidth-1, Height);
    Font.Name := 'Courier New';
    font.Size := 8;
    offset := Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
    l := '1234567890';
    DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_SINGLELINE	or DT_CALCRECT );
    lh := r.Bottom-r.Top+2;
    r.Top := 0;
    Perform(EM_POSFROMCHAR, Integer(@pt), Perform(EM_LINEINDEX, offset, 0));
    r.Bottom := 0;
    FillRect(Rect(0, 0, FGutterWidth-10, lh));
    while (offset < lines.Count-1) and (r.Top < Height) do begin
      Perform(EM_POSFROMCHAR, Integer(@pt2), Perform(EM_LINEINDEX, offset+1, 0));
      r := Rect(0, pt.y, FGutterWidth-10, pt2.y);
      l := format('%10d', [offset+1]);
      DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_RIGHT or DT_SINGLELINE);
      DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_RIGHT or DT_SINGLELINE or DT_CALCRECT);
      FillRect(Rect(0, r.Bottom, FGutterWidth-10, pt2.Y+1));
      Inc(offset);
      pt := pt2;
    end;
    if (offset = lines.Count-1) then begin   // bottom part
      r := Rect(0, pt.y, FGutterWidth-10, pt.y+lh);
      l := format('%10d', [offset+1]);
      DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_RIGHT or DT_SINGLELINE);
      DrawText(Handle, PChar(l), Length(l), r, DT_NOCLIP or DT_RIGHT or DT_SINGLELINE or DT_CALCRECT);
      FillRect(Rect(0, r.Bottom, FGutterWidth-10, height));
    end;
  end;
end;

initialization
finalization
  if FRichEditModule <> 0 then begin
    FreeLibrary(FRichEditModule);
    FRichEditModule := 0;
  end;
end.
