object frm_GraphViz: Tfrm_GraphViz
  Left = 398
  Top = 227
  BorderStyle = bsDialog
  Caption = 'GraphViz - version'
  ClientHeight = 273
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 304
    Top = 24
    Width = 38
    Height = 13
    Caption = 'Include:'
  end
  object Label3: TLabel
    Left = 304
    Top = 80
    Width = 30
    Height = 13
    Caption = 'Show:'
  end
  object btn_Create: TBitBtn
    Left = 304
    Top = 248
    Width = 113
    Height = 25
    Caption = 'Create'
    TabOrder = 0
    OnClick = btn_CreateClick
  end
  object cb_Vars: TCheckBox
    Left = 304
    Top = 40
    Width = 65
    Height = 17
    Caption = 'Variables'
    TabOrder = 1
  end
  object cb_Funcs: TCheckBox
    Left = 304
    Top = 56
    Width = 65
    Height = 17
    Caption = 'Functions'
    TabOrder = 2
  end
  object cb_PackageBorder: TCheckBox
    Left = 304
    Top = 112
    Width = 97
    Height = 17
    Caption = 'Package border'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object cb_Legenda: TCheckBox
    Left = 304
    Top = 128
    Width = 97
    Height = 17
    Caption = 'Legenda'
    Enabled = False
    TabOrder = 4
    Visible = False
  end
  object pc_Config: TPageControl
    Left = 0
    Top = 0
    Width = 297
    Height = 273
    ActivePage = ts_Packages
    TabIndex = 0
    TabOrder = 5
    object ts_Packages: TTabSheet
      Caption = 'Include Packages'
      object lv_Packages: TListView
        Left = 0
        Top = 0
        Width = 289
        Height = 217
        Align = alTop
        Checkboxes = True
        Columns = <
          item
            Caption = 'Name'
            Width = 165
          end
          item
            Caption = 'Color'
            Width = 100
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        SmallImages = il_Tags
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnAdvancedCustomDrawSubItem = lv_PackagesAdvancedCustomDrawSubItem
        OnDblClick = lv_PackagesDblClick
      end
      object cb_Color: TComboBox
        Left = 168
        Top = 24
        Width = 97
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        Visible = False
        OnChange = cb_ColorChange
        OnExit = cb_ColorExit
        Items.Strings = (
          'antiquewhite1'
          'antiquewhite2'
          'antiquewhite3'
          'antiquewhite4'
          'azure1'
          'azure2'
          'azure3'
          'azure4'
          'bisque1'
          'bisque2'
          'bisque3'
          'bisque4'
          'blanchedalmond'
          'cornsilk1'
          'cornsilk2'
          'cornsilk3'
          'cornsilk4'
          'floralwhite'
          'gainsboro'
          'ghostwhite'
          'honeydew1'
          'honeydew2'
          'honeydew3'
          'honeydew4'
          'ivory1'
          'ivory2'
          'ivory3'
          'ivory4'
          'lavender'
          'lavenderblush1'
          'lavenderblush2'
          'lavenderblush3'
          'lavenderblush4'
          'lemonchiffon1'
          'lemonchiffon2'
          'lemonchiffon3'
          'lemonchiffon4'
          'linen'
          'mintcream'
          'mistyrose1'
          'mistyrose2'
          'mistyrose3'
          'mistyrose4'
          'moccasin'
          'navajowhite1'
          'navajowhite2'
          'navajowhite3'
          'navajowhite4'
          'oldlace'
          'papayawhip'
          'peachpuff1'
          'peachpuff2'
          'peachpuff3'
          'peachpuff4'
          'seashell1'
          'seashell2'
          'seashell3'
          'seashell4'
          'snow1'
          'snow2'
          'snow3'
          'snow4'
          'thistle1'
          'thistle2'
          'thistle3'
          'thistle4'
          'wheat1'
          'wheat2'
          'wheat3'
          'wheat4'
          'white'
          'whitesmoke'
          ''
          'darkslategray1'
          'darkslategray2'
          'darkslategray3'
          'darkslategray4'
          'dimgray'
          'gray'
          'lightgray'
          'lightslategray'
          'slategray1'
          'slategray2'
          'slategray3'
          'slategray4'
          ''
          'black'
          ''
          'coral1'
          'coral2'
          'coral3'
          'coral4'
          'crimson'
          'darksalmon'
          'deeppink1'
          'deeppink2'
          'deeppink3'
          'deeppink4'
          'firebrick1'
          'firebrick2'
          'firebrick3'
          'firebrick4'
          'hotpink1'
          'hotpink2'
          'hotpink3'
          'hotpink4'
          'indianred1'
          'indianred2'
          'indianred3'
          'indianred4'
          'lightpink1'
          'lightpink2'
          'lightpink3'
          'lightpink4'
          'lightsalmon1'
          'lightsalmon2'
          'lightsalmon3'
          'lightsalmon4'
          'maroon1'
          'maroon2'
          'maroon3'
          'maroon4'
          'mediumvioletred'
          'orangered1'
          'orangered2'
          'orangered3'
          'orangered4'
          'palevioletred1'
          'palevioletred2'
          'palevioletred3'
          'palevioletred4'
          'pink1'
          'pink2'
          'pink3'
          'pink4'
          'red1'
          'red2'
          'red3'
          'red4'
          'salmon1'
          'salmon2'
          'salmon3'
          'salmon4'
          'tomato1'
          'tomato2'
          'tomato3'
          'tomato4'
          'violetred1'
          'violetred2'
          'violetred3'
          'violetred4'
          ''
          'beige'
          'brown1'
          'brown2'
          'brown3'
          'brown4'
          'burlywood1'
          'burlywood2'
          'burlywood3'
          'burlywood4'
          'chocolate1'
          'chocolate2'
          'chocolate3'
          'chocolate4'
          'darkkhaki'
          'khaki1'
          'khaki2'
          'khaki3'
          'khaki4'
          'peru'
          'rosybrown1'
          'rosybrown2'
          'rosybrown3'
          'rosybrown4'
          'saddlebrown'
          'sandybrown'
          'sienna1'
          'sienna2'
          'sienna3'
          'sienna4'
          'tan1'
          'tan2'
          'tan3'
          'tan4'
          ''
          'darkorange1'
          'darkorange2'
          'darkorange3'
          'darkorange4'
          'orange1'
          'orange2'
          'orange3'
          'orange4'
          'orangered1'
          'orangered2'
          'orangered3'
          'orangered4'
          ''
          'darkgoldenrod1'
          'darkgoldenrod2'
          'darkgoldenrod3'
          'darkgoldenrod4'
          'gold1'
          'gold2'
          'gold3'
          'gold4'
          'goldenrod1'
          'goldenrod2'
          'goldenrod3'
          'goldenrod4'
          'greenyellow'
          'lightgoldenrod1'
          'lightgoldenrod2'
          'lightgoldenrod3'
          'lightgoldenrod4'
          'lightgoldenrodyellow'
          'lightyellow1'
          'lightyellow2'
          'lightyellow3'
          'lightyellow4'
          'palegoldenrod'
          'yellow1'
          'yellow2'
          'yellow3'
          'yellow4'
          'yellowgreen'
          ''
          'chartreuse1'
          'chartreuse2'
          'chartreuse3'
          'chartreuse4'
          'darkgreen'
          'darkolivegreen1'
          'darkolivegreen2'
          'darkolivegreen3'
          'darkolivegreen4'
          'darkseagreen1'
          'darkseagreen2'
          'darkseagreen3'
          'darkseagreen4'
          'forestgreen'
          'green1'
          'green2'
          'green3'
          'green4'
          'greenyellow'
          'lawngreen'
          'lightseagreen'
          'limegreen'
          'mediumseagreen'
          'mediumspringgreen'
          'mintcream'
          'olivedrab1'
          'olivedrab2'
          'olivedrab3'
          'olivedrab4'
          'palegreen1'
          'palegreen2'
          'palegreen3'
          'palegreen4'
          'seagreen1'
          'seagreen2'
          'seagreen3'
          'seagreen4'
          'springgreen1'
          'springgreen2'
          'springgreen3'
          'springgreen4'
          'yellowgreen'
          ''
          'aquamarine1'
          'aquamarine2'
          'aquamarine3'
          'aquamarine4'
          'cyan1'
          'cyan2'
          'cyan3'
          'cyan4'
          'darkturquoise'
          'lightcyan1'
          'lightcyan2'
          'lightcyan3'
          'lightcyan4'
          'mediumaquamarine'
          'mediumturquoise'
          'paleturquoise1'
          'paleturquoise2'
          'paleturquoise3'
          'paleturquoise4'
          'turquoise1'
          'turquoise2'
          'turquoise3'
          'turquoise4'
          ''
          'aliceblue'
          'blue1'
          'blue2'
          'blue3'
          'blue4'
          'blueviolet'
          'cadetblue1'
          'cadetblue2'
          'cadetblue3'
          'cadetblue4'
          'cornflowerblue'
          'darkslateblue'
          'deepskyblue1'
          'deepskyblue2'
          'deepskyblue3'
          'deepskyblue4'
          'dodgerblue1'
          'dodgerblue2'
          'dodgerblue3'
          'dodgerblue4'
          'indigo'
          'lightblue1'
          'lightblue2'
          'lightblue3'
          'lightblue4'
          'lightskyblue1'
          'lightskyblue2'
          'lightskyblue3'
          'lightskyblue4'
          'lightslateblue1'
          'lightslateblue2'
          'lightslateblue3'
          'lightslateblue4'
          'mediumblue'
          'mediumslateblue'
          'midnightblue'
          'navy'
          'navyblue'
          'powderblue'
          'royalblue1'
          'royalblue2'
          'royalblue3'
          'royalblue4'
          'skyblue1'
          'skyblue2'
          'skyblue3'
          'skyblue4'
          'slateblue1'
          'slateblue2'
          'slateblue3'
          'slateblue4'
          'steelblue1'
          'steelblue2'
          'steelblue3'
          'steelblue4'
          ''
          'blueviolet'
          'darkorchid1'
          'darkorchid2'
          'darkorchid3'
          'darkorchid4'
          'darkviolet'
          'magenta1'
          'magenta2'
          'magenta3'
          'magenta4'
          'mediumorchid1'
          'mediumorchid2'
          'mediumorchid3'
          'mediumorchid4'
          'mediumpurple1'
          'mediumpurple2'
          'mediumpurple3'
          'mediumpurple4'
          'mediumvioletred'
          'orchid1'
          'orchid2'
          'orchid3'
          'orchid4'
          'palevioletred1'
          'palevioletred2'
          'palevioletred3'
          'palevioletred4'
          'plum1'
          'plum2'
          'plum3'
          'plum4'
          'purple1'
          'purple2'
          'purple3'
          'purple4'
          'violet'
          'violetred1'
          'violetred2'
          'violetred3'
          'violetred4')
      end
      object btn_Colorize: TBitBtn
        Left = 214
        Top = 220
        Width = 75
        Height = 25
        Caption = 'Colorize'
        TabOrder = 2
        OnClick = btn_ColorizeClick
      end
      object btn_Deselect: TBitBtn
        Left = 0
        Top = 220
        Width = 75
        Height = 25
        Caption = 'Deselect all'
        TabOrder = 3
        OnClick = btn_DeselectClick
      end
      object cl_Color: TColorBox
        Left = 168
        Top = 48
        Width = 97
        Height = 22
        NoneColorColor = clNone
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 4
        Visible = False
        OnChange = cl_ColorChange
        OnExit = cb_ColorExit
      end
      object btn_SelectAll: TBitBtn
        Left = 80
        Top = 220
        Width = 75
        Height = 25
        Caption = 'Select all'
        TabOrder = 5
        OnClick = btn_SelectAllClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Global settings'
      ImageIndex = 1
      object mm_Settings: TMemo
        Left = 0
        Top = 0
        Width = 289
        Height = 245
        Align = alClient
        Lines.Strings = (
          'node [shape=box, style=filled];'
          'edge [dir=back];')
        TabOrder = 0
      end
    end
  end
  object cb_OnlyPackages: TCheckBox
    Left = 304
    Top = 96
    Width = 97
    Height = 17
    Caption = 'Only packages'
    TabOrder = 6
  end
  object sd_Save: TSaveDialog
    DefaultExt = '.dot'
    Filter = 'DOT files|*.dot|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 352
    Top = 168
  end
  object il_Tags: TImageList
    Left = 320
    Top = 168
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848684000402040084868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848684000402040084868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848684000402040004020400C4C6C40004020400040204008486
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000848684000402040004020400C4C6C40004020400040204008486
      84000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000008486
      8400040204000402040004FEFC0004FEFC00FCFEFC0004FEFC000402FC000402
      0400040204008486840000000000000000000000000000000000000000008486
      84000402040004020400FCFE0400FCFE0400FCFEFC00FCFE0400FC0204000402
      04000402040084868400000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00000000000000FF000000
      FF000000FF000000FF000000FF000000FF0000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000084868400040204000402
      040004FEFC00FC02040004FEFC0004FEFC00C4C6C4000402FC0004FEFC00FC02
      040004FEFC000402040004020400848684000000000084868400040204000402
      0400FCFE04000402FC00FCFE0400FCFE0400C4C6C400FC020400FCFE04000402
      FC00FCFE040004020400040204008486840000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00000000000000FF000000
      FF000000FF000000FF000000FF000000FF00000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000402040004FEFC0004FE
      FC0004FEFC00FC02040004FEFC0004FEFC00FCFEFC0004FEFC000402FC00FC02
      04000402FC0004FEFC000402FC00040204000000000004020400FCFE0400FCFE
      0400FCFE04000402FC00FCFE0400FCFE0400FCFEFC00FCFE0400FC0204000402
      FC00FC020400FCFE0400FC0204000402040000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000402040004FEFC0004FE
      FC0004FEFC00FC02040004FEFC0004FEFC00C4C6C4000402FC0004FEFC00FC02
      040004FEFC000402FC0004FEFC00040204000000000004020400FCFE0400FCFE
      0400FCFE04000402FC00FCFE0400FCFE0400C4C6C400FC020400FCFE04000402
      FC00FCFE0400FC020400FCFE04000402040000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00000000000000000000000000000000000402040004FEFC0004FE
      FC0004FEFC00FC02040004FEFC0004FEFC00FCFEFC0004FEFC000402FC00FC02
      04000402FC0004FEFC000402FC00040204000000000004020400FCFE0400FCFE
      0400FCFE04000402FC00FCFE0400FCFE0400FCFEFC00FCFE0400FC0204000402
      FC00FC020400FCFE0400FC0204000402040000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000000000FFFF0000FFFF0000FFFF00000000000000000000FFFF000000
      000000FFFF0000FFFF000000000000000000000000000402040004FEFC0004FE
      FC0004FEFC00FC02040004FEFC0004FEFC00C4C6C4000402FC0004FEFC00FC02
      040004FEFC000402FC0004FEFC00040204000000000004020400FCFE0400FCFE
      0400FCFE04000402FC00FCFE0400FCFE0400C4C6C400FC020400FCFE04000402
      FC00FCFE0400FC020400FCFE04000402040000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF00000000000000000000000000000000000402040004FEFC0004FE
      FC0004FEFC00FC0204008486840084868400FCFEFC008486840084868400FC02
      04000402FC0004FEFC000402FC00040204000000000004020400FCFE0400FCFE
      0400FCFE04000402FC008486840084868400FCFEFC0084868400848684000402
      FC00FC020400FCFE0400FC0204000402040000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000C0C0C000000000000000000000000000000000000402040004FEFC0004FE
      FC0084868400FC02040004FEFC00FCFEFC0004FEFC00FCFEFC0004FEFC00FC02
      0400848684000402FC0004FEFC00040204000000000004020400FCFE0400FCFE
      0400848684000402FC00FCFE0400FCFEFC00FCFE0400FCFEFC00FCFE04000402
      FC0084868400FC020400FCFE040004020400000000000000000000000000C0C0
      C000800000008000000080000000800000008000000080000000C0C0C000FFFF
      FF00C0C0C000800000008000000080000000800000008000000080000000C0C0
      C000FFFFFF00C0C0C00080000000800000008000000080000000800000008000
      0000C0C0C0000000000000000000000000000000000004020400848684008486
      8400FCFEFC0004FEFC00FC02040004FEFC00FCFEFC0004FEFC00FC02040004FE
      FC00FCFEFC008486840084868400040204000000000004020400848684008486
      8400FCFEFC00FCFE04000402FC00FCFE0400FCFEFC00FCFE04000402FC00FCFE
      0400FCFEFC00848684008486840004020400000000000000000000000000C0C0
      C000800000008000000080000000800000008000000080000000C0C0C000FFFF
      FF00C0C0C000800000008000000080000000800000008000000080000000C0C0
      C000FFFFFF00C0C0C00080000000800000008000000080000000800000008000
      0000C0C0C000000000000000000000000000000000000402040004FEFC00FCFE
      FC0004FEFC00FCFEFC0004FEFC00FC020400FC020400FC02040004FEFC00FCFE
      FC0004FEFC00FCFEFC0004FEFC00040204000000000004020400FCFE0400FCFE
      FC00FCFE0400FCFEFC00FCFE04000402FC000402FC000402FC00FCFE0400FCFE
      FC00FCFE0400FCFEFC00FCFE040004020400000000000000000000000000C0C0
      C000800000008000000080000000800000008000000080000000C0C0C000FFFF
      FF00C0C0C000800000008000000080000000800000008000000080000000C0C0
      C000FFFFFF00C0C0C00080000000800000008000000080000000800000008000
      0000C0C0C0000000000000000000000000000000000084868400040204000402
      0400FCFEFC0004FEFC00FC020400FCFEFC0004FEFC00FCFEFC00FC02040004FE
      FC00FCFEFC000402040004020400848684000000000084868400040204000402
      0400FCFEFC00FCFE04000402FC00FCFEFC00FCFE0400FCFEFC000402FC00FCFE
      0400FCFEFC00040204000402040084868400000000000000000000000000C0C0
      C000800000008000000080000000800000008000000080000000C0C0C000C0C0
      C00080000000800000008000000080000000800000008000000080000000C0C0
      C000C0C0C0008000000080000000800000008000000080000000800000008000
      0000C0C0C0000000000000000000000000000000000000000000000000008486
      84000402040004020400FCFEFC0004FEFC00FCFEFC0004FEFC00FCFEFC000402
      0400040204008486840000000000000000000000000000000000000000008486
      84000402040004020400FCFEFC00FCFE0400FCFEFC00FCFE0400FCFEFC000402
      040004020400848684000000000000000000000000000000000000000000C0C0
      C000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      00000000000084868400040204000402040004FEFC0004020400040204008486
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000848684000402040004020400FCFE040004020400040204008486
      840000000000000000000000000000000000000000000000000000000000C0C0
      C000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848684000402040084868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848684000402040084868400000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000800000008000000080000000800000008000000080000000C0C0C000C0C0
      C000C0C0C0008000000080000000800000008000000080000000C0C0C000C0C0
      C000C0C0C0008000000080000000800000008000000080000000C0C0C0000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FE3FFE3F04020400F80FF80F04020400
      E003E0038486840080008000D1CFCF0080008000D1CFCF0080008000D1CFCF00
      80008000D1CFCF0080008000D1CFCF0080008000848684008000800084868400
      80008000D1CFCF0080008000D1CFCF0080008000D1CFCF00E003E0030000FF00
      F80FF80F20000000FE3FFE3F00000000}
  end
end
