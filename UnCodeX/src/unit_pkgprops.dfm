object frm_PackageProps: Tfrm_PackageProps
  Left = 323
  Top = 143
  Width = 298
  Height = 277
  BorderIcons = []
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 298
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnShow = FormShow
  DesignSize = (
    290
    250)
  PixelsPerInch = 96
  TextHeight = 13
  object gb_Flags: TGroupBox
    Left = 0
    Top = 0
    Width = 290
    Height = 57
    Align = alTop
    Caption = 'Flags'
    TabOrder = 0
    object cb_AllowDownload: TCheckBox
      Left = 8
      Top = 16
      Width = 129
      Height = 17
      Caption = 'Allow &Download'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cb_ClientOptional: TCheckBox
      Left = 8
      Top = 32
      Width = 129
      Height = 17
      Caption = '&Client Optional'
      TabOrder = 1
    end
    object cb_ServerSideOnly: TCheckBox
      Left = 144
      Top = 16
      Width = 137
      Height = 17
      Caption = '&Server Side Only'
      TabOrder = 2
    end
    object cb_Official: TCheckBox
      Left = 144
      Top = 32
      Width = 137
      Height = 17
      Caption = '&Official'
      TabOrder = 3
    end
  end
  object gb_Description: TGroupBox
    Left = 0
    Top = 57
    Width = 290
    Height = 159
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Description'
    TabOrder = 1
    object mm_Desc: TMemo
      Left = 2
      Top = 15
      Width = 286
      Height = 142
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object btn_Ok: TBitBtn
    Left = 215
    Top = 223
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkOK
  end
  object btn_Cancel: TBitBtn
    Left = 135
    Top = 223
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 3
    Kind = bkCancel
  end
end
