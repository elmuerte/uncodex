object frm_Settings: Tfrm_Settings
  Left = 243
  Top = 181
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
  Position = poMainFormCenter
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
    TabOrder = 0
    Kind = bkOK
  end
  object btn_Cancel: TBitBtn
    Left = 592
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 1
    Kind = bkCancel
  end
  object pc_Settings: TPageControl
    Left = 145
    Top = 0
    Width = 441
    Height = 378
    ActivePage = ts_SourcePaths
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    MultiLine = True
    Style = tsFlatButtons
    TabOrder = 2
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
          TabOrder = 0
        end
        object btn_SAdd: TBitBtn
          Left = 8
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Add'
          TabOrder = 1
          OnClick = btn_SAddClick
        end
        object btn_SRemove: TBitBtn
          Left = 88
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Remove'
          TabOrder = 2
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
          TabOrder = 3
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
          TabOrder = 4
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
        object Label1: TLabel
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
          Caption = 'u'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btn_CompilerPlaceholdersClick
        end
        object Edit1: TEdit
          Left = 8
          Top = 32
          Width = 377
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ReadOnly = True
          TabOrder = 0
        end
        object BitBtn1: TBitBtn
          Left = 400
          Top = 32
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
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
        object Label2: TLabel
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
        object Edit2: TEdit
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
        object BitBtn2: TBitBtn
          Left = 400
          Top = 32
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
        end
        object ComboBox1: TComboBox
          Left = 8
          Top = 72
          Width = 417
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          Items.Strings = (
            'Low'
            'Normal'
            'High'
            'Real time')
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
    TabOrder = 3
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
    object Classname1: TMenuItem
      Caption = 'Class name'
    end
    object Classfilename1: TMenuItem
      Caption = 'Class filename'
    end
    object Fullclasspath1: TMenuItem
      Caption = 'Full class path'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Packagename1: TMenuItem
      Caption = 'Package name'
    end
    object Packagepath1: TMenuItem
      Caption = 'Package path'
    end
  end
end
