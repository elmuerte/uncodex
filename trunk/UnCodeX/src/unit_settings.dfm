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
    ActivePage = ts_ProgramOptions
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    MultiLine = True
    Style = tsFlatButtons
    TabOrder = 1
    object ts_SourcePaths: TTabSheet
      HelpType = htKeyword
      HelpKeyword = 'sourcepaths'
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
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            040000000000800000000000000000000000100000000000000000000000C0C0
            C000FF00FF0080808000FFFFFF0000FFFF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000222222222222
            2222223333333333333320000000000000032045454545004503205454545401
            0403204545454505100320545454540000034043545455454503355345354454
            5403234353545545450333343454545454034535433330000002235353522222
            2222352342352222222252235223222222222223422222222222}
        end
        object btn_SRemove: TBitBtn
          Left = 88
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Remove'
          TabOrder = 1
          OnClick = btn_SRemoveClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000C0C0C000FF00FF0080808000FFFFFF0000FFFF0000000000000000000000
            0000000000000000000000000000000000000000000000000000333333333333
            3333334444444444444430000000000000043056565656005604406565656502
            0504105656565606200411656541650000044146541456565604311461156565
            6504341111565656560434111565656565044111140000000003114311433333
            3333333331143333333333333311433333333333333333333333}
        end
        object btn_SUp: TBitBtn
          Left = 366
          Top = 16
          Width = 27
          Height = 25
          Anchors = [akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btn_SUpClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            040000000000800000000000000000000000100000000000000004020400CCCA
            0400FC02FC006D820000F808700091C15F000C7644001E0000009C3474001931
            0E0003D0000000810000674C0100162200009C7D000019820000222222222222
            2222222222222222222222222222222222222222222222222222222220000022
            2222222220111022222222222011102222222222201110222222220000111000
            0222222011111110222222220111110222222222201110222222222222010222
            2222222222202222222222222222222222222222222222222222}
        end
        object btn_SDown: TBitBtn
          Left = 398
          Top = 16
          Width = 27
          Height = 25
          Anchors = [akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btn_SDownClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000C40E0000C40E0000100000000000000004020400CCCA
            0400FC02FC0086820000F808700091C15F000C7644001E0000009C3488001931
            0A0003D0000000810000674C0100162200009C7D000019820000222222222222
            2222222222222222222222222222222222222222222222222222222222202222
            2222222222010222222222222011102222222222011111022222222011111110
            2222220000111000022222222011102222222222201110222222222220111022
            2222222220000022222222222222222222222222222222222222}
        end
      end
    end
    object ts_PackagePriority: TTabSheet
      HelpType = htKeyword
      HelpKeyword = 'packagepriority'
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
        object btn_PUp: TBitBtn
          Left = 400
          Top = 16
          Width = 27
          Height = 25
          Anchors = [akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = btn_PUpClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            040000000000800000000000000000000000100000000000000004020400CCCA
            0400FC02FC006D820000F808700091C15F000C7644001E0000009C3474001931
            0E0003D0000000810000674C0100162200009C7D000019820000222222222222
            2222222222222222222222222222222222222222222222222222222220000022
            2222222220111022222222222011102222222222201110222222220000111000
            0222222011111110222222220111110222222222201110222222222222010222
            2222222222202222222222222222222222222222222222222222}
        end
        object btn_PDown: TBitBtn
          Left = 400
          Top = 48
          Width = 27
          Height = 25
          Anchors = [akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Marlett'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btn_PDownClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000C40E0000C40E0000100000000000000004020400CCCA
            0400FC02FC0086820000F808700091C15F000C7644001E0000009C3488001931
            0A0003D0000000810000674C0100162200009C7D000019820000222222222222
            2222222222222222222222222222222222222222222222222222222222202222
            2222222222010222222222222011102222222222011111022222222011111110
            2222220000111000022222222011102222222222201110222222222220111022
            2222222220000022222222222222222222222222222222222222}
        end
        object btn_AddPackage: TBitBtn
          Left = 400
          Top = 270
          Width = 27
          Height = 25
          Anchors = [akRight, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btn_AddPackageClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            040000000000800000000000000000000000100000000000000000000000C0C0
            C000FF00FF0080808000FFFFFF0000FFFF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000222222222222
            2222223333333333333320000000000000032045454545004503205454545401
            0403204545454505100320545454540000034043545455454503355345354454
            5403234353545545450333343454545454034535433330000002235353522222
            2222352342352222222252235223222222222223422222222222}
        end
        object btn_DelPackage: TBitBtn
          Left = 400
          Top = 302
          Width = 27
          Height = 25
          Anchors = [akRight, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btn_DelPackageClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000C0C0C000FF00FF0080808000FFFFFF0000FFFF0000000000000000000000
            0000000000000000000000000000000000000000000000000000333333333333
            3333334444444444444430000000000000043056565656005604406565656502
            0504105656565606200411656541650000044146541456565604311461156565
            6504341111565656560434111565656565044111140000000003114311433333
            3333333331143333333333333311433333333333333333333333}
        end
        object btn_Import: TBitBtn
          Left = 400
          Top = 334
          Width = 27
          Height = 25
          Hint = 'Import priority list from an .ini file'
          Anchors = [akRight, akBottom]
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = btn_ImportClick
        end
        object clb_PackagePriority: TCheckListBox
          Left = 8
          Top = 16
          Width = 385
          Height = 343
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ItemHeight = 13
          TabOrder = 5
        end
      end
    end
    object ts_IgnorePackages: TTabSheet
      HelpType = htKeyword
      HelpKeyword = 'ignorepackages'
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
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btn_AddIgnoreClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            040000000000800000000000000000000000100000000000000000000000C0C0
            C000FF00FF0080808000FFFFFF0000FFFF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000222222222222
            2222223333333333333320000000000000032045454545004503205454545401
            0403204545454505100320545454540000034043545455454503355345354454
            5403234353545545450333343454545454034535433330000002235353522222
            2222352342352222222252235223222222222223422222222222}
        end
        object btn_DelIgnore: TBitBtn
          Left = 400
          Top = 48
          Width = 27
          Height = 25
          Anchors = [akRight, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btn_DelIgnoreClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000C0C0C000FF00FF0080808000FFFFFF0000FFFF0000000000000000000000
            0000000000000000000000000000000000000000000000000000333333333333
            3333334444444444444430000000000000043056565656005604406565656502
            0504105656565606200411656541650000044146541456565604311461156565
            6504341111565656560434111565656565044111140000000003114311433333
            3333333331143333333333333311433333333333333333333333}
        end
      end
    end
    object ts_HTMLOutput: TTabSheet
      HelpType = htKeyword
      HelpKeyword = 'htmloutput'
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
      HelpType = htKeyword
      HelpKeyword = 'mshtmlhelp'
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
      HelpType = htKeyword
      HelpKeyword = 'compile'
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
      HelpType = htKeyword
      HelpKeyword = 'gameserver'
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
      HelpType = htKeyword
      HelpKeyword = 'fulltextsearch'
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
          Caption = 'Default to regular expression'
          TabOrder = 3
        end
      end
    end
    object ts_Layout: TTabSheet
      HelpType = htKeyword
      HelpKeyword = 'layout'
      Caption = 'Layout'
      ImageIndex = 8
      TabVisible = False
      object gb_Layout: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'Layout'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lbl_TreeFont: TLabel
          Left = 8
          Top = 16
          Width = 53
          Height = 13
          Caption = 'Tree layout'
        end
        object lbl_LogLayout: TLabel
          Left = 8
          Top = 136
          Width = 49
          Height = 13
          Caption = 'Log layout'
        end
        object tv_TreeLayout: TTreeView
          Left = 8
          Top = 32
          Width = 305
          Height = 73
          Anchors = [akLeft, akTop, akRight]
          HideSelection = False
          Indent = 19
          ReadOnly = True
          TabOrder = 0
          Items.Data = {
            010000001F0000000000000000000000FFFFFFFFFFFFFFFF0000000002000000
            064F626A6563741E0000000000000000000000FFFFFFFFFFFFFFFF0000000001
            000000054163746F721D0000000000000000000000FFFFFFFFFFFFFFFF000000
            000000000004496E666F200000000000000000000000FFFFFFFFFFFFFFFF0000
            0000000000000753657373696F6E}
        end
        object btn_FontSelect: TBitBtn
          Left = 320
          Top = 32
          Width = 105
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Font'
          TabOrder = 1
          OnClick = btn_FontSelectClick
        end
        object btn_FontColor: TBitBtn
          Left = 320
          Top = 56
          Width = 105
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Font color'
          TabOrder = 3
          OnClick = btn_FontColorClick
        end
        object btn_BGColor: TBitBtn
          Left = 320
          Top = 80
          Width = 105
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Background color'
          TabOrder = 2
          OnClick = btn_BGColorClick
        end
        object btn_LogFont: TBitBtn
          Left = 320
          Top = 152
          Width = 105
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Font'
          TabOrder = 4
          OnClick = btn_LogFontClick
        end
        object btn_LogFontColor: TBitBtn
          Left = 320
          Top = 176
          Width = 105
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Font color'
          TabOrder = 5
          OnClick = btn_LogFontColorClick
        end
        object btn_LogColor: TBitBtn
          Left = 320
          Top = 200
          Width = 105
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Background color'
          TabOrder = 6
          OnClick = btn_LogColorClick
        end
        object lb_LogLayout: TListBox
          Left = 8
          Top = 152
          Width = 305
          Height = 73
          Anchors = [akLeft, akTop, akRight]
          ExtendedSelect = False
          ItemHeight = 13
          Items.Strings = (
            
              'Actor.uc #1238,72: // called after PostBeginPlay.  On a net clie' +
              'nt, PostNetBeginPlay() is spawned after replicated variables hav' +
              'e been initialized to'
            
              'Actor.uc #1678,49: simulated function bool EffectIsRelevant(vect' +
              'or SpawnLocation, bool bForceDedicated )'
            'Actor.uc #1689,12:  else if ( SpawnLocation == Location )'
            
              'Actor.uc #1699,41:    bResult = ( (Vector(P.Rotation) Dot (Spawn' +
              'Location - P.ViewTarget.Location)) > 0.0 );'
            
              'Volume.uc #15,75: var() edfindable decorationlist DecoList;  // ' +
              'A list of decorations to be spawned inside the volume when the l' +
              'evel starts'
            
              'PhysicsVolume.uc #114,16:    PainTimer = spawn(class'#39'VolumeTimer' +
              #39', self);')
          TabOrder = 7
        end
        object cb_ExpandObject: TCheckBox
          Left = 8
          Top = 112
          Width = 305
          Height = 17
          Caption = 'Expand '#39'Object'#39' on startup'
          TabOrder = 8
        end
      end
    end
    object ts_ProgramOptions: TTabSheet
      HelpType = htKeyword
      HelpKeyword = 'programoptions'
      Caption = 'Program Options'
      ImageIndex = 9
      TabVisible = False
      object gb_ProgramOptions: TGroupBox
        Left = 0
        Top = 0
        Width = 433
        Height = 368
        Align = alClient
        Caption = 'Program Options'
        TabOrder = 0
        DesignSize = (
          433
          368)
        object lbl_StateFile: TLabel
          Left = 8
          Top = 16
          Width = 162
          Height = 13
          Caption = 'State file (relative to the config file)'
        end
        object lbl_HotKeys: TLabel
          Left = 8
          Top = 128
          Width = 42
          Height = 13
          Caption = 'Hot keys'
        end
        object ed_StateFilename: TEdit
          Left = 8
          Top = 32
          Width = 417
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          TabOrder = 0
        end
        object cb_MinimzeOnClose: TCheckBox
          Left = 8
          Top = 80
          Width = 113
          Height = 17
          Caption = 'Minimize on close'
          TabOrder = 1
        end
        object lv_HotKeys: TListView
          Left = 8
          Top = 168
          Width = 417
          Height = 193
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelKind = bkSoft
          BorderStyle = bsNone
          Columns = <
            item
              AutoSize = True
              Caption = 'Command'
            end
            item
              AutoSize = True
              Caption = 'Hot key'
            end>
          ColumnClick = False
          ReadOnly = True
          RowSelect = True
          SortType = stText
          TabOrder = 2
          ViewStyle = vsReport
          OnClick = lv_HotKeysClick
        end
        object ed_HotKey: TEdit
          Left = 8
          Top = 144
          Width = 177
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkSoft
          BorderStyle = bsNone
          ReadOnly = True
          TabOrder = 3
        end
        object btn_SetHotKey: TBitBtn
          Left = 368
          Top = 144
          Width = 57
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Set'
          TabOrder = 4
          OnClick = btn_SetHotKeyClick
        end
        object hk_HotKey: THotKey
          Left = 192
          Top = 144
          Width = 169
          Height = 21
          Anchors = [akTop, akRight]
          HotKey = 0
          InvalidKeys = [hcNone]
          Modifiers = []
          TabOrder = 5
        end
        object cb_ModifiedOnStartup: TCheckBox
          Left = 8
          Top = 56
          Width = 193
          Height = 17
          Caption = 'Analyse modified classes on startup'
          TabOrder = 6
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
  object btn_Help: TBitBtn
    Left = 592
    Top = 72
    Width = 75
    Height = 25
    TabOrder = 4
    OnClick = btn_HelpClick
    Kind = bkHelp
  end
  object sd_SaveFile: TSaveDialog
    DefaultExt = '*.chm'
    Filter = 'HTML Help files|*.chm|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'HTML Help output file'
    Left = 592
    Top = 104
  end
  object pm_CompilerPlaceholders: TPopupMenu
    Left = 592
    Top = 136
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
    Left = 592
    Top = 168
  end
  object pm_OpenResultPlaceHolders: TPopupMenu
    Left = 624
    Top = 136
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
  object od_BrowseIni: TOpenDialog
    DefaultExt = '*.ini'
    Filter = 'INI Files|*.ini|All Files|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Select an .ini file'
    Left = 624
    Top = 168
  end
  object fd_Font: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdForceFontExist]
    Left = 592
    Top = 200
  end
  object cd_Color: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen, cdAnyColor]
    Left = 624
    Top = 200
  end
end
