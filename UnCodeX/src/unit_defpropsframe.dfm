object fr_DefPropsBrowser: Tfr_DefPropsBrowser
  Left = 0
  Top = 0
  Width = 597
  Height = 322
  Constraints.MinHeight = 100
  Constraints.MinWidth = 250
  TabOrder = 0
  object spl_Main: TSplitter
    Left = 193
    Top = 0
    Width = 4
    Height = 322
    Cursor = crHSplit
    AutoSnap = False
    OnMoved = spl_MainMoved
  end
  object gb_Property: TGroupBox
    Left = 197
    Top = 0
    Width = 400
    Height = 322
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      400
      322)
    object lbl_EffValue: TLabel
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
    object lbl_DefinedIn: TLabel
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
    object lbl_Type: TLabel
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
      Width = 396
      Height = 184
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
      OnDblClick = lv_SelPropertyDblClick
    end
    object ed_EffValue: TEdit
      Left = 8
      Top = 112
      Width = 382
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
      Width = 382
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
      Width = 382
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
  object tv_Properties: TTreeView
    Left = 0
    Top = 0
    Width = 193
    Height = 322
    Align = alLeft
    HideSelection = False
    Indent = 19
    ParentShowHint = False
    PopupMenu = mi_defprop
    ReadOnly = True
    RightClickSelect = True
    RowSelect = True
    ShowButtons = False
    ShowHint = True
    ShowLines = False
    SortType = stText
    TabOrder = 1
    OnAdvancedCustomDrawItem = tv_PropertiesAdvancedCustomDrawItem
    OnChange = tv_PropertiesChange
    OnChanging = tv_PropertiesChanging
    OnKeyDown = tv_PropertiesKeyDown
  end
  object mi_defprop: TPopupMenu
    Left = 8
    Top = 8
    object mi_Findavariable1: TMenuItem
      Caption = 'Find a variable'
      OnClick = mi_Findavariable1Click
    end
  end
end
