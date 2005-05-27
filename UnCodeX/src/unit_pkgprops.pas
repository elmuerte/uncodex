{*******************************************************************************
  Name:
    unit_pkgprops.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    UnrealScript Package properties viewer\editor

  $Id: unit_pkgprops.pas,v 1.14 2005-05-27 13:45:07 elmuerte Exp $
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
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit unit_pkgprops;

{$I defines.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, unit_ucxIniFiles, unit_uclasses;

type
  Tfrm_PackageProps = class(TForm)
    gb_Flags: TGroupBox;
    cb_AllowDownload: TCheckBox;
    cb_ClientOptional: TCheckBox;
    cb_ServerSideOnly: TCheckBox;
    gb_Description: TGroupBox;
    mm_Desc: TMemo;
    cb_Official: TCheckBox;
    btn_Ok: TBitBtn;
    btn_Cancel: TBitBtn;
    cb_ExternalDescription: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure cb_AllowDownloadClick(Sender: TObject);
  protected
    UPackage: TUPackage;
    ini: TUCXIniFile;
  public
    flagschanged: boolean;
  end;

  procedure ShowPackageProps(pkg: TUPackage);

var
  frm_PackageProps: Tfrm_PackageProps;

implementation

uses unit_definitions, unit_analyse, unit_main;

{$R *.dfm}

procedure ShowPackageProps(pkg: TUPackage);
var
  sl: TStringList;
begin
  with (Tfrm_PackageProps.Create(Application)) do begin
    UPackage := pkg;
    ini := TUCXIniFile.Create(pkg.path+PathDelim+pkg.name+PKGCFG);
    try
      try // bug in Delphi 6 on my laptop for StrToBool
        cb_AllowDownload.Checked := StrToBool(ini.ReadString('Flags', 'AllowDownload', BoolToStr(cb_AllowDownload.Checked)));
        cb_ServerSideOnly.Checked := StrToBool(ini.ReadString('Flags', 'ServerSideOnly', BoolToStr(cb_ServerSideOnly.Checked)));
        cb_ClientOptional.Checked := StrToBool(ini.ReadString('Flags', 'ClientOptional', BoolToStr(cb_ClientOptional.Checked)));
        cb_Official.Checked := StrToBool(ini.ReadString('Flags', 'Official', BoolToStr(cb_Official.Checked)));
      except
      end;
      ini.ReadSectionRaw('Package_Description', mm_Desc.Lines);
      if (mm_Desc.Lines.Count = 0) then begin
        mm_Desc.Lines.Text := pkg.comment;
        cb_ExternalDescription.Checked := mm_Desc.Lines.count > 0;
      end;
      Caption := pkg.name+' - '+pkg.name+PKGCFG;
      flagschanged := false;
      if (ShowModal = mrOk) then begin
        UPackage.comment := mm_Desc.Text;
        TreeUpdated := true;

        if (flagschanged) then begin
          ini.WriteString('Flags', 'AllowDownload', BoolToStr(cb_AllowDownload.Checked, true));
          ini.WriteString('Flags', 'ServerSideOnly', BoolToStr(cb_ServerSideOnly.Checked, true));
          ini.WriteString('Flags', 'ClientOptional', BoolToStr(cb_ClientOptional.Checked, true));
          ini.WriteString('Flags', 'Official', BoolToStr(cb_Official.Checked, true));
        end;
        if (not cb_ExternalDescription.Checked) then begin
          flagschanged := true;
          ini.EraseSection('Package_Description');
          if (mm_Desc.Lines.Count > 0) then begin
            sl := TStringList.Create;
            try
              ini.GetStrings(sl);
              sl.Add('[Package_Description]');
              sl.AddStrings(mm_Desc.Lines);
              ini.SetStrings(sl);
            finally
              sl.Free;
            end;
          end;
        end;
        if (flagschanged) then ini.UpdateFile;
      end;
    finally
      ini.Free;
    end;

    if (cb_ExternalDescription.Checked) then begin
      if (config.Comments.Packages <> '') then begin
        ini := TUCXIniFile.Create(config.Comments.Packages);
        sl := TStringList.Create;
        try
          ini.WriteSectionRaw(pkg.name, mm_Desc.lines);
          ini.UpdateFile;
        finally;
          sl.Free;
          ini.Free;
        end;
      end;
    end;
  end;
end;

procedure Tfrm_PackageProps.FormShow(Sender: TObject);
begin
  if (PixelsPerInch <> Screen.PixelsPerInch) then begin
    ScaleBy(Screen.PixelsPerInch, PixelsPerInch);
  end;
end;

procedure Tfrm_PackageProps.cb_AllowDownloadClick(Sender: TObject);
begin
  flagschanged := true;
end;

end.
