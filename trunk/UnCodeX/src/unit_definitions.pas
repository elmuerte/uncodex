{-----------------------------------------------------------------------------
 Unit Name: unit_definitions
 Author:    elmuerte
 Purpose:   General definitions
 History:
-----------------------------------------------------------------------------}

unit unit_definitions;

interface

uses
  Types, Forms, StdCtrls, Classes, Dialogs, Graphics, Windows, Consts, Controls,
  Messages;

type
  // Used for -reuse
  TRedirectStruct = packed record
    Find: string[64];
    OpenFind: boolean;
    OpenTags: boolean;
    Batch: string[255];
    NewHandle: integer;
  end;

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

  // repeat a string
  function StrRepeat(line: string; count: integer): string;

  // Query dialog
  function SearchQuery(const ACaption, APrompt: string; var value: string; var checkvalue: array of boolean;
    var history: TStringList; CheckPrompt: array of string): boolean; overload;
  function SearchQuery(const ACaption, APrompt: string; var value: string; var history: TStringList): boolean; overload;
  
const
  APPTITLE = 'UnCodeX';
  APPVERSION = '059 Beta';

  PATHDELIM = '\';
  WILDCARD = '*.*';
  SOURCECARD = '*.uc';
  CLASSDIR = 'Classes';
  TEMPLATEPATH = 'Templates';

  // Full Text search tokens
  FTS_LN_BEGIN = ' #';
  FTS_LN_END = ': ';
  FTS_LN_SEP = ',';

  // Tree icons
  ICON_PACKAGE = 0;
  ICON_PACKAGE_TAGGED = 1;
  ICON_CLASS = 2;
  ICON_CLASS_TAGGED = 3;

  CMD_HELP =  'Commandline options:'+#13+#10+
              '-config'#9#9#9'loads a diffirent config file (next argument)'+#13+#10+
              '-batch'#9#9#9'start UnCodeX in batch processing mode, the next'+#13+#10+
              #9#9#9'arguments must contain the batch order, '+#13+#10+
              #9#9#9'which can be on of the following:'+#13+#10+
              #9'rebuild'#9#9'rebuild class tree'+#13+#10+
              #9'analyse'#9#9'analyse all classes'+#13+#10+
              #9'createhtml'#9'create HTML output'+#13+#10+
              #9'htmlhelp'#9#9'create MS HTML Help file'+#13+#10+
              #9'close'#9#9'close UnCodeX'+#13+#10+
              #9'--'#9#9'end of batch commands'+#13+#10+
              '-find'#9#9#9'find a class'+#13+#10+
              '-help'#9#9#9'display this message'+#13+#10+
              '-hide'#9#9#9'hides UnCodeX'+#13+#10+
              '-handle'#9#9#9'Window handle'+#13+#10+
              '-open'#9#9#9'find and open a class'+#13+#10+
              '-reuse'#9#9#9'reuse a previous window'+#13+#10+
              '-tags'#9#9#9'display class properties';

implementation

function StrRepeat(line: string; count: integer): string;
begin
  result := '';
  while (count > 0) do begin
    result := result+line;
    Dec(count);
  end;
end;

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
  if (prevCaption = Caption) then msg.Result := 1
  else inherited;
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
