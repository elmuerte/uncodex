unit unit_pkgprops;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IniFiles, unit_uclasses;

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
  private
    UPackage: TUPackage;
    ini: TMemIniFile;
  public
  end;

  procedure ShowPackageProps(pkg: TUPackage);

var
  frm_PackageProps: Tfrm_PackageProps;

implementation

uses unit_definitions, unit_analyse;

{$R *.dfm}

procedure ShowPackageProps(pkg: TUPackage);
var
	sl: TStringList;
begin
	with (Tfrm_PackageProps.Create(Application)) do begin
    UPackage := pkg;
    ini := TMemIniFile.Create(pkg.path+PathDelim+pkg.name+PKGCFG);
    try
      cb_AllowDownload.Checked := StrToBool(ini.ReadString('Flags', 'AllowDownload', BoolToStr(cb_AllowDownload.Checked)));
      cb_ServerSideOnly.Checked := StrToBool(ini.ReadString('Flags', 'ServerSideOnly', BoolToStr(cb_ServerSideOnly.Checked)));
      cb_ClientOptional.Checked := StrToBool(ini.ReadString('Flags', 'ClientOptional', BoolToStr(cb_ClientOptional.Checked)));
      cb_Official.Checked := StrToBool(ini.ReadString('Flags', 'Official', BoolToStr(cb_Official.Checked)));
      ini.ReadSectionValues('Package_Description', mm_Desc.Lines);
      Caption := pkg.name+' - '+pkg.name+PKGCFG;
    	if (ShowModal = mrOk) then begin
        ini.WriteString('Flags', 'AllowDownload', BoolToStr(cb_AllowDownload.Checked, true));
        ini.WriteString('Flags', 'ServerSideOnly', BoolToStr(cb_ServerSideOnly.Checked, true));
        ini.WriteString('Flags', 'ClientOptional', BoolToStr(cb_ClientOptional.Checked, true));
        ini.WriteString('Flags', 'Official', BoolToStr(cb_Official.Checked, true));
        if (mm_Desc.Lines.Count > 0) then begin
	        ini.EraseSection('Package_Description');
  	     	sl := TStringList.Create;
    	    try
						ini.GetStrings(sl);
        	  sl.Add('[Package_Description]');
	          sl.AddStrings(mm_Desc.Lines);
  	        UPackage.comment := mm_Desc.Text;
    	      ini.SetStrings(sl);
            TreeUpdated := true;
      	  finally
						sl.Free;
	        end;
        end;
        ini.UpdateFile;
      end;
    finally
			ini.Free;
    end;
  end;
end;

end.
