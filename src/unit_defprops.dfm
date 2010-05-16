object frm_DefPropsBrowser: Tfrm_DefPropsBrowser
  Left = 255
  Top = 164
  Width = 620
  Height = 340
  BorderIcons = [biSystemMenu, biMaximize]
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pc_DefPropPages: TPageControl
    Left = 0
    Top = 0
    Width = 612
    Height = 313
    Align = alClient
    PopupMenu = pm_This
    Style = tsFlatButtons
    TabOrder = 0
    OnContextPopup = pc_DefPropPagesContextPopup
  end
  object pm_This: TPopupMenu
    Left = 64
    Top = 24
    object mi_Close1: TMenuItem
      Caption = 'Close this tab'
      OnClick = mi_Close1Click
    end
  end
end
