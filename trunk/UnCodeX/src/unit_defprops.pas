unit unit_defprops;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, unit_uclasses;

type
  Tfrm_DefPropsBrowser = class(TForm)
    lv_Props: TListView;
    procedure FormShow(Sender: TObject);
  protected
    uclass: TUClass;
  public
  	procedure LoadDefProps;
    procedure AddVariable(vname,vclass,vvalue: string);
  end;

  procedure ShowDefaultProperties(ucls: TUClass);

var
  frm_DefPropsBrowser: Tfrm_DefPropsBrowser;

implementation

{$R *.dfm}

procedure ShowDefaultProperties(ucls: TUClass);
begin
	with (Tfrm_DefPropsBrowser.Create(Application)) do begin
		uclass := ucls;
    ShowModal;
  end;
end;

procedure Tfrm_DefPropsBrowser.AddVariable(vname,vclass,vvalue: string);
var
	li: TListItem;
begin
	li := lv_Props.Items.Add;
  li.Caption := vname;
  li.SubItems.Add(vvalue);
  li.SubItems.Add(vclass);
end;

procedure Tfrm_DefPropsBrowser.LoadDefProps;
var
	i: integer;
  sl: TStringList;
  pclass: TUClass;
begin
	pclass := uclass;
  sl := TStringList.Create;
  lv_Props.Items.Clear;
  lv_Props.Items.BeginUpdate;
  try
		while (pclass <> nil) do begin
			sl.Clear;
      sl.Text := pclass.defaultproperties;
      for i := 0 to sl.Count-1 do begin
				if (trim(sl.Names[i]) <> '') then begin
          AddVariable(trim(sl.Names[i]), pclass.FullName, sl.Values[sl.Names[i]]);
        end;
      end;
      pclass := pclass.parent;
    end;
  finally
		sl.Free;
    lv_Props.Items.EndUpdate;
  end;
end;

procedure Tfrm_DefPropsBrowser.FormShow(Sender: TObject);
begin
	Application.ProcessMessages;
  LoadDefProps; 
end;

end.
