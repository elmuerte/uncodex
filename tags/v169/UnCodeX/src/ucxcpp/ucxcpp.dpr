{-----------------------------------------------------------------------------
 Unit Name: ucxcpp
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   UnCodeX Comment PreProcessor (Example)
-----------------------------------------------------------------------------}

program ucxcpp;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  comment: string;
  c: char;

begin
  while (not eof(input)) do begin
    c := #0;
    comment := '';
    while ((c <> #4) and (not eof(input))) do begin
      read(input, c);
      if (c <> #4) then comment := comment+c;
    end;
    writeln(ErrOutput, 'Got comment:');
    comment := StringReplace(comment, 'Unreal', '<a href="http://www.unreal.com">Unreal</a>', [rfReplaceAll, rfIgnoreCase]);
    write(output, comment+#4);
    flush(output);
    writeln(ErrOutput, comment);
  end;
end.
