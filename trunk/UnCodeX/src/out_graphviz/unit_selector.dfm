object frm_GraphViz: Tfrm_GraphViz
  Left = 398
  Top = 227
  ActiveControl = lb_Packages
  BorderStyle = bsDialog
  Caption = 'GraphViz - version 007 beta'
  ClientHeight = 287
  ClientWidth = 307
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 88
    Height = 13
    Caption = 'Include packages:'
  end
  object Label2: TLabel
    Left = 184
    Top = 24
    Width = 38
    Height = 13
    Caption = 'Include:'
  end
  object Label3: TLabel
    Left = 184
    Top = 80
    Width = 30
    Height = 13
    Caption = 'Show:'
  end
  object lb_Packages: TListBox
    Left = 8
    Top = 24
    Width = 169
    Height = 225
    ItemHeight = 13
    MultiSelect = True
    Sorted = True
    TabOrder = 0
  end
  object cb_Vars: TCheckBox
    Left = 184
    Top = 40
    Width = 65
    Height = 17
    Caption = 'Variables'
    Enabled = False
    TabOrder = 1
  end
  object cb_Funcs: TCheckBox
    Left = 184
    Top = 56
    Width = 113
    Height = 17
    Caption = 'Function arguments'
    Enabled = False
    TabOrder = 2
  end
  object cb_Own: TCheckBox
    Left = 184
    Top = 96
    Width = 81
    Height = 17
    Caption = 'Own classes'
    Enabled = False
    TabOrder = 3
  end
  object cb_Other: TCheckBox
    Left = 184
    Top = 112
    Width = 113
    Height = 17
    Caption = 'Depended classes'
    Enabled = False
    TabOrder = 4
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Create'
    TabOrder = 5
    OnClick = BitBtn1Click
  end
  object sd_Save: TSaveDialog
    DefaultExt = '.dot'
    Filter = 'DOT files|*.dot|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 16
    Top = 32
  end
end
