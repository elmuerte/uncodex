{-----------------------------------------------------------------------------
 Unit Name: unit_richeditex
 Author:    elmuerte
 Purpose:   we need RichEdit control version 2
 History:
-----------------------------------------------------------------------------}

unit unit_richeditex;

interface

uses
  Windows, Controls, Classes, RichEdit, ComCtrls, Graphics, Messages, sysUtils;

type
  TRichEditEx = class(TRichEdit)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    //function EditWordBreak(lpch: pchar; ichCurrent: integer; cch: integer; code: integer): integer; stdcall;
  public
    procedure CreateWnd(); override;
    procedure SetSelBgColor(color: TColor);
    procedure ClearBgColor();
    procedure makeurl();
  end;

  procedure Register;

implementation

uses unit_main;

const
  RichEditModuleName = 'RICHED20.DLL';

var
  FRichEditModule: THandle;

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

procedure TRichEditEx.CreateWnd();
begin
  inherited;
  SendMessage(Self.Handle, EM_SETWORDBREAKPROC, 0, LPARAM(@EditWordBreak));
  SendMessage(Self.Handle, EM_SETOPTIONS, ECOOP_OR, ECO_SELECTIONBAR);
  //SendMessage(Self.Handle, EM_AUTOURLDETECT, Integer(True), 0);
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
    Style := Style or HideScrollBars[false] or
      HideSelections[HideSelection];
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

initialization
finalization
  if FRichEditModule <> 0 then FreeLibrary(FRichEditModule);
end.
