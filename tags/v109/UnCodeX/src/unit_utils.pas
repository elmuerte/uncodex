{-----------------------------------------------------------------------------
 Unit Name: unit_utils
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   General function/utils that require Forms
 $Id: unit_utils.pas,v 1.3 2003-06-10 12:00:28 elmuerte Exp $
-----------------------------------------------------------------------------}

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

  // Query dialog
  function SearchQuery(const ACaption, APrompt: string; var value: string; var checkvalue: array of boolean;
    var history: TStringList; CheckPrompt: array of string): boolean; overload;
  function SearchQuery(const ACaption, APrompt: string; var value: string; var history: TStringList): boolean; overload;

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

function SearchQuery(const ACaption, APrompt: string; var value: string; var checkvalue: array of boolean;
    var history: TStringList; CheckPrompt: array of string): boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TComboBox;
  CheckBox: array of TCheckBox;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight, i, last: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(250, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(234, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TComboBox.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(234, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        if (history <> nil) then Items := history;
        AutoComplete := true;
        SelectAll;
      end;
      last := Edit.Top + Edit.Height;
      SetLength(CheckBox, High(CheckPrompt)+1);
      for i := 0 to High(CheckPrompt) do begin
        CheckBox[i] := TCheckBox.Create(Form);
        with CheckBox[i] do
        begin
          Parent := Form;
          Left := Prompt.Left;
          Top := last + 5;
          Width := MulDiv(234, DialogUnits.X, 4);
          Caption := CheckPrompt[i];
          Checked := checkvalue[i];
          last := Top+Height;
        end;
      end;
      ButtonTop := Last + 10;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgOK;
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(73, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgCancel;
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(127, DialogUnits.X, 4), ButtonTop,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;          
      end;
      if ShowModal = mrOk then
      begin
        for i := 0 to High(CheckPrompt) do checkvalue[i] := CheckBox[i].Checked;
        Value := Edit.Text;
        if (History.IndexOf(Value) = -1) then begin
          History.Insert(0, Value);
          while (History.Count > 10) do History.Delete(History.Count-1);
        end
        else History.Move(History.IndexOf(Value), 0);
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

function SearchQuery(const ACaption, APrompt: string; var value: string; var history: TStringList): boolean;
var
  tmpb: array[0..0] of boolean;
  tmps: array[0..0] of string;
begin
  result := SearchQuery(ACaption, APrompt, value, tmpb, history, tmps);
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
  R := ClientRect;
  with Canvas do begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;
    Pen.Color   := clBtnShadow;
    Pen.Width   := 1;
    Rectangle(R.Top, R.Left, R.Left+18, R.Bottom);
    Canvas.Font.Name := 'Marlett';
    Canvas.Font.Style := [fsBold];
    Canvas.Font.Color := clWindowText;
    R2 := Rect(R.Left+1, R.Top+2, R.Left+18, R.Bottom-2);
    TmpCaption := '?';
    DrawText(Canvas.Handle, PChar(TmpCaption), 1, R2, DT_LEFT or DT_NOPREFIX or DT_VCENTER or DT_CENTER or DrawTextBiDiModeFlagsReadingOnly);
  end;

  Canvas.Font.Name := 'Arial';
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
