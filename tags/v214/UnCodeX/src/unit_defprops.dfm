object frm_DefPropsBrowser: Tfrm_DefPropsBrowser
  Left = 299
  Top = 153
  Width = 629
  Height = 455
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lv_Props: TListView
    Left = 0
    Top = 0
    Width = 621
    Height = 428
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'Variable'
      end
      item
        AutoSize = True
        Caption = 'Value'
      end
      item
        AutoSize = True
        Caption = 'Class'
      end>
    IconOptions.WrapText = False
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
  end
end
