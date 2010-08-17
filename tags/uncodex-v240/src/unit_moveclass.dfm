object frm_MoveClass: Tfrm_MoveClass
  Left = 307
  Top = 200
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Move class'
  ClientHeight = 184
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyUp = FormKeyUp
  DesignSize = (
    443
    184)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Class: TLabel
    Left = 8
    Top = 8
    Width = 25
    Height = 13
    Caption = 'Class'
  end
  object lbl_OldPkg: TLabel
    Left = 8
    Top = 48
    Width = 79
    Height = 13
    Caption = 'Current package'
  end
  object lbl_NewPkg: TLabel
    Left = 8
    Top = 88
    Width = 67
    Height = 13
    Caption = 'New package'
  end
  object lbl_Duplicate: TLabel
    Left = 8
    Top = 128
    Width = 425
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'The package already has a class with that name'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
    Visible = False
  end
  object ed_Class: TEdit
    Left = 8
    Top = 24
    Width = 427
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    ReadOnly = True
    TabOrder = 0
  end
  object btn_Cancel: TBitBtn
    Left = 280
    Top = 152
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkCancel
  end
  object btn_Move: TBitBtn
    Left = 360
    Top = 152
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Enabled = False
    TabOrder = 1
    Kind = bkOK
  end
  object ed_OldPkg: TEdit
    Left = 8
    Top = 64
    Width = 425
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    ReadOnly = True
    TabOrder = 3
  end
  object cb_NewPkg: TComboBox
    Left = 8
    Top = 104
    Width = 425
    Height = 21
    AutoDropDown = True
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
    OnChange = cb_NewPkgChange
  end
  object cb_NewPackage: TCheckBox
    Left = 8
    Top = 156
    Width = 97
    Height = 17
    Caption = 'New package'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = cb_NewPackageClick
  end
end
