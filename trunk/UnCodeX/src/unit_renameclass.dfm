object frm_RenameClass: Tfrm_RenameClass
  Left = 223
  Top = 124
  BorderStyle = bsDialog
  Caption = 'Rename class'
  ClientHeight = 144
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    442
    144)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Class: TLabel
    Left = 8
    Top = 8
    Width = 72
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Old class name'
  end
  object lbl_OldPkg: TLabel
    Left = 8
    Top = 48
    Width = 78
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = 'New class name'
  end
  object lbl_Duplicate: TLabel
    Left = 8
    Top = 88
    Width = 425
    Height = 17
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'There is already a class with that name in this package'
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
  object lbl_Warning: TLabel
    Left = 8
    Top = 88
    Width = 425
    Height = 17
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Warning: there'#39's already a class with that name'
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
    Width = 425
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    ReadOnly = True
    TabOrder = 0
  end
  object ed_NewClass: TEdit
    Left = 8
    Top = 64
    Width = 425
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    OnChange = ed_NewClassChange
    OnKeyPress = ed_NewClassKeyPress
  end
  object btn_Cancel: TBitBtn
    Left = 281
    Top = 112
    Width = 75
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Kind = bkCancel
  end
  object btn_Rename: TBitBtn
    Left = 361
    Top = 112
    Width = 75
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    TabOrder = 3
    Kind = bkOK
  end
end
