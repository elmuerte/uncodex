unit unit_analyse;

interface

uses
  Windows, SysUtils, Variants, Classes, unit_uclasses, unit_parser,
  unit_definitions;

type
  TClassAnalyser = class(TThread)
  private
    onlynew: boolean;
    instate: boolean;
    currentState: TUState;
    classes: TUClassList;
    uclass: TUClass;
    fs: TFileStream;
    p: TUCParser;
    status: TStatusReport;
    procedure AnalyseClass();
    function pConst: TUConst;
    function pVar: TUProperty;
    function pEnum: TUEnum;
    function pStruct: TUStruct;
    function pFunc: TUFunction;
    function pState(modifiers: string): TUState;
    function pBrackets: string;
    function pSquareBrackets: string;
    function pAngleBrackets: string;
    function pCurlyBrackets: string;
    procedure ExecuteList;
    procedure ExecuteSingle;
  public
    constructor Create(classes: TUClassList; status: TStatusReport; onlynew: boolean = false); overload;
    constructor Create(uclass: TUClass; status: TStatusReport; onlynew: boolean = false); overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;

implementation

uses unit_main;

constructor TClassAnalyser.Create(classes: TUClassList; status: TStatusReport; onlynew: boolean = false);
begin
  self.classes := classes;
  Self.status := status;
  Self.onlynew := onlynew;
  Self.FreeOnTerminate := true;
  instate := false;
  inherited Create(true);
end;

constructor TClassAnalyser.Create(uclass: TUClass; status: TStatusReport; onlynew: boolean = false);
begin
  self.classes := nil;
  self.uclass := uclass;
  Self.status := status;
  Self.onlynew := onlynew;
  Self.FreeOnTerminate := true;
  inherited Create(true);
end;

destructor TClassAnalyser.Destroy;
begin
  inherited Destroy();
end;

procedure TClassAnalyser.Execute;
var
  stime: Cardinal;
begin
  stime := GetTickCount();
  if (classes = nil) then begin
    Status('Analysing class '+uclass.name+' ...');
    ExecuteSingle;
  end
  else ExecuteList;
  Status('Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds');
end;

procedure TClassAnalyser.ExecuteList;
var
  i: integer;
begin
  for i := 0 to classes.Count-1 do begin
    uclass := classes[i];
    Status('Analysing class '+uclass.name+' ...', round(i/(classes.count-1)*100));
    ExecuteSingle;
    if (Self.Terminated) then break;
  end;
end;

procedure TClassAnalyser.ExecuteSingle;
var
  filename: string;
  currenttime: Integer;
begin
  filename := uclass.package.path+PATHDELIM+CLASSDIR+PATHDELIM+uclass.filename;
  if (not FileExists(filename)) then begin
    Log('Cant''t open file: '+filename);
    exit;
  end;
  currenttime := FileAge(filename);
  if (onlynew and (currenttime <= uclass.filetime)) then exit;
  if (onlynew) then Log('Class changed since last time: '+uclass.name);
  uclass.filetime := currenttime;
  fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
  p := TUCParser.Create(fs);
  try
    uclass.consts.Clear;
    uclass.properties.Clear;
    uclass.enums.Clear;
    uclass.structs.Clear;
    uclass.functions.Clear;
    uclass.states.Clear;
    AnalyseClass();
    if (not Self.Terminated) then begin
      uclass.consts.Sort;
      uclass.properties.Sort;
      uclass.enums.Sort;
      uclass.structs.Sort;
      uclass.functions.Sort;
      uclass.states.Sort;
    end;
  finally
    p.Free;
    fs.Free;
  end;
end;

function TClassAnalyser.pBrackets: string;
begin
  result := '';
  if (p.Token = '(') then begin
    p.NextToken;
    while ((p.Token <> ')')  and (p.Token <> toEOF)) do begin
      if (result <> '') then result := result+' ';
      result := result+p.TokenString;
      p.NextToken;
    end;
    p.NextToken;
    result := '('+result+')';
  end;
  if (p.Token = toEOF) then result := '';
end;

function TClassAnalyser.pSquareBrackets: string;
begin
  result := '';
  if (p.Token = '[') then begin
    p.NextToken;
    while ((p.Token <> ']') and (p.Token <> toEOF)) do begin
      if (result <> '') then result := result+' ';
      result := result+p.TokenString;
      p.NextToken;
    end;
    p.NextToken;
    result := '['+result+']';
  end;
  if (p.Token = toEOF) then result := '';
end;

function TClassAnalyser.pAngleBrackets: string;
var
  bcount: integer;
begin
  result := '';
  bcount := 0;
  if (p.Token = '<') then begin
    Inc(bcount);
    result := p.TokenString;
    p.NextToken;
    while ((bcount > 0)  and (p.Token <> toEOF)) do begin
      result := result+p.TokenString;
      case (p.Token) of
        '<': Inc(bcount);
        '>': Dec(bcount);
      end;
      p.NextToken;
    end;
  end;
  if (p.Token = toEOF) then result := '';
end;

function TClassAnalyser.pCurlyBrackets: string;
var
  bcount: integer;
begin
  result := '';
  bcount := 0;
  if (p.Token = '{') then begin
    Inc(bcount);
    result := p.TokenString;
    p.NextToken;
    while ((bcount > 0) and (p.Token <> toEOF)) do begin
      result := result+p.TokenString;
      case (p.Token) of
        '{': Inc(bcount);
        '}': Dec(bcount);
      end;
      p.NextToken;
    end;
  end;
  if (p.Token = toEOF) then result := '';
end;

// const <name> = <value>;
function TClassAnalyser.pConst: TUConst;
begin
  result := TUConst.Create;
  result.comment := p.GetCopyData;
  result.name := p.TokenString;
  result.srcline := p.SourceLine;
  p.NextToken; // =
  p.NextToken;
  result.value := p.TokenString;
  p.NextToken; // = ;
  uclass.consts.Add(result);
end;

// var() <modifiers> <type> <name>,<name>;
// var() <modifiers> enum <name> {...} <name>,<name>;
function TClassAnalyser.pVar: TUProperty;
var
  last, prev: string;
  nprop: TUProperty;
  i: integer;
begin
  pBrackets;
  result := TUProperty.Create;
  result.comment := p.GetCopyData;
  result.srcline := p.SourceLine;
  while (p.Token <> ';') do begin
    if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
    result.modifiers := result.modifiers+prev;
    
    prev := last;
    last := p.TokenString;
    p.NextToken;
    while (p.Token = ',') do begin
      p.NextToken;
      last := last+','+p.TokenString;
      p.NextToken;
    end;
    last := last+pSquareBrackets;
    last := last+pAngleBrackets;
    if (CompareText(last, 'enum') = 0) then begin
      prev := pEnum.name;
      last := p.TokenString;
      p.NextToken;
      last := last+pSquareBrackets; // name
      while (p.Token = ',') do begin
        p.NextToken;
        last := last+','+p.TokenString;
        p.NextToken;
        last := last+pSquareBrackets; // name
      end;
      break;
    end;
  end;
  result.ptype := prev;
  result.name := last;
  i := Pos(',', result.name);
  while (i > 0) do begin
    nprop := TUProperty.Create;
    nprop.comment := result.comment;
    nprop.srcline := result.srcline;
    nprop.ptype := result.ptype;
    nprop.modifiers := result.modifiers;
    nprop.name := Copy(result.name, 1, i-1);
    uclass.properties.Add(nprop);
    Delete(result.name, 1, i);
    i := Pos(',', result.name);
  end;
  uclass.properties.Add(result);
  p.NextToken;
end;

// enum <name> { <option>, ... };
function TClassAnalyser.pEnum: TUEnum;
begin
  result := TUEnum.Create;
  result.comment := p.GetCopyData;
  result.name := p.TokenString;
  result.srcline := p.SourceLine;
  p.NextToken; // {
  p.NextToken; // first element
  while (p.Token <> '}') do begin
    result.options := result.options+p.TokenString;
    p.NextToken;
  end;
  p.NextToken; // = ;
  uclass.enums.Add(result);
end;

// struct <modifiers> <name> [extends <name>] { declaration };
function TClassAnalyser.pStruct: TUStruct;
var
  last, prev: string;
begin
  Result := TUStruct.Create;
  result.comment := p.GetCopyData;
  result.name := p.TokenString;
  result.srcline := p.SourceLine;
  while (p.Token <> '{') do begin
    if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
    result.modifiers := result.modifiers+prev;
    prev := last;
    last := p.TokenString;
    p.NextToken;
    if (p.TokenSymbolIs('extends') or p.TokenSymbolIs('expands')) then begin
      p.NextToken;
      result.parent := p.TokenString;
      p.NextToken;
      break;
    end;
  end;
  result.name := last;
  result.data := p.TokenString;
  p.FullCopy := true;
  p.GetCopyData(true);// preflush
  pCurlyBrackets();
  p.FullCopy := false;
  result.data := result.data+p.GetCopyData(true);
  p.NextToken; // = ;
  uclass.structs.Add(result);
end;

// <modifiers> function <return> <name> ( <params>, <param> )
function TClassAnalyser.pFunc: TUFunction;
var
  bcount: integer;
  last: string;
const
  OPERATOR_NAMES: set of char = ['+', '-', '!', '<', '>', '=', '~', '*', '|', '^'];
begin
  bcount := 0;
  result := TUFunction.Create;
  result.srcline := p.SourceLine;
  while not (p.TokenSymbolIs('function') or p.TokenSymbolIs('event') or
    p.TokenSymbolIs('operator') or p.TokenSymbolIs('preoperator') or
    p.TokenSymbolIs('postoperator') or p.TokenSymbolIs('delegate') or
    p.TokenSymbolIs('state') or (p.token = toEOF)) do begin
    if (instate) then begin
      if (p.Token = ':') then begin // state labels
        bcount := 1;
        while (bcount > 0) do begin
          p.NextToken;
          case (p.token) of
            '{' : Inc(bcount);
            '}' : Dec(bcount);
          end;
        end;
        p.NextToken;
        currentState := nil;
        instate := false;
        result.Free;
        exit;
      end;
    end;
    if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
    result.modifiers := result.modifiers+last;
    last := p.TokenString;
    p.NextToken;
    last := last+pBrackets;
  end;
  if (p.token = toEOF) then begin
    log('EOF reached in pFunc of '+uclass.name+'('+IntToStr(p.SourceLine)+') '+result.modifiers);
    result.Free;
    Exception.Create('EOF reached');
  end;
  if (result.modifiers <> '') then result.modifiers := result.modifiers+' ';
  result.modifiers := result.modifiers+last;
  if (p.TokenSymbolIs('state')) then begin
    pState(result.modifiers);
    result.Free;
    exit;
  end
  else if (p.TokenSymbolIs('event')) then result.ftype := uftEvent
  else if (p.TokenSymbolIs('operator')) then result.ftype := uftOperator
  else if (p.TokenSymbolIs('preoperator')) then result.ftype := uftPreoperator
  else if (p.TokenSymbolIs('postoperator')) then result.ftype := uftPostoperator
  else if (p.TokenSymbolIs('delegate')) then result.ftype := uftDelegate
  else result.ftype := uftFunction;
  result.comment := p.GetCopyData;
  //FIXME: todo function type
  p.NextToken;
  pBrackets; // possible operator precendence
  result.return := p.TokenString; // optional return
  p.NextToken;
  // check if return is array<> or class<>
  if ((CompareText(result.return, 'array') = 0) or
      (CompareText(result.return, 'class') = 0)) then result.return := result.return+pAngleBrackets;
  if (p.Token = '(') then begin
    result.name := result.return;
    result.return := '';
  end
  else begin
    result.name := p.TokenString;
    p.NextToken; // (
  end;
  // fix operator names
  while (p.Token in OPERATOR_NAMES) do begin
    result.name := result.name+p.TokenString;
    p.NextToken; 
  end;
  p.NextToken; // (
  while (p.Token <> ')') do begin
    // todo params
    result.params := result.params+' '+p.TokenString;
    p.NextToken;
  end;
  p.NextToken; // )
  if (p.Token <> ';') then begin
    if (p.Token = '{') then bcount := 1;
    while (bcount > 0) do begin
     p.NextToken;
     case (p.token) of
        '{' : Inc(bcount);
        '}' : Dec(bcount);
      end;
    end;
  end;
  p.NextToken; // = } or ;
  result.state := currentState;
  uclass.functions.Add(result);
end;

// [modifiers] state <name> [extends <name>] { .. }
function TClassAnalyser.pState(modifiers: string): TUState;
begin
  result := TUState.Create;
  result.comment := p.GetCopyData;
  result.srcline := p.SourceLine;
  result.modifiers := modifiers;
  p.NextToken; // name
  pBrackets;
  result.name := p.TokenString;
  p.NextToken;
  if (p.TokenSymbolIs('extends') or p.TokenSymbolIs('expands')) then begin
    p.NextToken; // extends
    result.extends := p.TokenString;
    p.NextToken;
  end;
  if (p.Token = '{') then begin
    p.NextToken;
    instate := true;
    if (p.TokenSymbolIs('ignores')) then begin
      while (p.Token <> ';') do p.NextToken;
    end;
  end;
  currentState := Result;
  uclass.states.Add(result);
end;

procedure TClassAnalyser.AnalyseClass;
var
  bHadClass: boolean;
begin
  bHadClass := false;
  while ((p.token <> toEOF) and (not Self.Terminated)) do begin

      // first check class
      // class <classname> extends [<package>].<classname> <modifiers>;
      if (p.TokenSymbolIs('class') and not bHadClass) then begin
        bHadClass := true;
        p.NextToken;
        uclass.name := p.TokenString;
        uclass.comment := p.GetCopyData;
        p.NextToken;
        if (p.TokenSymbolIs('extends') or p.TokenSymbolIs('expands')) then begin
          p.NextToken;
          uclass.parentname := p.TokenString;
          if (p.NextToken = '.') then begin // package.class
            p.NextToken;                    // (should work with checking package)
            uclass.parentname := p.TokenString;
          end;
        end;
        uclass.modifiers := '';
        while (p.Token <> ';') do begin
          uclass.modifiers := uclass.modifiers+p.TokenString+' ';
          p.NextToken;
        end;
        continue;
      end;
      if (p.TokenSymbolIs('var')) then begin
        p.NextToken;
        pVar();
        continue;
      end;
      if (p.TokenSymbolIs('const')) then begin
        p.NextToken;
        pConst();
        continue;
      end;
      if (p.TokenSymbolIs('enum')) then begin
        p.NextToken;
        pEnum();
        continue;
      end;
      if (p.TokenSymbolIs('struct')) then begin
        p.NextToken;
        pStruct();
        continue;
      end;
      if (p.TokenSymbolIs('defaultproperties')) then begin
        p.GetCopyData(true);// preflush
        p.NextToken;
        uclass.defaultproperties := p.TokenString;
        p.FullCopy := true;
        pCurlyBrackets();
        p.FullCopy := false;
        uclass.defaultproperties := uclass.defaultproperties+p.GetCopyData(true);
        continue;
      end;
      if (p.TokenSymbolIs('replication')) then begin
        p.NextToken;
        pCurlyBrackets();
        continue;
      end;
      if (p.TokenSymbolIs('cpptext')) then begin
        p.NextToken;
        pCurlyBrackets();
        continue;
      end;
      if ((p.Token = '}') and instate) then begin
        currentState := nil;
        instate := false;
        p.NextToken;
        continue;
      end;
      if (p.Token = toSymbol) then begin
        // I think it's a function or an event
        pFunc();
        continue;
      end;

    p.NextToken;
  end;
end;

end.
