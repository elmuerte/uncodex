{-----------------------------------------------------------------------------
 Unit Name: unit_license
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   Display the LICENSE.TXT file
 $Id: unit_license.pas,v 1.2 2003-12-16 11:37:58 elmuerte Exp $
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

unit unit_license;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfrm_License = class(TForm)
    mm_License: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_License: Tfrm_License;

implementation

{$R *.dfm}

procedure Tfrm_License.FormShow(Sender: TObject);
begin
	if (FileExists(ExtractFilePath(ParamStr(0))+'LICENSE.TXT')) then begin
  	mm_License.Lines.LoadFromFile(ExtractFilePath(ParamStr(0))+'LICENSE.TXT');
  end;
end;

procedure Tfrm_License.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then Close;
end;

end.