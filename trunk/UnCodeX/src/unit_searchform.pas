{-----------------------------------------------------------------------------
 Unit Name: unit_searchform
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Search form, much better than the previous version
 $Id: unit_searchform.pas,v 1.2 2003-06-10 12:00:27 elmuerte Exp $
-----------------------------------------------------------------------------}

unit unit_searchform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TClassSearch = record
    caption:      string;
    text:         string;
    query:        string;
    history:      TStrings;
    isRegex:      boolean;
    isBodySearch: boolean;
    isStrict:     boolean;
    isFromTop:    boolean;
    Wrapped:      boolean;
  end;

  Tfrm_SearchForm = class(TForm)
    lbl_Text: TLabel;
    cb_History: TComboBox;
    cb_SearchBody: TCheckBox;
    cb_Regex: TCheckBox;
    cb_Strict: TCheckBox;
    btn_Ok: TBitBtn;
    btn_Cancel: TBitBtn;
    cb_FromTop: TCheckBox;
    procedure cb_SearchBodyClick(Sender: TObject);
  private
    config: TClassSearch;
  public
    constructor CreateSearch(AOwner: TComponent; var searchconfig: TClassSearch);
  end;

  function SearchForm(var cs: TClassSearch): boolean;

var
  frm_SearchForm: Tfrm_SearchForm;

implementation

{$R *.dfm}

function SearchForm(var cs: TClassSearch): boolean;
begin
  with (Tfrm_SearchForm.CreateSearch(nil, cs)) do begin
    result := ShowModal = mrOk;
    if (result) then begin
      cs.Wrapped := true;
      cs.query := cb_History.Text;
      cs.isRegex := cb_Regex.Checked;
      cs.isBodySearch := cb_SearchBody.Checked;
      cs.isStrict := cb_Strict.Checked;
      cs.isFromTop := cb_FromTop.Checked;
      if (config.history.IndexOf(cs.query) = -1) then begin
        cs.history.Insert(0, cs.query);
        while (cs.history.Count > 10) do cs.history.Delete(cs.history.Count-1);
      end
      else cs.history.Move(cs.history.IndexOf(cs.query), 0);
    end;
    Free;
  end;
end;

constructor Tfrm_SearchForm.CreateSearch(AOwner: TComponent; var searchconfig: TClassSearch);
begin
  inherited Create(AOwner);
  config := searchconfig;
  Caption := config.caption;
  lbl_Text.Caption := config.text;
  cb_History.Items.Assign(config.history);
  cb_SearchBody.Checked := config.isBodySearch;
  cb_Regex.Checked := config.isRegex;
  cb_Strict.Checked := config.isStrict;
  cb_FromTop.Checked := config.isFromTop;

  cb_SearchBodyClick(nil); // make sure the init is correct
end;

procedure Tfrm_SearchForm.cb_SearchBodyClick(Sender: TObject);
begin
  cb_Regex.Enabled := cb_SearchBody.Checked;
  cb_Strict.Enabled := not cb_SearchBody.Checked;
end;

end.
