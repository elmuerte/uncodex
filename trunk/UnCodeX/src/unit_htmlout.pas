unit unit_htmlout;

interface

uses
  Windows, Classes, SysUtils, ComCtrls, unit_uclasses, unit_definitions, StrUtils,
  Hashes, IniFiles;

type
  TGlossaryItem = class(TObject)
    classname: string;
    link: string;
  end;

  TGlossaryInfo = class(TObject)
    item: string;
    glossay: TStringList;
  end;

  THTMLoutConfig = record
    PackageList: TUPackageList;
    ClassList: TUClassList;
    ClassTree: TTreeView;
    outputdir, TemplateDir: string;
  end;

  TReplacement = function(var replacement: string; data: TObject = nil): boolean of Object;

  THTMLOutput = class(TThread)
  private
    MaxInherit: integer;
    HTMLOutputDir: string;
    TemplateDir: string;
    TypeCache: Hashes.TStringHash;
    ConstCache: Hashes.TStringHash;
    VarCache: Hashes.TStringHash;
    EnumCache: Hashes.TStringHash;
    StructCache: Hashes.TStringHash;
    FunctionCache: Hashes.TStringHash;
    
    PackageList: TUPackageList;
    ClassList: TUClassList;
    ClassTree: TTreeView;
    status: TStatusReport;
    ini: TMemIniFile;
    procedure parseTemplate(input, output: TStream; replace: TReplacement; data: TObject = nil);
    function replaceDefault(var replacement: string; data: TObject = nil): boolean;
    procedure htmlIndex; // creates index.html
    function replaceIndex(var replacement: string; data: TObject = nil): boolean;
    procedure htmlOverview; // creates overview.html
    function replaceOverview(var replacement: string; data: TObject = nil): boolean;
    procedure htmlPackagesList; // creates packages.html
    function replacePackagesList(var replacement: string; data: TObject = nil): boolean;
    function replacePackagesListEntry(var replacement: string; data: TObject = nil): boolean;
    procedure htmlClassesList; // creates classes.html
    function replaceClassesList(var replacement: string; data: TObject = nil): boolean;
    procedure htmlPackageOverview; // creates <packagename>.html
    function replacePackageOverview(var replacement: string; data: TObject = nil): boolean;
    procedure htmlClassOverview; // creates <packagename>_<classname>.html
    function replaceClass(var replacement: string; data: TObject = nil): boolean;
    function replaceClassConst(var replacement: string; data: TObject = nil): boolean;
    function replaceClassVar(var replacement: string; data: TObject = nil): boolean;
    function replaceClassEnum(var replacement: string; data: TObject = nil): boolean;
    function replaceClassStruct(var replacement: string; data: TObject = nil): boolean;
    function replaceClassFunction(var replacement: string; data: TObject = nil): boolean;
    function GetTypeLink(name: string): string;
    function TypeLink(name: string; uclass: TUClass): string;
    procedure htmlTree;
    procedure ProcTreeNode(var replacement: string; node: TTreeNode; basestring: string);
    function replaceClasstree(var replacement: string; data: TObject = nil): boolean;
    procedure htmlGlossary;
    function replaceGlossary(var replacement: string; data: TObject = nil): boolean;
    procedure CopyFiles;
  public
    constructor Create(config: THTMLoutConfig; status: TStatusReport);
    destructor Destroy; override;
    procedure Execute; override;
  end;

  function ClassLink(uclass: TUClass): string;

const
  default_title = 'UnCodeX';
  packages_list_filename = 'packages.html';
  classes_list_filename = 'classes.html';
  overview_filename = 'overview.html';
  classtree_filename = 'classtree.html';
  glossary_filename = 'glossary_A.html';

implementation

uses unit_copyparser, unit_main;

var
  currentClass: TUClass;

function ClassLink(uclass: TUClass): string;
begin
  result := LowerCase(uclass.package.name+'_'+uclass.name+'.html');
end;

function HTMLChars(line: string): string;
begin
  result := StringReplace(line, '<', '&lt;', [rfReplaceAll]);
  result := StringReplace(result, '>', '&gt;', [rfReplaceAll]);
  result := StringReplace(result, '"', '&quot;', [rfReplaceAll]);
end;

constructor THTMLOutput.Create(config: THTMLoutConfig; status: TStatusReport);
begin
  Self.PackageList := Config.PackageList;
  Self.ClassList := Config.ClassList;
  Self.ClassTree := Config.ClassTree;
  Self.status := status;
  Self.HTMLOutputDir := Config.outputdir;
  Self.TemplateDir := Config.TemplateDir+PATHDELIM;
  TypeCache := Hashes.TStringHash.Create;
  ConstCache := Hashes.TStringHash.Create;
  VarCache := Hashes.TStringHash.Create;
  EnumCache := Hashes.TStringHash.Create;
  StructCache := Hashes.TStringHash.Create;
  FunctionCache := Hashes.TStringHash.Create;
  ini := TMemIniFile.Create(TemplateDir+'template.ini');
  MaxInherit := ini.ReadInteger('Settings', 'MaxInherit', MaxInt);
  if (MaxInherit <= 0) then MaxInherit := MaxInt;
  inherited Create(true);
end;

destructor THTMLOutput.Destroy;
begin
  //TypeCache.Free; <-- will crash the system
  TypeCache.Clear;
  ConstCache.Clear;
  VarCache.Clear;
  EnumCache.Clear;
  StructCache.Clear;
  FunctionCache.Clear;
  ini.Free;
end;

procedure THTMLOutput.Execute;
var
  stime: Cardinal;
  i: integer;
begin
  Status('Working ...', 0);
  stime := GetTickCount();
  forcedirectories(htmloutputdir);
  PackageList.AlphaSort;
  ClassList.Sort;
  TypeCache.Items['int'] := '-';
  TypeCache.Items['string'] := '-';
  TypeCache.Items['float'] := '-';
  TypeCache.Items['bool'] := '-';
  TypeCache.Items['byte'] := '-';
  TypeCache.Items['class'] := '-';
  TypeCache.Items['name'] := '-';
  for i := 0 to ClassTree.Items.Count-1 do begin
    if (not TypeCache.Exists(LowerCase(ClassTree.Items[i].Text))) then
      TypeCache.Items[LowerCase(ClassTree.Items[i].Text)] := TUClass(ClassTree.Items[i].data).package.name+'_'+TUClass(ClassTree.Items[i].data).name+'.html'
      else Log('Type already cached '+ClassTree.Items[i].Text);
  end;

  if (not Self.Terminated) then htmlIndex;
  if (not Self.Terminated) then htmlOverview;
  if (not Self.Terminated) then htmlPackagesList;
  if (not Self.Terminated) then htmlClassesList;
  if (not Self.Terminated) then htmlPackageOverview;
  if (not Self.Terminated) then htmlClassOverview;
  if (ini.ReadBool('Settings', 'CreateClassTree', true) and (not Self.Terminated)) then htmlTree; // create class tree
  if (ini.ReadBool('Settings', 'CreateGlossary', true) and (not Self.Terminated)) then htmlGlossary; // iglossery
  if (not Self.Terminated) then CopyFiles;
  Status('Operation completed in '+Format('%.3f', [(GetTickCount()-stime)/1000])+' seconds');
end;

procedure THTMLOutput.parseTemplate(input, output: TStream; replace: TReplacement; data: TObject = nil);
var
  p: TCopyParser;
  replacement: string;
begin
  p := TCopyParser.Create(input, output);
  try
    while (p.Token <> toEOF) do begin
      if (p.Token = '%') then begin
        replacement := p.SkipToToken('%');
        if (replace(replacement, data)) then begin
          p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
        end
        else begin // put back old
          replacement := '%'+replacement+'%';
          p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
        end;
      end
      else begin
        p.CopyTokenToOutput;
      end;
      p.SkipToken(true);
    end;
  finally
    p.Free;
  end;
end;

function THTMLOutput.replaceDefault(var replacement: string; data: TObject = nil): boolean;
begin
  result := false;
  if (CompareText(replacement, 'default_title') = 0) then begin
    replacement := default_title;
    result := true;
  end
  else if (CompareText(replacement, 'create_time') = 0) then begin
    replacement := DateTimeToStr(Now);
    result := true;
  end
  else if (CompareText(replacement, 'glossary_link') = 0) then begin
    replacement := glossary_filename;
    result := true;
  end
  else if (CompareText(replacement, 'glossary_title') = 0) then begin
    replacement := ini.ReadString('titles', 'Glossary', '');
    result := true;
  end
  else if (CompareText(replacement, 'classtree_link') = 0) then begin
    replacement := classtree_filename;
    result := true;
  end
  else if (CompareText(replacement, 'classtree_title') = 0) then begin
    replacement := ini.ReadString('titles', 'ClassTree', '');
    result := true;
  end
  else if (CompareText(replacement, 'index_link') = 0) then begin
    replacement := overview_filename;
    result := true;
  end
  else if (CompareText(replacement, 'index_title') = 0) then begin
    replacement := ini.ReadString('titles', 'Overview', '');
    result := true;
  end
end;

procedure THTMLOutput.htmlIndex;
var
  template, target: TFileStream;
begin
  Status('Creating index.html');
  template := TFileStream.Create(templatedir+'index.html', fmOpenRead or fmShareDenyWrite);
  target := TFileStream.Create(htmloutputdir+PATHDELIM+'index.html', fmCreate);
  try
    parseTemplate(template, target, replaceIndex);
  finally
    template.Free;
    target.Free;
  end;
end;

function THTMLOutput.replaceIndex(var replacement: string; data: TObject = nil): boolean;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'packages_list') = 0) then begin
    replacement := packages_list_filename;
    result := true;
  end
  else if (CompareText(replacement, 'classes_list') = 0) then begin
    replacement := classes_list_filename;
    result := true;
  end
  else if (CompareText(replacement, 'overview') = 0) then begin
    replacement := overview_filename;
    result := true;
  end
end;

procedure THTMLOutput.htmlOverview;
var
  template, target: TFileStream;
begin
  Status('Creating '+overview_filename);
  template := TFileStream.Create(templatedir+'overview.html', fmOpenRead or fmShareDenyWrite);
  target := TFileStream.Create(htmloutputdir+PATHDELIM+overview_filename, fmCreate);
  try
    parseTemplate(template, target, replaceOverview);
  finally
    template.Free;
    target.Free;
  end;
end;

function THTMLOutput.replaceOverview(var replacement: string; data: TObject = nil): boolean;
var
  template: TFileStream;
  target: TStringStream;
  i: integer;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'packages_table') = 0) then begin
    template := TFileStream.Create(templatedir+'packages_table_entry.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      for i := 0 to PackageList.Count-1 do begin
        template.Position := 0;
        parseTemplate(template, target, replacePackagesListEntry, PackageList[i]);
        if (Self.Terminated) then break;
      end;
      replacement := target.DataString;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
end;

procedure THTMLOutput.htmlPackagesList;
var
  template, target: TFileStream;
begin
  Status('Creating '+packages_list_filename);
  template := TFileStream.Create(templatedir+'packages_list.html', fmOpenRead or fmShareDenyWrite);
  target := TFileStream.Create(htmloutputdir+PATHDELIM+packages_list_filename, fmCreate);
  try
    parseTemplate(template, target, replacePackagesList);
  finally
    template.Free;
    target.Free;
  end;
end;

function THTMLOutput.replacePackagesList(var replacement: string; data: TObject = nil): boolean;
var
  template: TFileStream;
  target: TStringStream;
  i: integer;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'packages_list') = 0) then begin
    template := TFileStream.Create(templatedir+'packages_list_entry.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      for i := 0 to PackageList.Count-1 do begin
        template.Position := 0;
        parseTemplate(template, target, replacePackagesListEntry, PackageList[i]);
        if (Self.Terminated) then break;
      end;
      replacement := target.DataString;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
end;

function THTMLOutput.replacePackagesListEntry(var replacement: string; data: TObject = nil): boolean;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'package_link') = 0) then begin
    replacement := 'package_'+TUPackage(data).name+'.html';
    result := true;
  end
  else if (CompareText(replacement, 'package_name') = 0) then begin
    replacement := TUPackage(data).name;
    result := true;
  end
  else if (CompareText(replacement, 'package_class_count') = 0) then begin
    replacement := IntToStr(TUPackage(data).classes.count);
    result := true;
  end
  else if (CompareText(replacement, 'package_path') = 0) then begin
    replacement := TUPackage(data).path;
    result := true;
  end
end;

procedure THTMLOutput.htmlClassesList;
var
  template, target: TFileStream;
begin
  Status('Creating '+classes_list_filename);
  template := TFileStream.Create(templatedir+'classes_list.html', fmOpenRead or fmShareDenyWrite);
  target := TFileStream.Create(htmloutputdir+PATHDELIM+classes_list_filename, fmCreate);
  try
    parseTemplate(template, target, replaceClassesList);
  finally
    template.Free;
    target.Free;
  end;
end;

function THTMLOutput.replaceClassesList(var replacement: string; data: TObject = nil): boolean;
var
  template: TFileStream;
  target: TStringStream;
  i: integer;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'classes_list') = 0) then begin
    template := TFileStream.Create(templatedir+'classes_list_entry.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      for i := 0 to ClassList.Count-1 do begin
        template.Position := 0;
        parseTemplate(template, target, replaceClass, ClassList[i]);
        if (Self.Terminated) then break;
      end;
      replacement := target.DataString;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
end;

procedure THTMLOutput.htmlPackageOverview;
var
  template, target: TFileStream;
  i: integer;
begin
  template := TFileStream.Create(templatedir+'package_overview.html', fmOpenRead or fmShareDenyWrite);
  try
    for i := 0 to PackageList.Count-1 do begin
      Status('Creating package_'+PackageList[i].name+'.html');
      PackageList[i].classes.Sort;
      target := TFileStream.Create(htmloutputdir+PATHDELIM+'package_'+PackageList[i].name+'.html', fmCreate);
      try
        template.Position := 0;
        parseTemplate(template, target, replacePackageOverview, PackageList[i]);
      finally
        target.Free;
      end;
      if (Self.Terminated) then break;
    end;
  finally
    template.Free;
  end;
end;

function THTMLOutput.replacePackageOverview(var replacement: string; data: TObject = nil): boolean;
var
  template: TFileStream;
  target: TStringStream;
  i: integer;
begin
  result := replaceDefault(replacement) or replacePackagesListEntry(replacement, data);
  if (result) then exit;
  if (CompareText(replacement, 'package_classes_table') = 0) then begin
    template := TFileStream.Create(templatedir+'package_classes_table_entry.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      for i := 0 to TUPackage(data).classes.Count-1 do begin
        template.Position := 0;
        parseTemplate(template, target, replaceClass, TUPackage(data).classes[i]);
        if (Self.Terminated) then break;
      end;
      replacement := target.DataString;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
end;

procedure THTMLOutput.htmlClassOverview;
var
  template, target: TFileStream;
  i: integer;
begin
  template := TFileStream.Create(templatedir+'class.html', fmOpenRead or fmShareDenyWrite);
  try
    for i := 0 to ClassList.Count-1 do begin
      Status('Creating '+ClassLink(ClassList[i]), round(i/(classlist.count-1)*100));
      currentClass := ClassList[i];
      target := TFileStream.Create(htmloutputdir+PATHDELIM+ClassLink(ClassList[i]), fmCreate);
      try
        template.Position := 0;
        parseTemplate(template, target, replaceClass, ClassList[i]);
        if (Self.Terminated) then break;
      finally
        target.Free;
      end;
    end;
  finally
    template.Free;
  end;
end;

function CreateClassTree(uclass: TUClass; var level: integer): string;
begin
  if (uclass.parent <> nil) then begin
    result := CreateClassTree(uclass.parent, level);
  end;
  if (level > 0) then begin
    result := result+DupeString(' ', (Level-1)*4)+'|'+#10;
    result := result+DupeString(' ', (Level-1)*4)+'+-- ';
  end;
  result := result+'<a href="package_'+uclass.package.name+'.html">'+uclass.package.name+'</a>.<a href="'+uclass.package.name+'_'+uclass.name+'.html">'+uclass.name+'</a>'+#10;
  Inc(level);
end;

function THTMLOutput.replaceClass(var replacement: string; data: TObject = nil): boolean;
var
  i, cnt: integer;
  uclass, up: TUClass;
  template: TFileStream;
  target: TStringStream;
  tmp: string;
begin
  result := replaceDefault(replacement) or replacePackageOverview(replacement, TUClass(data).package);
  if (result) then exit;
  if (CompareText(replacement, 'class_link') = 0) then begin
    replacement := ClassLink(TUClass(data));
    result := true;
  end
  else if (CompareText(replacement, 'class_name') = 0) then begin
    replacement := TUClass(data).name;
    result := true;
  end
  else if (CompareText(replacement, 'class_modifiers') = 0) then begin
    replacement := TUClass(data).modifiers;
    result := true;
  end
  else if (CompareText(replacement, 'class_parent_tree') = 0) then begin
    i := 0;
    replacement := CreateClassTree(TUClass(data), i);
    result := true;
  end
  else if (CompareText(replacement, 'class_filename') = 0) then begin
    replacement := TUClass(data).filename;
    result := true;
  end
  else if (CompareText(replacement, 'class_fileage') = 0) then begin
    replacement := DateTimeToStr(FileDateToDateTime(TUClass(data).filetime));
    result := true;
  end
  else if (CompareText(replacement, 'class_children') = 0) then begin
    replacement := '';
    if (TUClass(data).treenode = nil) then begin
      log('Orphan detected: '+TUClass(data).package.name+'.'+TUClass(data).name);
      exit;
    end;
    for i := 0 to TUClass(data).treenode.count-1 do begin
      uclass := TUClass(TUClass(data).treenode[i].Data);
      if (uclass <> nil) then begin
        if (replacement <> '') then replacement := replacement+', ';
        replacement := replacement+'<a href="'+uclass.package.name+'_'+
          uclass.name+'.html">'+uclass.name+'</a>'
      end;
      if (Self.Terminated) then break;
    end;
    if (replacement <> '') then begin
      replacement := ini.ReadString('titles', 'DirectSubclasses', '')+replacement;
    end;
    result := true;
  end
  else if (CompareText(replacement, 'class_constants') = 0) then begin
    template := TFileStream.Create(templatedir+'class_const_entry.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      for i := 0 to TUClass(data).consts.Count-1 do begin
        template.Position := 0;
        parseTemplate(template, target, replaceClassConst, TUClass(data).consts[i]);
        if (Self.Terminated) then break;
      end;
      replacement := target.DataString;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'inherited_constants') = 0) then begin
    replacement := '';
    cnt := 0;
    template := TFileStream.Create(templatedir+'class_inherited.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      up := TUClass(data).parent;
      while ((up <> nil) and (cnt < MaxInherit)) do begin
        template.Position := 0;
        if (up.consts.Count > 0) then begin
          tmp := LowerCase(up.package.name+'.'+up.name);
          if (not ConstCache.Exists(tmp)) then begin
            parseTemplate(template, target, replaceClass, up);
            for i := 0 to up.consts.Count-1 do begin
              if (i > 0) then target.WriteString(', ');
              target.WriteString('<a href="'+ClassLink(up)+'#'+up.consts[i].name+'">'+up.consts[i].name+'</a>');
            end;
            replacement := replacement+target.DataString;
            ConstCache.Items[tmp] := target.DataString; // add to cache
            target.Position := 0; // clear template
            target.Size := 0; // clear template
          end
          else begin
            replacement := replacement+ConstCache.Items[tmp];
          end;
        end;
        up := up.parent;
        Inc(cnt);
        if (Self.Terminated) then break;
      end;
      if (replacement <> '') then begin
        replacement := ini.ReadString('titles', 'InheritedConstants', '')+replacement;
      end;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'class_variables') = 0) then begin
    template := TFileStream.Create(templatedir+'class_var_entry.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      for i := 0 to TUClass(data).properties.Count-1 do begin
        template.Position := 0;
        parseTemplate(template, target, replaceClassVar, TUClass(data).properties[i]);
        if (Self.Terminated) then break;
      end;
      replacement := target.DataString;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'inherited_variables') = 0) then begin
    replacement := '';
    cnt := 0;
    template := TFileStream.Create(templatedir+'class_inherited.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      up := TUClass(data).parent;
      while ((up <> nil) and (cnt < MaxInherit)) do begin
        template.Position := 0;
        if (up.properties.Count > 0) then begin
          tmp := LowerCase(up.package.name+'.'+up.name);
          if (not VarCache.Exists(tmp)) then begin
            parseTemplate(template, target, replaceClass, up);
            for i := 0 to up.properties.Count-1 do begin
              if (i > 0) then target.WriteString(', ');
              target.WriteString('<a href="'+ClassLink(up)+'#'+up.properties[i].name+'">'+up.properties[i].name+'</a>');
            end;
            replacement := replacement+target.DataString;
            VarCache.Items[tmp] := target.DataString; // add to cache
            target.Position := 0; // clear template
            target.Size := 0; // clear template
          end
          else begin
            replacement := replacement+VarCache.Items[tmp];
          end;
        end;
        up := up.parent;
        Inc(cnt);
        if (Self.Terminated) then break;
      end;
      if (replacement <> '') then begin
        replacement := ini.ReadString('titles', 'InheritedVariables', '')+replacement;
      end;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'class_enums') = 0) then begin
    template := TFileStream.Create(templatedir+'class_enum_entry.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      for i := 0 to TUClass(data).enums.Count-1 do begin
        template.Position := 0;
        parseTemplate(template, target, replaceClassEnum, TUClass(data).enums[i]);
        if (Self.Terminated) then break;
      end;
      replacement := target.DataString;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'inherited_enums') = 0) then begin
    replacement := '';
    cnt := 0;
    template := TFileStream.Create(templatedir+'class_inherited.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      up := TUClass(data).parent;
      while ((up <> nil) and (cnt < MaxInherit)) do begin
        template.Position := 0;
        if (up.enums.Count > 0) then begin
          tmp := LowerCase(up.package.name+'.'+up.name);
          if (not EnumCache.Exists(tmp)) then begin
            parseTemplate(template, target, replaceClass, up);
            for i := 0 to up.enums.Count-1 do begin
              if (i > 0) then target.WriteString(', ');
              target.WriteString('<a href="'+ClassLink(up)+'#'+up.enums[i].name+'">'+up.enums[i].name+'</a>');
            end;
            replacement := replacement+target.DataString;
            EnumCache.Items[tmp] := target.DataString; // add to cache
            target.Position := 0; // clear template
            target.Size := 0; // clear template
          end
          else begin
            replacement := replacement+EnumCache.Items[tmp];
          end;
        end;
        up := up.parent;
        Inc(cnt);
        if (Self.Terminated) then break;
      end;
      if (replacement <> '') then begin
        replacement := ini.ReadString('titles', 'InheritedEnums', '')+replacement;
      end;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'class_structs') = 0) then begin
    template := TFileStream.Create(templatedir+'class_struct_entry.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      for i := 0 to TUClass(data).structs.Count-1 do begin
        template.Position := 0;
        parseTemplate(template, target, replaceClassStruct, TUClass(data).structs[i]);
        if (Self.Terminated) then break;
      end;
      replacement := target.DataString;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'inherited_structs') = 0) then begin
    replacement := '';
    cnt := 0;
    template := TFileStream.Create(templatedir+'class_inherited.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      up := TUClass(data).parent;
      while ((up <> nil) and (cnt < MaxInherit)) do begin
        template.Position := 0;
        if (up.structs.Count > 0) then begin
          tmp := LowerCase(up.package.name+'.'+up.name);
          if (not StructCache.Exists(tmp)) then begin
            parseTemplate(template, target, replaceClass, up);
            for i := 0 to up.structs.Count-1 do begin
              if (i > 0) then target.WriteString(', ');
              target.WriteString('<a href="'+ClassLink(up)+'#'+up.structs[i].name+'">'+up.structs[i].name+'</a>');
            end;
            replacement := replacement+target.DataString;
            StructCache.Items[tmp] := target.DataString; // add to cache
            target.Position := 0; // clear template
            target.Size := 0; // clear template
          end
          else begin
            replacement := replacement+StructCache.Items[tmp];
          end;
        end;
        up := up.parent;
        Inc(cnt);
        if (Self.Terminated) then break;
      end;
      if (replacement <> '') then begin
        replacement := ini.ReadString('titles', 'InheritedStructs', '')+replacement;
      end;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'class_functions') = 0) then begin
    template := TFileStream.Create(templatedir+'class_function_entry.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      for i := 0 to TUClass(data).functions.Count-1 do begin
        template.Position := 0;
        parseTemplate(template, target, replaceClassFunction, TUClass(data).functions[i]);
        if (Self.Terminated) then break;
      end;
      replacement := target.DataString;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'inherited_functions') = 0) then begin
    replacement := '';
    cnt := 0;
    template := TFileStream.Create(templatedir+'class_inherited.html', fmOpenRead);
    target := TStringStream.Create('');
    try
      up := TUClass(data).parent;
      while ((up <> nil) and (cnt < MaxInherit)) do begin
        template.Position := 0;
        if (up.functions.Count > 0) then begin
          tmp := LowerCase(up.package.name+'.'+up.name);
          if (not FunctionCache.Exists(tmp)) then begin
            parseTemplate(template, target, replaceClass, up);
            for i := 0 to up.functions.Count-1 do begin
              if (i > 0) then target.WriteString(', ');
              target.WriteString('<a href="'+ClassLink(up)+'#'+HTMLChars(up.functions[i].name)+'">'+HTMLChars(up.functions[i].name)+'</a>');
            end;
            replacement := replacement+target.DataString;
            FunctionCache.Items[tmp] := target.DataString; // add to cache
            target.Position := 0; // clear template
            target.Size := 0; // clear template
          end
          else begin
            replacement := replacement+FunctionCache.Items[tmp];
          end;
        end;
        up := up.parent;
        Inc(cnt);
        if (Self.Terminated) then break;
      end;
      if (replacement <> '') then begin
        replacement := ini.ReadString('titles', 'InheritedFunctions', '')+replacement;
      end;
      result := true;
    finally
      template.Free;
      target.Free;
    end;
  end
  else if (CompareText(replacement, 'title_Constants') = 0) then begin
    if (TUClass(data).consts.Count > 0) then
      replacement := ini.ReadString('titles', 'Constants', '')
      else replacement := '';
    result := true;
  end
  else if (CompareText(replacement, 'title_Variables') = 0) then begin
    if (TUClass(data).properties.Count > 0) then
      replacement := ini.ReadString('titles', 'Variables', '')
      else replacement := '';
    result := true;
  end
  else if (CompareText(replacement, 'title_Enums') = 0) then begin
    if (TUClass(data).enums.Count > 0) then
      replacement := ini.ReadString('titles', 'Enums', '')
      else replacement := '';
    result := true;
  end
  else if (CompareText(replacement, 'title_Structs') = 0) then begin
    if (TUClass(data).structs.Count > 0) then
      replacement := ini.ReadString('titles', 'Structs', '')
      else replacement := '';
    result := true;
  end
  else if (CompareText(replacement, 'title_Functions') = 0) then begin
    if (TUClass(data).functions.Count > 0) then
      replacement := ini.ReadString('titles', 'Functions', '')
      else replacement := '';
    result := true;
  end
end;

function THTMLOutput.replaceClassConst(var replacement: string; data: TObject = nil): boolean;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'const_name') = 0) then begin
    replacement := TUConst(data).name;
    result := true;
  end
  else if (CompareText(replacement, 'const_value') = 0) then begin
    replacement := TUConst(data).value;
    result := true;
  end
  else if (CompareText(replacement, 'const_srcline') = 0) then begin
    replacement := IntToStr(TUConst(data).srcline);
    result := true;
  end
end;

function THTMLOutput.replaceClassVar(var replacement: string; data: TObject = nil): boolean;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'var_name') = 0) then begin
    replacement := TUProperty(data).name;
    result := true;
  end
  else if (CompareText(replacement, 'var_type') = 0) then begin
    replacement := GetTypeLink(TUProperty(data).ptype);
    result := true;
  end
  else if (CompareText(replacement, 'var_type_plain') = 0) then begin
    replacement := TUProperty(data).ptype;
    result := true;
  end
  else if (CompareText(replacement, 'var_modifiers') = 0) then begin
    replacement := TUProperty(data).modifiers;
    result := true;
  end
  else if (CompareText(replacement, 'var_srcline') = 0) then begin
    replacement := IntToStr(TUProperty(data).srcline);
    result := true;
  end
end;

function THTMLOutput.replaceClassEnum(var replacement: string; data: TObject = nil): boolean;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'enum_name') = 0) then begin
    replacement := TUEnum(data).name;
    result := true;
  end
  else if (CompareText(replacement, 'enum_options') = 0) then begin
    replacement := TUEnum(data).options;
    result := true;
  end
  else if (CompareText(replacement, 'enum_options_newline') = 0) then begin
    replacement := StringReplace(TUEnum(data).options, ',', ','+#10, [rfReplaceAll]);
    result := true;
  end
  else if (CompareText(replacement, 'enum_options_break') = 0) then begin
    replacement := StringReplace(TUEnum(data).options, ',', ',<br />', [rfReplaceAll]);
    result := true;
  end
  else if (CompareText(replacement, 'enum_srcline') = 0) then begin
    replacement := IntToStr(TUEnum(data).srcline);
    result := true;
  end
end;

function THTMLOutput.replaceClassStruct(var replacement: string; data: TObject = nil): boolean;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'struct_name') = 0) then begin
    replacement := TUStruct(data).name;
    result := true;
  end
  else if (CompareText(replacement, 'struct_extends') = 0) then begin
    replacement := TUStruct(data).parent;
    result := true;
  end
  else if (CompareText(replacement, 'struct_modifiers') = 0) then begin
    replacement := TUStruct(data).modifiers;
    result := true;
  end
  else if (CompareText(replacement, 'struct_data') = 0) then begin
    replacement := TUStruct(data).data;
    result := true;
  end
  else if (CompareText(replacement, 'struct_data_indent') = 0) then begin
    replacement := TUStruct(data).data;
    replacement := StringReplace(replacement, '{', '{<blockquote>', [rfReplaceAll]);
    replacement := StringReplace(replacement, '}', '</blockquote>}', [rfReplaceAll]);
    replacement := StringReplace(replacement, ';', ';<br>'+#13#10, [rfReplaceAll]);
    result := true;
  end
  else if (CompareText(replacement, 'struct_srcline') = 0) then begin
    replacement := IntToStr(TUStruct(data).srcline);
    result := true;
  end
end;

function THTMLOutput.replaceClassFunction(var replacement: string; data: TObject = nil): boolean;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'function_name') = 0) then begin
    replacement := HTMLChars(TUFunction(data).name);
    result := true;
  end
  else if (CompareText(replacement, 'function_return') = 0) then begin
    replacement := GetTypeLink(TUFunction(data).return);
    result := true;
  end
  else if (CompareText(replacement, 'function_return_plain') = 0) then begin
    replacement := TUFunction(data).return;
    result := true;
  end
  else if (CompareText(replacement, 'function_params') = 0) then begin
    replacement := HTMLChars(TUFunction(data).params);
    result := true;
  end
  else if (CompareText(replacement, 'function_modifiers') = 0) then begin
    replacement := TUFunction(data).modifiers;
    result := true;
  end
  else if (CompareText(replacement, 'function_state') = 0) then begin
    if (TUFunction(data).state <> nil) then replacement := TUFunction(data).state.name
      else replacement := '';
    result := true;
  end
  else if (CompareText(replacement, 'function_srcline') = 0) then begin
    replacement := IntToStr(TUFunction(data).srcline);
    result := true;
  end
end;

function THTMLOutput.GetTypeLink(name: string): string;
var
  tname: string;
  i: integer;
begin
  name := Trim(name);
  if (name = '') then exit;
  i := Pos('<', name);
  if (i > 0) then begin
    tname := Copy(name, 1, i-1);
    result := tname+'&lt;'+GetTypeLink(Copy(name,i+1, Length(name)-i-1))+'&gt;';
    exit;
  end;
  // do .
  tname := LowerCase(name);
  if (not TypeCache.Exists(tname)) then begin
    result := TypeLink(name, currentClass);
    if (result = '') then result := '-';
    TypeCache.Items[tname] := result;
  end
  else result := TypeCache.Items[tname];
  if (result = '-') then result := HTMLChars(name)
  else result := '<a href="'+result+'">'+HTMLChars(name)+'</a>';
end;

function THTMLOutput.TypeLink(name: string; uclass: TUClass): string;
var
  i: integer;
begin
  for i := 0 to uclass.enums.Count-1 do begin
    if (CompareText(uclass.enums[i].name, name) = 0) then begin
      result := ClassLink(uclass)+'#'+uclass.enums[i].name;
      exit;
    end;
  end;
  for i := 0 to uclass.structs.Count-1 do begin
    if (CompareText(uclass.structs[i].name, name) = 0) then begin
      result := ClassLink(uclass)+'#'+uclass.structs[i].name;
      exit;
    end;
  end;
  if (uclass.parent <> nil) then begin
    result := TypeLink(name, uclass.parent);
  end;
end;

procedure THTMLOutput.CopyFiles;
var
  tmp: string;
  sl: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  try
    ini.ReadSectionValues('CopyFiles', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      Log('Copy template file '+tmp);
      CopyFile(PChar(TemplateDir+tmp), PChar(HTMLOutputDir+PATHDELIM+tmp), false);
    end;
  finally
    sl.Free;
  end;
end;

procedure THTMLOutput.htmlTree;
var
  template, target: TFileStream;
begin
  Status('Creating '+classtree_filename);
  template := TFileStream.Create(templatedir+classtree_filename, fmOpenRead or fmShareDenyWrite);
  target := TFileStream.Create(htmloutputdir+PATHDELIM+classtree_filename, fmCreate);
  try
    parseTemplate(template, target, replaceClasstree);
  finally
    template.Free;
    target.Free;
  end;
end;

const
  TLINE = '|   ';
  TNODE = '+-- ';
  TBLANK ='    ';

procedure THTMLOutput.ProcTreeNode(var replacement: string; node: TTreeNode; basestring: string);
var
  i: integer;
begin
  Status('Creating '+classtree_filename+' class: '+node.Text);
  for i := 0 to node.Count-1 do begin
    replacement := replacement+basestring+TNODE+'<a href="'+ClassLink(TUClass(node.Item[i].data))+'" name="'+node.Item[i].Text+'">'+node.Item[i].Text+'</a>'+#13#10;
    if (i < node.Count-1)
      then ProcTreeNode(replacement, node.Item[i], basestring+TLINE)
      else ProcTreeNode(replacement, node.Item[i], basestring+TBLANK);
  end;
end;

function THTMLOutput.replaceClasstree(var replacement: string; data: TObject = nil): boolean;
var
  node: TTreeNode;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'classtree') = 0) then begin
    replacement := '';
    node := ClassTree.Items.GetFirstNode;
    while (node <> nil) do begin
      replacement := replacement+'<a href="'+ClassLink(TUClass(node.data))+'" name="'+node.Text+'">'+node.Text+'</a>'+#13#10;
      ProcTreeNode(replacement, node, '');
      node := node.getNextSibling;
    end;
    result := true;
  end
end;

procedure THTMLOutput.htmlGlossary;
var
  template, target: TFileStream;
  i,j: integer;
  gl: TStringList;
  gi, cgi: TGlossaryItem;
  gli: TGlossaryInfo;
const
  glossaryitems : array[0..25] of char = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
                                          'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
                                          'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');
begin
  Status('Creating glossay');
  template := TFileStream.Create(templatedir+'glossary.html', fmOpenRead or fmShareDenyWrite);
  gl := TStringList.Create;
  gli := TGlossaryInfo.Create;
  try
    // create table
    for i := 0 to ClassList.Count-1 do begin
      gi := TGlossaryItem.Create;
      cgi := gi;
      gi.classname := classlist[i].name;
      gi.link := ClassLink(classlist[i]);
      gl.AddObject(classlist[i].name, gi);
      for j := 0 to ClassList[i].consts.Count-1 do begin
        gi := TGlossaryItem.Create;
        gi.classname := cgi.classname;
        gi.link := cgi.link+'#'+classlist[i].consts[j].name;
        gl.AddObject(classlist[i].consts[j].name, gi);
      end;
      for j := 0 to ClassList[i].properties.Count-1 do begin
        gi := TGlossaryItem.Create;
        gi.classname := cgi.classname;
        gi.link := cgi.link+'#'+classlist[i].properties[j].name;
        gl.AddObject(classlist[i].properties[j].name, gi);
      end;
      for j := 0 to ClassList[i].enums.Count-1 do begin
        gi := TGlossaryItem.Create;
        gi.classname := cgi.classname;
        gi.link := cgi.link+'#'+classlist[i].enums[j].name;
        gl.AddObject(classlist[i].enums[j].name, gi);
      end;
      for j := 0 to ClassList[i].structs.Count-1 do begin
        gi := TGlossaryItem.Create;
        gi.classname := cgi.classname;
        gi.link := cgi.link+'#'+classlist[i].structs[j].name;
        gl.AddObject(classlist[i].structs[j].name, gi);
      end;
      for j := 0 to ClassList[i].functions.Count-1 do begin
        gi := TGlossaryItem.Create;
        gi.classname := cgi.classname;
        gi.link := cgi.link+'#'+classlist[i].functions[j].name;
        gl.AddObject(classlist[i].functions[j].name, gi);
      end;
      if (Self.Terminated) then break;
    end;
    gl.Sort;
    // create table -- end
    gli.glossay := gl;
    for i := Low(glossaryitems) to high(glossaryitems) do begin
      if (Self.Terminated) then break;
      gli.item := glossaryitems[i];
      Status('Creating glossary_'+glossaryitems[i]+'.html');
      template.Position := 0;
      target := TFileStream.Create(htmloutputdir+PATHDELIM+'glossary_'+glossaryitems[i]+'.html', fmCreate);
      try
        parseTemplate(template, target, replaceGlossary, gli);
      finally
        target.Free;
      end;
    end;
  finally
    gli.Free;
    gl.Free;
    template.Free;
  end;
end;

function THTMLOutput.replaceGlossary(var replacement: string; data: TObject = nil): boolean;
var
  i: integer;
  lastname: string;
  gl : TStringlist;
begin
  result := replaceDefault(replacement);
  if (result) then exit;
  if (CompareText(replacement, 'glossary_item') = 0) then begin
    replacement := TGlossaryInfo(data).item;
    result := true;
  end
  else if (CompareText(replacement, 'glossary_items') = 0) then begin
    replacement := '';
    gl := TGlossaryInfo(data).glossay;
    i := 0;
    while ((i < gl.Count) and (UpperCase(gl[i][1]) <> TGlossaryInfo(data).item)) do Inc(i);
    while ((i < gl.Count) and (UpperCase(gl[i][1]) = TGlossaryInfo(data).item)) do begin
      if ((i < (gl.Count-1)) and (CompareText(lastname, gl[i]) <> 0)) then begin
        if (CompareText(gl[i+1], gl[i]) = 0) then begin
          replacement := replacement+gl[i]+'<br>'+#13#10;
          lastname := gl[i];
        end;
      end;
      if (CompareText(lastname, gl[i]) = 0) then begin
        replacement := replacement+'... <a href="'+TGlossaryItem(gl.Objects[i]).link+'">'+TGlossaryItem(gl.Objects[i]).classname+'</a><br>';
      end
      else begin
        replacement := replacement+'<a href="'+TGlossaryItem(gl.Objects[i]).link+'">'+gl[i]+'</a><br>'+#13#10;
      end;
      lastname := gl[i];
      TGlossaryItem(gl.Objects[i]).Free;
      Inc(i);
    end;
    result := true;
  end
end;

end.
