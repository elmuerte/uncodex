object frm_Settings: Tfrm_Settings
  Left = 254
  Top = 180
  Width = 679
  Height = 405
  Caption = 'Settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    671
    378)
  PixelsPerInch = 96
  TextHeight = 13
  object btn_Ok: TBitBtn
    Left = 592
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 2
    Kind = bkOK
  end
  object btn_Cancel: TBitBtn
    Left = 592
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 3
    Kind = bkCancel
  end
  object pc_Settings: TPageControl
    Left = 145
    Top = 0
    Width = 441
    Height = 378
    ActivePage = ts_FullTextSearch
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    MultiLine = True
    Style = tsFlatButtons
    TabOrder = 1
    object ts_SourcePaths: TTabSheet
      Caption = 'Source Paths'
      TabVisible = False
      object gb_SourcePaths: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'Source paths'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lb_Paths: TListBox
          Left = 8
          Top = 48
          Width = 417
          Height = 311
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ItemHeight = 13
          TabOrder = 4
        end
        object btn_SAdd: TBitBtn
          Left = 8
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Add'
          TabOrder = 0
          OnClick = btn_SAddClick
        end
        object btn_SRemove: TBitBtn
          Left = 88
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Remove'
          TabOrder = 1
          OnClick = btn_SRemoveClick
        end
        object btn_SUp: TBitBtn
          Left = 366
          Top = 16
          Width = 27
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '5'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btn_SUpClick
        end
        object btn_SDown: TBitBtn
          Left = 398
          Top = 16
          Width = 27
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '6'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btn_SDownClick
        end
      end
    end
    object ts_PackagePriority: TTabSheet
      Caption = 'Package Priority'
      ImageIndex = 1
      TabVisible = False
      object gb_PackagePriority: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'Package priority'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lb_PackagePriority: TListBox
          Left = 8
          Top = 16
          Width = 385
          Height = 343
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ExtendedSelect = False
          ItemHeight = 13
          TabOrder = 0
        end
        object btn_PUp: TBitBtn
          Left = 400
          Top = 16
          Width = 27
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '5'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btn_PUpClick
        end
        object btn_PDown: TBitBtn
          Left = 400
          Top = 48
          Width = 27
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '6'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btn_PDownClick
        end
        object btn_AddPackage: TBitBtn
          Left = 400
          Top = 302
          Width = 27
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = '+'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btn_AddPackageClick
        end
        object btn_DelPackage: TBitBtn
          Left = 400
          Top = 334
          Width = 27
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = '-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          OnClick = btn_DelPackageClick
        end
      end
    end
    object ts_IgnorePackages: TTabSheet
      Caption = 'Ignore Packages'
      ImageIndex = 6
      TabVisible = False
      object gb_IgnorePackages: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'Ignore Packages'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lb_IgnorePackages: TListBox
          Left = 8
          Top = 16
          Width = 385
          Height = 343
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ExtendedSelect = False
          ItemHeight = 13
          Sorted = True
          TabOrder = 0
        end
        object btn_AddIgnore: TBitBtn
          Left = 400
          Top = 16
          Width = 27
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = '+'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btn_AddIgnoreClick
        end
        object btn_DelIgnore: TBitBtn
          Left = 400
          Top = 48
          Width = 27
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = '-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btn_DelIgnoreClick
        end
      end
    end
    object ts_HTMLOutput: TTabSheet
      Caption = 'HTML Output'
      ImageIndex = 2
      TabVisible = False
      object gb_HTMLOutput: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'HTML Output'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lbl_OutputDir: TLabel
          Left = 8
          Top = 16
          Width = 75
          Height = 13
          Caption = 'Output directory'
        end
        object lbl_Template: TLabel
          Left = 8
          Top = 56
          Width = 92
          Height = 13
          Caption = 'Templates directory'
        end
        object ed_HTMLOutputDir: TEdit
          Left = 8
          Top = 32
          Width = 393
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ReadOnly = True
          TabOrder = 0
        end
        object btn_HTMLOutputDir: TBitBtn
          Left = 400
          Top = 32
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = btn_HTMLOutputDirClick
        end
        object ed_TemplateDir: TEdit
          Left = 8
          Top = 72
          Width = 393
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ReadOnly = True
          TabOrder = 2
        end
        object btn_SelectTemplateDir: TBitBtn
          Left = 400
          Top = 72
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 3
          OnClick = btn_SelectTemplateDirClick
        end
      end
    end
    object ts_HTMLHelp: TTabSheet
      Caption = 'MS HTML Help'
      ImageIndex = 3
      TabVisible = False
      object gb_HTMLHelp: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'MS HTML Help'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lbl_Workshop: TLabel
          Left = 8
          Top = 16
          Width = 107
          Height = 13
          Caption = 'HTML Help Workshop'
        end
        object lbl_HTMLHelpOutput: TLabel
          Left = 8
          Top = 56
          Width = 48
          Height = 13
          Caption = 'Output file'
        end
        object ed_WorkshopPath: TEdit
          Left = 8
          Top = 32
          Width = 393
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ReadOnly = True
          TabOrder = 0
        end
        object btn_SelectWorkshop: TBitBtn
          Left = 400
          Top = 32
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = btn_SelectWorkshopClick
        end
        object ed_HTMLHelpOutput: TEdit
          Left = 8
          Top = 72
          Width = 393
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ReadOnly = True
          TabOrder = 2
        end
        object btn_HTMLHelpOutput: TBitBtn
          Left = 400
          Top = 72
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 3
          OnClick = btn_HTMLHelpOutputClick
        end
      end
    end
    object ts_Compile: TTabSheet
      Caption = 'Compile'
      ImageIndex = 4
      TabVisible = False
      object gb_Compile: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'Compile'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lbl_CompilerCommandline: TLabel
          Left = 8
          Top = 16
          Width = 105
          Height = 13
          Caption = 'Compiler commandline'
        end
        object btn_CompilerPlaceholders: TBitBtn
          Left = 384
          Top = 32
          Width = 17
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'u'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btn_CompilerPlaceholdersClick
        end
        object ed_CompilerCommandline: TEdit
          Left = 8
          Top = 32
          Width = 377
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          TabOrder = 0
        end
        object btn_BrowseCompiler: TBitBtn
          Left = 400
          Top = 32
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 2
          OnClick = btn_BrowseCompilerClick
        end
      end
    end
    object ts_GameServer: TTabSheet
      Caption = 'Game Server'
      ImageIndex = 5
      TabVisible = False
      object gb_GameServer: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'Game Server'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lbl_ServerCommandline: TLabel
          Left = 8
          Top = 16
          Width = 96
          Height = 13
          Caption = 'Server commandline'
        end
        object Label3: TLabel
          Left = 8
          Top = 56
          Width = 64
          Height = 13
          Caption = 'Server priority'
        end
        object lbl_ClientCommandline: TLabel
          Left = 8
          Top = 112
          Width = 91
          Height = 13
          Caption = 'Client commandline'
        end
        object ed_ServerCommandline: TEdit
          Left = 8
          Top = 32
          Width = 393
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          TabOrder = 0
        end
        object btn_BrowseServer: TBitBtn
          Left = 400
          Top = 32
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = btn_BrowseServerClick
        end
        object cb_ServerPriority: TComboBox
          Left = 8
          Top = 72
          Width = 417
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 2
          Text = 'Normal'
          Items.Strings = (
            'Low'
            'Normal'
            'High'
            'Real time')
        end
        object ed_ClientCommandline: TEdit
          Left = 8
          Top = 128
          Width = 393
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          TabOrder = 3
        end
        object btn_ClientCommandline: TBitBtn
          Left = 400
          Top = 128
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 4
          OnClick = btn_ClientCommandlineClick
        end
      end
    end
    object ts_FullTextSearch: TTabSheet
      Caption = 'Full Text Search'
      ImageIndex = 7
      TabVisible = False
      object gb_FullTextSearch: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'Full Text Search'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lbl_OpenResult: TLabel
          Left = 8
          Top = 16
          Width = 249
          Height = 13
          Caption = 'Open result command (leave blank for default action)'
        end
        object btn_OpenResultPlaceHolder: TBitBtn
          Left = 384
          Top = 32
          Width = 17
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'u'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btn_OpenResultPlaceHolderClick
        end
        object ed_OpenResultCmd: TEdit
          Left = 8
          Top = 32
          Width = 377
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          TabOrder = 0
        end
        object btn_OpenResultCmd: TBitBtn
          Left = 400
          Top = 32
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 2
          OnClick = btn_OpenResultCmdClick
        end
        object cb_FTSRegExp: TCheckBox
          Left = 8
          Top = 56
          Width = 417
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Default regular expression'
          TabOrder = 3
        end
      end
    end
  end
  object lb_Settings: TListBox
    Left = 0
    Top = 0
    Width = 145
    Height = 378
    Style = lbOwnerDrawFixed
    Align = alLeft
    BevelKind = bkSoft
    BorderStyle = bsNone
    ItemHeight = 18
    TabOrder = 0
    OnClick = lb_SettingsClick
  end
  object sd_SaveFile: TSaveDialog
    DefaultExt = '*.chm'
    Filter = 'HTML Help files|*.chm|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'HTML Help output file'
    Left = 592
    Top = 72
  end
  object pm_CompilerPlaceholders: TPopupMenu
    Left = 592
    Top = 104
    object mi_Classname: TMenuItem
      Caption = 'Class name'
      OnClick = mi_ClassnameClick
    end
    object mi_Classfilename: TMenuItem
      Caption = 'Class filename'
      OnClick = mi_ClassfilenameClick
    end
    object mi_Fullclasspath: TMenuItem
      Caption = 'Full class path'
      OnClick = mi_FullclasspathClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mi_Packagename: TMenuItem
      Caption = 'Package name'
      OnClick = mi_PackagenameClick
    end
    object mi_Packagepath: TMenuItem
      Caption = 'Package path'
      OnClick = mi_PackagepathClick
    end
  end
  object od_BrowseExe: TOpenDialog
    DefaultExt = '*.exe'
    Filter = 'Programs|*.exe;*.bat;*.com|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Select executable'
    Left = 624
    Top = 72
  end
  object pm_OpenResultPlaceHolders: TPopupMenu
    Left = 624
    Top = 104
    object mi_ClassName2: TMenuItem
      Caption = 'Class name'
      OnClick = mi_ClassName2Click
    end
    object mi_ClassFile2: TMenuItem
      Caption = 'Class filename'
      OnClick = mi_ClassFile2Click
    end
    object mi_ClassPath2: TMenuItem
      Caption = 'Full class path'
      OnClick = mi_ClassPath2Click
    end
    object mi_N2: TMenuItem
      Caption = '-'
    end
    object mi_PackageName2: TMenuItem
      Caption = 'Package name'
      OnClick = mi_PackageName2Click
    end
    object mi_PackagePath2: TMenuItem
      Caption = 'Package path'
      OnClick = mi_PackagePath2Click
    end
    object mi_N3: TMenuItem
      Caption = '-'
    end
    object mi_Resultline1: TMenuItem
      Caption = 'Result line'
      OnClick = mi_Resultline1Click
    end
    object mi_Resultposition1: TMenuItem
      Caption = 'Result position'
      OnClick = mi_Resultposition1Click
    end
  end
end
