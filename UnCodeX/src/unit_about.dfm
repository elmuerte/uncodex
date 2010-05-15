object frm_About: Tfrm_About
  Left = 424
  Top = 211
  ActiveControl = ed_Email
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = 'About ...'
  ClientHeight = 320
  ClientWidth = 331
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
    331
    320)
  PixelsPerInch = 96
  TextHeight = 13
  object img_Logo: TImage
    Left = 0
    Top = 0
    Width = 57
    Height = 321
    Anchors = [akLeft, akTop, akBottom]
    Stretch = True
  end
  object bvl_Border: TBevel
    Left = 0
    Top = 0
    Width = 57
    Height = 320
    Align = alLeft
    Shape = bsFrame
  end
  object lbl_TitleHighlight: TLabel
    Left = 63
    Top = -1
    Width = 138
    Height = 32
    Caption = 'UnCodeX'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16644812
    Font.Height = -27
    Font.Name = 'Verdana'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Transparent = True
  end
  object lbl_TitleShadow: TLabel
    Left = 65
    Top = 1
    Width = 138
    Height = 32
    Caption = 'UnCodeX'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'Verdana'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Transparent = True
  end
  object lbl_Title: TLabel
    Left = 64
    Top = 0
    Width = 138
    Height = 32
    Caption = 'UnCodeX'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 13286153
    Font.Height = -27
    Font.Name = 'Verdana'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Transparent = True
  end
  object lbl_Version: TLabel
    Left = 216
    Top = 3
    Width = 63
    Height = 13
    Caption = 'lbl_Version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lbl_Author: TLabel
    Left = 64
    Top = 48
    Width = 34
    Height = 13
    Caption = 'Author:'
  end
  object lbl_Author2: TLabel
    Left = 80
    Top = 64
    Width = 159
    Height = 13
    Caption = 'Michiel '#39'El Muerte'#39' Hendriks'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_Homepage: TLabel
    Left = 64
    Top = 104
    Width = 55
    Height = 13
    Caption = 'Homepage:'
  end
  object lbl_TimeStamp: TLabel
    Left = 64
    Top = 29
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Visible = False
  end
  object lbl_Platform: TLabel
    Left = 216
    Top = 17
    Width = 54
    Height = 13
    Caption = 'lbl_Platform'
    Transparent = True
  end
  object mm_LegalShit: TMemo
    Left = 64
    Top = 168
    Width = 266
    Height = 152
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelKind = bkSoft
    BorderStyle = bsNone
    Lines.Strings = (
      'UnCodeX '#169' Copyright 2003-2006 '
      'Michiel '#39'El Muerte'#39' Hendriks'
      ''
      'All rights belong to their respectfull owners.'
      'The license can be found in "Help->License"'
      ''
      'Uses Andrey Sorokin'#39's TRegExpr'
      'Uses Ciaran McCreesh'#39's Hashes Library'
      'Uses The Helpware Group'#39's HTML Help API Unit'
      'Uses Emil M. Santos'#39's FastShareMem'
      'Uses RemObjects'#39' PascalScript')
    ParentColor = True
    ReadOnly = True
    TabOrder = 0
    WantReturns = False
  end
  object ed_Email: TEdit
    Left = 80
    Top = 80
    Width = 250
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkSoft
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    Text = 'elmuerte@drunksnipers.com'
  end
  object ed_Homepage: TEdit
    Left = 80
    Top = 120
    Width = 250
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkSoft
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    Text = 'http://wiki.beyondunreal.com/wiki/UnCodeX'
  end
  object btn_EmailGo: TBitBtn
    Left = 312
    Top = 81
    Width = 17
    Height = 17
    Caption = '8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Marlett'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btn_EmailGoClick
  end
  object btn_HPGo: TBitBtn
    Left = 312
    Top = 121
    Width = 17
    Height = 17
    Caption = '8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Marlett'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btn_HPGoClick
  end
  object ed_Homepage2: TEdit
    Left = 80
    Top = 144
    Width = 250
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkSoft
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    Text = 'http://sourceforge.net/projects/uncodex'
  end
  object btn_HPGo2: TBitBtn
    Left = 312
    Top = 145
    Width = 17
    Height = 17
    Caption = '8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Marlett'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btn_HPGo2Click
  end
end
