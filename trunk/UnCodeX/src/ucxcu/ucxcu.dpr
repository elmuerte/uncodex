program ucxcu;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  unit_clpipe in '..\unit_clpipe.pas',
  unit_copyparser in '..\unit_copyparser.pas',
  unit_definitions in '..\unit_definitions.pas',
  unit_htmlout in '..\unit_htmlout.pas',
  unit_mshtmlhelp in '..\unit_mshtmlhelp.pas',
  unit_outputdefs in '..\unit_outputdefs.pas',
  unit_packages in '..\unit_packages.pas',
  unit_parser in '..\unit_parser.pas',
  unit_sourceparser in '..\unit_sourceparser.pas',
  unit_uclasses in '..\unit_uclasses.pas',
  unit_analyse in '..\unit_analyse.pas',
  Hashes in '..\Hashes.pas';

const
  PB_BEGIN = '[';
  PB_END = ']';
  PB_DONE = #219; // full bock
  PB_TODO = #176; // 25% block
  VERSION = '002 Alpha';

var
  lastsp: integer;

procedure DrawProgressBar(progress: integer; size: integer = 20; showvalue: boolean = true; text: string = '');
var
  sp: integer;
begin
  if (showvalue) then size := size - 5;
  sp := round(progress / (100 / size));
  if (sp = lastsp) then exit;
  write(#13+text);
  write(PB_BEGIN);
  write(StrRepeat(PB_DONE, sp));
  write(StrRepeat(PB_TODO, size - sp));
  write(PB_END);
  if (showvalue) then write(format(' %3d%%', [progress]));
end;

procedure PrintBanner;
begin
  writeln('------------------------------------------------------------');
  writeln(' UnCodeX Commandline Utility (ucxcu) version '+VERSION);
  writeln(' (c) 2003 Michiel ''El Muerte'' Hendriks');
  writeln(' http://wiki.beyondunreal.com/wiki/UnCodeX');
  writeln('------------------------------------------------------------');
  writeln('');
end;


var
  i: integer;
  times: array[0..5] of Cardinal;
  curlabel: string;
begin
  PrintBanner;
  times[0] := GetTickCount;
  curlabel := '1) Scanning packages   ';
  for i := 0 to 100 do begin
    DrawProgressBar(i,35,true,curlabel);
    sleep(10);
  end;
  times[1] := GetTickCount-times[0];
  writeln(#13+curlabel+format(': completed in %n seconds                   ', [times[1]/1000]));

  curlabel := '2) Building classtree  ';
  for i := 0 to 100 do begin
    DrawProgressBar(i,35,true,curlabel);
    sleep(5);
  end;
  times[2] := GetTickCount-times[1]-times[0];
  writeln(#13+curlabel+format(': completed in %n seconds                     ', [times[2]/1000]));

  curlabel := '3) Analysing classes   ';
  for i := 0 to 100 do begin
    DrawProgressBar(i,35,true,curlabel);
    sleep(12);
  end;
  times[3] := GetTickCount-times[2]-times[1]-times[0];
  writeln(#13+curlabel+format(': completed in %n seconds                    ', [times[3]/1000]));

  curlabel := '4) Creating HTML files ';
  for i := 0 to 100 do begin
    DrawProgressBar(i,35,true,curlabel);
    sleep(15);
  end;
  times[4] := GetTickCount-times[3]-times[2]-times[1]-times[0];
  writeln(#13+curlabel+format(': completed in %n seconds                  ', [times[4]/1000]));

  writeln('');
  writeln('Done in '+FloatToStr((GetTickCount-times[0]) / 1000)+' seconds');



  sleep(5000);
end.
 