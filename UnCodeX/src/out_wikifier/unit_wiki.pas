unit unit_wiki;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, unit_uclasses, Buttons;

type
  Tfrm_Wikifier = class(TForm)
    re_WikiCode: TRichEdit;
    btn_SelectAll: TBitBtn;
    btn_Copy: TBitBtn;
    btn_Close: TBitBtn;
    procedure btn_SelectAllClick(Sender: TObject);
    procedure btn_CopyClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Wikify(uclass: TUClass);
  end;

var
  frm_Wikifier: Tfrm_Wikifier;

implementation

{$R *.dfm}

function StringShift(var input: string; delim: string = ','): string;
var
  i: integer;
begin
  i := Pos(delim, input);
  if (i = 0) then i := Length(input);
  result := trim(Copy(input, 1, i-1));
  Delete(input, 1, i);
  input := trim(input);
end;


procedure Tfrm_Wikifier.Wikify(uclass: TUClass);
var
  tmp: string;
  i: integer;
begin
  Caption := Caption+' - '+uclass.name;
  with (re_WikiCode.Lines) do begin
    { header }
    tmp := '@@ [[UT2003]] :: ';
    if (uclass.parent <> nil) then begin
      if (uclass.parent.parent <> nil) then tmp := tmp+'... >> ';
      tmp := tmp+'[['+uclass.parent.name+']] >> ';
    end;
    tmp := tmp+'[['+uclass.name+']]';
    Add(tmp);
    { properties }
    Add('');
    Add('== Properties ==');
    for i := 0 to uclass.properties.Count-1 do begin
      Add('; '+uclass.properties[i].ptype+' '+uclass.properties[i].name+' : ');
    end;
    Add('');
    Add('== Enums ==');
    for i := 0 to uclass.enums.Count-1 do begin
      Add('');
      Add('=== '+uclass.enums[i].name+' ===');
      tmp := uclass.enums[i].options;
      while (tmp <> '') do begin
        Add('; '+StringShift(tmp)+' :');
      end;
    end;
  end;
end;

procedure Tfrm_Wikifier.btn_SelectAllClick(Sender: TObject);
begin
  re_WikiCode.SelectAll;
end;

procedure Tfrm_Wikifier.btn_CopyClick(Sender: TObject);
begin
  re_WikiCode.CopyToClipboard;
end;

procedure Tfrm_Wikifier.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

end.
