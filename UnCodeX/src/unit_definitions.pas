unit unit_definitions;

interface

uses
  Types, Forms, StdCtrls, Classes, Dialogs, Graphics, Windows, Consts, Controls,
  Messages;

type
  TStatusReport = procedure(msg: string; progress: byte = 255) of Object;

  function StrRepeat(line: string; count: integer): string;

  function SearchQuery(const ACaption, APrompt: string; var value: string; var checkvalue: array of boolean;
    var history: TStringList; CheckPrompt: array of string): boolean; overload;
  function SearchQuery(const ACaption, APrompt: string; var value: string; var history: TStringList): boolean; overload;
  
const
  APPTITLE = 'UnCodeX';
  APPVERSION = '041 Beta';

  PATHDELIM = '\';
  WILDCARD = '*.*';
  SOURCECARD = '*.uc';
  CLASSDIR = 'Classes';
  TEMPLATEPATH = 'Templates';

  FTS_LN_BEGIN = ' #';
  FTS_LN_END = ': ';
  FTS_LN_SEP = ',';

implementation

function StrRepeat(line: string; count: integer): string;
begin
  result := '';
  while (count > 0) do begin
    result := result+line;
    Dec(count);
  end;
end;

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

end.
