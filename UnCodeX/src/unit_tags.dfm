object frm_Tags: Tfrm_Tags
  Left = 423
  Top = 190
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'Tags'
  ClientHeight = 300
  ClientWidth = 209
  Color = clBtnFace
  Constraints.MinWidth = 155
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  DesignSize = (
    209
    300)
  PixelsPerInch = 96
  TextHeight = 13
  inline fr_Main: Tfr_Properties
    Left = 0
    Top = 0
    Width = 209
    Height = 300
    Align = alClient
    Constraints.MinHeight = 45
    TabOrder = 1
    inherited bvl_Nothing: TBevel
      Width = 209
    end
    inherited lv_Properties: TListView
      Width = 209
      Height = 270
    end
    inherited pnl_Ctrls: TPanel
      Width = 209
    end
    inherited pm_Props: TPopupMenu
      inherited mi_Editexternalcomment1: TMenuItem
        OnClick = fr_Mainmi_Editexternalcomment1Click
      end
    end
  end
  object btn_MakeWindow: TBitBtn
    Left = 198
    Top = 0
    Width = 10
    Height = 10
    Anchors = [akTop, akRight]
    Caption = '7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Marlett'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = FormDblClick
  end
end
