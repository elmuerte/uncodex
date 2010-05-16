{*******************************************************************************
  Name:
    unit_searchform.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Search dialog

  $Id: unit_searchform.pas,v 1.15 2005/04/06 10:10:53 elmuerte Exp $
*******************************************************************************}
{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003, 2004  Michiel Hendriks

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

{$I defines.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, unit_uclasses, ComCtrls;

type
  TSearchConfig = record
    query:        string;
    history:      TStrings;
    ftshistory:   TStrings;
    Wrapped:      boolean;
    // config
    isFTS:        boolean;
    // class search
    isFromTop:    boolean;
    isStrict:     boolean;
    // fts
    isRegex:      boolean;
    isFindFirst:  boolean;
    Scope:        integer;

    // find next info
    searchtree:   TTreeView;
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
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    cfg: TSearchConfig;
    ahistory: TStrings;
  public
    constructor CreateSearch(AOwner: TComponent; var searchconfig: TSearchConfig);
  end;

  function SearchForm(var cs: TSearchConfig): boolean;

  {procedure LoadSearchConfig(ini: TCustomIniFile; section: string; var searchconfig: TSearchConfig);
  procedure SaveSearchConfig(ini: TCustomIniFile; section: string; searchconfig: TSearchConfig);}

var
  frm_SearchForm: Tfrm_SearchForm;

implementation

uses unit_main;

{$R *.dfm}

function SearchForm(var cs: TSearchConfig): boolean;
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
        config.SearchConfig := cs;
      end;
    end;
    Free;
  end;
end;

{
procedure LoadSearchConfig(ini: TCustomIniFile; section: string; var searchconfig: TSearchConfig);
var
  i: integer;
begin
  searchconfig.isFromTop := ini.ReadBool(section, 'isFromTop', false);
  searchconfig.isStrict := ini.ReadBool(section, 'isStrict', false);
  searchconfig.isRegex := ini.ReadBool(section, 'isRegex', false);
  searchconfig.isFindFirst := ini.ReadBool(section, 'isFindFirst', false);
  searchconfig.Scope := ini.ReadInteger(section, 'Scope', 0);
  searchconfig.history.Clear;
  for i := 0 to ini.ReadInteger(section, 'history', 0)-1 do begin
    searchconfig.history.Add(ini.ReadString(section, 'history:'+IntToStr(i), ''));
  end;
  searchconfig.ftshistory.Clear;
  for i := 0 to ini.ReadInteger(section, 'ftshistory', 0)-1 do begin
    searchconfig.ftshistory.Add(ini.ReadString(section, 'ftshistory:'+IntToStr(i), ''));
  end;
end;

procedure SaveSearchConfig(ini: TCustomIniFile; section: string; searchconfig: TSearchConfig);
var
  i: integer;
begin
  ini.WriteBool(section, 'isFromTop', searchconfig.isFromTop);
  ini.WriteBool(section, 'isStrict', searchconfig.isStrict);
  ini.WriteBool(section, 'isRegex', searchconfig.isRegex);
  ini.WriteBool(section, 'isFindFirst', searchconfig.isFindFirst);
  ini.WriteInteger(section, 'Scope', searchconfig.Scope);
  ini.WriteInteger(section, 'history', searchconfig.history.Count);
  for i := 0 to searchconfig.history.Count-1 do begin
    ini.WriteString(section, 'history:'+IntToStr(i), searchconfig.history[i]);
  end;
  ini.WriteInteger(section, 'ftshistory', searchconfig.ftshistory.Count);
  for i := 0 to searchconfig.ftshistory.Count-1 do begin
    ini.WriteString(section, 'ftshistory:'+IntToStr(i), searchconfig.ftshistory[i]);
  end;
end;
}

{ Tfrm_SearchForm }

constructor Tfrm_SearchForm.CreateSearch(AOwner: TComponent; var searchconfig: TSearchConfig);
begin
  inherited Create(AOwner);
  cfg := searchconfig;
  cb_History.Text := searchconfig.query;
  cb_History.SelectAll;
  rb_FTS.Checked := cfg.isFTS;
  cb_RegularExpression.Checked := cfg.isRegex;
  cb_CompareStrict.Checked := cfg.isStrict;
  cb_SearchFromTheTop.Checked := cfg.isFromTop;
  cb_FindFirst.Checked := cfg.isFindFirst;
  rg_Scope.ItemIndex := cfg.Scope;
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

  if (rb_ClassSearch.Checked) then ahistory := cfg.history
  else ahistory := cfg.ftshistory;
  cb_History.Items.Assign(ahistory);
end;

procedure Tfrm_SearchForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F1) then hh_Help.HelpTopic('window_search.html');
end;

end.
