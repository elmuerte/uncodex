object frm_Splash: Tfrm_Splash
  Left = 303
  Top = 156
  BorderStyle = bsNone
  Caption = 'Loading ...'
  ClientHeight = 308
  ClientWidth = 104
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object img_Logo: TImage
    Left = 0
    Top = 0
    Width = 49
    Height = 308
    Stretch = True
  end
  object Label1: TLabel
    Left = 1
    Top = 293
    Width = 46
    Height = 13
    Caption = 'Loading'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object tmr_Show: TTimer
    Interval = 100
    OnTimer = tmr_ShowTimer
    Left = 8
    Top = 8
  end
end
