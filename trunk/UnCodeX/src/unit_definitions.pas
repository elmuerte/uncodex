{-----------------------------------------------------------------------------
 Unit Name: unit_definitions
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   General definitions
-----------------------------------------------------------------------------}

unit unit_definitions;

interface

uses
  Hashes, unit_uclasses;

type
  TLogProc = procedure (msg: string);
  TLogClassProc = procedure (msg: string; uclass: TUClass = nil);

  // Used for -reuse
  TRedirectStruct = packed record
    Find: string[64];
    OpenFind: boolean;
    OpenTags: boolean;
    Batch: string[255];
    NewHandle: integer;
  end;

  // repeat a string
  function StrRepeat(line: string; count: integer): string;

const
  APPTITLE = 'UnCodeX';
  APPVERSION = '104';

  PATHDELIM = '\';
  WILDCARD = '*.*';
  SOURCECARD = '*.uc';
  CLASSDIR = 'Classes';
  TEMPLATEPATH = 'Templates';

  // Full Text search tokens
  FTS_LN_BEGIN = ' #';
  FTS_LN_END = ': ';
  FTS_LN_SEP = ',';

  // Tree icons
  ICON_PACKAGE = 0;
  ICON_PACKAGE_TAGGED = 1;
  ICON_CLASS = 2;
  ICON_CLASS_TAGGED = 3;

  CMD_HELP =  'Commandline options:'+#13+#10+
              '-config'#9#9#9'loads a diffirent config file (next argument)'+#13+#10+
              '-batch'#9#9#9'start UnCodeX in batch processing mode, the next'+#13+#10+
              #9#9#9'arguments must contain the batch order, '+#13+#10+
              #9#9#9'which can be on of the following:'+#13+#10+
              #9'rebuild'#9#9'rebuild class tree'+#13+#10+
              #9'analyse'#9#9'analyse all classes'+#13+#10+
              #9'createhtml'#9'create HTML output'+#13+#10+
              #9'htmlhelp'#9#9'create MS HTML Help file'+#13+#10+
              #9'close'#9#9'close UnCodeX'+#13+#10+
              #9'ext:<name>'#9#9'call an custom output module'+#13+#10+
              #9'--'#9#9'end of batch commands'+#13+#10+
              '-find'#9#9#9'find a class'+#13+#10+
              '-help'#9#9#9'display this message'+#13+#10+
              '-hide'#9#9#9'hides UnCodeX'+#13+#10+
              '-handle'#9#9#9'Window handle'+#13+#10+
              '-open'#9#9#9'find and open a class'+#13+#10+
              '-reuse'#9#9#9'reuse a previous window'+#13+#10+
              '-tags'#9#9#9'display class properties';

var
  Keywords: Hashes.TStringHash;
  Log: TLogProc;
  LogClass: TLogClassProc;              

implementation

uses
  SysUtils, Classes;

var
  i: integer;
  sl: TStringList;

function StrRepeat(line: string; count: integer): string;
begin
  result := '';
  while (count > 0) do begin
    result := result+line;
    Dec(count);
  end;
end;

initialization
  Keywords := Hashes.TStringHash.Create;
  if (FileExists(ExtractFilePath(ParamStr(0))+'keywords.list')) then begin
    Keywords.Clear;
    sl := TStringList.Create;
    try
      sl.LoadFromFile(ExtractFilePath(ParamStr(0))+'keywords.list');
      for i := 0 to sl.Count-1 do begin
        if (sl[i] <> '') then Keywords.Items[LowerCase(sl[i])] := '-';
      end;
    finally
      sl.Free;
    end;
  end
  else begin
    Keywords.Items['abstract'] := '-';
    Keywords.Items['array'] := '-';
    Keywords.Items['bool'] := '-';
    Keywords.Items['break'] := '-';
    Keywords.Items['byte'] := '-';
    Keywords.Items['case'] := '-';
    Keywords.Items['class'] := '-';
    Keywords.Items['coerce'] := '-';
    Keywords.Items['collapsecategories'] := '-';
    Keywords.Items['config'] := '-';
    Keywords.Items['const'] := '-';
    Keywords.Items['continue'] := '-';
    Keywords.Items['cpptext'] := '-';
    Keywords.Items['defaultproperties'] := '-';
    Keywords.Items['delegate'] := '-';
    Keywords.Items['dependsOn'] := '-';
    Keywords.Items['do'] := '-';
    Keywords.Items['editconst'] := '-';
    Keywords.Items['editinline'] := '-';
    Keywords.Items['editinlinenew'] := '-';
    Keywords.Items['else'] := '-';
    Keywords.Items['enum'] := '-';
    Keywords.Items['event'] := '-';
    Keywords.Items['exec'] := '-';
    Keywords.Items['expands'] := '-';
    Keywords.Items['export'] := '-';
    Keywords.Items['exportstructs'] := '-';
    Keywords.Items['extends'] := '-';
    Keywords.Items['false'] := '-';
    Keywords.Items['final'] := '-';
    Keywords.Items['float'] := '-';
    Keywords.Items['for'] := '-';
    Keywords.Items['foreach'] := '-';
    Keywords.Items['function'] := '-';
    Keywords.Items['globalconfig'] := '-';
    Keywords.Items['hidecategories'] := '-';
    Keywords.Items['if'] := '-';
    Keywords.Items['ignores'] := '-';
    Keywords.Items['input'] := '-';
    Keywords.Items['instanced'] := '-';
    Keywords.Items['int'] := '-';
    Keywords.Items['latent'] := '-';
    Keywords.Items['local'] := '-';
    Keywords.Items['localized'] := '-';
    Keywords.Items['name'] := '-';
    Keywords.Items['native'] := '-';
    Keywords.Items['nativereplication'] := '-';
    Keywords.Items['new'] := '-';
    Keywords.Items['noexport'] := '-';
    Keywords.Items['noteditinlinenew'] := '-';
    Keywords.Items['notplaceable'] := '-';
    Keywords.Items['operator'] := '-';
    Keywords.Items['optional'] := '-';
    Keywords.Items['out'] := '-';
    Keywords.Items['perobjectconfig'] := '-';
    Keywords.Items['placeable'] := '-';
    Keywords.Items['postoperator'] := '-';
    Keywords.Items['preoperator'] := '-';
    Keywords.Items['private'] := '-';
    Keywords.Items['protected'] := '-';
    Keywords.Items['reliable'] := '-';
    Keywords.Items['replication'] := '-';
    Keywords.Items['return'] := '-';
    Keywords.Items['showcategories'] := '-';
    Keywords.Items['simulated'] := '-';
    Keywords.Items['singular'] := '-';
    Keywords.Items['skip'] := '-';
    Keywords.Items['spawn'] := '-';
    Keywords.Items['state'] := '-';
    Keywords.Items['static'] := '-';
    Keywords.Items['string'] := '-';
    Keywords.Items['struct'] := '-';
    Keywords.Items['switch'] := '-';
    Keywords.Items['then'] := '-';
    Keywords.Items['transient'] := '-';
    Keywords.Items['true'] := '-';
    Keywords.Items['unreliable'] := '-';
    Keywords.Items['until'] := '-';
    Keywords.Items['var'] := '-';
    Keywords.Items['while'] := '-';
    Keywords.Items['within'] := '-';
    sl := TStringList.Create;
    Keywords.Restart;
    try
      while (Keywords.Next) do begin
        if (Keywords.CurrentKey <> '') then sl.Add(Keywords.CurrentKey)
      end;
      sl.SaveToFile(ExtractFilePath(ParamStr(0))+'keywords.list');
    finally
      sl.Free;
    end;
  end;
  // fill keyword table -- end
finalization
  Keywords.Clear;
end.
