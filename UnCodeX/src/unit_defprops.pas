{*******************************************************************************
  Name:
    unit_defprops.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    UnrealScript class defaultproperties browser.

  $Id: unit_defprops.pas,v 1.9 2005-03-27 20:10:34 elmuerte Exp $
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
unit unit_defprops;

{$I defines.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, unit_uclasses, ExtCtrls, StdCtrls;

type
  Tfrm_DefPropsBrowser = class(TForm)
    lb_Properties: TListBox;
    spl_Main: TSplitter;
    gb_Property: TGroupBox;
    lv_SelProperty: TListView;
    Label1: TLabel;
    ed_EffValue: TEdit;
    Label2: TLabel;
    ed_DefIn: TEdit;
    Label3: TLabel;
    ed_type: TEdit;
    procedure FormShow(Sender: TObject);
    procedure lb_PropertiesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    uclass: TUClass;
  public
    procedure LoadDefProps;
    procedure AddVariable(vname,vvalue: string; dclass: TUClass);
  end;

  procedure ShowDefaultProperties(ucls: TUClass);

var
  frm_DefPropsBrowser: Tfrm_DefPropsBrowser;

implementation

uses unit_definitions;

{$R *.dfm}

procedure ShowDefaultProperties(ucls: TUClass);
begin
  with (Tfrm_DefPropsBrowser.Create(Application)) do begin
    uclass := ucls;
    ShowModal;
  end;
end;

procedure Tfrm_DefPropsBrowser.AddVariable(vname,vvalue: string; dclass: TUClass);
var
  i: integer;
begin
  i := lb_Properties.Items.IndexOf(vname);
  if (i = -1) then begin
    i := lb_Properties.Items.Add(vname);
    lb_Properties.Items.Objects[i] := TStringList.Create;
  end;
  TStringList(lb_Properties.Items.Objects[i]).AddObject(vvalue, dclass);
end;

procedure Tfrm_DefPropsBrowser.LoadDefProps;
var
  i: integer;
  sl: TStringList;
  pclass: TUClass;
  s: string;
begin
  pclass := uclass;
  sl := TStringList.Create;
  lb_Properties.Items.BeginUpdate;
  try
    while (pclass <> nil) do begin
      sl.Clear;
      sl.Text := pclass.defaultproperties.data;
      i := 0;
      while (i < sl.Count) do begin
        s := trim(sl.Names[i]);
        // if begin object -> remove
        if (SameText('begin ', Copy(s, 1, 6))) then begin
          repeat
            Inc(i);
            s := trim(sl.Names[i]);
          until (SameText('end ', Copy(s, 1, 4)) or (i >= sl.Count-1));
          Inc(i);
          continue;
        end;
        if (s <> '') then begin
          AddVariable(s, sl.Values[sl.Names[i]], pclass);
        end;
        Inc(i);
      end;
      pclass := pclass.parent;
    end;
  finally
    sl.Free;
    lb_Properties.Items.EndUpdate;
  end;
end;

procedure Tfrm_DefPropsBrowser.FormShow(Sender: TObject);
begin
  Caption := Caption+': '+uclass.FullName;
  Application.ProcessMessages;
  LoadDefProps;
end;

procedure Tfrm_DefPropsBrowser.lb_PropertiesClick(Sender: TObject);
var
  i: integer;
  li: TListItem;
  pclass: TUClass;
  prop: TUProperty;
  shortname: string;
begin
  if (lb_Properties.ItemIndex = -1) then exit;
  gb_Property.Caption := lb_Properties.Items[lb_Properties.ItemIndex];
  lv_SelProperty.Items.BeginUpdate;
  lv_SelProperty.Items.Clear;
  with lb_Properties.Items.Objects[lb_Properties.ItemIndex] as TStringList do begin
    for i := 0 to Count-1 do begin
      li := lv_SelProperty.Items.Add;
      li.Caption := Strings[i];
      if (i = 0) then ed_EffValue.Text := Strings[i];
      li.SubItems.Add(TUClass(Objects[i]).FullName);
      li.Data := Objects[i];
    end;
  end;
  lv_SelProperty.Items.EndUpdate;
  pclass := uclass;
  shortname := gb_Property.Caption;
  shortname := GetToken(shortname, '[', true);
  shortname := GetToken(shortname, '(', true);
  ed_type.Text := '';
  ed_DefIn.Text := '';
  while (pclass <> nil) do begin
    prop := pclass.properties.FindEx(shortname);
    if (prop <> nil) then begin
      ed_type.Text := prop.ptype;
      ed_DefIn.Text := pclass.FullName;
      break;
    end;
    pclass := pclass.parent;
  end;
end;

procedure Tfrm_DefPropsBrowser.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lb_Properties.Count-1 do begin
    TStringList(lb_Properties.Items.Objects[i]).Free;
  end;
end;

procedure Tfrm_DefPropsBrowser.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
