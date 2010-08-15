object frm_MultiLineQuery: Tfrm_MultiLineQuery
  Left = 391
  Top = 299
  Width = 480
  Height = 201
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Query'
  Color = clBtnFace
  Constraints.MinHeight = 140
  Constraints.MinWidth = 190
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    472
    174)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Prompt: TLabel
    Left = 8
    Top = 8
    Width = 461
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
  end
  object mm_Input: TMemo
    Left = 8
    Top = 24
    Width = 457
    Height = 117
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 0
    WantTabs = True
  end
  object btn_Cancel: TBitBtn
    Left = 304
    Top = 147
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkCancel
  end
  object btn_Ok: TBitBtn
    Left = 384
    Top = 147
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 1
    Kind = bkOK
  end
end
