object frm_CreateNewClass: Tfrm_CreateNewClass
  Left = 361
  Top = 209
  HelpType = htKeyword
  BorderStyle = bsDialog
  Caption = 'Create new class'
  ClientHeight = 271
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'bla'
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnKeyUp = FormKeyUp
  DesignSize = (
    351
    271)
  PixelsPerInch = 96
  TextHeight = 13
  object bvl_MsgBorder: TBevel
    Left = 8
    Top = 136
    Width = 337
    Height = 97
    Anchors = [akLeft, akTop, akRight]
    ParentShowHint = False
    ShowHint = True
  end
  object lbl_Package: TLabel
    Left = 8
    Top = 8
    Width = 43
    Height = 13
    Caption = 'Package'
  end
  object lbl_ParentClass: TLabel
    Left = 8
    Top = 48
    Width = 58
    Height = 13
    Caption = 'Parent class'
  end
  object lbl_NewClass: TLabel
    Left = 8
    Top = 96
    Width = 49
    Height = 13
    Caption = 'New class'
  end
  object lbl_FileName: TLabel
    Left = 16
    Top = 144
    Width = 45
    Height = 13
    Caption = 'Filename:'
  end
  object lbl_Duplicate: TLabel
    Left = 16
    Top = 208
    Width = 321
    Height = 17
    Hint = 
      'There is already a class with that name. You are advised to use ' +
      'an unique class name.'
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Duplicate class name'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowAccelChar = False
    ShowHint = True
    Layout = tlCenter
    Visible = False
  end
  object cb_Package: TComboBox
    Left = 8
    Top = 24
    Width = 337
    Height = 21
    HelpType = htKeyword
    AutoDropDown = True
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnChange = ed_NewClassChange
    OnKeyPress = ed_NewClassKeyPress
  end
  object cb_ParentClass: TComboBox
    Left = 8
    Top = 64
    Width = 337
    Height = 21
    AutoDropDown = True
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnKeyPress = ed_NewClassKeyPress
  end
  object btn_Ok: TBitBtn
    Left = 272
    Top = 240
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btn_OkClick
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
    Left = 192
    Top = 240
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 4
    Kind = bkCancel
  end
  object ed_Filename: TEdit
    Left = 16
    Top = 160
    Width = 321
    Height = 21
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkSoft
    BorderStyle = bsNone
    ParentColor = True
    ReadOnly = True
    TabOrder = 5
  end
  object cb_NewPackage: TCheckBox
    Left = 16
    Top = 184
    Width = 321
    Height = 17
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Create new package'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = cb_NewPackageClick
  end
  object ed_NewClass: TEdit
    Left = 8
    Top = 112
    Width = 337
    Height = 21
    TabOrder = 2
    Text = 'NewClass'
    OnChange = ed_NewClassChange
    OnKeyPress = ed_NewClassKeyPress
  end
end
