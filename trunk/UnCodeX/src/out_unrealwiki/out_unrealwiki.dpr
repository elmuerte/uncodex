{-----------------------------------------------------------------------------
 Unit Name: out_unrealwiki
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   Finds and opens the UnrealWiki page for the selected class
 $Id: out_unrealwiki.dpr,v 1.3 2004-11-29 14:46:10 elmuerte Exp $
-----------------------------------------------------------------------------}
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
library out_unrealwiki;

uses
  FastShareMem in '..\FastShareMem.pas',
  SysUtils,
  Classes,
  unit_uclasses in '..\unit_uclasses.pas',
  unit_outputdefs in '..\unit_outputdefs.pas',
  IdHTTP,
  shellapi,
  Windows;

type
    THTTPThread = class(TThread)
    protected
        info: TUCXOutputInfo;
    public
        constructor Create(var myinfo: TUCXOutputInfo);
        procedure Execute; override;
    end;

const
    URL_WIKI_BASE = 'http://wiki.beyondunreal.com/wiki/';
    URL_WIKI_SEARCH = 'http://wiki.beyondunreal.com/wiki?search=';
    ERROR404 = '"page not found"';

{$R *.res}

// return true if succesfull
function UCX_Details(var Info: TUCXOutputDetails): boolean; stdcall
begin
    Info.AName := 'UnrealWiki';
    Info.ADescription := 'Open the UnrealWiki page for this class';
    Info.ASingleClass := true;
    Info.AMultipleClass := false;
    result := true;
end;

// return true if succesfull
function UCX_Output(var Info: TUCXOutputInfo): boolean; stdcall
begin
    result := false;
    if (info.ASelectedClass = nil) then exit;
    Info.WaitForTerminate := true;
    try
        Info.AThread := THTTPThread.Create(Info);
    finally
    end;
    result := true;
end;

constructor THTTPThread.Create(var myinfo: TUCXOutputInfo);
begin
    info := myinfo;
    OnTerminate := myinfo.AThreadTerminated;
    FreeOnTerminate := true;
    inherited create(true);
end;

procedure THTTPThread.Execute;
var
	http: TidHTTP;
    url, res: string;
begin
    url := URL_WIKI_BASE+info.ASelectedClass.name;
    info.AStatusReport('Trying '+url+' ...');
    http := TidHTTP.Create(nil);
    http.HandleRedirects := true;
    res := http.Get(url);
    if (http.Response.Location <> '') then begin
        url := http.Response.Location;
    end;
    if ((Pos(ERROR404, res) <> 0) or (http.ResponseCode = 404)) then begin
        info.AStatusReport('Class''s page not found on the UnrealWiki');
        if (MessageBox(0, pchar('No UnrealWiki was found for this class name.'+#13+#10+
            'Do you want to search the wiki for '''+info.ASelectedClass.name+'''?'), pchar('No page found'),
            MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = idYes) then begin
            url := URL_WIKI_SEARCH+info.ASelectedClass.name;
            ShellExecute(0, nil, pchar(url), nil, nil, SW_SHOW);
        end;
    end
    else if (http.ResponseCode = 200) then begin
        info.AStatusReport('Found '+url+', opening page ...');
        ShellExecute(0, nil, pchar(url), nil, nil, SW_SHOW);
    end
    else begin
        info.AStatusReport('Invalid HTTP response from the UnrealWiki: '+IntToStr(http.ResponseCode));
    end;
    http.Free;
    info.AThreadTerminated(self);
end;

exports
    UCX_Output,
    UCX_Details;

begin
end.
