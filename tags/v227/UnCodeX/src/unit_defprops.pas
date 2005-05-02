{*******************************************************************************
  Name:
    unit_defprops.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    UnrealScript class defaultproperties browser.

  $Id: unit_defprops.pas,v 1.10 2005-04-20 15:06:02 elmuerte Exp $
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
  ComCtrls, unit_uclasses, ExtCtrls, StdCtrls, ActnList, Contnrs, Menus;

type
  Tfrm_DefPropsBrowser = class(TForm)
    pc_DefPropPages: TPageControl;
    pm_This: TPopupMenu;
    mi_Close1: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure mi_Close1Click(Sender: TObject);
    procedure pc_DefPropPagesContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
  protected
    DoInit: boolean;
    frames: TObjectList;
  public
    procedure AddPropertyPage(uclass: TUClass; delayLoad: boolean = false);
  end;

  procedure ShowDefaultProperties(ucls: TUClass);

var
  frm_DefPropsBrowser: Tfrm_DefPropsBrowser;

implementation

uses Dialogs, StrUtils, unit_main, unit_defpropsframe, unit_definitions;

{$R *.dfm}

procedure ShowDefaultProperties(ucls: TUClass);
var
  created: boolean;
begin
  created := false;
  if (frm_DefPropsBrowser = nil) then begin
    frm_DefPropsBrowser := Tfrm_DefPropsBrowser.Create(Application);
    created := true;
  end;
  if (not created) then frm_DefPropsBrowser.Show;
  frm_DefPropsBrowser.AddPropertyPage(ucls, created);
  if (created) then frm_DefPropsBrowser.Show;
end;

procedure Tfrm_DefPropsBrowser.AddPropertyPage(uclass: TUClass; delayLoad: boolean = false);
var
  ts: TTabSheet;
  fr: Tfr_DefPropsBrowser;
  i: integer;
begin
  for i := 0 to frames.Count-1 do begin
    if (Tfr_DefPropsBrowser(frames[i]).uclass = uclass) then exit;
  end;
  if (pc_DefPropPages.PageCount > 0) then begin
    pc_DefPropPages.ActivePage.TabVisible := true;
    Caption := 'Defaultproperties browser';
  end
  else Caption := 'Defaultproperties browser: '+uclass.FullName+' - loading ...';
  ts := TTabSheet.Create(pc_DefPropPages);
  ts.PageControl := pc_DefPropPages;
  ts.TabVisible := pc_DefPropPages.PageCount > 1;
  ts.Caption := uclass.FullName;
  fr := Tfr_DefPropsBrowser.Create(ts);
  fr.Parent := ts;
  fr.uclass := uclass;
  fr.Align := alClient;
  fr.Show;
  if (not delayLoad) then begin
    ts.Caption := 'Loading...';
    Application.ProcessMessages;
    fr.LoadDefProps;
    ts.Caption := uclass.FullName;
  end;
  frames.Add(fr);
end;

procedure Tfrm_DefPropsBrowser.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to frames.Count-1 do begin
    Tfr_DefPropsBrowser(frames[i]).Clear;
  end;
  frames.Free;
  frm_DefPropsBrowser := nil;
end;

procedure Tfrm_DefPropsBrowser.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tfrm_DefPropsBrowser.FormCreate(Sender: TObject);
begin
  DoInit := true;
  frames := TObjectList.Create(false);
end;

procedure Tfrm_DefPropsBrowser.FormActivate(Sender: TObject);
begin
  if (DoInit) then begin
    DoInit := false;
    Application.ProcessMessages;
    with Tfr_DefPropsBrowser(frames[0]) do begin
      LoadDefProps;
      Caption := 'Defaultproperties browser: '+uclass.FullName;
    end;
  end;
end;

var
  closePage: integer;

procedure Tfrm_DefPropsBrowser.mi_Close1Click(Sender: TObject);
begin
  if (closePage <> -1) then begin
    Tfr_DefPropsBrowser(frames[closePage]).Clear;
    frames.Delete(closePage);
    pc_DefPropPages.Pages[closePage].Free;
    if (pc_DefPropPages.PageCount = 1) then begin
      //pc_DefPropPages.ActivePage := pc_DefPropPages.Pages[0];
      Caption := 'Defaultproperties browser: '+Tfr_DefPropsBrowser(frames[0]).uclass.FullName;;
      //pc_DefPropPages.ActivePage.TabVisible := false;
    end
    else if (pc_DefPropPages.PageCount = 0) then begin
      Close;
    end;
  end;
end;

procedure Tfrm_DefPropsBrowser.pc_DefPropPagesContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  closePage := pc_DefPropPages.IndexOfTabAt(MousePos.x, MousePos.y);
  Handled := closePage = -1;
end;

end.
