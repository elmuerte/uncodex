{*******************************************************************************
	Name:
        unit_multilinequery.pas
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        MultiLine input query dialog box

	$Id: unit_multilinequery.pas,v 1.4 2004-10-20 13:00:41 elmuerte Exp $
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
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
	Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA	02111-1307	USA
}

unit unit_multilinequery;

{$I defines.inc}

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, Buttons;

type
	Tfrm_MultiLineQuery = class(TForm)
		lbl_Prompt: TLabel;
		mm_Input: TMemo;
		BitBtn1: TBitBtn;
		BitBtn2: TBitBtn;
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	frm_MultiLineQuery: Tfrm_MultiLineQuery;

implementation

{$R *.dfm}

end.
