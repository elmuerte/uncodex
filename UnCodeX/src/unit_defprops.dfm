object frm_DefPropsBrowser: Tfrm_DefPropsBrowser
  Left = 255
  Top = 164
  Width = 576
  Height = 265
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Defaultproperties browser'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object spl_Main: TSplitter
    Left = 169
    Top = 0
    Width = 4
    Height = 238
    Cursor = crHSplit
    AutoSnap = False
  end
  object lb_Properties: TListBox
    Left = 0
    Top = 0
    Width = 169
    Height = 238
    Align = alLeft
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnClick = lb_PropertiesClick
  end
  object gb_Property: TGroupBox
    Left = 173
    Top = 0
    Width = 395
    Height = 238
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      395
      238)
    object Label1: TLabel
      Left = 8
      Top = 96
      Width = 71
      Height = 13
      Caption = 'Effective value'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 48
      Height = 13
      Caption = 'Defined in'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 16
      Width = 24
      Height = 13
      Caption = 'Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lv_SelProperty: TListView
      Left = 2
      Top = 136
      Width = 391
      Height = 100
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Value'
          MinWidth = 50
          Width = -1
          WidthType = (
            -1)
        end
        item
          Caption = 'Set in class'
          Width = -1
          WidthType = (
            -1)
        end>
      ColumnClick = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
    end
    object ed_EffValue: TEdit
      Left = 8
      Top = 112
      Width = 377
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object ed_DefIn: TEdit
      Left = 8
      Top = 72
      Width = 377
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object ed_type: TEdit
      Left = 8
      Top = 32
      Width = 377
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
  end
end
