unit unit_definitions;

interface

type
  TStatusReport = procedure(msg: string; progress: byte = 255) of Object;

  function StrRepeat(line: string; count: integer): string;
  
const
  APPTITLE = 'UnCodeX';
  APPVERSION = '032 Beta';

  PATHDELIM = '\';
  WILDCARD = '*.*';
  SOURCECARD = '*.uc';
  CLASSDIR = 'Classes';
  TEMPLATEPATH = 'Templates';

implementation

function StrRepeat(line: string; count: integer): string;
begin
  result := '';
  while (count > 0) do begin
    result := result+line;
    Dec(count);
  end;
end;

end.
 