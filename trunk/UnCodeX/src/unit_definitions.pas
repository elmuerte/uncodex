unit unit_definitions;

interface

uses
  Types, Forms, StdCtrls, Classes, Dialogs, Graphics, Windows, Consts, Controls;

type
  TStatusReport = procedure(msg: string; progress: byte = 255) of Object;

  function StrRepeat(line: string; count: integer): string;

  function SearchQuery(const ACaption, APrompt: string; var value: string; var checkvalue: boolean;
    var history: TStringList;  CheckPrompt: string = ''): boolean; overload;
  function SearchQuery(const ACaption, APrompt: string; var value: string; var history: TStringList): boolean; overload;
  
const
  APPTITLE = 'UnCodeX';
  APPVERSION = '037 Beta';

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

function SearchQuery(const ACaption, APrompt: string; var value: string; var checkvalue: boolean;
    var history: TStringList;  CheckPrompt: string = ''): boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TComboBox;
  CheckBox: TCheckBox;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
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
      CheckBox := TCheckBox.Create(Form);
      with CheckBox do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Edit.Top + Edit.Height + 5;
        Width := MulDiv(234, DialogUnits.X, 4);
        Caption := CheckPrompt;
        Checked := checkvalue;
        Visible := CheckPrompt <> '';
      end;
      ButtonTop := CheckBox.Top + CheckBox.Height + 15;
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
        checkvalue := CheckBox.Checked;
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
  tmpb: boolean;
begin
  result := SearchQuery(ACaption, APrompt, value, tmpb, history, '');
end;

end.
 