object frm_Run: Tfrm_Run
  Left = 283
  Top = 131
  Width = 583
  Height = 509
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Run'
  Color = clBtnFace
  Constraints.MinHeight = 482
  Constraints.MinWidth = 575
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    575
    482)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Exe: TLabel
    Left = 8
    Top = 8
    Width = 64
    Height = 13
    Caption = 'Executable'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_Args: TLabel
    Left = 8
    Top = 48
    Width = 60
    Height = 13
    Caption = 'Arguments'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_Presets: TLabel
    Left = 8
    Top = 458
    Width = 43
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Presets'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pc_Args: TPageControl
    Left = 0
    Top = 93
    Width = 575
    Height = 356
    ActivePage = ts_URL
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Style = tsFlatButtons
    TabIndex = 2
    TabOrder = 0
    object ts_Commandline: TTabSheet
      Caption = 'Commandline'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      DesignSize = (
        567
        325)
      object lbl_Format: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 13
        Caption = 'Commandline format'
      end
      object lbl_FormatExe: TLabel
        Left = 0
        Top = 20
        Width = 33
        Height = 13
        Caption = '%exe%'
      end
      object bvl_sep1: TBevel
        Left = 0
        Top = 88
        Width = 565
        Height = 9
        Shape = bsBottomLine
      end
      object lbl_GTOptName: TLabel
        Left = 0
        Top = 152
        Width = 109
        Height = 13
        Caption = 'Gametype option name'
      end
      object lbl_MutOptname: TLabel
        Left = 0
        Top = 200
        Width = 97
        Height = 13
        Caption = 'Mutator option name'
      end
      object Label1: TLabel
        Left = 0
        Top = 104
        Width = 43
        Height = 13
        Caption = 'Map filter'
      end
      object Label2: TLabel
        Left = 0
        Top = 48
        Width = 71
        Height = 13
        Caption = 'Process priority'
      end
      object ed_Format: TEdit
        Left = 40
        Top = 16
        Width = 525
        Height = 21
        Hint = 'The commandline format to use'
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = '%url% %switch%'
        OnChange = ed_MapChange
      end
      object ed_GameTypeOptionName: TEdit
        Left = 0
        Top = 168
        Width = 193
        Height = 21
        Hint = 'The name of the Game type option on the url'
        TabOrder = 1
        Text = 'Game'
        OnChange = ed_MapChange
      end
      object ed_MutOptName: TEdit
        Left = 0
        Top = 216
        Width = 193
        Height = 21
        Hint = 'The name of the mutator option in the url'
        TabOrder = 2
        Text = 'Mutator'
        OnChange = ed_MapChange
      end
      object cb_MutCSL: TCheckBox
        Left = 0
        Top = 240
        Width = 193
        Height = 17
        Hint = 'Use a comma seperated list for the mutator list'
        Caption = 'Comma seperated list'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = ed_MapChange
      end
      object ed_Mapfilter: TEdit
        Left = 0
        Top = 120
        Width = 193
        Height = 21
        Hint = 'File mask to use for maps'
        TabOrder = 4
        Text = '*.unr;*.ut2'
      end
      object cb_Priority: TComboBox
        Left = 0
        Top = 64
        Width = 564
        Height = 21
        Hint = 'The priority on witch the process will run'
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 5
        Text = 'Normal'
        Items.Strings = (
          'Low'
          'Normal'
          'High'
          'Real time')
      end
    end
    object ts_Switches: TTabSheet
      Caption = 'Switches'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      DesignSize = (
        567
        325)
      object lbl_MainSwitch: TLabel
        Left = 0
        Top = 0
        Width = 83
        Height = 13
        Caption = 'Main Switches'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl_AdditionalSwitches: TLabel
        Left = 192
        Top = 224
        Width = 110
        Height = 13
        Caption = 'Additional switches'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl_ConfigurationSwitches: TLabel
        Left = 192
        Top = 0
        Width = 76
        Height = 13
        Caption = 'Configuration'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl_ServerSwitches: TLabel
        Left = 192
        Top = 88
        Width = 38
        Height = 13
        Caption = 'Server'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl_MiscSwitches: TLabel
        Left = 192
        Top = 152
        Width = 78
        Height = 13
        Caption = 'Miscelaneous'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object clb_MainSwitches: TCheckListBox
        Left = 0
        Top = 16
        Width = 185
        Height = 309
        Hint = 'Optional switches'
        OnClickCheck = ed_MapChange
        Anchors = [akLeft, akTop, akBottom]
        Ctl3D = True
        ItemHeight = 13
        Items.Strings = (
          'alladmin'
          'changevideo'
          'compressdxt'
          'conflicts'
          'defaultres'
          'firstrun'
          'hardwaremultitexture'
          'lanplay'
          'lazy'
          'log'
          'makenames'
          'memstat'
          'newwindow'
          'no3dsound'
          'nobind'
          'noconform'
          'noddraw'
          'nodetect'
          'nodeviceid'
          'nodsound'
          'nogc'
          'nohard'
          'nojoy'
          'nok6'
          'nokni'
          'noloadwarn'
          'nommx'
          'nomultitexture'
          'norunaway'
          'nosound'
          'nosplash'
          'primarynet'
          'profile'
          'profilestats'
          'reallysilent'
          'safe'
          'server'
          'silent'
          'windowed')
        ParentColor = True
        ParentCtl3D = False
        Sorted = True
        TabOrder = 0
      end
      object cb_INI: TCheckBox
        Left = 192
        Top = 18
        Width = 97
        Height = 17
        Hint = 'System configuration'
        Caption = 'INI='
        TabOrder = 1
        OnClick = ed_MapChange
      end
      object ed_INI: TEdit
        Left = 296
        Top = 16
        Width = 201
        Height = 21
        Hint = 'System configuration'
        TabOrder = 2
        OnChange = ed_MapChange
      end
      object mm_AddSwitches: TMemo
        Left = 192
        Top = 240
        Width = 374
        Height = 84
        Hint = 'Additional switches'
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssVertical
        TabOrder = 3
        WantReturns = False
        OnChange = ed_MapChange
      end
      object cb_USERINI: TCheckBox
        Left = 192
        Top = 66
        Width = 97
        Height = 17
        Hint = 'The user configuration file'
        Caption = 'USERINI='
        TabOrder = 4
        OnClick = ed_MapChange
      end
      object ed_USERINI: TEdit
        Left = 296
        Top = 64
        Width = 201
        Height = 21
        Hint = 'The user configuration file'
        TabOrder = 5
        OnChange = ed_MapChange
      end
      object cb_LOG: TCheckBox
        Left = 192
        Top = 170
        Width = 97
        Height = 17
        Hint = 'The log file to use'
        Caption = 'LOG='
        TabOrder = 6
        OnClick = ed_MapChange
      end
      object ed_LOG: TEdit
        Left = 296
        Top = 168
        Width = 201
        Height = 21
        Hint = 'The log file to use'
        TabOrder = 7
        OnChange = ed_MapChange
      end
      object cb_MultiHome: TCheckBox
        Left = 192
        Top = 106
        Width = 97
        Height = 17
        Hint = 'IP address to use for a multihome system'
        Caption = 'MULTIHOME='
        TabOrder = 8
        OnClick = ed_MapChange
      end
      object ed_MULTIHOME: TEdit
        Left = 296
        Top = 104
        Width = 225
        Height = 21
        Hint = 'IP address to use for a multihome system'
        TabOrder = 9
        OnChange = ed_MapChange
      end
      object cb_READINI: TCheckBox
        Left = 192
        Top = 42
        Width = 97
        Height = 17
        Hint = 'Read from this ini file, but do not save to it'
        Caption = 'READINI='
        TabOrder = 10
        OnClick = ed_MapChange
      end
      object ed_READINI: TEdit
        Left = 296
        Top = 40
        Width = 201
        Height = 21
        Hint = 'Read from this ini file, but do not save to it'
        TabOrder = 11
        OnChange = ed_MapChange
      end
      object cb_MOD: TCheckBox
        Left = 192
        Top = 194
        Width = 97
        Height = 17
        Hint = 'UT2004 Mod Architecture'
        Caption = 'MOD='
        TabOrder = 12
        OnClick = ed_MapChange
      end
      object ed_MOD: TEdit
        Left = 296
        Top = 192
        Width = 225
        Height = 21
        Hint = 'UT2004 Mod Architecture'
        TabOrder = 13
        OnChange = ed_MapChange
      end
      object cb_PORT: TCheckBox
        Left = 192
        Top = 130
        Width = 97
        Height = 17
        Hint = 'The port to listen on'
        Caption = 'PORT='
        TabOrder = 14
        OnClick = ed_MapChange
      end
      object ed_PORT: TEdit
        Left = 296
        Top = 128
        Width = 225
        Height = 21
        Hint = 'The port to listen on'
        TabOrder = 15
        OnChange = ed_MapChange
      end
      object btn_INI: TBitBtn
        Left = 496
        Top = 16
        Width = 25
        Height = 21
        Caption = '...'
        TabOrder = 16
        OnClick = btn_INIClick
      end
      object btn_READINI: TBitBtn
        Left = 496
        Top = 40
        Width = 25
        Height = 21
        Caption = '...'
        TabOrder = 17
        OnClick = btn_READINIClick
      end
      object btn_USERINI: TBitBtn
        Left = 496
        Top = 64
        Width = 25
        Height = 21
        Caption = '...'
        TabOrder = 18
        OnClick = btn_USERINIClick
      end
      object btn_LOG: TBitBtn
        Left = 496
        Top = 168
        Width = 25
        Height = 21
        Caption = '...'
        TabOrder = 19
        OnClick = btn_LOGClick
      end
    end
    object ts_URL: TTabSheet
      Caption = 'URL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      DesignSize = (
        567
        325)
      object lbl_Gametype: TLabel
        Left = 0
        Top = 60
        Width = 48
        Height = 13
        Caption = 'Gametype'
      end
      object lbl_AddOptions: TLabel
        Left = 0
        Top = 120
        Width = 102
        Height = 13
        Caption = 'Additional options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cb_Gametype: TComboBox
        Left = 96
        Top = 56
        Width = 193
        Height = 21
        Hint = 'Selected gametype'
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnChange = ed_MapChange
      end
      object ed_Map: TEdit
        Left = 96
        Top = 0
        Width = 169
        Height = 21
        Hint = 'Map file'
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
        OnChange = ed_MapChange
      end
      object ed_Loc: TEdit
        Left = 96
        Top = 24
        Width = 193
        Height = 21
        Hint = 'Location, this can be a internet address or file'
        TabOrder = 2
        OnChange = ed_MapChange
      end
      object btn_Map: TBitBtn
        Left = 264
        Top = 0
        Width = 25
        Height = 21
        Caption = '...'
        TabOrder = 3
        OnClick = btn_MapClick
      end
      object rb_Map: TRadioButton
        Left = 0
        Top = 2
        Width = 89
        Height = 17
        Caption = 'Map'
        Checked = True
        TabOrder = 4
        TabStop = True
        OnClick = ed_MapChange
      end
      object rb_Location: TRadioButton
        Left = 0
        Top = 26
        Width = 89
        Height = 17
        Caption = 'Location'
        TabOrder = 5
        OnClick = ed_MapChange
      end
      object gb_Mutators: TGroupBox
        Left = 0
        Top = 191
        Width = 567
        Height = 134
        Align = alBottom
        Caption = 'Mutators'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        DesignSize = (
          567
          134)
        object lbl_AvailMut: TLabel
          Left = 8
          Top = 16
          Width = 43
          Height = 13
          Caption = 'Available'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lbl_SelectedMut: TLabel
          Left = 304
          Top = 16
          Width = 42
          Height = 13
          Caption = 'Selected'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lb_AvailMut: TListBox
          Left = 8
          Top = 32
          Width = 257
          Height = 97
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          Sorted = True
          TabOrder = 0
          OnDblClick = btn_AddMutClick
        end
        object lb_SelMut: TListBox
          Left = 304
          Top = 32
          Width = 257
          Height = 97
          Hint = 'Selected mutators'
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          Sorted = True
          TabOrder = 1
          OnDblClick = btn_DelMutClick
        end
        object btn_AddMut: TBitBtn
          Left = 272
          Top = 40
          Width = 25
          Height = 25
          Hint = 'Add the selected mutator'
          Caption = '4'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Marlett'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btn_AddMutClick
        end
        object btn_DelMut: TBitBtn
          Left = 272
          Top = 64
          Width = 25
          Height = 25
          Hint = 'Remove the selected mutator'
          Caption = '3'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Marlett'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btn_DelMutClick
        end
        object btn_MutPlus: TBitBtn
          Left = 272
          Top = 96
          Width = 25
          Height = 25
          Hint = 'Add a mutator by hand'
          Caption = '+'
          TabOrder = 4
          OnClick = btn_MutPlusClick
        end
      end
      object mm_AddOptions: TMemo
        Left = 0
        Top = 136
        Width = 561
        Height = 49
        Hint = 'Additional options, start with a ?'
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssVertical
        TabOrder = 7
        WantReturns = False
        OnChange = ed_MapChange
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Replacements'
      ImageIndex = 3
      object mm_Replacements: TMemo
        Left = 0
        Top = 0
        Width = 567
        Height = 325
        Cursor = crArrow
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            'The following replacement variables are accepted in any of the a' +
            'rguments:'
          '%url%'#9#9'the information from the URL tab'
          '%swith%'#9#9'the information from the Switched tab'
          '%rand%'#9#9'a random number'
          
            '%inc%'#9#9'this number is increased on every run, and reset when the' +
            ' application is restarted')
        ParentColor = True
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        WantTabs = True
      end
    end
  end
  object ed_Exe: TEdit
    Left = 8
    Top = 24
    Width = 537
    Height = 21
    Hint = 'The system executable'
    Anchors = [akLeft, akTop, akRight]
    ParentColor = True
    ReadOnly = True
    TabOrder = 1
    OnChange = ed_ExeChange
  end
  object ed_Args: TEdit
    Left = 8
    Top = 64
    Width = 561
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ParentColor = True
    ReadOnly = True
    TabOrder = 2
  end
  object btn_Exe: TBitBtn
    Left = 544
    Top = 24
    Width = 25
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 3
    OnClick = btn_ExeClick
  end
  object btn_ok: TBitBtn
    Left = 496
    Top = 452
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Enabled = False
    TabOrder = 4
    OnClick = btn_okClick
    Kind = bkOK
  end
  object btn_Cancel: TBitBtn
    Left = 416
    Top = 452
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 5
    Kind = bkCancel
  end
  object cb_PreSets: TComboBox
    Left = 64
    Top = 454
    Width = 185
    Height = 21
    Hint = 'Select a preset configuration. (System wide)'
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    Sorted = True
    TabOrder = 6
    OnChange = cb_PreSetsChange
  end
  object btn_AddPre: TBitBtn
    Left = 248
    Top = 454
    Width = 17
    Height = 21
    Hint = 'Add a new preset'
    Anchors = [akLeft, akBottom]
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = btn_AddPreClick
  end
  object btn_DelPre: TBitBtn
    Left = 264
    Top = 454
    Width = 17
    Height = 21
    Hint = 'Remove the current preset'
    Anchors = [akLeft, akBottom]
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = btn_DelPreClick
  end
  object btn_Default: TBitBtn
    Left = 288
    Top = 454
    Width = 17
    Height = 21
    Hint = 'Set as default'
    Anchors = [akLeft, akBottom]
    Caption = 'a'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Marlett'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = btn_DefaultClick
  end
  object od_SelectMap: TOpenDialog
    Filter = 'Maps|*.unr;*.ut2|All Files|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Select Map'
    Left = 248
    Top = 424
  end
  object od_IniFiles: TOpenDialog
    Filter = 'INI Files|*.ini|All Files|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Select ini files'
    Left = 280
    Top = 424
  end
  object od_Exe: TOpenDialog
    Filter = 'Executables|*.exe;*.bat;*.cmd|All Files|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Executable'
    Left = 312
    Top = 424
  end
  object od_Log: TOpenDialog
    Filter = 'Log files|*.log|All Files|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Log files'
    Left = 344
    Top = 424
  end
end
