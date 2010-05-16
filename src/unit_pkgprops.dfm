object frm_PackageProps: Tfrm_PackageProps
  Left = 323
  Top = 143
  Width = 298
  Height = 309
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
  OnShow = FormShow
  DesignSize = (
    290
    282)
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
      OnClick = cb_AllowDownloadClick
    end
    object cb_ClientOptional: TCheckBox
      Left = 8
      Top = 32
      Width = 129
      Height = 17
      Caption = '&Client Optional'
      TabOrder = 1
      OnClick = cb_AllowDownloadClick
    end
    object cb_ServerSideOnly: TCheckBox
      Left = 144
      Top = 16
      Width = 137
      Height = 17
      Caption = '&Server Side Only'
      TabOrder = 2
      OnClick = cb_AllowDownloadClick
    end
    object cb_Official: TCheckBox
      Left = 144
      Top = 32
      Width = 137
      Height = 17
      Caption = '&Official'
      TabOrder = 3
      OnClick = cb_AllowDownloadClick
    end
  end
  object gb_Description: TGroupBox
    Left = 0
    Top = 57
    Width = 290
    Height = 191
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Description'
    TabOrder = 1
    DesignSize = (
      290
      191)
    object mm_Desc: TMemo
      Left = 2
      Top = 15
      Width = 286
      Height = 146
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object cb_ExternalDescription: TCheckBox
      Left = 8
      Top = 168
      Width = 273
      Height = 17
      Hint = 
        'Don'#39't save the description to the upkg files, but to the package' +
        ' description file'
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'External description'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object btn_Ok: TBitBtn
    Left = 215
    Top = 255
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkOK
  end
  object btn_Cancel: TBitBtn
    Left = 135
    Top = 255
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 3
    Kind = bkCancel
  end
end
