{*******************************************************************************
  Name:
    unit_config
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Contains the configuration of UnCodeX

  $Id: unit_config.pas,v 1.4 2005-04-04 15:12:19 elmuerte Exp $
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
  {$IFNDEF CONSOLE}
  Graphics, Controls, unit_searchform,
  {$ENDIF}
  unit_htmlout, Classes, SysUtils, unit_ucxinifiles;

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
  public
    constructor Create(filename: string);
    destructor Destroy; override;
    procedure LoadFromIni;
    procedure SaveToIni(filename: string = '');
  end;

  {$IFNDEF CONSOLE}
  TAppBarLocation = (abNone, abLeft, abRight);

  TStoreControl = class(TControl)
  published
    property Font;
    property Color;
  end;

  TComponentSettgins = class(TObject)
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
  end;

  TSourcePreviewFont = record
    Color:                TColor;
    Style:                TFontStyles;
  end;

  TUCXGUIConfig = class(TUCXConfig)
  protected
    procedure UpgradeConfig; override;
    procedure InternalLoadFromIni; override;
    procedure InternalSaveToIni; override;
  public
    StateFile:            string;
    NewClassTemplate:     string;
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
      TreeView:           TComponentSettgins;
      LogWindow:          TComponentSettgins;
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
    SearchConfig:         TClassSearch;
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

  IncludeConfig.Pre := TStringList.Create;
  IncludeConfig.Post := TStringList.Create;
  {$IFDEF UNIX}
  IncludeConfig.Pre.Add('/etc/uncodexrc');
  IncludeConfig.Pre.Add('~.uncodexrc');
  {$ENDIF}
  PackagesPriority := TStringList.Create;
  IgnorePackages := TStringList.Create;
  SourcePaths := TStringList.Create;

  HTMLOutput.OutputDir := ExtractFilePath(ParamStr(0))+'UnCodeX-Output';
  HTMLOutput.TemplateDir := ExtractFilePath(ParamStr(0))+TEMPLATEPATH+PATHDELIM+DEFTEMPLATE;
  HTMLOutput.CreateSource := tbMaybe;
  HTMLOutput.TabsToSpaces := 0;
  HTMLOutput.TargetExtention := '';
  HTMLOutput.CPP := '';
  HTMLOutput.DefaultTitle := '';
  HTMLOutput.GZCompress := tbMaybe;
  HTMLHelp.Compiler := '';
  HTMLHelp.OutputFile := ExtractFilePath(ParamStr(0))+'UnCodeX-UnrealScript.chm';
  HTMLHelp.Title := '';
  Comments.Packages := ExtractFilePath(ParamStr(0))+DefaultPDF;
  Comments.Declarations := ExtractFilePath(ParamStr(0))+DefaultECF;
end;

destructor TUCXConfig.Destroy;
begin
  FreeAndNil(IncludeConfig.Pre);
  FreeAndNil(IncludeConfig.Post);
  FreeAndNil(PackagesPriority);
  FreeAndNil(IgnorePackages);
  FreeAndNil(SourcePaths);
  FreeAndNil(iniStack);
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
  ini := TUCXIniFile.Create(filename);
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

  ini.ReadStringArray('Packages', 'EditPackage', PackagesPriority);
  sl := TStringList.Create;
  try
    ini.ReadStringArray('Packages', 'Tag', sl);
    for i := 0 to sl.Count-1 do begin
      n := PackagesPriority.IndexOf(sl[i]);
      if (n > 0) then PackagesPriority.Objects[n] := PackagesPriority;
    end;
  finally
    sl.Free;
  end;
  ini.ReadStringArray('Packages', 'IgnorePackage', IgnorePackages);
  ini.ReadStringArray('Sources', 'Path', SourcePaths);

  with HTMLOutput do begin
    OutputDir := ini.ReadString('HTMLOutput', 'OutputDir', OutputDir);
    TemplateDir := ini.ReadString('HTMLOutput', 'OutputDir', OutputDir);
    CreateSource := TTriBool(ini.ReadInteger('HTMLOutput', 'CreateSource', ord(CreateSource)));
    TabsToSpaces := ini.ReadInteger('HTMLOutput', 'TabsToSpaces', TabsToSpaces);
    TargetExtention := ini.ReadString('HTMLOutput', 'TargetExtention', TargetExtention);
    CPP := ini.ReadString('HTMLOutput', 'CommentPreProcessor', CPP);
    DefaultTitle := ini.ReadString('HTMLOutput', 'DefaultTitle', DefaultTitle);
    GZCompress := TTriBool(ini.ReadInteger('HTMLOutput', 'GZCompress', ord(GZCompress)));
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
end;

procedure TUCXConfig.InternalSaveToIni;
var
  i: integer;
begin
  ini.WriteStringArray('Packages', 'EditPackage', PackagesPriority);
  ini.DeleteKey('Packages', 'Tag');
  for i := 0 to PackagesPriority.Count-1 do begin
    if (PackagesPriority.Objects[i] <> nil) then ini.AddToStringArray('Packages', 'Tag', PackagesPriority[i]);
  end;
  ini.WriteStringArray('Packages', 'IgnorePackage', IgnorePackages);
  ini.WriteStringArray('Sources', 'Path', SourcePaths);
  with HTMLOutput do begin
    ini.WriteString('HTMLOutput', 'OutputDir', OutputDir);
    ini.WriteString('HTMLOutput', 'OutputDir', OutputDir);
    ini.WriteInteger('HTMLOutput', 'CreateSource', ord(CreateSource));
    ini.WriteInteger('HTMLOutput', 'TabsToSpaces', TabsToSpaces);
    ini.WriteString('HTMLOutput', 'TargetExtention', TargetExtention);
    ini.WriteString('HTMLOutput', 'CommentPreProcessor', CPP);
    ini.WriteString('HTMLOutput', 'DefaultTitle', DefaultTitle);
    ini.WriteInteger('HTMLOutput', 'GZCompress', ord(GZCompress));
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
end;

procedure TUCXConfig.UpgradeConfig;
var
  i: integer;
  sl: TStringList;
  tmp, tmp2: string;
begin
  Log('Converting old configuration file');

  HTMLOutput.OutputDir := ini.ReadString('Config', 'HTMLOutputDir', HTMLOutput.OutputDir);
  HTMLOutput.TemplateDir := ini.ReadString('Config', 'TemplateDir', HTMLOutput.TemplateDir);
  HTMLOutput.TabsToSpaces := ini.ReadInteger('Config', 'TabsToSpaces', HTMLOutput.TabsToSpaces);
  HTMLOutput.TargetExtention := ini.ReadString('Config', 'HTMLTargetExt', HTMLOutput.TargetExtention);
  HTMLOutput.CPP := ini.ReadString('Config', 'CPP', HTMLOutput.CPP);
  HTMLOutput.DefaultTitle := ini.ReadString('Config', 'HTMLDefaultTitle', HTMLOutput.DefaultTitle);
  HTMLOutput.GZCompress := TTriBool(ini.ReadInteger('Config', 'GZCompress', Ord(HTMLOutput.GZCompress)));
  HTMLHelp.Compiler := ini.ReadString('Config', 'HHCPath', HTMLHelp.Compiler)+PATHDELIM+'HHC.EXE';
  HTMLHelp.OutputFile := ini.ReadString('Config', 'HTMLHelpFile', HTMLHelp.OutputFile);
  HTMLHelp.Title := ini.ReadString('Config', 'HHTitle', HTMLHelp.Title);
  Comments.Packages := ini.ReadString('Config', 'PackageDescriptionFile', Comments.Packages);
  Comments.Declarations := ini.ReadString('Config', 'ExternalCommentFile', Comments.Declarations);

  sl := TStringList.Create;
  try
    ini.ReadSectionValues('PackagePriority', sl);
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
    ini.ReadSectionValues('IgnorePackages', sl);
    for i := 0 to sl.Count-1 do begin
      tmp := sl[i];
      Delete(tmp, 1, Pos('=', tmp));
      IgnorePackages.Add(LowerCase(tmp));
    end;
    ini.ReadSectionValues('SourcePaths', sl);
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
    Log('Failed loading include config: '+filename, ltError);
    ini := TUCXIniFile(iniStack.Last);
    iniStack.Remove(ini);
  end;
end;

{$IFNDEF CONSOLE}
{ TUCXGUIConfig }

constructor TUCXGUIConfig.Create(filename: string);
begin
  inherited Create(filename);
  
  Layout.TreeView := TComponentSettgins.Create;
  Layout.LogWindow := TComponentSettgins.Create;
  DockState.data.Center := TMemoryStream.Create;
  DockState.data.Top := TMemoryStream.Create;
  DockState.data.Bottom := TMemoryStream.Create;
  DockState.data.Left := TMemoryStream.Create;
  DockState.data.Right := TMemoryStream.Create;
  HotKeys := TStringList.Create;

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
  DockState.size.Top := 0;
  DockState.size.Bottom := 0;
  DockState.size.Left := 0;
  DockState.size.Right := 0;
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
  StateFile := ChangeFileExt(ExtractFilename(ConfigFile), '.ucx');
  NewClassTemplate := ExtractFilePath(ParamStr(0))+TEMPLATEPATH+PathDelim+'NewClass.uc';
end;

destructor TUCXGUIConfig.Destroy;
begin
  inherited Destroy;
  FreeAndNil(Layout.TreeView);
  FreeAndNil(Layout.LogWindow);
  FreeAndNil(DockState.data.Center);
  FreeAndNil(DockState.data.Top);
  FreeAndNil(DockState.data.Bottom);
  FreeAndNil(DockState.data.Left);
  FreeAndNil(DockState.data.Right);
  FreeAndNil(HotKeys);
end;

procedure TUCXGUIConfig.InternalLoadFromIni;
begin
  inherited InternalLoadFromIni;
end;

procedure TUCXGUIConfig.InternalSaveToIni;
begin
  inherited InternalSaveToIni;
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
  ini.ReadSectionValues('HotKeys', HotKeys);
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

procedure TComponentSettgins.Assign(target: TControl);
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

{$ENDIF}

end.
