object frm_SearchForm: Tfrm_SearchForm
  Left = 314
  Top = 224
  ActiveControl = cb_History
  BorderStyle = bsDialog
  Caption = 'Search'
  ClientHeight = 199
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnKeyUp = FormKeyUp
  DesignSize = (
    400
    199)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Text: TLabel
    Left = 8
    Top = 8
    Width = 107
    Height = 13
    Caption = 'Enter the search query'
  end
  object bvl_Div: TBevel
    Left = 192
    Top = 48
    Width = 9
    Height = 144
    Anchors = [akLeft, akTop, akBottom]
    Shape = bsLeftLine
  end
  object cb_History: TComboBox
    Left = 8
    Top = 24
    Width = 384
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 10
    ItemHeight = 13
    TabOrder = 0
    OnChange = cb_HistoryChange
  end
  object rb_ClassSearch: TRadioButton
    Left = 8
    Top = 48
    Width = 177
    Height = 17
    Hint = 'Search for a class in the selected tree'
    Caption = '&Class search'
    Checked = True
    TabOrder = 3
    TabStop = True
    OnClick = rb_ClassSearchClick
  end
  object rb_FTS: TRadioButton
    Left = 200
    Top = 48
    Width = 193
    Height = 17
    Hint = 'Search in the class files'
    Anchors = [akLeft, akTop, akRight]
    Caption = '&Full text search'
    TabOrder = 4
    OnClick = rb_ClassSearchClick
  end
  object cb_SearchFromTheTop: TCheckBox
    Left = 8
    Top = 72
    Width = 177
    Height = 17
    Hint = 'Search from the top of the tree instead of the selected item'
    Caption = 'Search from the &top'
    TabOrder = 5
  end
  object cb_CompareStrict: TCheckBox
    Left = 8
    Top = 88
    Width = 177
    Height = 17
    Hint = 'Compare for the exact name'
    Caption = 'Compare &strict'
    TabOrder = 6
  end
  object cb_FindFirst: TCheckBox
    Left = 200
    Top = 72
    Width = 193
    Height = 17
    Hint = 'Stop search after the first match'
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Find first &match'
    TabOrder = 7
  end
  object cb_RegularExpression: TCheckBox
    Left = 200
    Top = 88
    Width = 193
    Height = 17
    Hint = 'Search query is an regular expression'
    Anchors = [akLeft, akTop, akRight]
    Caption = '&Regular expression'
    TabOrder = 8
  end
  object rg_Scope: TRadioGroup
    Left = 200
    Top = 112
    Width = 193
    Height = 81
    Hint = 'Search scope'
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Scope'
    ItemIndex = 0
    Items.Strings = (
      '&All classes'
      'From s&elected class'
      '&Subclasses'
      '&Parent classes')
    TabOrder = 9
  end
  object cb_Default: TCheckBox
    Left = 8
    Top = 152
    Width = 177
    Height = 17
    Hint = 'Set the current settings as the default'
    Caption = 'Set as &default'
    TabOrder = 10
  end
  object btn_Ok: TBitBtn
    Left = 8
    Top = 168
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object btn_Cancel: TBitBtn
    Left = 112
    Top = 168
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
