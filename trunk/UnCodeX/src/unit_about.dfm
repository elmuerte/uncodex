object frm_About: Tfrm_About
  Left = 424
  Top = 211
  ActiveControl = ed_Email
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = 'About ...'
  ClientHeight = 308
  ClientWidth = 322
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
    322
    308)
  PixelsPerInch = 96
  TextHeight = 13
  object img_Logo: TImage
    Left = 0
    Top = 0
    Width = 49
    Height = 308
    Stretch = True
  end
  object bvl_Border: TBevel
    Left = 0
    Top = 0
    Width = 49
    Height = 308
    Align = alLeft
    Shape = bsFrame
  end
  object lbl_TitleHighlight: TLabel
    Left = 55
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
    Left = 57
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
    Left = 56
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
    Left = 208
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
    Left = 56
    Top = 48
    Width = 34
    Height = 13
    Caption = 'Author:'
  end
  object lbl_Author2: TLabel
    Left = 72
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
    Left = 56
    Top = 104
    Width = 55
    Height = 13
    Caption = 'Homepage:'
  end
  object lbl_TimeStamp: TLabel
    Left = 56
    Top = 29
    Width = 69
    Height = 13
    Caption = 'lbl_TimeStamp'
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
    Left = 208
    Top = 17
    Width = 54
    Height = 13
    Caption = 'lbl_Platform'
    Transparent = True
  end
  object mm_LegalShit: TMemo
    Left = 56
    Top = 152
    Width = 265
    Height = 156
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelKind = bkSoft
    BorderStyle = bsNone
    Lines.Strings = (
      'UnCodeX '#169' Copyright 2003, 2004 '
      'Michiel '#39'El Muerte'#39' Hendriks'
      ''
      'All rights belong to their respectfull owners.'
      'For the complete license read the LICENSE.TXT '
      'file in the program'#39's directory.'
      ''
      'Uses Andrey Sorokin'#39's TRegExpr'
      'Uses Ciaran McCreesh'#39's Hashes Library'
      'Uses The Helpware Group'#39's HTML Help API Unit'
      'Uses Emil M. Santos'#39's FastShareMem')
    ParentColor = True
    ReadOnly = True
    TabOrder = 0
    WantReturns = False
  end
  object ed_Email: TEdit
    Left = 72
    Top = 80
    Width = 249
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
    Left = 72
    Top = 120
    Width = 249
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
    Left = 303
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
    Left = 304
    Top = 121
    Width = 16
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
end
