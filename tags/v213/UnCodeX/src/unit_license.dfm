object frm_License: Tfrm_License
  Left = 237
  Top = 153
  BorderStyle = bsDialog
  BorderWidth = 2
  Caption = 'UnCodeX License'
  ClientHeight = 509
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object mm_License: TMemo
    Left = 0
    Top = 0
    Width = 667
    Height = 509
    Cursor = crArrow
    Align = alClient
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    Lines.Strings = (
      'WARNING !'
      ''
      'The license file (LICENSE.TXT) could not be found.'
      'You are using an unlicensed version of this application.'
      
        'Please remove it from your system and install a licensed version' +
        ' of the '
      'application.')
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
