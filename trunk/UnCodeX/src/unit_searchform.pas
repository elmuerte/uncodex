{-----------------------------------------------------------------------------
 Unit Name: unit_searchform
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Search form, much better than the previous version
 $Id: unit_searchform.pas,v 1.5 2004-03-20 20:56:08 elmuerte Exp $
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
  Dialogs, StdCtrls, Buttons, ExtCtrls, unit_uclasses, ComCtrls;

type
  TClassSearch = record
    query:        string;
    history:      TStrings;
    ftshistory:   TStrings;
    Wrapped:      boolean;
    // config
    isFTS:				boolean;
    // class search
    isFromTop:		boolean;
    isStrict:			boolean;
    // fts
    isRegex:			boolean;
    isFindFirst:	boolean;
    Scope:				integer;

    // find next info
    searchtree:			TTreeView;
  end;

  Tfrm_SearchForm = class(TForm)
    lbl_Text: TLabel;
    cb_History: TComboBox;
    btn_Ok: TBitBtn;
    btn_Cancel: TBitBtn;
    rb_ClassSearch: TRadioButton;
    rb_FTS: TRadioButton;
    cb_SearchFromTheTop: TCheckBox;
    bvl_Div: TBevel;
    cb_CompareStrict: TCheckBox;
    cb_FindFirst: TCheckBox;
    cb_RegularExpression: TCheckBox;
    rg_Scope: TRadioGroup;
    cb_Default: TCheckBox;
    procedure cb_HistoryChange(Sender: TObject);
    procedure rb_ClassSearchClick(Sender: TObject);
  private
    config: TClassSearch;
    ahistory: TStrings;
  public
    constructor CreateSearch(AOwner: TComponent; var searchconfig: TClassSearch);
  end;

  function SearchForm(var cs: TClassSearch): boolean;

var
  frm_SearchForm: Tfrm_SearchForm;

implementation

uses unit_main;

{$R *.dfm}

function SearchForm(var cs: TClassSearch): boolean;
begin
  with (Tfrm_SearchForm.CreateSearch(nil, cs)) do begin
    result := ShowModal = mrOk;
    if (result) then begin
      cs.Wrapped := true;
      cs.query := cb_History.Text;
      cs.isRegex := cb_RegularExpression.Checked;
      cs.isFTS := rb_FTS.Checked;
      cs.isStrict := cb_CompareStrict.Checked;
      cs.isFromTop := cb_SearchFromTheTop.Checked;
      cs.isFindFirst := cb_FindFirst.Checked;
      cs.Scope := rg_Scope.ItemIndex;
      if (ahistory.IndexOf(cs.query) = -1) then begin
        ahistory.Insert(0, cs.query);
        while (ahistory.Count > 20) do ahistory.Delete(ahistory.Count-1);
      end
      else ahistory.Move(ahistory.IndexOf(cs.query), 0);
      if (cb_Default.Checked) then begin
				DefaultSC := cs;
      end;
    end;
    Free;
  end;
end;

constructor Tfrm_SearchForm.CreateSearch(AOwner: TComponent; var searchconfig: TClassSearch);
begin
  inherited Create(AOwner);
  config := searchconfig;
  cb_History.Text := searchconfig.query;
  cb_History.SelectAll;
  rb_FTS.Checked := config.isFTS;
  cb_RegularExpression.Checked := config.isRegex;
  cb_CompareStrict.Checked := config.isStrict;
  cb_SearchFromTheTop.Checked := config.isFromTop;
  cb_FindFirst.Checked := config.isFindFirst;
  rg_Scope.ItemIndex := config.Scope;
  rb_ClassSearchClick(nil);
  if (cb_History.Text = '') then begin
    if (ahistory.Count > 0) then cb_History.Text := ahistory[0];
  end;
  btn_Ok.Enabled := cb_History.Text <> '';
end;

procedure Tfrm_SearchForm.cb_HistoryChange(Sender: TObject);
begin
  btn_Ok.Enabled := cb_History.Text <> '';
end;

procedure Tfrm_SearchForm.rb_ClassSearchClick(Sender: TObject);
begin
  cb_SearchFromTheTop.Enabled := rb_ClassSearch.Checked;
  cb_CompareStrict.Enabled := rb_ClassSearch.Checked;

  cb_FindFirst.Enabled := rb_FTS.Checked;
  cb_RegularExpression.Enabled := rb_FTS.Checked;
  rg_Scope.Enabled := rb_FTS.Checked;

  if (rb_ClassSearch.Checked) then ahistory := config.history
  else ahistory := config.ftshistory;
  cb_History.Items.Assign(ahistory);
end;

end.
