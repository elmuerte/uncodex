object frm_MultiLineQuery: Tfrm_MultiLineQuery
  Left = 391
  Top = 299
  Width = 488
  Height = 190
  BorderIcons = [biMaximize]
  Caption = 'Query'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    480
    163)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Prompt: TLabel
    Left = 8
    Top = 8
    Width = 469
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
  end
  object mm_Input: TMemo
    Left = 8
    Top = 24
    Width = 465
    Height = 106
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 0
    WantTabs = True
  end
  object BitBtn2: TBitBtn
    Left = 312
    Top = 136
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkCancel
  end
  object BitBtn1: TBitBtn
    Left = 392
    Top = 136
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 1
    Kind = bkOK
  end
end
