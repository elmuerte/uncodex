{-----------------------------------------------------------------------------
 Unit Name: unit_wiki
 Author:    elmuerte
 Copyright: 2003, 2004 Michiel 'El Muerte' Hendriks
 Purpose:   Copy paste window
 $Id: unit_wiki.pas,v 1.10 2006/01/14 21:26:09 elmuerte Exp $
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

unit unit_wiki;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, unit_uclasses, Buttons;

type
  Tfrm_Wikifier = class(TForm)
    re_WikiCode: TRichEdit;
    btn_SelectAll: TBitBtn;
    btn_Copy: TBitBtn;
    btn_Close: TBitBtn;
    procedure btn_SelectAllClick(Sender: TObject);
    procedure btn_CopyClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Wikify(uclass: TUClass);
  end;

var
  frm_Wikifier: Tfrm_Wikifier;

implementation

uses unit_comment2doc;

{$R *.dfm}

function StringShift(var input: string; delim: string = ','): string;
var
  i: integer;
begin
  i := Pos(delim, input);
  if (i = 0) then i := Length(input)+1;
  result := trim(Copy(input, 1, i-1));
  Delete(input, 1, i);
  input := trim(input);
end;

function FixComments(comment: string; fixnl: boolean = true): string;
var
	sl: TStringList;
	i: integer;
begin
  comment := convertComment(comment, dfAuto, dfWookee);
  if (fixnl) then result := StringReplace(trim(comment), #13#10, '\\'+#13#10, [rfReplaceAll])
  else result := comment;
  result := StringReplace(result, #9, ' ', [rfReplaceAll]);
  
  sl := TStringList.Create;
  try
    sl.Text := result;
		for i := 0 to sl.count-1 do begin
			sl[i] := trim(sl[i]);
    end;
    result := sl.Text;
  finally
  	sl.Free;
  end;
end;

procedure Tfrm_Wikifier.Wikify(uclass: TUClass);
var
  tmp: string;
  i, j, evtcnt: integer;
  pclass: TUClass;
  hist: TStringList;
begin
  evtcnt := 0;
  hist := TStringList.Create;
  try
    Caption := Caption+' - '+uclass.name;
    with (re_WikiCode.Lines) do begin
      { header }
      pclass := uclass.parent;
      while (pclass <> nil) do begin
        tmp := '[['+pclass.name+']] >> '+tmp;
        pclass := pclass.parent;
      end;
      tmp := '@@ [[... ENGINE ...]] :: '+tmp+'[['+uclass.name+']]';
      Add(tmp);
      Add(FixComments(uclass.comment, false));
      { Constants }
      if (uclass.consts.Count > 0) then begin
        Add('');
        Add('== Constants');
        for i := 0 to uclass.consts.Count-1 do begin
          Add('; '+uclass.consts[i].name+' = '+uclass.consts[i].value+' : '+FixComments(trim(uclass.consts[i].comment)));
        end;
      end;
      { properties }
      if (uclass.properties.Count > 0) then begin
        uclass.properties.SortOnTag;
        Add('');
        Add('== Properties');
        tmp := '';
        for i := 0 to uclass.properties.Count-1 do begin
          if (tmp <> uclass.properties[i].tag) then begin
            Add('=== '+uclass.properties[i].tag);
            tmp := uclass.properties[i].tag;
          end;
          Add('; '+uclass.properties[i].ptype+' '+uclass.properties[i].name+' : '+FixComments(trim(uclass.properties[i].comment)));
        end;
        uclass.properties.Sort;
      end;
      { enums }
      if (uclass.enums.Count > 0) then begin
        Add('');
        Add('== Enums');
        for i := 0 to uclass.enums.Count-1 do begin
          Add('');
          Add('=== '+uclass.enums[i].name);
          Add(FixComments(trim(uclass.enums[i].comment)));
          tmp := uclass.enums[i].options;
          while (tmp <> '') do begin
            Add('; '+StringShift(tmp)+' :');
          end;
        end;
      end;
      { structs }
      if (uclass.structs.Count > 0) then begin
        Add('');
        Add('== Structures');
        for i := 0 to uclass.structs.Count-1 do begin
          Add('');
          Add('=== '+uclass.structs[i].name);
          //Add('<uscript>'+uclass.structs[i].data+'</uscript>');
          Add(FixComments(trim(uclass.structs[i].comment)));

          { struct properties }
          if (uclass.structs[i].properties.Count > 0) then begin
            uclass.structs[i].properties.SortOnTag;
            tmp := '';
            for j := 0 to uclass.structs[i].properties.Count-1 do begin
              if (tmp <> uclass.structs[i].properties[j].tag) then begin
                Add('==== '+uclass.structs[i].properties[j].tag);
                tmp := uclass.structs[i].properties[j].tag;
              end;
              Add('; '+uclass.structs[i].properties[j].ptype+' '+uclass.structs[i].properties[j].name+' : '+FixComments(trim(uclass.structs[i].properties[j].comment)));
            end;
            uclass.structs[i].properties.Sort;
          end;
        end;
      end;
      { delegates }
      if (uclass.delegates.Count > 0) then begin
        Add('');
        Add('== Delegates');
        hist.Clear;
        for i := 0 to uclass.delegates.Count-1 do begin
          if (uclass.delegates[i].ftype = uftDelegate) then begin
            if (hist.IndexOf(LowerCase(uclass.delegates[i].name)) = -1) then begin
              Add('; '+uclass.functions[i].return+' '+uclass.delegates[i].name+'('+StringReplace(uclass.delegates[i].params, #13#10, ' ', [rfReplaceAll])+' ): '+FixComments(trim(uclass.delegates[i].comment)));
              hist.Add(LowerCase(uclass.delegates[i].name));
            end;
          end;
        end;
      end;
      { functions }
      if (uclass.functions.Count > 0) then begin
        Add('');
        Add('== Functions');
        hist.Clear;
        for i := 0 to uclass.functions.Count-1 do begin
          if (uclass.functions[i].ftype = uftFunction) then begin
            if (hist.IndexOf(LowerCase(uclass.functions[i].name)) = -1) then begin
              Add('; '+uclass.functions[i].return+' '+uclass.functions[i].name+'('+StringReplace(uclass.functions[i].params, #13#10, ' ', [rfReplaceAll])+' ): '+FixComments(trim(uclass.functions[i].comment)));
              hist.Add(LowerCase(uclass.functions[i].name));
            end;
          end
          else if (uclass.functions[i].ftype = uftEvent) then Inc(evtcnt);
        end;
      end;
      { events }
      if (evtcnt > 0) then begin
        Add('');
        Add('== Events');
        hist.Clear;
        for i := 0 to uclass.functions.Count-1 do begin
          if (uclass.functions[i].ftype = uftEvent) then begin
            if (hist.IndexOf(LowerCase(uclass.functions[i].name)) = -1) then begin
              Add('; '+uclass.functions[i].return+' '+uclass.functions[i].name+'('+StringReplace(uclass.functions[i].params, #13#10, ' ', [rfReplaceAll])+' ): '+FixComments(trim(uclass.functions[i].comment)));
              hist.Add(LowerCase(uclass.functions[i].name));
            end;
          end;
        end;
      end;
    end;
  finally
    hist.Free;
  end;
end;

procedure Tfrm_Wikifier.btn_SelectAllClick(Sender: TObject);
begin
  re_WikiCode.SelectAll;
end;

procedure Tfrm_Wikifier.btn_CopyClick(Sender: TObject);
begin
  re_WikiCode.CopyToClipboard;
end;

procedure Tfrm_Wikifier.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

end.
