{*******************************************************************************
  Name:
    unit_config
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Contains the configuration of UnCodeX

  $Id: unit_config.pas,v 1.2 2005-04-02 20:37:03 elmuerte Exp $
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
  Graphics,
  {$ENDIF}
  unit_htmlout, Classes, IniFiles, SysUtils;

type
  TUCXConfig = class(TObject)
  protected
    ConfigVersion: integer;
    ini: TMemIniFile;
    procedure UpgradeConfig; virtual;
    procedure InternalLoadFromIni; virtual;
    procedure InternalSaveToIni; virtual;
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
      ExternalComments:   string;
    end;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromIni(filename: string);
    procedure SaveToIni(filename: string);
  end;

  {$IFNDEF CONSOLE}
  TAppBarLocation = (abNone, abLeft, abRight);

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
    procedure Assign(target: TComponent);
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
    //TODO: search config
  public
    constructor Create;
    destructor Destroy; override;
  end;
  {$ENDIF}

implementation

const
  // always increase this when change have been made in the structure
  CURRENT_CONFIG_VERSION = 1;

{ TUCXConfig }
constructor TUCXConfig.Create;
begin
  IncludeConfig.Pre := TStringList.Create;
  IncludeConfig.Post := TStringList.Create;
  PackagesPriority := TStringList.Create;
  IgnorePackages := TStringList.Create;
  SourcePaths := TStringList.Create;

  //TODO: set defaults
end;

destructor TUCXConfig.Destroy;
begin
  FreeAndNil(IncludeConfig.Pre);
  FreeAndNil(IncludeConfig.Post);
  FreeAndNil(PackagesPriority);
  FreeAndNil(IgnorePackages);
  FreeAndNil(SourcePaths);
end;

procedure TUCXConfig.LoadFromIni(filename: string);
begin
  if (not FileExists(filename)) then exit;
  ini := TMemIniFile.Create(filename);
  try
    ConfigVersion := ini.ReadInteger('Configuration', 'Version', -1);
    if (ConfigVersion < 0) then begin
      UpgradeConfig;
      InternalSaveToIni;
    end;
    else InternalLoadFromIni;
  finally
    FreeAndNil(ini);
  end;
end;

procedure TUCXConfig.SaveToIni(filename: string);
begin
  ini := TMemIniFile.Create(filename);
  try
    ConfigVersion := CURRENT_CONFIG_VERSION;
    InternalSaveToIni;
    ini.UpdateFile;
  finally
    FreeAndNil(ini)
  end;
end;

procedure TUCXConfig.InternalLoadFromIni;
begin

end;

procedure TUCXConfig.InternalSaveToIni;
begin

end;

procedure TUCXConfig.UpgradeConfig;
var
  i: integer;
  sl: TStringList;
  tmp, tmp2: string;
begin
  HTMLOutput.OutputDir := ini.ReadString('Config', 'HTMLOutputDir', HTMLOutput.OutputDir);
  HTMLOutput.TemplateDir := ini.ReadString('Config', 'TemplateDir', HTMLOutput.TemplateDir);
  HTMLOutput.CreateSource := true; // TODO: never set, should be 3 state
  HTMLOutput.TabsToSpaces := ini.ReadInteger('Config', 'TabsToSpaces', HTMLOutput.TabsToSpaces);
  HTMLOutput.TargetExtention := ini.ReadString('Config', 'HTMLTargetExt', HTMLOutput.TargetExtention);
  HTMLOutput.CPP := ini.ReadString('Config', 'CPP', HTMLOutput.CPP);
  HTMLOutput.DefaultTitle := ini.ReadString('Config', 'HTMLDefaultTitle', HTMLOutput.DefaultTitle);
  HTMLOutput.GZCompress := ini.ReadInteger('Config', 'GZCompress', HTMLOutput.GZCompress);
  HTMLHelp.Compiler := ini.ReadString('Config', 'HHCPath', HTMLHelp.Compiler);
  HTMLHelp.OutputFile := ini.ReadString('Config', 'HTMLHelpFile', HTMLHelp.OutputFile);
  HTMLHelp.Title := ini.ReadString('Config', 'HHTitle', HTMLHelp.Title);
  Comments.Packages := ini.ReadString('Config', 'PackageDescriptionFile', Comments.Packages);
  Comments.ExternalComments := ini.ReadString('Config', 'ExternalCommentFile', Comments.ExternalComments);

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

{$IFNDEF CONSOLE}
{ TUCXGUIConfig }

constructor TUCXGUIConfig.Create;
begin
  Layout.TreeView := TComponentSettgins.Create;
  Layout.LogWindow := TComponentSettgins.Create;
  DockState.data.Center := TMemoryStream.Create;
  DockState.data.Top := TMemoryStream.Create;
  DockState.data.Bottom := TMemoryStream.Create;
  DockState.data.Left := TMemoryStream.Create;
  DockState.data.Right := TMemoryStream.Create;
  HotKeys := TStringList.Create;

  //TODO: defaults
end;

destructor TUCXGUIConfig.Destroy;
begin
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

end;

procedure TUCXGUIConfig.InternalSaveToIni;
begin

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
end;

{ TComponentSettgins }

procedure TComponentSettgins.Assign(target: TComponent);
begin

end;

{$ENDIF}

end.
