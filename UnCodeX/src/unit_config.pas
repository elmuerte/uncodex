{*******************************************************************************
  Name:
    unit_config
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Contains the configuration of UnCodeX

  $Id: unit_config.pas,v 1.1 2005-04-02 11:42:12 elmuerte Exp $
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
  unit_htmlout,
  Classes;

type

  TUCXConfig = class(TObject)
  protected
    procedure UpgradeConfig; virtual;
  public
    PackagesPriority:     TStringList;
    IgnorePackages:       TStringList;
    SourcePaths:          TStringList;
    HTMLOutput:           THTMLoutConfig;
    HTMLHelp: record
      Compiler:           string;
      OutputFile:         string;
      Title:              string;
    end;
    Commands: record
      Server:             string;
      ServerPriority:     integer;
      Client:             string;
      Compiler:           string;
      OpenClass:          string;
    end;
    Comments: record
      Packages:           string;
      ExternalComments:   string;
    end;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromIni(filename: string); virtual;
    procedure SaveToIni(filename: string); virtual;
  end;

  {$IFNDEF CONSOLE}
  TAppBarLocation = (abLeft, abRight);

  TComponentSettgins = class(TObject)
  public
    Font: record
      Color:              TColor;
      Name:               TFontName;
      Style:              TFontStyle;
      Size:               integer;
    end;
    Color:                TColor;
  public
    //procedure Assign(target: TComponent);
  end;

  TSourcePreviewFont = record
    Color:                TColor;
    Style:                TFontStyle;
  end;

  TUCXGUIConfig = class(TUCXConfig)
  protected
    //procedure UpgradeConfig; override;
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
  end;
  {$ENDIF}

implementation

{ TUCXConfig }
constructor TUCXConfig.Create;
begin

end;

destructor TUCXConfig.Destroy;
begin

end;

procedure TUCXConfig.LoadFromIni(filename: string);
begin

end;

procedure TUCXConfig.SaveToIni(filename: string);
begin

end;

procedure TUCXConfig.UpgradeConfig;
begin

end;

{ TUCXGUIConfig }

end.
 