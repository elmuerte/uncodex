object frm_Tags: Tfrm_Tags
  Left = 423
  Top = 190
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'Tags'
  ClientHeight = 294
  ClientWidth = 201
  Color = clBtnFace
  Constraints.MinWidth = 209
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline fr_Main: Tfr_Properties
    Left = 0
    Top = 0
    Width = 201
    Height = 294
    Align = alClient
    AutoScroll = False
    TabOrder = 1
    inherited bcl_Spacer: TBevel
      Width = 201
    end
    inherited lv_Properties: TListView
      Width = 201
      Height = 277
    end
  end
  object btn_MakeWindow: TBitBtn
    Left = 0
    Top = 0
    Width = 10
    Height = 10
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
