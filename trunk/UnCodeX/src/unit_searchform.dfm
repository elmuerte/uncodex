object frm_SearchForm: Tfrm_SearchForm
  Left = 314
  Top = 224
  BorderStyle = bsDialog
  Caption = 'frm_SearchForm'
  ClientHeight = 154
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    402
    154)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Text: TLabel
    Left = 8
    Top = 8
    Width = 37
    Height = 13
    Caption = 'lbl_Text'
  end
  object cb_History: TComboBox
    Left = 8
    Top = 24
    Width = 386
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 10
    ItemHeight = 13
    TabOrder = 0
  end
  object cb_SearchBody: TCheckBox
    Left = 8
    Top = 56
    Width = 169
    Height = 17
    Caption = '&Search class body'
    TabOrder = 1
    OnClick = cb_SearchBodyClick
  end
  object cb_Regex: TCheckBox
    Left = 8
    Top = 72
    Width = 169
    Height = 17
    Caption = '&Regular expression'
    TabOrder = 2
  end
  object cb_Strict: TCheckBox
    Left = 8
    Top = 88
    Width = 169
    Height = 17
    Caption = '&Compare strict'
    TabOrder = 3
  end
  object btn_Ok: TBitBtn
    Left = 120
    Top = 120
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkOK
  end
  object btn_Cancel: TBitBtn
    Left = 208
    Top = 120
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object cb_FromTop: TCheckBox
    Left = 208
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Search from &top'
    TabOrder = 6
  end
end
