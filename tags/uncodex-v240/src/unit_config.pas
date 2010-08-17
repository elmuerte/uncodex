{*******************************************************************************
  Name:
    unit_config
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Contains the configuration of UnCodeX

  $Id: unit_config.pas,v 1.19 2010/05/15 15:04:13 elmuerte Exp $
*******************************************************************************}

{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003-2005  Michiel Hendriks

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
unit unit_config;

{$I defines.inc}

interface

uses
  {$IFDEF TUCXGUIConfig}
  Graphics, Controls, unit_searchform, Contnrs,
  {$ENDIF}
  unit_htmlout, Classes, SysUtils, unit_ucxinifiles, unit_uclasses,
  unit_definitionlist;

type
  TUCXConfig = class(TObject)
  protected
    ConfigFile: string;
    ConfigVersion: integer;
    ini: TUCXIniFile;
    iniStack: TList;
    procedure UpgradeConfig; virtual;
    procedure InternalLoadFromIni; virtual;
    procedure InternalSaveToIni; virtual;
    procedure StackLoad(filename: string);
  public
    IncludeConfig: record
      Pre:                TStringList;
      Post:               TStringList;
    end;
    PackageList:          TUPackageList;
    ClassList:            TUClassList;
    BaseDefinitions:      TDefinitionList;

    PackagesPriority:     TStringList;
    IgnorePackages:       TStringList;
    SourcePaths:          TStringList;
    HTMLOutput:           THTMLoutConfig;
    HTMLHelp: record
      Compiler:           string;
      OutputFile:         string;
      Title:              string;
    end;
    Comments: record
      Packages:           string;
      Declarations:       string;
    end;
    FunctionModifiers:    TStringList;
  public
    constructor Create(filename: string);
    destructor Destroy; override;
    procedure LoadFromIni;
    procedure SaveToIni(filename: string = '');
    property Filename: String read ConfigFile;
  end;

  {$IFDEF VSADDIN}
  TUCXAddinConfig = class(TUCXConfig)
  protected
    procedure InternalLoadFromIni; override;
    procedure InternalSaveToIni; override;
  public
    StateFile:            string;
    constructor Create(filename: string);
  end;
  {$ENDIF}

  {$IFDEF TUCXGUIConfig}
  TAppBarLocation = (abNone, abLeft, abRight);

  TStoreControl = class(TControl)
  published
    property Font;
    property Color;
  end;

  TComponentSettings = class(TObject)
  public
    Font: record
      Color:              TColor;
      Name:               TFontName;
      Style:              TFontStyles;
      Size:               integer;
    end;
    Color:                TColor;
  public
    procedure Assign(target: TControl);
    procedure Import(source: TControl);
  end;

  TSourcePreviewFont = record
    Color:                TColor;
    Style:                TFontStyles;
  end;

  TBookmarkEntryType = (betLinenumber=0, betFieldname=1);

  TBookmarkEntry = class(TObject)
    EntryType:            TBookmarkEntryType;
    Entry:                string;
    Comment:              string;
  end;

  TBookmarkEntryList = class(TObjectList)
  end;

  TBookmark = class(TObject)
  protected
    fName: string;
  public
    Entries: TBookmarkEntryList;
    constructor Create(inname: string);
    destructor Destroy; override;
    property Name: string read fname;
    procedure AddEntry(encoded: string); overload;
    procedure AddEntry(intype: TBookmarkEntryType; inentry: string; incomment: string = ''); overload;
  end;

  TBookmarkList = class(TObjectList)
  end;

  TUCXGUIConfig = class(TUCXConfig)
  protected
    procedure UpgradeConfig; override;
    procedure InternalLoadFromIni; override;
    procedure InternalSaveToIni; override;
    procedure LoadComponentSettings(ident: string; cs: TComponentSettings);
    procedure LoadSourcePreviewFont(ident: string; var target: TSourcePreviewFont);
    procedure LoadBookmarks;
    procedure SaveComponentSettings(ident: string; cs: TComponentSettings);
    procedure SaveSourcePreviewFont(ident: string; var target: TSourcePreviewFont);
    procedure SaveBookmarks;
  public
    StateFile:            string;
    NewClassTemplate:     string;
    Startup: record
      AnalyseModified:    boolean;
    end;
    Plugins: record
      LoadDLLs:           boolean;
      PascalScriptPath:   string;
    end;
    Layout: record
      StayOnTop:          boolean;
      SavePosition:       boolean;
      SaveSize:           boolean;
      IsMaximized:        boolean;
      Top:                integer;
      Left:               integer;
      Width:              integer;
      Height:             integer;
      MenuBar:            boolean;
      Toolbar:            boolean;
      PackageTree:        boolean;
      Log:                boolean;
      SourcePreview:      boolean;
      PropertyInspector:  boolean;
      MinimizeOnClose:    boolean;
      ExpandObject:       boolean;
      TreeView:           TComponentSettings;
      LogWindow:          TComponentSettings;
      InlineSearchTimeout:integer;
    end;
    DockState: record
      data: record
        Center:           TMemorystream;
        Top:              TMemorystream;
        Bottom:           TMemorystream;
        Left:             TMemorystream;
        Right:            TMemorystream;
      end;
      size: record
        Top:              integer;
        Bottom:           integer;
        Left:             integer;
        Right:            integer;
      end;
      host: record
        Classes:          string;
        Packages:         string;
        Log:              string;
        SourcePreview:    string;
        PropertyInspector:string;
      end;
    end;
    ApplicationBar: record
      Width:              integer;
      AutoHide:           boolean;
      Location:           TAppBarLocation;
    end;
    SourcePreview: record
      Color:              TColor;
      FontName:           TFontName;
      FontSize:           integer;
      FontColor:          TColor;
      TabSize:            integer;
      HighLightColor:     TColor;
      Keyword1:           TSourcePreviewFont;
      Keyword2:           TSourcePreviewFont;
      StringType:         TSourcePreviewFont;
      Number:             TSourcePreviewFont;
      Macro:              TSourcePreviewFont;
      Comment:            TSourcePreviewFont;
      Name:               TSourcePreviewFont;
      ClassLink:          TSourcePreviewFont;
    end;
    PropertyInspector: record
      InheritenceDepth:   integer;
      AlwaysWindow:       boolean;
    end;
    HotKeys:              TStringList;
    Commands: record
      Server:             string;
      ServerPriority:     integer;
      Client:             string;
      Compiler:           string;
      OpenClass:          string;
    end;
    SearchConfig:         TSearchConfig;
    Bookmarks:            TBookmarkList;
  public
    constructor Create(filename: string);
    destructor Destroy; override;
  end;
  {$ENDIF}

implementation

uses
  unit_definitions;

const
  // always increase this when change have been made in the structure
  CURRENT_CONFIG_VERSION = 1;

{ TUCXConfig }
constructor TUCXConfig.Create(filename: string);
begin
  ConfigFile := filename;
  ConfigVersion := 0;
  iniStack := Tlist.Create;
  PackageList := TUPackageList.Create(true);
  ClassList := TUClassList.Create(true);
  BaseDefinitions := TDefinitionList.Create(nil);

  IncludeConfig.Pre := TStringList.Create;
  IncludeConfig.Post := TStringList.Create;
  {$IFDEF UNIX}
  IncludeConfig.Pre.Add('/etc/uncodexrc');
  IncludeConfig.Pre.Add('~.uncodexrc');
  {$ENDIF}
  PackagesPriority := TStringList.Create;
  IgnorePackages := TStringList.Create;
  SourcePaths := TStringList.Create;

  HTMLOutput.PackageList := PackageList;
  HTMLOutput.ClassList := ClassList;
   
  HTMLOutput.OutputDir := GetDataDirectory+'HTML';
  HTMLOutput.TemplateDir := ExtractFilePath(ParamStr(0))+TEMPLATEPATH+PATHDELIM+DEFTEMPLATE;
  HTMLOutput.CreateSource := tbMaybe;
  HTMLOutput.TabsToSpaces := 0;
  HTMLOutput.TargetExtention := '';
  HTMLOutput.CPP := '';
  HTMLOutput.DefaultTitle := '';
  HTMLOutput.GZCompress := tbMaybe;
  HTMLHelp.Compiler := '';
  HTMLHelp.OutputFile := GetDataDirectory+'UnCodeX-UnrealScript.chm';
  HTMLHelp.Title := '';
  Comments.Packages := GetDataDirectory+DefaultPDF;
  Comments.Declarations := GetDataDirectory+DefaultECF;

  FunctionModifiers := TStringList.Create;
  {$IFNDEF FPC}
  FunctionModifiers.CaseSensitive := false;
  {$ENDIF}
end;

destructor TUCXConfig.Destroy;
begin
  FreeAndNil(IncludeConfig.Pre);
  FreeAndNil(IncludeConfig.Post);
  FreeAndNil(PackagesPriority);
  FreeAndNil(IgnorePackages);
  FreeAndNil(SourcePaths);
  FreeAndNil(iniStack);
  FreeAndNil(PackageList);
  FreeAndNil(ClassList);
  FreeAndNil(BaseDefinitions);
  FreeAndNil(FunctionModifiers);
end;

function TriBoolToString(bool: TTriBool): string;
begin
  case bool of
    tbMaybe: result := 'Maybe';
    tbFalse: result := 'False';
    tbTrue: result := 'True';
  end;
end;

function StringToTriBool(bool: string; default: TTriBool = tbMaybe): TTriBool;
begin
  result := default;
  if (bool = '') then exit;
  case StrToIntDef(bool, -2) of
    -1: result := tbMaybe;
    0: result := tbFalse;
    1: result := tbTrue;
  else
    if (SameText(bool, 'Maybe')) then result := tbMaybe
    else if (SameText(bool, 'False')) then result := tbFalse
    else if (SameText(bool, 'true')) then result := tbTrue;
  end;
end;

procedure TUCXConfig.LoadFromIni;
var
  sl: TStringList;
  i: integer;
begin
  if (not FileExists(ConfigFile)) then exit;
  ini := TUCXIniFile.Create(ConfigFile);
  try
    ConfigVersion := ini.ReadInteger('Configuration', 'Version', -1);
    if (ConfigVersion < 0) then begin
      UpgradeConfig;
      ini.Clear; // erase old config
      InternalSaveToIni;
      ini.UpdateFile;
    end
    else begin
      InternalLoadFromIni;
      sl := TStringList.Create;
      try
        for i := 0 to IncludeConfig.Post.Count-1 do begin
          StackLoad(IncludeConfig.Post[i]);
        end;
      finally
        sl.Free;
      end;
    end;
  finally
    FreeAndNil(ini);
  end;
end;

procedure TUCXConfig.SaveToIni(filename: string = '');
begin
  if (filename = '') then filename := ConfigFile;
  if (FileExists(filename) and FileIsReadOnly(filename)) then exit;
  ini := TUCXIniFile.Create(filename);
  ini.DelayedUpdate := true;
  try
    ConfigVersion := CURRENT_CONFIG_VERSION;
    InternalSaveToIni;
    ini.UpdateFile;
  finally
    FreeAndNil(ini)
  end;
end;

procedure TUCXConfig.InternalLoadFromIni;
var
  i, n: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  ini.ReadStringArray('Include', 'Pre', sl);
  try
    for i := 0 to sl.Count-1 do begin
      IncludeConfig.Pre.Add(sl[i]);
      StackLoad(sl[i]);
    end;
  finally
    sl.Free;
  end;
  ini.ReadStringArray('Include', 'Post', IncludeConfig.Post, true);

  ini.ReadStringArray('Packages', 'EditPackages', PackagesPriority);
  sl := TStringList.Create;
  try
    ini.ReadStringArray('Packages', 'Tag', sl);
    for i := 0 to sl.Count-1 do begin
      n := PackagesPriority.IndexOf(sl[i]);
      if (n > -1) then PackagesPriority.Objects[n] := PackagesPriority;
    end;
  finally
    sl.Free;
  end;
  ini.ReadStringArray('Packages', 'IgnorePackage', IgnorePackages);
  ini.ReadStringArray('Sources', 'Path', SourcePaths);

  sl := TStringList.Create;
  ini.ReadSectionRaw('Defines', sl);
  try
    for i := 0 to sl.Count-1 do begin
      BaseDefinitions.AddEntry(sl[i]);
    end;
  finally
    sl.Free;
  end;

  with HTMLOutput do begin
    OutputDir := ini.ReadString('HTMLOutput', 'OutputDir', OutputDir);
    TemplateDir := ini.ReadString('HTMLOutput', 'TemplateDir', TemplateDir);
    CreateSource := StringToTriBool(ini.ReadString('HTMLOutput', 'CreateSource', ''), CreateSource);
    TabsToSpaces := ini.ReadInteger('HTMLOutput', 'TabsToSpaces', TabsToSpaces);
    TargetExtention := ini.ReadString('HTMLOutput', 'TargetExtention', TargetExtention);
    CPP := ini.ReadString('HTMLOutput', 'CommentPreProcessor', CPP);
    DefaultTitle := ini.ReadString('HTMLOutput', 'DefaultTitle', DefaultTitle);
    GZCompress := StringToTriBool(ini.ReadString('HTMLOutput', 'GZCompress', ''), GZCompress);
  end;
  with HTMLHelp do begin
    Compiler := ini.ReadString('HTMLHelp', 'Compiler', Compiler);
    OutputFile := ini.ReadString('HTMLHelp', 'OutputFile', OutputFile);
    Title := ini.ReadString('HTMLHelp', 'Title', Title);
  end;
  with Comments do begin
    Packages := ini.ReadString('ExternalComments', 'Packages', Packages);
    Declarations := ini.ReadString('ExternalComments', 'Declarations', Declarations)
  end;

  ini.ReadStringArray('Parser', 'FunctionModifiers', FunctionModifiers);
end;

procedure TUCXConfig.InternalSaveToIni;
var
  i: integer;
  sl: TStringList;
begin
  ini.WriteInteger('Configuration', 'Version', CURRENT_CONFIG_VERSION);

  ini.WriteStringArray('Packages', 'EditPackages', PackagesPriority);
  ini.DeleteKey('Packages', 'Tag');
  for i := 0 to PackagesPriority.Count-1 do begin
    if (PackagesPriority.Objects[i] <> nil) then ini.AddToStringArray('Packages', 'Tag', PackagesPriority[i]);
  end;
  ini.WriteStringArray('Packages', 'IgnorePackage', IgnorePackages);
  ini.WriteStringArray('Sources', 'Path', SourcePaths);

  sl := TStringList.Create;
  try
    for i := 0 to BaseDefinitions.Count-1 do begin
      sl.Add(BaseDefinitions.Entry[i])
    end;
    ini.WriteSectionRaw('Defines', sl);
  finally
    sl.Free;
  end;

  with HTMLOutput do begin
    ini.WriteString('HTMLOutput', 'OutputDir', OutputDir);
    ini.WriteString('HTMLOutput', 'TemplateDir', TemplateDir);
    ini.WriteString('HTMLOutput', 'CreateSource', TriBoolToString(CreateSource));
    ini.WriteInteger('HTMLOutput', 'TabsToSpaces', TabsToSpaces);
    ini.WriteString('HTMLOutput', 'TargetExtention', TargetExtention);
    ini.WriteString('HTMLOutput', 'CommentPreProcessor', CPP);
    ini.WriteString('HTMLOutput', 'DefaultTitle', DefaultTitle);
    ini.WriteString('HTMLOutput', 'GZCompress', TriBoolToString(GZCompress));
  end;
  with HTMLHelp do begin
    ini.WriteString('HTMLHelp', 'Compiler', Compiler);
    ini.WriteString('HTMLHelp', 'OutputFile', OutputFile);
    ini.WriteString('HTMLHelp', 'Title', Title);
  end;
  with Comments do begin
    ini.WriteString('ExternalComments', 'Packages', Packages);
    ini.WriteString('ExternalComments', 'Declarations', Declarations)
  end;

  ini.WriteStringArray('Parser', 'FunctionModifiers', FunctionModifiers);
end;

procedure TUCXConfig.UpgradeConfig;
var
  i: integer;
  sl: TStringList;
  tmp, tmp2: string;
begin
  //Log('Converting old configuration file');

  HTMLOutput.OutputDir := ini.ReadString('Config', 'HTMLOutputDir', HTMLOutput.OutputDir);
  HTMLOutput.TemplateDir := ini.ReadString('Config', 'TemplateDir', HTMLOutput.TemplateDir);
  HTMLOutput.TabsToSpaces := ini.ReadInteger('Config', 'TabsToSpaces', HTMLOutput.TabsToSpaces);
  HTMLOutput.TargetExtention := ini.ReadString('Config', 'HTMLTargetExt', HTMLOutput.TargetExtention);
  HTMLOutput.CPP := ini.ReadString('Config', 'CPP', HTMLOutput.CPP);
  HTMLOutput.DefaultTitle := ini.ReadString('Config', 'HTMLDefaultTitle', HTMLOutput.DefaultTitle);
  HTMLOutput.GZCompress := StringToTriBool(ini.ReadString('Config', 'GZCompress', ''), HTMLOutput.GZCompress);
  HTMLHelp.Compiler := ini.ReadString('Config', 'HHCPath', HTMLHelp.Compiler)+PATHDELIM+'HHC.EXE';
  HTMLHelp.OutputFile := ini.ReadString('Config', 'HTMLHelpFile', HTMLHelp.OutputFile);
  HTMLHelp.Title := ini.ReadString('Config', 'HHTitle', HTMLHelp.Title);
  Comments.Packages := ini.ReadString('Config', 'PackageDescriptionFile', Comments.Packages);
  Comments.Declarations := ini.ReadString('Config', 'ExternalCommentFile', Comments.Declarations);

  sl := TStringList.Create;
  try
    ini.ReadSectionRaw('PackagePriority', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      tmp2 := Copy(tmp, 1, Pos('=', tmp));
      Delete(tmp, 1, Pos('=', tmp));
      if (LowerCase(tmp2) = 'packages=') then begin
        PackagesPriority.Add(LowerCase(tmp));
      end;
    end;
    // must be after Package= listing
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      tmp2 := Copy(tmp, 1, Pos('=', tmp));
      Delete(tmp, 1, Pos('=', tmp));
      if (LowerCase(tmp2) = 'tag=') then begin
        PackagesPriority.Objects[PackagesPriority.IndexOf(LowerCase(tmp))] := PackagesPriority;
      end;
    end;
    ini.ReadSectionRaw('IgnorePackages', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      IgnorePackages.Add(LowerCase(tmp));
    end;
    ini.ReadSectionRaw('SourcePaths', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      SourcePaths.Add(LowerCase(tmp));
    end;
  finally
    sl.Free;
  end;
end;

procedure TUCXConfig.StackLoad(filename: string);
begin
  filename := iFindFile(filename);
  if (not FileExists(filename)) then exit;
  iniStack.Add(ini);
  try
    ini := TUCXIniFile.Create(filename);
    try
      InternalLoadFromIni;
    finally
      ini.Free;
    end;
  except
    //Log('Failed loading include config: '+filename, ltError);
    ini := TUCXIniFile(iniStack.Last);
    iniStack.Remove(ini);
  end;
end;

{$IFDEF VSADDIN}
constructor TUCXAddinConfig.Create(filename: string);
begin
  inherited Create(filename);
  StateFile := ChangeFileExt(filename, '.ucx');

  //Comments.Packages := ExtractFilePath(ParamStr(0))+DefaultPDF;
  //Comments.Declarations := ExtractFilePath(ParamStr(0))+DefaultECF;
end;

procedure TUCXAddinConfig.InternalLoadFromIni;
begin
  inherited InternalLoadFromIni;
  StateFile := ini.ReadString('VSADDIN.General', 'StateFile', StateFile);
  if (ExtractFilePath(StateFile) = '') then StateFile := ExtractFilePath(ini.filename)+StateFile;
end;

procedure TUCXAddinConfig.InternalSaveToIni;
var
  tmp: string;
begin
  inherited InternalSaveToIni;
  tmp := StateFile;
  if (SameText(ExtractFilePath(tmp), ExtractFilePath(ini.FileName))) then tmp := ExtractFileName(tmp);
  ini.WriteString('VSADDIN.General', 'StateFile', tmp);
end;
{$ENDIF}

{$IFDEF TUCXGUIConfig}

function StringToFontStyles(style: string): TFontStyles;
var
  tmp: string;
begin
  result := [];
  while (style <> '') do begin
    tmp := GetToken(style, ';');
    if (SameText(tmp, 'fsBold')) then Include(result, fsBold)
    else if (SameText(tmp, 'fsItalic')) then Include(result, fsItalic)
    else if (SameText(tmp, 'fsUnderline')) then Include(result, fsUnderline)
    else if (SameText(tmp, 'fsStrikeout')) then Include(result, fsStrikeout);
  end;
end;

function FontStylesToString(style: TFontStyles): string;
begin
  result := '';
  if (fsBold in style) then result := result+'fsBold;';
  if (fsItalic in style) then result := result+'fsItalic;';
  if (fsUnderline in style) then result := result+'fsUnderline;';
  if (fsStrikeout in style) then result := result+'fsStrikeout;';
end;

{ TUCXGUIConfig }

constructor TUCXGUIConfig.Create(filename: string);
begin
  inherited Create(filename);
  
  Layout.TreeView := TComponentSettings.Create;
  Layout.LogWindow := TComponentSettings.Create;
  DockState.data.Center := TMemoryStream.Create;
  DockState.data.Top := TMemoryStream.Create;
  DockState.data.Bottom := TMemoryStream.Create;
  DockState.data.Left := TMemoryStream.Create;
  DockState.data.Right := TMemoryStream.Create;
  HotKeys := TStringList.Create;

  Startup.AnalyseModified := true;
  Plugins.LoadDLLs := true;
  Plugins.PascalScriptPath := ExtractFilePath(ParamStr(0))+UPSDIR+PathDelim;
  Layout.StayOnTop := false;
  Layout.SavePosition := true;
  Layout.SaveSize := true;
  Layout.IsMaximized := false;
  Layout.Top := -1;
  Layout.Left := -1;
  Layout.Height := -1;
  Layout.Width := -1;
  Layout.MenuBar := true;
  Layout.Toolbar := true;
  Layout.PackageTree := true;
  Layout.Log := true;
  Layout.SourcePreview := true;
  Layout.PropertyInspector := false;
  Layout.MinimizeOnClose := false;
  Layout.ExpandObject := true;
  Layout.TreeView.Color := clWindow;
  Layout.TreeView.Font.Color := clWindowText;
  Layout.TreeView.Font.Name := 'MS Sans Serif';
  Layout.TreeView.Font.Style := [];
  Layout.TreeView.Font.Size := 8;
  Layout.LogWindow.Color := clWindow;
  Layout.LogWindow.Font.Color := clWindowText;
  Layout.LogWindow.Font.Name := 'Courier New';
  Layout.LogWindow.Font.Style := [];
  Layout.LogWindow.Font.Size := 8;
  Layout.LogWindow.Color := clWindow;
  Layout.InlineSearchTimeout := 5; // in seconds
  DockState.size.Top := -1;
  DockState.size.Bottom := -1;
  DockState.size.Left := -1;
  DockState.size.Right := -1;
  DockState.host.Classes := 'pnlCenter';
  DockState.host.Packages := 'dckLeft';
  DockState.host.Log := 'dckBottom';
  DockState.host.SourcePreview := 'dckRight';
  DockState.host.PropertyInspector := 'pnlCenter';
  ApplicationBar.Width := 150;
  ApplicationBar.AutoHide := false;
  ApplicationBar.Location := abNone;
  SourcePreview.Color := clWindow;
  SourcePreview.FontName := 'Courier New';
  SourcePreview.FontSize := 9;
  SourcePreview.FontColor := clBlack;
  SourcePreview.TabSize := 4;
  SourcePreview.HighLightColor := clFuchsia;
  SourcePreview.Keyword1.Color := $00000000;
  SourcePreview.Keyword1.Style := [fsBold];
  SourcePreview.Keyword2.Color := $00555555;
  SourcePreview.Keyword2.Style := [fsBold];
  SourcePreview.StringType.Color := $00FF0000;
  SourcePreview.StringType.Style := [];
  SourcePreview.Number.Color := $00FF0000;
  SourcePreview.Number.Style := [];
  SourcePreview.Macro.Color := $000000CC;
  SourcePreview.Macro.Style := [];
  SourcePreview.Comment.Color := $00339900;
  SourcePreview.Comment.Style := [fsItalic];
  SourcePreview.Name.Color := $00000066;
  SourcePreview.Name.Style := [];
  SourcePreview.ClassLink.Color := $00990000;
  SourcePreview.ClassLink.Style := [fsUnderline];
  PropertyInspector.InheritenceDepth := 0;
  PropertyInspector.AlwaysWindow := false;
  Commands.Server := '';
  Commands.ServerPriority := 1;
  Commands.Client := '';
  Commands.Compiler := '';
  Commands.OpenClass := '';
  SearchConfig.isFromTop := false;
  SearchConfig.isStrict := false;
  SearchConfig.isRegex := false;
  SearchConfig.isFindFirst := false;
  SearchConfig.Scope := 0;
  SearchConfig.history := TStringList.Create;
  SearchConfig.ftshistory := TStringList.Create;
  StateFile := ChangeFileExt(ExtractFilename(ConfigFile), '.ucx');
  Bookmarks := TBookmarkList.Create;
  NewClassTemplate := ExtractFilePath(ParamStr(0))+TEMPLATEPATH+PathDelim+'NewClass.uc';
end;

destructor TUCXGUIConfig.Destroy;
begin
  inherited Destroy;
  FreeAndNil(SearchConfig.history);
  FreeAndNil(SearchConfig.ftshistory);
  FreeAndNil(Layout.TreeView);
  FreeAndNil(Layout.LogWindow);
  FreeAndNil(DockState.data.Center);
  FreeAndNil(DockState.data.Top);
  FreeAndNil(DockState.data.Bottom);
  FreeAndNil(DockState.data.Left);
  FreeAndNil(DockState.data.Right);
  FreeAndNil(HotKeys);
  FreeAndNil(Bookmarks);
end;

procedure TUCXGUIConfig.InternalLoadFromIni;
begin
  inherited InternalLoadFromIni;
  with Startup do begin
    AnalyseModified := ini.ReadBool('GUI.Startup', 'AnalyseModified', AnalyseModified);
  end;
  with Plugins do begin
    LoadDLLs := ini.ReadBool('GUI.Plugins', 'LoadDLLs', LoadDLLs);
    PascalScriptPath := ini.ReadString('GUI.Plugins', 'PascalScriptPath', PascalScriptPath);
  end;
  with Layout do begin
    StayOnTop := ini.ReadBool('GUI.Layout', 'Option.StayOnTop', StayOnTop);
    SavePosition := ini.ReadBool('GUI.Layout', 'Option.SavePosition', SavePosition);
    SaveSize := ini.ReadBool('GUI.Layout', 'Option.SaveSize', SaveSize);
    IsMaximized := ini.ReadBool('GUI.Layout', 'Option.IsMaximized', IsMaximized);
    MinimizeOnClose := ini.ReadBool('GUI.Layout', 'Option.MinimizeOnClose', MinimizeOnClose);
    ExpandObject := ini.ReadBool('GUI.Layout', 'Option.ExpandObject', ExpandObject);
    Top := ini.ReadInteger('GUI.Layout', 'Position.Top', Top);
    Left := ini.ReadInteger('GUI.Layout', 'Position.Left', Left);
    Width := ini.ReadInteger('GUI.Layout', 'Position.Width', Width);
    Height := ini.ReadInteger('GUI.Layout', 'Position.Height', Height);
    MenuBar := ini.ReadBool('GUI.Layout', 'Show.MenuBar', MenuBar);
    Toolbar := ini.ReadBool('GUI.Layout', 'Show.Toolbar', Toolbar);
    PackageTree := ini.ReadBool('GUI.Layout', 'Show.PackageTree', PackageTree);
    Log := ini.ReadBool('GUI.Layout', 'Show.Log', Log);
    SourcePreview := ini.ReadBool('GUI.Layout', 'Show.SourcePreview', SourcePreview);
    PropertyInspector := ini.ReadBool('GUI.Layout', 'Show.PropertyInspector', PropertyInspector);
    LoadComponentSettings('TreeView', TreeView);
    LoadComponentSettings('LogWindow', LogWindow);
    InlineSearchTimeout := ini.ReadInteger('GUI.Layout', 'InlineSearchTimeout', InlineSearchTimeout);
  end;
  with DockState do begin
    data.Center.Clear;
    ini.ReadBinaryStream('GUI.DockState', 'data.Center', data.Center);
    data.Top.Clear;
    ini.ReadBinaryStream('GUI.DockState', 'data.Top', data.Top);
    data.Bottom.Clear;
    ini.ReadBinaryStream('GUI.DockState', 'data.Bottom', data.Bottom);
    data.Left.Clear;
    ini.ReadBinaryStream('GUI.DockState', 'data.Left', data.Left);
    data.Right.Clear;
    ini.ReadBinaryStream('GUI.DockState', 'data.Right', data.Right);
    size.Top := ini.ReadInteger('GUI.DockState', 'size.Top', size.Top);
    size.Bottom := ini.ReadInteger('GUI.DockState', 'size.Bottom', size.Bottom);
    size.Left := ini.ReadInteger('GUI.DockState', 'size.Left', size.Left);
    size.Right := ini.ReadInteger('GUI.DockState', 'size.Right', size.Right);
    host.Classes := ini.ReadString('GUI.DockState', 'host.Classes', host.Classes);
    host.Packages := ini.ReadString('GUI.DockState', 'host.Packages', host.Packages);
    host.Log := ini.ReadString('GUI.DockState', 'host.Log', host.Log);
    host.SourcePreview := ini.ReadString('GUI.DockState', 'host.SourcePreview', host.SourcePreview);
    host.PropertyInspector := ini.ReadString('GUI.DockState', 'host.Classes', host.PropertyInspector);
  end;
  with ApplicationBar do begin
    Width := ini.ReadInteger('GUI.ApplicationBar', 'Width', Width);
    AutoHide := ini.ReadBool('GUI.ApplicationBar', 'AutoHide', AutoHide);
    Location := TAppBarLocation(ini.ReadInteger('GUI.ApplicationBar','Location', ord(Location)));
  end;
  with SourcePreview do begin
    Color := ini.ReadInteger('GUI.SourcePreview', 'Color', Color);
    FontName := ini.ReadString('GUI.SourcePreview', 'FontName', FontName);
    FontSize := ini.ReadInteger('GUI.SourcePreview', 'FontSize', FontSize);
    FontColor := ini.ReadInteger('GUI.SourcePreview', 'FontColor', FontColor);
    TabSize := ini.ReadInteger('GUI.SourcePreview', 'TabSize', TabSize);
    HighLightColor := ini.ReadInteger('GUI.SourcePreview', 'HighLightColor', HighLightColor);
    LoadSourcePreviewFont('Keyword1', Keyword1);
    LoadSourcePreviewFont('Keyword2', Keyword2);
    LoadSourcePreviewFont('StringType', StringType);
    LoadSourcePreviewFont('Number', Number);
    LoadSourcePreviewFont('Comment', Comment);
    LoadSourcePreviewFont('Macro', Macro);
    LoadSourcePreviewFont('ClassLink', ClassLink);
  end;
  with PropertyInspector do begin
    InheritenceDepth := ini.ReadInteger('GUI.PropertyInspector', 'InheritenceDepth', InheritenceDepth);
    AlwaysWindow := ini.ReadBool('GUI.PropertyInspector', 'AlwaysWindow', AlwaysWindow);
  end;
  ini.ReadSectionRaw('GUI.HotKeys', HotKeys);
  with Commands do begin
    Server := ini.ReadString('GUI.Commands', 'Server', Server);
    ServerPriority := ini.ReadInteger('GUI.Commands', 'ServerPriority', ServerPriority);
    Client := ini.ReadString('GUI.Commands', 'Client', Client);
    Compiler := ini.ReadString('GUI.Commands', 'Compiler', Compiler);
    OpenClass := ini.ReadString('GUI.Commands', 'OpenClass', OpenClass);
  end;
  with SearchConfig do begin
    isFromTop := ini.ReadBool('GUI.Search', 'isFromTop', isFromTop);
    isStrict := ini.ReadBool('GUI.Search', 'isStrict', isStrict);
    isRegex := ini.ReadBool('GUI.Search', 'isRegex', isRegex);
    isFindFirst := ini.ReadBool('GUI.Search', 'isFindFirst', isFindFirst);
    Scope := ini.ReadInteger('GUI.Search', 'Scope', Scope);
    ini.ReadStringArray('GUI.Search', 'history', history);
    ini.ReadStringArray('GUI.Search', 'ftshistory', ftshistory);
  end;
  StateFile := ini.ReadString('GUI.General', 'StateFile', StateFile);
  if (ExtractFilePath(StateFile) = '') then StateFile := ExtractFilePath(ini.filename)+StateFile;
  NewClassTemplate := ini.ReadString('GUI.General', 'NewClassTemplate', NewClassTemplate);
  LoadBookmarks;
end;

procedure TUCXGUIConfig.LoadComponentSettings(ident: string; cs: TComponentSettings);
begin
  with cs do begin
    with font do begin
      Color := ini.ReadInteger('GUI.Layout', ident+'.Font.Color', Color);
      Name := ini.ReadString('GUI.Layout', ident+'.Font.Name', Name);
      Style := StringToFontStyles(ini.ReadString('GUI.Layout', ident+'.Font.Style', FontStylesToString(Style)));
      Size := ini.ReadInteger('GUI.Layout', ident+'.Font.Size', Size);
    end;
    Color := ini.ReadInteger('GUI.Layout', ident+'.Color', Color);
  end;
end;

procedure TUCXGUIConfig.LoadSourcePreviewFont(ident: string; var target: TSourcePreviewFont);
begin
  with target do begin
    Color := ini.ReadInteger('GUI.SourcePreview', ident+'.Color', Color);
    Style := StringToFontStyles(ini.ReadString('GUI.SourcePreview', ident+'.Style', FontStylesToString(Style)));
  end;
end;

procedure TUCXGUIConfig.LoadBookmarks;
var
  sl, sl2: TStringlist;
  i, j: integer;
  bm: TBookmark;
begin
  sl := TStringList.Create;
  try
    ini.ReadStringArray('Bookmarks', 'Mark', sl);
    for i := 0 to sl.count-1 do begin
      bm := TBookmark.Create(sl[i]);
      sl2 := TStringList.Create;
      try
        ini.ReadStringArray('Bookmarks', 'Entry.'+sl[i], sl2);
        for j := 0 to sl2.Count-1 do begin
          bm.AddEntry(sl2[j]);
        end;
      finally
        sl2.Free;
      end;
      Bookmarks.Add(bm);
    end;
  finally
    sl.Free;
  end;
end;

procedure TUCXGUIConfig.InternalSaveToIni;
var
  tmp: string;
begin
  inherited InternalSaveToIni;
  with Startup do begin
    ini.WriteBool('GUI.Startup', 'AnalyseModified', AnalyseModified);
  end;
  with Plugins do begin
    ini.WriteBool('GUI.Plugins', 'LoadDLLs', LoadDLLs);
    ini.WriteString('GUI.Plugins', 'PascalScriptPath', PascalScriptPath);
  end;
  with Layout do begin
    ini.WriteBool('GUI.Layout', 'Option.StayOnTop', StayOnTop);
    ini.WriteBool('GUI.Layout', 'Option.SavePosition', SavePosition);
    ini.WriteBool('GUI.Layout', 'Option.SaveSize', SaveSize);
    ini.WriteBool('GUI.Layout', 'Option.IsMaximized', IsMaximized);
    ini.WriteBool('GUI.Layout', 'Option.MinimizeOnClose', MinimizeOnClose);
    ini.WriteBool('GUI.Layout', 'Option.ExpandObject', ExpandObject);
    ini.WriteInteger('GUI.Layout', 'Position.Top', Top);
    ini.WriteInteger('GUI.Layout', 'Position.Left', Left);
    ini.WriteInteger('GUI.Layout', 'Position.Width', Width);
    ini.WriteInteger('GUI.Layout', 'Position.Height', Height);
    ini.WriteBool('GUI.Layout', 'Show.MenuBar', MenuBar);
    ini.WriteBool('GUI.Layout', 'Show.Toolbar', Toolbar);
    ini.WriteBool('GUI.Layout', 'Show.PackageTree', PackageTree);
    ini.WriteBool('GUI.Layout', 'Show.Log', Log);
    ini.WriteBool('GUI.Layout', 'Show.SourcePreview', SourcePreview);
    ini.WriteBool('GUI.Layout', 'Show.PropertyInspector', PropertyInspector);
    SaveComponentSettings('TreeView', TreeView);
    SaveComponentSettings('LogWindow', LogWindow);
    ini.WriteInteger('GUI.Layout', 'InlineSearchTimeout', InlineSearchTimeout);
  end;
  with DockState do begin
    ini.WriteBinaryStream('GUI.DockState', 'data.Center', data.Center);
    ini.WriteBinaryStream('GUI.DockState', 'data.Top', data.Top);
    ini.WriteBinaryStream('GUI.DockState', 'data.Bottom', data.Bottom);
    ini.WriteBinaryStream('GUI.DockState', 'data.Left', data.Left);
    ini.WriteBinaryStream('GUI.DockState', 'data.Right', data.Right);
    ini.WriteInteger('GUI.DockState', 'size.Top', size.Top);
    ini.WriteInteger('GUI.DockState', 'size.Bottom', size.Bottom);
    ini.WriteInteger('GUI.DockState', 'size.Left', size.Left);
    ini.WriteInteger('GUI.DockState', 'size.Right', size.Right);
    ini.WriteString('GUI.DockState', 'host.Classes', host.Classes);
    ini.WriteString('GUI.DockState', 'host.Packages', host.Packages);
    ini.WriteString('GUI.DockState', 'host.Log', host.Log);
    ini.WriteString('GUI.DockState', 'host.SourcePreview', host.SourcePreview);
    ini.WriteString('GUI.DockState', 'host.Classes', host.PropertyInspector);
  end;
  with ApplicationBar do begin
    ini.WriteInteger('GUI.ApplicationBar', 'Width', Width);
    ini.WriteBool('GUI.ApplicationBar', 'AutoHide', AutoHide);
    ini.WriteInteger('GUI.ApplicationBar','Location', ord(Location));
  end;
  with SourcePreview do begin
    ini.WriteInteger('GUI.SourcePreview', 'Color', Color);
    ini.WriteString('GUI.SourcePreview', 'FontName', FontName);
    ini.WriteInteger('GUI.SourcePreview', 'FontSize', FontSize);
    ini.WriteInteger('GUI.SourcePreview', 'FontColor', FontColor);
    ini.WriteInteger('GUI.SourcePreview', 'TabSize', TabSize);
    ini.WriteInteger('GUI.SourcePreview', 'HighLightColor', HighLightColor);
    SaveSourcePreviewFont('Keyword1', Keyword1);
    SaveSourcePreviewFont('Keyword2', Keyword2);
    SaveSourcePreviewFont('StringType', StringType);
    SaveSourcePreviewFont('Number', Number);
    SaveSourcePreviewFont('Comment', Comment);
    SaveSourcePreviewFont('Macro', Macro);
    SaveSourcePreviewFont('ClassLink', ClassLink);
  end;
  with PropertyInspector do begin
    ini.WriteInteger('GUI.PropertyInspector', 'InheritenceDepth', InheritenceDepth);
    ini.WriteBool('GUI.PropertyInspector', 'AlwaysWindow', AlwaysWindow);
  end;
  ini.WriteSectionRaw('GUI.HotKeys', HotKeys);
  with Commands do begin
    ini.WriteString('GUI.Commands', 'Server', Server);
    ini.WriteInteger('GUI.Commands', 'ServerPriority', ServerPriority);
    ini.WriteString('GUI.Commands', 'Client', Client);
    ini.WriteString('GUI.Commands', 'Compiler', Compiler);
    ini.WriteString('GUI.Commands', 'OpenClass', OpenClass);
  end;
  with SearchConfig do begin
    ini.WriteBool('GUI.Search', 'isFromTop', isFromTop);
    ini.WriteBool('GUI.Search', 'isStrict', isStrict);
    ini.WriteBool('GUI.Search', 'isRegex', isRegex);
    ini.WriteBool('GUI.Search', 'isFindFirst', isFindFirst);
    ini.WriteInteger('GUI.Search', 'Scope', Scope);
    ini.WriteStringArray('GUI.Search', 'history', history);
    ini.WriteStringArray('GUI.Search', 'ftshistory', ftshistory);
  end;
  tmp := StateFile;
  if (SameText(ExtractFilePath(tmp), ExtractFilePath(ini.FileName))) then tmp := ExtractFileName(tmp);
  ini.WriteString('GUI.General', 'StateFile', tmp);
  ini.WriteString('GUI.General', 'NewClassTemplate', NewClassTemplate);
  SaveBookmarks;
end;

procedure TUCXGUIConfig.SaveComponentSettings(ident: string; cs: TComponentSettings);
begin
  with cs do begin
    with font do begin
      ini.WriteInteger('GUI.Layout', ident+'.Font.Color', Color);
      ini.WriteString('GUI.Layout', ident+'.Font.Name', Name);
      ini.WriteString('GUI.Layout', ident+'.Font.Style', FontStylesToString(Style));
      ini.WriteInteger('GUI.Layout', ident+'.Font.Size', Size);
    end;
    ini.WriteInteger('GUI.Layout', ident+'.Color', Color);
  end;
end;

procedure TUCXGUIConfig.SaveSourcePreviewFont(ident: string; var target: TSourcePreviewFont);
begin
  with target do begin
    ini.WriteInteger('GUI.SourcePreview', ident+'.Color', Color);
    ini.WriteString('GUI.SourcePreview', ident+'.Style', FontStylesToString(Style));
  end;
end;

procedure TUCXGUIConfig.SaveBookmarks;
var
  sl, sl2: TStringList;
  i, j: integer;
  bm: TBookmark;
  bme: TBookmarkentry;
begin
  sl := TStringList.Create;
  try
    for i := 0 to Bookmarks.count-1 do begin
      bm := TBookmark(Bookmarks[i]);
      sl.Add(bm.name);
      sl2 := TStringList.Create;
      try
        for j := 0 to bm.Entries.Count-1 do begin
          bme := TBookmarkentry(bm.Entries[j]);
          sl2.Add(inttostr(ord(bme.EntryType))+';'+bme.Entry+';'+bme.Comment);
        end;
        ini.WriteStringArray('Bookmarks', 'Entry.'+bm.name, sl2);
      finally
        sl2.Free;
      end;
      Bookmarks.Add(bm);
    end;
    ini.WriteStringArray('Bookmarks', 'Mark', sl);
  finally
    sl.Free;
  end;
end;

procedure TUCXGUIConfig.UpgradeConfig;

  function FontStylesToInt(style: TFontStyles): cardinal;
  begin
    result := 0;
    if (fsBold in style) then result := result or 1;
    if (fsItalic in style) then result := result or 2;
    if (fsUnderline in style) then result := result or 4;
    if (fsStrikeout in style) then result := result or 8;
  end;

  function IntToFontStyles(style: cardinal): TFontStyles;
  begin
    result := [];
    if (1 and style <> 0) then result := result + [fsBold];
    if (2 and style <> 0) then result := result + [fsItalic];
    if (4 and style <> 0) then result := result + [fsUnderline];
    if (8 and style <> 0) then result := result + [fsStrikeout];
  end;

var
  i: integer;
begin
  inherited UpgradeConfig;
  Startup.AnalyseModified := ini.ReadBool('Config', 'AnalyseModified', Startup.AnalyseModified);
  Layout.StayOnTop := ini.ReadBool('Layout', 'StayOnTop', Layout.StayOnTop);
  Layout.SavePosition := ini.ReadBool('Layout', 'SavePosition', Layout.SavePosition);
  Layout.SaveSize := ini.ReadBool('Layout', 'SaveSize', Layout.SaveSize);
  Layout.IsMaximized := ini.ReadBool('Layout', 'IsMaximized', Layout.IsMaximized);
  Layout.Top := ini.ReadInteger('Layout', 'Top', Layout.Top);
  Layout.Left := ini.ReadInteger('Layout', 'Top', Layout.Left);
  Layout.Width := ini.ReadInteger('Layout', 'Top', Layout.Width);
  Layout.Height := ini.ReadInteger('Layout', 'Top', Layout.Height);
  Layout.MenuBar := ini.ReadBool('Layout', 'MenuBar', Layout.MenuBar);
  Layout.Toolbar := ini.ReadBool('Layout', 'Toolbar', Layout.Toolbar);
  Layout.PackageTree := ini.ReadBool('Layout', 'PackageTree', Layout.PackageTree);
  Layout.Log := ini.ReadBool('Layout', 'Log', Layout.Log);
  Layout.SourcePreview := ini.ReadBool('Layout', 'SourceSnoop', Layout.SourcePreview);
  Layout.PropertyInspector := ini.ReadBool('Layout', 'PropertyInspector', Layout.PropertyInspector);
  Layout.MinimizeOnClose := ini.ReadBool('Layout', 'MinimizeOnClose', Layout.MinimizeOnClose);
  Layout.ExpandObject := ini.ReadBool('Layout', 'ExpandObject', Layout.ExpandObject);
  Layout.TreeView.Font.Color := ini.ReadInteger('Layout', 'Tree.Font.Color', Layout.TreeView.Font.Color);
  Layout.TreeView.Font.Name := ini.ReadString('Layout', 'Tree.Font.Name', Layout.TreeView.Font.Name);
  Layout.TreeView.Font.Size := ini.ReadInteger('Layout', 'Tree.Font.Size', Layout.TreeView.Font.Size);
  Layout.TreeView.Color := ini.ReadInteger('Layout', 'Tree.Color', Layout.TreeView.Color);
  Layout.LogWindow.Font.Color := ini.ReadInteger('Layout', 'Log.Font.Color', Layout.LogWindow.Font.Color);
  Layout.LogWindow.Font.Name := ini.ReadString('Layout', 'Log.Font.Name', Layout.LogWindow.Font.Name);
  Layout.LogWindow.Font.Size := ini.ReadInteger('Layout', 'Log.Font.Size', Layout.LogWindow.Font.Size);
  Layout.LogWindow.Color := ini.ReadInteger('Layout', 'Log.Color', Layout.LogWindow.Color);
  Layout.InlineSearchTimeout := ini.ReadInteger('config', 'InlineSearchTimeout', Layout.InlineSearchTimeout);
  ini.ReadBinaryStream('pnlCenter.DockManager', 'data', DockState.data.Center);
  ini.ReadBinaryStream('dckTop.DockManager', 'data', DockState.data.Top);
  ini.ReadBinaryStream('dckBottom.DockManager', 'data', DockState.data.Bottom);
  ini.ReadBinaryStream('dckLeft.DockManager', 'data', DockState.data.Left);
  ini.ReadBinaryStream('dckRight.DockManager', 'data', DockState.data.Right);
  DockState.size.Top := ini.ReadInteger('dckTop.DockManager', 'height', DockState.size.Top);
  DockState.size.Bottom := ini.ReadInteger('dckBottom.DockManager', 'height', DockState.size.Bottom);
  DockState.size.Left := ini.ReadInteger('dckLeft.DockManager', 'width', DockState.size.Left);
  DockState.size.Right := ini.ReadInteger('dckRight.DockManager', 'width', DockState.size.Right);
  DockState.host.Classes := ini.ReadString('DockHosts', 'tv_Classes', DockState.host.Classes);
  DockState.host.Packages := ini.ReadString('DockHosts', 'tv_Packages', DockState.host.Packages);
  DockState.host.Log := ini.ReadString('DockHosts', 'lb_Log', DockState.host.Log);
  DockState.host.SourcePreview := ini.ReadString('DockHosts', 're_SourceSnoop', DockState.host.SourcePreview);
  DockState.host.PropertyInspector := ini.ReadString('DockHosts', 'fr_Props', DockState.host.PropertyInspector);
  ApplicationBar.Width := ini.ReadInteger('Layout', 'ABWidth', ApplicationBar.Width);
  ApplicationBar.AutoHide := ini.ReadBool('Layout', 'AutoHide', ApplicationBar.AutoHide);
  if (ini.ReadBool('Layout', 'ABRight', false)) then ApplicationBar.Location := abRight;
  if (ini.ReadBool('Layout', 'ABLeft', false)) then ApplicationBar.Location := abLeft;
  SourcePreview.Color := ini.ReadInteger('Layout', 'Source.Color', SourcePreview.Color);
  SourcePreview.FontName := ini.ReadString('Layout', 'Source.Font.Name', SourcePreview.FontName);
  SourcePreview.FontSize := ini.ReadInteger('Layout', 'Source.Font.Size', SourcePreview.FontSize);
  SourcePreview.Keyword1.Color := ini.ReadInteger('Layout', 'Source.Keyword1.Color', SourcePreview.Keyword1.Color);
  SourcePreview.Keyword1.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Keyword1.Style', FontStylesToInt(SourcePreview.Keyword1.Style)));
  SourcePreview.Keyword2.Color := ini.ReadInteger('Layout', 'Source.Keyword2.Color', SourcePreview.Keyword2.Color);
  SourcePreview.Keyword2.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Keyword2.Style', FontStylesToInt(SourcePreview.Keyword2.Style)));
  SourcePreview.StringType.Color := ini.ReadInteger('Layout', 'Source.StringType.Color', SourcePreview.StringType.Color);
  SourcePreview.StringType.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.StringType.Style', FontStylesToInt(SourcePreview.StringType.Style)));
  SourcePreview.Number.Color := ini.ReadInteger('Layout', 'Source.Number.Color', SourcePreview.Number.Color);
  SourcePreview.Number.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Number.Style', FontStylesToInt(SourcePreview.Number.Style)));
  SourcePreview.Macro.Color := ini.ReadInteger('Layout', 'Source.Macro.Color', SourcePreview.Macro.Color);
  SourcePreview.Macro.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Macro.Style', FontStylesToInt(SourcePreview.Macro.Style)));
  SourcePreview.Comment.Color := ini.ReadInteger('Layout', 'Source.Comment.Color', SourcePreview.Comment.Color);
  SourcePreview.Comment.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Comment.Style', FontStylesToInt(SourcePreview.Comment.Style)));
  SourcePreview.Name.Color := ini.ReadInteger('Layout', 'Source.Name.Color', SourcePreview.Name.Color);
  SourcePreview.Name.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.Name.Style', FontStylesToInt(SourcePreview.Name.Style)));
  SourcePreview.ClassLink.Color := ini.ReadInteger('Layout', 'Source.ClassLink.Color', SourcePreview.ClassLink.Color);
  SourcePreview.ClassLink.Style := IntToFontStyles(ini.ReadInteger('Layout', 'Source.ClassLink.Style', FontStylesToInt(SourcePreview.ClassLink.Style)));
  PropertyInspector.InheritenceDepth := ini.ReadInteger('Config', 'DefaultInheritanceDepth', PropertyInspector.InheritenceDepth);
  PropertyInspector.AlwaysWindow := ini.ReadBool('config', 'ClassPropertiesWindow', PropertyInspector.AlwaysWindow);
  ini.ReadSectionRaw('HotKeys', HotKeys);
  Commands.Server := ini.ReadString('Config', 'ServerCmd', Commands.Server);
  Commands.ServerPriority := ini.ReadInteger('Config', 'ServerPrio', Commands.ServerPriority);
  Commands.Client := ini.ReadString('Config', 'ClientCmd', Commands.Client);
  Commands.Compiler := ini.ReadString('Config', 'CompilerCmd', Commands.Compiler);
  Commands.OpenClass := ini.ReadString('Config', 'OpenResultCmd', Commands.OpenClass);
  StateFile := ini.ReadString('Config', 'StateFile', StateFile);
  NewClassTemplate := ini.ReadString('Config', 'NewClassTemplate', NewClassTemplate);

  SearchConfig.isFromTop := ini.ReadBool('Search', 'isFromTop', false);
  SearchConfig.isStrict := ini.ReadBool('Search', 'isStrict', false);
  SearchConfig.isRegex := ini.ReadBool('Search', 'isRegex', false);
  SearchConfig.isFindFirst := ini.ReadBool('Search', 'isFindFirst', false);
  SearchConfig.Scope := ini.ReadInteger('Search', 'Scope', 0);
  SearchConfig.history.Clear;
  for i := 0 to ini.ReadInteger('Search', 'history', 0)-1 do begin
    SearchConfig.history.Add(ini.ReadString('Search', 'history:'+IntToStr(i), ''));
  end;
  SearchConfig.ftshistory.Clear;
  for i := 0 to ini.ReadInteger('Search', 'ftshistory', 0)-1 do begin
    SearchConfig.ftshistory.Add(ini.ReadString('Search', 'ftshistory:'+IntToStr(i), ''));
  end;
end;

{ TComponentSettgins }

procedure TComponentSettings.Assign(target: TControl);
begin
  try
    TStoreControl(target).Font.Name := Font.Name;
    TStoreControl(target).Font.Size := Font.Size;
    TStoreControl(target).Font.Color := Font.Color;
    TStoreControl(target).Font.Style := Font.Style;
    TStoreControl(target).Color := Color;
  except
  end;
end;

procedure TComponentSettings.Import(source: TControl);
begin
  try
    Font.Name := TStoreControl(source).Font.Name;
    Font.Size := TStoreControl(source).Font.Size;
    Font.Color := TStoreControl(source).Font.Color;
    Font.Style := TStoreControl(source).Font.Style;
    Color := TStoreControl(source).Color;
  except
  end;
end;

constructor TBookmark.Create(inname: string);
begin
  fname := inname;
  Entries := TBookmarkEntryList.Create(true);
end;

destructor TBookmark.Destroy;
begin
  Entries.Free;
  inherited Destroy;
end;

procedure TBookmark.AddEntry(encoded: string);
var
  it: TBookmarkEntryType;
  ie: string;
  i: integer;
begin
  i := Pos(';', encoded);
  it := TBookmarkEntryType(StrToIntDef(Copy(encoded, 1, i-1), 0));
  Delete(encoded, 1, i);
  i := Pos(';', encoded);
  if (i = 0) then i := length(encoded);
  ie := Copy(encoded, 1, i-1);
  Delete(encoded, 1, i);
  AddEntry(it, ie, encoded);
end;

procedure TBookmark.AddEntry(intype: TBookmarkEntryType; inentry: string; incomment: string = '');
var
  bme: TBookmarkEntry;
begin
  //TODO: find previous and override
  bme := TBookmarkEntry.Create;
  bme.EntryType := intype;
  bme.Entry := inentry;
  bme.Comment := incomment;
  Entries.Add(bme);
end;

{$ENDIF}

end.
