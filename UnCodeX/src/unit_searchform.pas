{-----------------------------------------------------------------------------
 Unit Name: unit_searchform
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Search form, much better than the previous version
 $Id: unit_searchform.pas,v 1.4 2003-11-04 19:35:27 elmuerte Exp $
-----------------------------------------------------------------------------}
{
    UnCodeX - UnrealScript source browser & documenter
    Copyright (C) 2003  Michiel Hendriks

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
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

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
    procedure cb_HistoryChange(Sender: TObject);
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
  cb_History.Text := searchconfig.query;
  cb_History.SelectAll;
  cb_History.Items.Assign(config.history);
  cb_SearchBody.Checked := config.isBodySearch;
  cb_Regex.Checked := config.isRegex;
  cb_Strict.Checked := config.isStrict;
  cb_FromTop.Checked := config.isFromTop;
  btn_Ok.Enabled := cb_History.Text <> '';
  cb_SearchBodyClick(nil); // make sure the init is correct
end;

procedure Tfrm_SearchForm.cb_SearchBodyClick(Sender: TObject);
begin
  cb_Regex.Enabled := cb_SearchBody.Checked;
  cb_Strict.Enabled := not cb_SearchBody.Checked;
end;

procedure Tfrm_SearchForm.cb_HistoryChange(Sender: TObject);
begin
  btn_Ok.Enabled := cb_History.Text <> '';
end;

end.
