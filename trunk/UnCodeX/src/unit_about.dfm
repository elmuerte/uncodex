object frm_About: Tfrm_About
  Left = 424
  Top = 211
  ActiveControl = ed_Email
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = 'About ...'
  ClientHeight = 292
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
    292)
  PixelsPerInch = 96
  TextHeight = 13
  object bvl_Border: TBevel
    Left = 0
    Top = 0
    Width = 49
    Height = 292
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
  object img_Icons: TImage
    Left = 8
    Top = 8
    Width = 32
    Height = 32
    AutoSize = True
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
    Left = 200
    Top = 16
    Width = 63
    Height = 13
    Caption = 'lbl_Version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_Author: TLabel
    Left = 56
    Top = 40
    Width = 34
    Height = 13
    Caption = 'Author:'
  end
  object lbl_Author2: TLabel
    Left = 72
    Top = 56
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
    Top = 96
    Width = 55
    Height = 13
    Caption = 'Homepage:'
  end
  object mm_LegalShit: TMemo
    Left = 56
    Top = 144
    Width = 265
    Height = 148
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelKind = bkSoft
    BorderStyle = bsNone
    Lines.Strings = (
      'UnCodeX '#169' Copyright 2003 '
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
    Top = 72
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
    Top = 112
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
end
