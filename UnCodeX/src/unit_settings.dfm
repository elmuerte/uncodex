object frm_Settings: Tfrm_Settings
  Left = 254
  Top = 152
  Width = 670
  Height = 405
  AlphaBlendValue = 128
  Caption = 'Settings'
  Color = clBtnFace
  TransparentColorValue = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 670
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  DesignSize = (
    662
    378)
  PixelsPerInch = 96
  TextHeight = 13
  object btn_Ok: TBitBtn
    Left = 583
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object btn_Cancel: TBitBtn
    Left = 583
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 2
    OnClick = btn_CancelClick
    Kind = bkCancel
  end
  object pc_Settings: TPageControl
    Left = 145
    Top = 24
    Width = 432
    Height = 353
    ActivePage = ts_ProgramOptions
    Align = alCustom
    Anchors = [akLeft, akTop, akRight, akBottom]
    MultiLine = True
    Style = tsFlatButtons
    TabOrder = 0
    object ts_SourcePaths: TTabSheet
      Tag = -1
      HelpType = htKeyword
      HelpKeyword = 'sourcepaths'
      Caption = 'Source Paths'
      TabVisible = False
      DesignSize = (
        424
        343)
      object btn_SAdd: TBitBtn
        Left = 0
        Top = 0
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
        Left = 80
        Top = 0
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
      object lb_Paths: TListBox
        Left = 0
        Top = 32
        Width = 424
        Height = 311
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ItemHeight = 13
        TabOrder = 2
      end
      object btn_SUp: TBitBtn
        Left = 365
        Top = 0
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
        Left = 397
        Top = 0
        Width = 27
        Height = 25
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Marlett'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
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
    object ts_PackagePriority: TTabSheet
      Tag = -1
      HelpType = htKeyword
      HelpKeyword = 'packagepriority'
      Caption = 'Package Priority'
      ImageIndex = 1
      TabVisible = False
      DesignSize = (
        424
        343)
      object clb_PackagePriority: TCheckListBox
        Left = 0
        Top = 0
        Width = 392
        Height = 343
        OnClickCheck = clb_PackagePriorityClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ItemHeight = 13
        TabOrder = 0
      end
      object btn_PUp: TBitBtn
        Left = 397
        Top = 0
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
        Left = 397
        Top = 32
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
        Left = 397
        Top = 221
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
        Left = 397
        Top = 253
        Width = 27
        Height = 25
        Hint = 'Remove package from the listing'
        Anchors = [akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = btn_DelPackageClick
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FF00
          FF00FFFF0000FFFF0000EFFD0000C7FF0000C3FB0000E3F70000F1E70000F8CF
          0000FC1F0000FE3F0000FC1F0000F8CF0000E1E70000C3F30000C7FD0000FFFF
          0000}
      end
      object btn_Ignore: TBitBtn
        Left = 397
        Top = 285
        Width = 27
        Height = 25
        Hint = 'Ignore package'
        Anchors = [akRight, akBottom]
        TabOrder = 5
        OnClick = btn_IgnoreClick
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
        Left = 397
        Top = 317
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
        TabOrder = 6
        OnClick = btn_ImportClick
      end
    end
    object ts_IgnorePackages: TTabSheet
      Tag = 1
      HelpType = htKeyword
      HelpKeyword = 'ignorepackages'
      Caption = 'Ignore Packages'
      ImageIndex = 6
      TabVisible = False
      DesignSize = (
        424
        343)
      object btn_AddIgnore: TBitBtn
        Left = 397
        Top = 0
        Width = 27
        Height = 25
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
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
      object lb_IgnorePackages: TListBox
        Left = 0
        Top = 0
        Width = 392
        Height = 343
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ExtendedSelect = False
        ItemHeight = 13
        Sorted = True
        TabOrder = 1
      end
      object btn_UnIgnore: TBitBtn
        Left = 397
        Top = 64
        Width = 27
        Height = 25
        Hint = 'Unignore the selected package'
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btn_UnIgnoreClick
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
      object btn_DelIgnore: TBitBtn
        Left = 397
        Top = 32
        Width = 27
        Height = 25
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = btn_DelIgnoreClick
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FF00
          FF00FFFF0000FFFF0000EFFD0000C7FF0000C3FB0000E3F70000F1E70000F8CF
          0000FC1F0000FE3F0000FC1F0000F8CF0000E1E70000C3F30000C7FD0000FFFF
          0000}
      end
    end
    object ts_HTMLOutput: TTabSheet
      Tag = -1
      HelpType = htKeyword
      HelpKeyword = 'htmloutput'
      Caption = 'HTML Output'
      ImageIndex = 2
      TabVisible = False
      DesignSize = (
        424
        343)
      object lbl_Template: TLabel
        Left = 0
        Top = 48
        Width = 92
        Height = 13
        Caption = 'Templates directory'
      end
      object lbl_TabsToSpaces: TLabel
        Left = 0
        Top = 192
        Width = 235
        Height = 13
        Caption = 'Tabs to spaces (0 = template default; -1 = disable)'
      end
      object lbl_OutputDir: TLabel
        Left = 0
        Top = 0
        Width = 75
        Height = 13
        Caption = 'Output directory'
      end
      object lbl_HTMLTargetExt: TLabel
        Left = 0
        Top = 144
        Width = 209
        Height = 13
        Caption = 'Target extention (leave blank for the default)'
      end
      object lbl_HTMLDefaultTitle: TLabel
        Left = 0
        Top = 96
        Width = 228
        Height = 13
        Caption = 'Default title (leave blank for the template default)'
      end
      object lbl_CPP: TLabel
        Left = 0
        Top = 240
        Width = 353
        Height = 13
        Caption = 
          'Comment PreProcessor (leave empty for template default, or none ' +
          'for none)'
      end
      object btn_HTMLOutputDir: TBitBtn
        Left = 399
        Top = 16
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 0
        OnClick = btn_HTMLOutputDirClick
      end
      object ud_TabsToSpaces: TUpDown
        Left = 408
        Top = 208
        Width = 15
        Height = 21
        Anchors = [akTop, akRight]
        Associate = ed_TabsToSpaces
        Min = -1
        Max = 255
        Position = 0
        TabOrder = 1
        Wrap = False
      end
      object ed_TemplateDir: TEdit
        Left = 0
        Top = 64
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 2
      end
      object ed_TabsToSpaces: TEdit
        Left = 0
        Top = 208
        Width = 408
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 3
        Text = '0'
      end
      object ed_HTMLTargetExt: TEdit
        Left = 0
        Top = 160
        Width = 424
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 4
      end
      object ed_HTMLOutputDir: TEdit
        Left = 0
        Top = 16
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 5
      end
      object ed_HTMLDefaultTitle: TEdit
        Left = 0
        Top = 112
        Width = 424
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 6
      end
      object ed_CPPApp: TEdit
        Left = 0
        Top = 256
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 7
      end
      object btn_SelectTemplateDir: TBitBtn
        Left = 399
        Top = 64
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 8
        OnClick = btn_SelectTemplateDirClick
      end
      object btn_SelectCPP: TBitBtn
        Left = 399
        Top = 256
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 9
        OnClick = btn_SelectCPPClick
      end
    end
    object ts_HTMLHelp: TTabSheet
      Tag = -1
      HelpType = htKeyword
      HelpKeyword = 'mshtmlhelp'
      Caption = 'MS HTML Help'
      ImageIndex = 3
      TabVisible = False
      DesignSize = (
        424
        343)
      object lbl_Workshop: TLabel
        Left = 0
        Top = 0
        Width = 107
        Height = 13
        Caption = 'HTML Help Workshop'
      end
      object lbl_HTMLTitle: TLabel
        Left = 0
        Top = 96
        Width = 153
        Height = 13
        Caption = 'Title (leave blank for default title)'
      end
      object lbl_HTMLHelpOutput: TLabel
        Left = 0
        Top = 48
        Width = 48
        Height = 13
        Caption = 'Output file'
      end
      object btn_HTMLHelpOutput: TBitBtn
        Left = 399
        Top = 64
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 0
        OnClick = btn_HTMLHelpOutputClick
      end
      object ed_WorkshopPath: TEdit
        Left = 0
        Top = 16
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 1
      end
      object ed_HTMLHelpOutput: TEdit
        Left = 0
        Top = 64
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 2
      end
      object ed_HHTitle: TEdit
        Left = 0
        Top = 112
        Width = 424
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 3
      end
      object btn_SelectWorkshop: TBitBtn
        Left = 399
        Top = 16
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 4
        OnClick = btn_SelectWorkshopClick
      end
    end
    object ts_ProgramOptions: TTabSheet
      Tag = -1
      HelpType = htKeyword
      HelpKeyword = 'programoptions'
      Caption = 'Program Options'
      ImageIndex = 9
      TabVisible = False
      DesignSize = (
        424
        343)
      object lbl_StateFile: TLabel
        Left = 0
        Top = 0
        Width = 162
        Height = 13
        Caption = 'State file (relative to the config file)'
      end
      object lbl_InlineSearchTimeout: TLabel
        Left = 0
        Top = 88
        Width = 157
        Height = 13
        Caption = 'Inline search timeout (in seconds)'
      end
      object Label1: TLabel
        Left = 0
        Top = 168
        Width = 210
        Height = 13
        Caption = 'Default inheritance depth for class properties'
      end
      object bvl_Sep1: TBevel
        Left = 0
        Top = 128
        Width = 425
        Height = 9
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object ud_InlineSearchTimeout: TUpDown
        Left = 409
        Top = 104
        Width = 16
        Height = 21
        Anchors = [akTop, akRight]
        Associate = ed_InlineSearchTimeout
        Min = 1
        Max = 255
        Position = 5
        TabOrder = 0
        Thousands = False
        Wrap = False
      end
      object ud_DefInheritDepth: TUpDown
        Left = 409
        Top = 184
        Width = 16
        Height = 21
        Anchors = [akTop, akRight]
        Associate = ed_DefInheritanceDepth
        Min = 0
        Max = 255
        Position = 0
        TabOrder = 1
        Thousands = False
        Wrap = False
      end
      object ed_StateFilename: TEdit
        Left = 0
        Top = 16
        Width = 425
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 2
      end
      object ed_InlineSearchTimeout: TEdit
        Left = 0
        Top = 104
        Width = 409
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 3
        Text = '5'
      end
      object ed_DefInheritanceDepth: TEdit
        Left = 0
        Top = 184
        Width = 409
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 4
        Text = '0'
      end
      object cb_ModifiedOnStartup: TCheckBox
        Left = 0
        Top = 40
        Width = 193
        Height = 17
        Caption = 'Analyse modified classes on startup'
        TabOrder = 5
      end
      object cb_MinimzeOnClose: TCheckBox
        Left = 0
        Top = 56
        Width = 113
        Height = 17
        Caption = 'Minimize on close'
        TabOrder = 6
      end
      object cb_CPAsWindow: TCheckBox
        Left = 0
        Top = 142
        Width = 177
        Height = 17
        Caption = 'Open class properties as window'
        TabOrder = 7
      end
    end
    object ts_Comments: TTabSheet
      Tag = 5
      Caption = 'Comments\Descriptions'
      ImageIndex = 13
      TabVisible = False
      DesignSize = (
        424
        343)
      object lbl_gpdf: TLabel
        Left = 0
        Top = 0
        Width = 152
        Height = 13
        Caption = 'General package description file'
      end
      object lbl_ExtCmtFile: TLabel
        Left = 0
        Top = 40
        Width = 100
        Height = 13
        Caption = 'External comment file'
      end
      object ed_gpdf: TEdit
        Left = 0
        Top = 16
        Width = 401
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 0
      end
      object btn_BrowseGPDF: TBitBtn
        Left = 399
        Top = 16
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = btn_BrowseGPDFClick
      end
      object ed_ExtCmtFile: TEdit
        Left = 0
        Top = 56
        Width = 401
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 2
      end
      object btn_ExtCmtFile: TBitBtn
        Left = 399
        Top = 56
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 3
        OnClick = btn_ExtCmtFileClick
      end
    end
    object ts_Command: TTabSheet
      Tag = 5
      HelpType = htKeyword
      HelpKeyword = 'compile'
      Caption = 'Commands'
      ImageIndex = 4
      TabVisible = False
      DesignSize = (
        424
        343)
      object lbl_OpenResult: TLabel
        Left = 0
        Top = 48
        Width = 315
        Height = 13
        Caption = 'Open result command (leave blank for default MS Windows action)'
      end
      object lbl_Create: TLabel
        Left = 0
        Top = 120
        Width = 124
        Height = 13
        Caption = 'Create new class template'
      end
      object lbl_CompilerCommandline: TLabel
        Left = 0
        Top = 0
        Width = 105
        Height = 13
        Caption = 'Compiler commandline'
      end
      object bvl_Create: TBevel
        Left = 0
        Top = 104
        Width = 424
        Height = 9
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
      end
      object ed_OpenResultCmd: TEdit
        Left = 0
        Top = 64
        Width = 384
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 1
      end
      object ed_NewClassTemplate: TEdit
        Left = 0
        Top = 136
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 2
      end
      object ed_CompilerCommandline: TEdit
        Left = 0
        Top = 16
        Width = 384
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 3
      end
      object btn_OpenResultPlaceHolder: TBitBtn
        Left = 383
        Top = 64
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
        TabOrder = 4
        OnClick = btn_OpenResultPlaceHolderClick
      end
      object btn_OpenResultCmd: TBitBtn
        Left = 399
        Top = 64
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 5
        OnClick = btn_OpenResultCmdClick
      end
      object btn_CompilerPlaceholders: TBitBtn
        Left = 383
        Top = 16
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
        TabOrder = 6
        OnClick = btn_CompilerPlaceholdersClick
      end
      object btn_BrowseTemplate: TBitBtn
        Left = 399
        Top = 136
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 7
        OnClick = btn_BrowseTemplateClick
      end
      object btn_BrowseCompiler: TBitBtn
        Left = 399
        Top = 16
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 0
        OnClick = btn_BrowseCompilerClick
      end
    end
    object ts_HotKeys: TTabSheet
      Tag = 5
      HelpType = htKeyword
      HelpKeyword = 'hotkeys'
      Caption = 'Hot keys'
      ImageIndex = 10
      TabVisible = False
      DesignSize = (
        424
        343)
      object btn_SetHotKey: TBitBtn
        Left = 367
        Top = 0
        Width = 57
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Set'
        TabOrder = 0
        OnClick = btn_SetHotKeyClick
      end
      object lv_HotKeys: TListView
        Left = 0
        Top = 32
        Width = 424
        Height = 311
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelKind = bkSoft
        BorderStyle = bsNone
        Columns = <
          item
            Caption = 'Action'
            Width = -1
            WidthType = (
              -1)
          end
          item
            Caption = 'Hotkey'
            Width = -1
            WidthType = (
              -1)
          end>
        ColumnClick = False
        ReadOnly = True
        RowSelect = True
        SortType = stText
        TabOrder = 1
        ViewStyle = vsReport
        OnSelectItem = lv_HotKeysSelectItem
      end
      object hk_HotKey: THotKey
        Left = 191
        Top = 0
        Width = 169
        Height = 21
        Anchors = [akTop, akRight]
        HotKey = 0
        InvalidKeys = [hcNone]
        Modifiers = []
        TabOrder = 2
      end
      object ed_HotKey: TEdit
        Left = 0
        Top = 0
        Width = 184
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 3
      end
    end
    object ts_GameServer: TTabSheet
      Tag = 5
      HelpType = htKeyword
      HelpKeyword = 'gameserver'
      Caption = 'Game Server'
      ImageIndex = 5
      TabVisible = False
      DesignSize = (
        424
        343)
      object lbl_ServerCommandline: TLabel
        Left = 0
        Top = 0
        Width = 96
        Height = 13
        Caption = 'Server commandline'
      end
      object lbl_ClientCommandline: TLabel
        Left = 0
        Top = 96
        Width = 91
        Height = 13
        Caption = 'Client commandline'
      end
      object lbl_ServerPriority: TLabel
        Left = 0
        Top = 40
        Width = 64
        Height = 13
        Caption = 'Server priority'
      end
      object lbl_RunHint: TLabel
        Left = 0
        Top = 317
        Width = 424
        Height = 26
        Align = alBottom
        Caption = 
          'Note: a more advanced method for starting servers/clients is ava' +
          'ilable via the Game Server->Run menu'
        ShowAccelChar = False
        WordWrap = True
      end
      object btn_BrowseServer: TBitBtn
        Left = 399
        Top = 16
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 0
        OnClick = btn_BrowseServerClick
      end
      object ed_ServerCommandline: TEdit
        Left = 0
        Top = 16
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 1
      end
      object ed_ClientCommandline: TEdit
        Left = 0
        Top = 112
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        TabOrder = 2
      end
      object cb_ServerPriority: TComboBox
        Left = 0
        Top = 56
        Width = 424
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 3
        Text = 'Normal'
        Items.Strings = (
          'Low'
          'Normal'
          'High'
          'Real time')
      end
      object btn_ClientCommandline: TBitBtn
        Left = 399
        Top = 112
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 4
        OnClick = btn_ClientCommandlineClick
      end
    end
    object ts_Layout: TTabSheet
      Tag = 5
      HelpType = htKeyword
      HelpKeyword = 'layout'
      Caption = 'Layout'
      ImageIndex = 8
      TabVisible = False
      DesignSize = (
        424
        343)
      object lbl_TreeFont: TLabel
        Left = 0
        Top = 0
        Width = 53
        Height = 13
        Caption = 'Tree layout'
      end
      object lbl_LogLayout: TLabel
        Left = 0
        Top = 128
        Width = 49
        Height = 13
        Caption = 'Log layout'
      end
      object btn_FontSelect: TBitBtn
        Left = 319
        Top = 16
        Width = 105
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Font'
        TabOrder = 0
        OnClick = btn_FontSelectClick
      end
      object tv_TreeLayout: TTreeView
        Left = 0
        Top = 16
        Width = 312
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 1
        Items.Data = {
          010000001F0000000000000000000000FFFFFFFFFFFFFFFF0000000002000000
          064F626A6563741E0000000000000000000000FFFFFFFFFFFFFFFF0000000001
          000000054163746F721D0000000000000000000000FFFFFFFFFFFFFFFF000000
          000000000004496E666F200000000000000000000000FFFFFFFFFFFFFFFF0000
          0000000000000753657373696F6E}
      end
      object lb_LogLayout: TListBox
        Left = 0
        Top = 144
        Width = 312
        Height = 89
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
        TabOrder = 2
      end
      object cb_LogFontColor: TColorBox
        Left = 319
        Top = 168
        Width = 105
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        ItemHeight = 16
        TabOrder = 3
        OnChange = cb_LogFontColorChange
      end
      object cb_LogColor: TColorBox
        Left = 319
        Top = 208
        Width = 105
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        ItemHeight = 16
        TabOrder = 4
        OnChange = cb_LogColorChange
      end
      object cb_FontColor: TColorBox
        Left = 319
        Top = 40
        Width = 105
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        ItemHeight = 16
        TabOrder = 5
        OnChange = cb_FontColorChange
      end
      object cb_ExpandObject: TCheckBox
        Left = 0
        Top = 104
        Width = 313
        Height = 17
        Caption = 'Expand '#39'Object'#39' on startup'
        TabOrder = 6
      end
      object cb_BGColor: TColorBox
        Left = 319
        Top = 72
        Width = 105
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        ItemHeight = 16
        TabOrder = 7
        OnChange = cb_BGColorChange
      end
      object btn_LogFont: TBitBtn
        Left = 319
        Top = 144
        Width = 105
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Font'
        TabOrder = 8
        OnClick = btn_LogFontClick
      end
    end
    object ts_SourceSnoop: TTabSheet
      Tag = 10
      HelpType = htKeyword
      HelpKeyword = 'sourcesnoop'
      Caption = 'Source snoop'
      ImageIndex = 11
      TabVisible = False
      DesignSize = (
        424
        343)
      object lbl_BackGround: TLabel
        Left = 232
        Top = 29
        Width = 58
        Height = 13
        Caption = 'Background'
      end
      object lbl_TabSize: TLabel
        Left = 232
        Top = 4
        Width = 40
        Height = 13
        Caption = 'Tab size'
      end
      object bvl_Font: TBevel
        Left = 104
        Top = 56
        Width = 320
        Height = 73
        Anchors = [akLeft, akTop, akRight]
        Shape = bsFrame
      end
      object btn_SourceFont: TBitBtn
        Left = 0
        Top = 0
        Width = 113
        Height = 25
        Caption = 'Font'
        TabOrder = 0
        OnClick = btn_SourceFontClick
      end
      object ud_TabSize: TUpDown
        Left = 409
        Top = 0
        Width = 16
        Height = 21
        Associate = ed_TabSize
        Min = 0
        Max = 256
        Position = 4
        TabOrder = 1
        Thousands = False
        Wrap = False
      end
      object re_Preview: TRichEditEx
        Left = 0
        Top = 136
        Width = 424
        Height = 207
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 2
        WordWrap = False
        GutterWidth = 50
      end
      object lb_Fonts: TListBox
        Left = 0
        Top = 24
        Width = 113
        Height = 105
        ItemHeight = 13
        Items.Strings = (
          'Default'
          'Keywords 1'
          'Keywords 2'
          'Strings'
          'Numbers'
          'Macros'
          'Comments'
          'Names'
          'Class Links')
        TabOrder = 3
        OnClick = lb_FontsClick
      end
      object ed_TabSize: TEdit
        Left = 328
        Top = 0
        Width = 81
        Height = 21
        BevelKind = bkSoft
        BiDiMode = bdLeftToRight
        BorderStyle = bsNone
        ParentBiDiMode = False
        TabOrder = 4
        Text = '4'
        OnChange = ed_TabSizeChange
      end
      object cb_SelColor: TColorBox
        Left = 120
        Top = 100
        Width = 137
        Height = 22
        DefaultColorColor = clWindowText
        Selected = clWindowText
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 5
        OnChange = cb_SelColorChange
      end
      object cb_funderline: TCheckBox
        Left = 280
        Top = 64
        Width = 128
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Underline'
        TabOrder = 6
        OnClick = cb_fboldClick
      end
      object cb_fstrikeout: TCheckBox
        Left = 280
        Top = 80
        Width = 128
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Strikeout'
        TabOrder = 7
        OnClick = cb_fboldClick
      end
      object cb_fitalic: TCheckBox
        Left = 120
        Top = 80
        Width = 97
        Height = 17
        Caption = 'Italic'
        TabOrder = 8
        OnClick = cb_fboldClick
      end
      object cb_fbold: TCheckBox
        Left = 120
        Top = 64
        Width = 97
        Height = 17
        Caption = 'Bold'
        TabOrder = 9
        OnClick = cb_fboldClick
      end
      object cb_Background: TColorBox
        Left = 328
        Top = 24
        Width = 97
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 10
        OnChange = cb_BackgroundChange
      end
    end
    object ts_PlugIns: TTabSheet
      Tag = 5
      Caption = 'Plug-ins'
      ImageIndex = 12
      TabVisible = False
      DesignSize = (
        424
        343)
      object lbl_UPSDIR: TLabel
        Left = 0
        Top = 32
        Width = 154
        Height = 13
        Caption = 'UnCodeX Pascal Script directory'
      end
      object ed_UPSDIR: TEdit
        Left = 0
        Top = 48
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkSoft
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 0
      end
      object btn_UPSDIR: TBitBtn
        Left = 399
        Top = 48
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = btn_UPSDIRClick
      end
      object cb_LoadCustomModules: TCheckBox
        Left = 0
        Top = 0
        Width = 161
        Height = 17
        Caption = 'Load custom output modules'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
    end
    object ts_Keywords: TTabSheet
      Tag = -1
      HelpType = htKeyword
      HelpKeyword = 'keywordlists'
      Caption = 'Keyword lists'
      ImageIndex = 12
      TabVisible = False
      DesignSize = (
        424
        343)
      object bvl_Keys: TBevel
        Left = 0
        Top = 0
        Width = 217
        Height = 343
        Align = alLeft
        Shape = bsRightLine
      end
      object lbl_SecondKey: TLabel
        Left = 224
        Top = 0
        Width = 99
        Height = 13
        Caption = 'Secondary keywords'
      end
      object lbl_PrimKey: TLabel
        Left = 0
        Top = 0
        Width = 82
        Height = 13
        Caption = 'Primary keywords'
      end
      object lb_SecKey: TListBox
        Left = 224
        Top = 40
        Width = 200
        Height = 303
        Hint = 'Press delete to remove the selected keyword'
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnClick = lb_SecKeyClick
        OnKeyUp = lb_SecKeyKeyUp
      end
      object lb_PrimKey: TListBox
        Left = 0
        Top = 40
        Width = 209
        Height = 303
        Hint = 'Press delete to remove the selected keyword'
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        Sorted = True
        TabOrder = 1
        OnClick = lb_PrimKeyClick
        OnKeyUp = lb_PrimKeyKeyUp
      end
      object ed_AddSecKey: TEdit
        Left = 224
        Top = 16
        Width = 200
        Height = 21
        Hint = 'Press enter to add this keyword'
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecLowerCase
        TabOrder = 2
        OnKeyUp = ed_AddSecKeyKeyUp
      end
      object ed_AddPrimKey: TEdit
        Left = 0
        Top = 16
        Width = 209
        Height = 21
        Hint = 'Press enter to add this keyword'
        CharCase = ecLowerCase
        TabOrder = 3
        OnKeyUp = ed_AddPrimKeyKeyUp
      end
    end
  end
  object btn_Help: TBitBtn
    Left = 583
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 3
    OnClick = btn_HelpClick
    Kind = bkHelp
  end
  object pnl_Caption: TPanel
    Left = 144
    Top = 0
    Width = 432
    Height = 25
    Alignment = taLeftJustify
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    Color = clBtnShadow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnHighlight
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object tv_SettingSelect: TTreeView
    Left = 0
    Top = 0
    Width = 145
    Height = 378
    Align = alLeft
    BevelKind = bkSoft
    BorderStyle = bsNone
    HideSelection = False
    Indent = 19
    ReadOnly = True
    RowSelect = True
    ShowButtons = False
    ShowLines = False
    TabOrder = 5
    OnChange = tv_SettingSelectChange
    OnCollapsing = tv_SettingSelectCollapsing
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
    object mi_Resultfilename1: TMenuItem
      Caption = 'Result filename'
      OnClick = mi_Resultfilename1Click
    end
    object mi_Resultline1: TMenuItem
      Caption = 'Result line'
      OnClick = mi_Resultline1Click
    end
    object mi_Resultposition1: TMenuItem
      Caption = 'Result position'
      OnClick = mi_Resultposition1Click
    end
    object mi_N7: TMenuItem
      Caption = '-'
    end
    object mi_SearchQuery: TMenuItem
      Caption = 'Search query'
      OnClick = mi_SearchQueryClick
    end
    object mi_Classsearchquery: TMenuItem
      Caption = 'Class search query'
      OnClick = mi_ClasssearchqueryClick
    end
    object mi_Inlinesearchquery: TMenuItem
      Caption = 'Inline search query'
      OnClick = mi_InlinesearchqueryClick
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
    Top = 232
  end
  object od_BrowseUC: TOpenDialog
    DefaultExt = '*.uc'
    Filter = 'UnrealScript files|*.uc|All Files|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Select UnrealScript file'
    Left = 592
    Top = 200
  end
end
