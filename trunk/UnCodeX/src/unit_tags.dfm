object frm_Tags: Tfrm_Tags
  Left = 423
  Top = 190
  ActiveControl = lv_Properties
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
  object lbl_InheritanceLevel: TLabel
    Left = 13
    Top = 4
    Width = 78
    Height = 13
    Caption = 'Inheritance level'
  end
  object lv_Properties: TListView
    Left = 0
    Top = 21
    Width = 201
    Height = 273
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Type'
        Width = 18
      end
      item
        AutoSize = True
        Caption = 'Name'
      end
      item
        Caption = 'Line'
        Width = 0
      end
      item
        Caption = 'Depth'
        Width = 0
      end
      item
        Caption = 'HintText'
        Width = 0
      end
      item
        Caption = 'CopyText'
        Width = 0
      end>
    ColumnClick = False
    HideSelection = False
    IconOptions.WrapText = False
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    PopupMenu = pm_Props
    ShowColumnHeaders = False
    ShowHint = True
    SmallImages = il_Types
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = lv_PropertiesCustomDrawItem
    OnDblClick = mi_OpenLocationClick
    OnInfoTip = lv_PropertiesInfoTip
    OnSelectItem = lv_PropertiesSelectItem
  end
  object ed_InheritanceLevel: TEdit
    Left = 96
    Top = 0
    Width = 33
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object ud_InheritanceLevel: TUpDown
    Left = 129
    Top = 0
    Width = 15
    Height = 21
    Associate = ed_InheritanceLevel
    Min = 0
    Position = 0
    TabOrder = 2
    Wrap = False
  end
  object btn_Refresh: TBitBtn
    Left = 152
    Top = 0
    Width = 49
    Height = 21
    Caption = 'Refresh'
    TabOrder = 3
    OnClick = btn_RefreshClick
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
    TabOrder = 4
    OnClick = FormDblClick
  end
  object il_Types: TImageList
    Left = 8
    Top = 32
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400C6C6C600C6C6C6008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF000000000000FF000000FF000000FF00
      0000000000008484840000000000000000000000000000000000000000008484
      840084848400C6C6C600FFFF0000C6C6C600C6C6C600C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      84000000000000000000848484008484000084840000FF000000840000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000084840000FF000000FF00
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000084848400000000000000000084848400000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100C0C0C000C0C0C000E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E10000000000C0C0C000E1E1E100E1E1E10080808000E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E10080808000E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E10080808000E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E10080808000E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100C0C0C00000000000E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E1008080800080808000808080008080800080808000808080008080
      80008080800080808000E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E1008080800080808000808080008080
      80008080800080808000808080008080800080808000E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E10000000000C0C0C0008080800080808000808080008080
      8000808080008080800080808000E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E10080808000808080008080
      8000808080008080800080808000808080008080800080808000E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100808080008080800080808000808080008080800080808000808080008080
      800080808000E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100808080008080800080808000808080008080
      800080808000808080008080800080808000E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E10080808000E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E10080808000E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E10080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000DCDC000064640000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800000FFFF0000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000FF0000008000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      80008080800080808000808080000000000080808000E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E1000000000000000000000000008080
      8000DCDC0000DCDC000064640000646400000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      800000FFFF0000FFFF0000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      80000000FF000000FF0000008000000080000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000808080008080800080808000000000000000000080808000DCDC
      0000DCDC0000DCDC000064640000646400006464000000000000000000000000
      00000000000000000000000000000000000000000000000000008080800000FF
      FF0000FFFF0000FFFF0000808000008080000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      FF000000FF000000FF0000008000000080000000800000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000080808000DCDC0000DCDC
      0000DCDC0000DCDC000064640000646400006464000000000000000000000000
      000000000000000000000000000000000000000000008080800000FFFF0000FF
      FF0000FFFF0000FFFF0000808000008080000080800000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF000000
      FF000000FF000000FF0000008000000080000000800000000000000000000000
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000808080000000000080808000E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100C0C0C000C0C0C00080808000DCDC0000DCDC0000DCDC
      0000DCDC0000DCDC000064640000646400006464000080808000DCDC0000DCDC
      0000DCDC0000DCDC0000DCDC0000000000008080800000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF000080800000808000008080008080800000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000000000808080000000FF000000FF000000
      FF000000FF000000FF00000080000000800000008000808080000000FF000000
      FF000000FF000000FF000000FF0000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000080808000DCDC0000DCDC
      0000DCDC00008080800064640000646400006464000000000000000000008080
      8000DCDC0000DCDC0000DCDC000000000000000000008080800000FFFF0000FF
      FF0000FFFF008080800000808000008080000080800000000000000000008080
      800000FFFF0000FFFF0000FFFF000000000000000000808080000000FF000000
      FF000000FF008080800000008000000080000000800000000000000000008080
      80000000FF000000FF000000FF0000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000080808000DCDC
      000080808000808080006464000064640000646400000000000080808000DCDC
      0000DCDC0000DCDC0000DCDC00000000000000000000000000008080800000FF
      FF008080800080808000008080000080800000808000000000008080800000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000808080000000
      FF00808080008080800000008000000080000000800000000000808080000000
      FF000000FF000000FF000000FF0000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000808080000000000080808000E1E1E10080808000E1E1
      E10080808000E1E1E100FFFFFF00C0C0C0000000000000000000000000008080
      80000000000080808000646400006464000064640000DCDC0000DCDC0000DCDC
      0000DCDC0000DCDC0000DCDC0000000000000000000000000000000000008080
      8000000000008080800000808000008080000080800000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000008080
      800000000000808080000000800000008000000080000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      000000000000808080006464000064640000DCDC0000DCDC0000DCDC0000DCDC
      0000DCDC000080808000DCDC0000000000000000000000000000000000000000
      00000000000080808000008080000080800000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF008080800000FFFF00000000000000000000000000000000000000
      0000000000008080800000008000000080000000FF000000FF000000FF000000
      FF000000FF00808080000000FF0000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000008080800064640000DCDC0000DCDC0000DCDC0000DCDC0000DCDC
      0000808080000000000080808000000000000000000000000000000000000000
      000000000000808080000080800000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00808080000000000080808000000000000000000000000000000000000000
      00000000000080808000000080000000FF000000FF000000FF000000FF000000
      FF0080808000000000008080800000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000808080000000000080808000E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E1000000000000000000000000000000
      00000000000080808000DCDC0000DCDC0000DCDC0000DCDC0000DCDC00008080
      8000000000000000000000000000808080000000000000000000000000000000
      0000000000008080800000FFFF0000FFFF0000FFFF0000FFFF0000FFFF008080
      8000000000000000000000000000808080000000000000000000000000000000
      000000000000808080000000FF000000FF000000FF000000FF000000FF008080
      800000000000000000000000000080808000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000080808000DCDC0000DCDC0000DCDC0000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008080800000FFFF0000FFFF0000FFFF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000808080000000FF000000FF000000FF00808080000000
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      000000000000000000000000000080808000DCDC000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008080800000FFFF0080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000FF0080808000000000000000
      000000000000000000000000000000000000DFDFDF00DFDFDF00DFDFDF00DFDF
      DF00DFDFDF00DFDFDF00808080000000000080808000E1E1E100E1E1E100E1E1
      E100E1E1E100E1E1E100E1E1E100E1E1E1000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      000000000000000000000000000000000000DFDFDF00DFDFDF00DFDFDF00DFDF
      DF00DFDFDF00DFDFDF00DFDFDF00DFDFDF00DFDFDF00DFDFDF00DFDFDF00DFDF
      DF00DFDFDF00DFDFDF00DFDFDF00DFDFDF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000040204000402
      0400040204008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000084848400000000000000000084848400000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009C9A040014160400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848684000000000000000000000000000000000084868400840284008402
      8400840284000402040084868400848684000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000084848400000000000000000084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000009C9A04009C9A04009C9A0400DCDA04009C9A0400141604000000
      0000000000000000000000000000000000000000000000000000000000008486
      8400848684008486840000000000000000000000000084028400840284008402
      8400840284008402840004020400848684000000000000000000000000000000
      00000000000084848400C6C6C600848484008484840084848400000000000000
      0000000000000000000000000000000000000000000084848400848484000000
      0000848484008484840000000000848484008484840000000000000000008484
      8400848484008484840084848400000000000000000000000000000000009C9A
      04009C9A0400FCFE0400DCDA0400FCFE0400DCDA04009C9A04009C9A04001416
      04000000000000000000000000000000000000000000FC020400040204000402
      0400848684008486840084868400848684008402840084028400840284008402
      840084028400840284000402040084868400000000000000000000000000C6C6
      C60084848400C6C6C600848484000000000084848400C6C6C600848484008484
      8400000000000000000000000000000000000000000000000000000000008484
      8400848484000000000084848400000000008484840000848400008484000000
      00008484840000000000000000000000000000000000000000009C9A0400DCDA
      0400FCFE0400DCDA0400FCFE0400DCDA0400DCDA04009C9A04009C9A04009C9A
      04001416040000000000000000000000000000000000FC020400FC020400FC02
      04000402040084868400848684008486840084028400FC02FC00840284008402
      8400840284008402840084028400000000000000000084848400C6C6C6008484
      8400C6C6C6000000000000000000848484000000000000000000C6C6C6008484
      84008484840084848400000000000000000000000000000000000000FF000000
      0000848484008484840084848400008484000084840000848400008484000084
      84000000000000000000000000000000000000000000000000009C9A0400FCFE
      0400DCDA0400FCFE0400DCDA0400FCFE0400DCDA04009C9A04009C9A04009C9A
      04009C9A040014160400000000000000000000000000FC020400FC020400FC02
      0400FC02040004020400040204008486840084028400FC02FC00FC02FC008402
      8400840284008402840084028400000000000000000084848400848484000000
      00000000000084848400C6C6C600848484008484840084848400000000000000
      00000000000000000000000000000000000000000000848484000000FF000000
      FF000000000084848400848484000084840000FFFF0000848400008484000084
      84000084840084848400848484000000000000000000000000009C9A0400DCDA
      0400FCFE0400FCFE0400DCDA0400DCDA0400DCDA04009C9A04009C9A04009C9A
      04009C9A040014160400000000000000000000000000FC020400FC020400FC02
      0400840204008402040084020400040204000000000084868400FC02FC00FC02
      FC0084028400840284000000000000000000000000000000000000000000C6C6
      C60084848400C6C6C600848484000000000084848400C6C6C600848484008484
      84000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF0000000000000000000084840000FFFF0000FFFF00008484000084
      84000084840000000000000000000000000000000000000000009C9A0400FCFE
      0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA04009C9A04009C9A
      04009C9A040014160400000000000000000000000000FC020400FC0204008402
      0400840204008402040084020400000000000000000000000000840284008402
      8400840284000000000000000000000000008484840084848400C6C6C6008484
      8400C6C6C6000000000000000000C6C6C6000000000000000000C6C6C6008484
      84008484840084848400000000000000000000000000000000000000FF000000
      FF00000084000000840000008400000000000000000000848400008484000000
      00008484840000000000000000000000000000000000000000009C9A0400DCDA
      0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA04009C9A
      04009C9A040014160400000000000000000000000000FC020400FC0204008402
      0400840204000000000000000000848684008486840084868400848684008486
      8400848684008486840000000000000000000000000084848400848484000000
      000000000000C6C6C600FFFF0000C6C6C600C6C6C600C6C6C600000000000000
      00000000000000000000000000000000000000000000848484000000FF000000
      FF00000084008484840000000000848484008484840084848400848484008484
      84000000000084848400848484000000000000000000000000009C9A0400DCDA
      0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA04009C9A
      04009C9A040014160400000000000000000000000000FC020400840204000000
      0000000000000000000004820400044204000442040004420400044204000442
      040004420400848684000000000000000000000000000000000000000000FFFF
      0000C6C6C600FFFF0000C6C6C600FFFF0000C6C6C600FFFF0000C6C6C600C6C6
      C6000000000000000000000000000000000000000000000000000000FF000000
      8400000000000000000084848400FF00000084840000FF000000000000008484
      8400848484000000000000000000000000000000000000000000000000009C9A
      0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA
      04009C9A04009C9A040000000000000000000000000000000000000000000000
      000000000000000000000482040004FE040004FE040004FE040004FE040004FE
      04000442040084868400000000000000000084848400C6C6C600FFFF0000C6C6
      C600FFFF0000C6C6C600FFFF0000C6C6C600FFFF0000C6C6C600FFFF0000C6C6
      C600C6C6C600C6C6C60000000000000000000000000000000000000000008484
      84000000000000000000848484008484000084840000FF000000000000008484
      8400848484000000000000000000000000000000000000000000000000000000
      00009C9A0400DCDA0400DCDA0400DCDA0400DCDA0400DCDA04009C9A04009C9A
      0400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000482040004FE040004FE040004FE040004FE040004FE
      040004420400848684000000000000000000000000008484840084848400FFFF
      0000C6C6C600FFFF0000C6C6C600FFFF0000C6C6C600FFFF0000C6C6C600C6C6
      C600000000000000000000000000000000000000000084848400848484000000
      000084848400848484000000000084848400FF000000FF000000000000008484
      8400000000008484840084848400000000000000000000000000000000000000
      0000000000009C9A0400DCDA0400DCDA04009C9A04009C9A0400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084FE840004FE040004FE040004FE040004FE040004FE
      0400044204008486840000000000000000000000000000000000000000008484
      840084848400C6C6C600FFFF0000C6C6C600C6C6C600C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      84000000000000000000848484008484000084840000FF000000840000000000
      0000848484000000000000000000000000000000000000000000000000000000
      000000000000000000009C9A04009C9A04000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084FE840004FE040004FE040004FE040004FE040004FE
      0400048204000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000084848400000000000000000084848400000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084FE840084FE840084FE840084FE8400048204000482
      0400048204000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFF0000F9FFF9FFF9FF0000
      F0FFF0FFF0FF0000E07FE07FE07F0000C07FC07FC07F00008000800080000000
      00000000000000008020802080200000C000C000C0000000E800E800E8000000
      F800F800F8000000F804F804F8040000F80EF80EF80E0000FC1FFC1FFC1F0000
      FE3FFE3FFE3F0000FF7FFF7FFF7F0000FFFFFFE3FFFFFFFFFFFFFFC1FEFFEDB7
      FF3FF780F83FED87F81FE380E00F8001E00F80008003E507C00780010001C007
      C003800180038001C00380838003C007C00381C70001C197C003860380038001
      C0039C038003CC07E003FC030001EC07F00FFC0380038001F83FFC03E00FEC17
      FCFFFC07F83FEDB7FFFFFC07FEFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object pm_Props: TPopupMenu
    Left = 8
    Top = 64
    object mi_CopyToClipboard: TMenuItem
      Caption = 'Copy to clipboard'
    end
    object mi_InsertText: TMenuItem
      Caption = 'Insert text'
      Visible = False
    end
    object mi_OpenLocation: TMenuItem
      Caption = 'Open source code'
      OnClick = mi_OpenLocationClick
    end
  end
end
