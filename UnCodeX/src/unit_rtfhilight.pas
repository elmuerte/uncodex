unit unit_rtfhilight;

interface

uses
  Classes, SysUtils;

  procedure RTFHilightUScript(input, output: TStream);

implementation

uses unit_sourceparser, Hashes;

var
  Keywords: Hashes.TStringHash;

const
  RTFHeader: string = '{\rtf1\ansi\ansicpg1252\deff0\deflang1033'+
    '{\fonttbl\f0\fmodern Courier new;}'+
    '{\colortbl;'+
      '\red0\green0\blue196;'+      //cf1 string
      '\red0\green0\blue128;'+    //cf2 comment
      '\red128\green0\blue0;'+  //cf3 name
      '\red0\green128\blue0;'+    //cf4 macro
      '\red0\green0\blue0;'+    //cf5 type
    '}'+
    '{\f0\fs20 ';

procedure RTFHilightUScript(input, output: TStream);
var
  p: TSourceParser;
  replacement, tmp: string;
begin
  p := TSourceParser.Create(input, output);
  try
    replacement := RTFHeader;
    p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
    while (p.Token <> toEOF) do begin
      if (p.Token = '{') then begin
        replacement := '\{';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = '}') then begin
        replacement := '\}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = '\') then begin
        replacement := '\\';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toString) then begin
        replacement := '{\cf1'+p.TokenString+'}'; // cf1 = string
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toComment) then begin
        replacement := p.TokenString;
        replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
        replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
        replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
        replacement := StringReplace(replacement, #10, '\par ', [rfReplaceAll]);
        replacement := '{\cf2'+replacement+'}'; // cf2 = comment
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toInteger) then begin
        replacement := '{\cf1'+p.TokenString+'}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toFloat) then begin
        replacement := '{\cf1'+p.TokenString+'}';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toName) then begin
        replacement := '{\cf3'+p.TokenString+'}'; // cf3 = name
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toMacro) then begin
        replacement := p.TokenString;
        replacement := StringReplace(replacement, '{', '\{', [rfReplaceAll]);
        replacement := StringReplace(replacement, '}', '\}', [rfReplaceAll]);
        replacement := StringReplace(replacement, '\', '\\', [rfReplaceAll]);
        replacement := '{\cf4'+replacement+'}\par '; // cf4 = macro
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toSymbol) then begin
        tmp := LowerCase(p.TokenString);
        replacement := p.TokenString;
        if (Keywords.Exists(tmp)) then begin
          replacement := '{\b '+replacement+'}'; // bold
        //end
        //else if (TypeCache.Exists(tmp)) then begin
        //  replacement := '{\cf5'+replacement+'}'; // type
        end;
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else if (p.Token = toEOL) then begin
        replacement := p.TokenString+'\par ';
        p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
      end
      else p.CopyTokenToOutput;
      p.SkipToken(true);
    end;
    replacement := '}}';
    p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
  finally
    p.Free;
  end;
end;

initialization
  // fill keyword table
  Keywords := Hashes.TStringHash.Create;
  Keywords.Items['abstract'] := '';
  Keywords.Items['array'] := '';
  Keywords.Items['bool'] := '';
  Keywords.Items['break'] := '';
  Keywords.Items['byte'] := '';
  Keywords.Items['case'] := '';
  Keywords.Items['class'] := '';
  Keywords.Items['coerce'] := '';
  Keywords.Items['collapsecategories'] := '';
  Keywords.Items['config'] := '';
  Keywords.Items['const'] := '';
  Keywords.Items['continue'] := '';
  Keywords.Items['defaultproperties'] := '';
  Keywords.Items['do'] := '';
  Keywords.Items['editconst'] := '';
  Keywords.Items['editinline'] := '';
  Keywords.Items['else'] := '';
  Keywords.Items['enum'] := '';
  Keywords.Items['event'] := '';
  Keywords.Items['exec'] := '';
  Keywords.Items['export'] := '';
  Keywords.Items['exportstructs'] := '';
  Keywords.Items['extends'] := '';
  Keywords.Items['false'] := '';
  Keywords.Items['final'] := '';
  Keywords.Items['float'] := '';
  Keywords.Items['for'] := '';
  Keywords.Items['forEach'] := '';
  Keywords.Items['function'] := '';
  Keywords.Items['globalconfig'] := '';
  Keywords.Items['hidecategories'] := '';
  Keywords.Items['if'] := '';
  Keywords.Items['ignores'] := '';
  Keywords.Items['input'] := '';
  Keywords.Items['int'] := '';
  Keywords.Items['latent'] := '';
  Keywords.Items['local'] := '';
  Keywords.Items['localized'] := '';
  Keywords.Items['name'] := '';
  Keywords.Items['native'] := '';
  Keywords.Items['nativereplication'] := '';
  Keywords.Items['new'] := '';
  Keywords.Items['noexport'] := '';
  Keywords.Items['operator'] := '';
  Keywords.Items['optional'] := '';
  Keywords.Items['out'] := '';
  Keywords.Items['placeable'] := '';
  Keywords.Items['postoperator'] := '';
  Keywords.Items['preoperator'] := '';
  Keywords.Items['private'] := '';
  Keywords.Items['protected'] := '';
  Keywords.Items['reliable'] := '';
  Keywords.Items['replication'] := '';
  Keywords.Items['return'] := '';
  Keywords.Items['simulated'] := '';
  Keywords.Items['skip'] := '';
  Keywords.Items['spawn'] := '';
  Keywords.Items['state'] := '';
  Keywords.Items['static'] := '';
  Keywords.Items['string'] := '';
  Keywords.Items['struct'] := '';
  Keywords.Items['switch'] := '';
  Keywords.Items['then'] := '';
  Keywords.Items['transient'] := '';
  Keywords.Items['true'] := '';
  Keywords.Items['unreliable'] := '';
  Keywords.Items['until'] := '';
  Keywords.Items['var'] := '';
  Keywords.Items['while'] := '';
  // fill keyword table -- end
finalization
  Keywords.Clear;
end.
