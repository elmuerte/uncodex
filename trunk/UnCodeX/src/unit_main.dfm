object frm_UnCodeX: Tfrm_UnCodeX
  Left = 232
  Top = 102
  HelpType = htKeyword
  ActiveControl = tv_Classes
  AutoScroll = False
  ClientHeight = 570
  ClientWidth = 658
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = mm_Main
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object splLeft: TSplitter
    Left = 0
    Top = 34
    Width = 4
    Height = 505
    Cursor = crHSplit
    AutoSnap = False
    Visible = False
  end
  object splTop: TSplitter
    Left = 0
    Top = 30
    Width = 658
    Height = 4
    Cursor = crVSplit
    Align = alTop
    AutoSnap = False
    Visible = False
  end
  object splBottom: TSplitter
    Left = 0
    Top = 539
    Width = 658
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Visible = False
  end
  object splRight: TSplitter
    Left = 654
    Top = 34
    Width = 4
    Height = 505
    Cursor = crHSplit
    Align = alRight
    AutoSnap = False
    Visible = False
    OnCanResize = splRightCanResize
    OnMoved = splRightMoved
  end
  object pnlCenter: TPanel
    Left = 4
    Top = 34
    Width = 650
    Height = 505
    Align = alClient
    BevelOuter = bvNone
    BevelWidth = 0
    DockSite = True
    TabOrder = 10
    OnDockDrop = pnlCenterDockDrop
    OnUnDock = pnlCenterUnDock
  end
  object tv_Packages: TTreeView
    Left = 32
    Top = 54
    Width = 169
    Height = 235
    HelpType = htKeyword
    HelpKeyword = 'packagetree'
    DragKind = dkDock
    HideSelection = False
    Images = il_Small
    Indent = 19
    PopupMenu = pm_ClassTree
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 1
    OnChange = tv_ClassesChange
    OnCollapsing = tv_ClassesExpanding
    OnDblClick = tv_ClassesDblClick
    OnEnter = tv_ClassesEnter
    OnExit = tv_ClassesExit
    OnExpanding = tv_ClassesExpanding
    OnKeyDown = tv_ClassesKeyDown
    OnKeyPress = tv_ClassesKeyPress
    OnMouseDown = tv_ClassesMouseDown
  end
  object sb_Status: TStatusBar
    Left = 0
    Top = 551
    Width = 658
    Height = 19
    Panels = <
      item
        Width = 23
      end>
    SimplePanel = False
    SizeGrip = False
  end
  object pb_Scan: TProgressBar
    Left = 0
    Top = 543
    Width = 658
    Height = 8
    Align = alBottom
    Min = 0
    Max = 100
    TabOrder = 4
  end
  object tb_Tools: TToolBar
    Left = 0
    Top = 0
    Width = 658
    Height = 30
    AutoSize = True
    BorderWidth = 1
    Images = il_Small
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object btn_OpenClass: TToolButton
      Left = 0
      Top = 2
      Action = ac_OpenClass
    end
    object btn_FindClass: TToolButton
      Left = 23
      Top = 2
      Action = ac_FindClass
    end
    object tb_FindNext: TToolButton
      Left = 46
      Top = 2
      Action = ac_FindNext
    end
    object tb_Sep4: TToolButton
      Left = 69
      Top = 2
      Width = 8
      ImageIndex = 9
      Style = tbsSeparator
    end
    object tb_FullTextSearch: TToolButton
      Left = 77
      Top = 2
      Action = ac_FullTextSearch
    end
    object btn_Sep1: TToolButton
      Left = 100
      Top = 2
      Width = 8
      Caption = 'btn_Sep1'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object btn_RebuildTree: TToolButton
      Left = 108
      Top = 2
      Action = ac_RecreateTree
    end
    object btn_FindOrphan: TToolButton
      Left = 131
      Top = 2
      Action = ac_FindOrphans
    end
    object btn_AnalyseAll: TToolButton
      Left = 154
      Top = 2
      Action = ac_AnalyseAll
    end
    object btn_AnalyseModified: TToolButton
      Left = 177
      Top = 2
      Action = ac_AnalyseModified
    end
    object btn_Sep2: TToolButton
      Left = 200
      Top = 2
      Width = 8
      Caption = 'btn_Sep2'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object btn_CreateHTML: TToolButton
      Left = 208
      Top = 2
      Action = ac_CreateHTMLfiles
    end
    object btn_OpenOutput: TToolButton
      Left = 231
      Top = 2
      Action = ac_OpenOutput
    end
    object btn_HTMLHelp: TToolButton
      Left = 254
      Top = 2
      Action = ac_HTMLHelp
    end
    object btn_Sep5: TToolButton
      Left = 277
      Top = 2
      Width = 8
      Caption = 'btn_Sep5'
      ImageIndex = 11
      Style = tbsSeparator
    end
    object tb_RunServer: TToolButton
      Left = 285
      Top = 2
      Action = ac_RunServer
    end
    object tb_JoinServer: TToolButton
      Left = 308
      Top = 2
      Action = ac_JoinServer
    end
    object btn_Sep3: TToolButton
      Left = 331
      Top = 2
      Width = 8
      Caption = 'btn_Sep3'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object btn_Settings: TToolButton
      Left = 339
      Top = 2
      Action = ac_Settings
    end
    object btn_Sep4: TToolButton
      Left = 362
      Top = 2
      Width = 8
      Caption = 'btn_Sep4'
      ImageIndex = 5
      Style = tbsSeparator
    end
    object btn_Abort: TToolButton
      Left = 370
      Top = 2
      Action = ac_Abort
    end
  end
  object re_SourceSnoop: TRichEditEx
    Left = 168
    Top = 166
    Width = 289
    Height = 187
    HelpType = htKeyword
    HelpKeyword = 'sourcesnoop'
    DragKind = dkDock
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    HideSelection = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    Visible = False
    WordWrap = False
    OnEndDock = re_SourceSnoopEndDock
    OnMouseMove = re_SourceSnoopMouseMove
    OnMouseUp = re_SourceSnoopMouseUp
  end
  object tv_Classes: TTreeView
    Left = 108
    Top = 70
    Width = 173
    Height = 243
    HelpType = htKeyword
    HelpKeyword = 'classtree'
    DragKind = dkDock
    HideSelection = False
    Images = il_Small
    Indent = 19
    PopupMenu = pm_ClassTree
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 2
    OnChange = tv_ClassesChange
    OnCollapsing = tv_ClassesExpanding
    OnDblClick = tv_ClassesDblClick
    OnEnter = tv_ClassesEnter
    OnExit = tv_ClassesExit
    OnExpanding = tv_ClassesExpanding
    OnKeyDown = tv_ClassesKeyDown
    OnKeyPress = tv_ClassesKeyPress
    OnMouseDown = tv_ClassesMouseDown
  end
  object dckTop: TPanel
    Left = 0
    Top = 34
    Width = 658
    Height = 0
    Align = alTop
    BevelOuter = bvNone
    DockSite = True
    TabOrder = 5
    OnDockDrop = dckLeftDockDrop
    OnUnDock = dckLeftUnDock
  end
  object dckBottom: TPanel
    Left = 0
    Top = 543
    Width = 658
    Height = 0
    Align = alBottom
    BevelOuter = bvNone
    DockSite = True
    TabOrder = 6
    OnDockDrop = dckLeftDockDrop
    OnUnDock = dckLeftUnDock
  end
  object dckLeft: TPanel
    Left = 4
    Top = 34
    Width = 0
    Height = 505
    Align = alLeft
    BevelOuter = bvNone
    DockSite = True
    TabOrder = 7
    OnDockDrop = dckLeftDockDrop
    OnUnDock = dckLeftUnDock
  end
  object dckRight: TPanel
    Left = 658
    Top = 34
    Width = 0
    Height = 505
    Align = alRight
    BevelOuter = bvNone
    DockSite = True
    TabOrder = 8
    OnDockDrop = dckLeftDockDrop
    OnUnDock = dckLeftUnDock
  end
  object lb_Log: TListBox
    Left = 68
    Top = 394
    Width = 461
    Height = 103
    HelpType = htKeyword
    HelpKeyword = 'log'
    DragKind = dkDock
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    PopupMenu = pm_Log
    TabOrder = 11
    OnClick = lb_LogClick
    OnDblClick = lb_LogDblClick
  end
  inline fr_Props: Tfr_Properties
    Left = 408
    Top = 88
    Width = 193
    Height = 272
    TabOrder = 12
  end
  object mm_Main: TMainMenu
    Images = il_Small
    Left = 8
    Top = 72
    object mi_Tree: TMenuItem
      Caption = 'Tree'
      object mi_RebuildAnalyse: TMenuItem
        Action = ac_RebuildAnalyse
      end
      object mi_N7: TMenuItem
        Caption = '-'
      end
      object mi_ScanPackages: TMenuItem
        Action = ac_RecreateTree
      end
      object mi_findorphans1: TMenuItem
        Action = ac_FindOrphans
      end
      object mi_N4: TMenuItem
        Caption = '-'
      end
      object mi_Analyseallclasses: TMenuItem
        Action = ac_AnalyseAll
      end
      object mi_AnalyseModifiedClasses: TMenuItem
        Action = ac_AnalyseModified
      end
      object mi_N6: TMenuItem
        Caption = '-'
      end
      object mi_SaveState: TMenuItem
        Action = ac_SaveState
      end
      object mi_LoadState: TMenuItem
        Action = ac_LoadState
      end
      object mi_N1: TMenuItem
        Caption = '-'
      end
      object mi_Settings: TMenuItem
        Action = ac_Settings
      end
      object mi_N5: TMenuItem
        Caption = '-'
      end
      object mi_Quit: TMenuItem
        Action = ac_Close
      end
    end
    object mi_Find: TMenuItem
      Caption = 'Find'
      object mi_FindClass: TMenuItem
        Action = ac_FindClass
      end
      object mi_FullTextSearch: TMenuItem
        Action = ac_FullTextSearch
      end
      object mi_N14: TMenuItem
        Caption = '-'
      end
      object mi_FindNext: TMenuItem
        Action = ac_FindNext
      end
    end
    object mi_View: TMenuItem
      Caption = 'View'
      object mi_Menubar: TMenuItem
        Action = ac_VMenuBar
        AutoCheck = True
      end
      object mi_Toolbar: TMenuItem
        Action = ac_VToolbar
        AutoCheck = True
      end
      object mi_N10: TMenuItem
        Caption = '-'
      end
      object mi_PackageTree: TMenuItem
        Action = ac_VPackageTree
        AutoCheck = True
      end
      object mi_ClassTree: TMenuItem
        AutoCheck = True
        Caption = 'Class Tree'
        Checked = True
        Enabled = False
      end
      object mi_PropInspector: TMenuItem
        Action = ac_PropInspector
        AutoCheck = True
      end
      object mi_SourceSnoop: TMenuItem
        Action = ac_VSourceSnoop
        AutoCheck = True
      end
      object mi_Log: TMenuItem
        Action = ac_VLog
        AutoCheck = True
      end
      object mi_N11: TMenuItem
        Caption = '-'
      end
      object mi_Savesize: TMenuItem
        Action = ac_VSaveSize
        AutoCheck = True
      end
      object mi_Saveposition: TMenuItem
        Action = ac_VSavePosition
        AutoCheck = True
      end
      object mi_N12: TMenuItem
        Caption = '-'
      end
      object mi_Stayontop: TMenuItem
        Action = ac_VStayOnTop
        AutoCheck = True
      end
      object mi_Toolwindow: TMenuItem
        Caption = 'Tool window'
        object mi_Autohide: TMenuItem
          Action = ac_VAutoHide
          AutoCheck = True
          GroupIndex = 1
        end
        object mi_N13: TMenuItem
          Caption = '-'
          GroupIndex = 1
        end
        object mi_Right: TMenuItem
          Action = ac_VTRight
          AutoCheck = True
          GroupIndex = 1
        end
        object mi_Left: TMenuItem
          Action = ac_VTLeft
          AutoCheck = True
          GroupIndex = 1
        end
      end
    end
    object mi_HTMLoutput: TMenuItem
      Caption = 'HTML Output'
      object mi_Createindexfiles: TMenuItem
        Action = ac_CreateHTMLfiles
      end
      object mi_OpenOutput: TMenuItem
        Action = ac_OpenOutput
        Hint = 'Open output|Open the result html file'
      end
      object mi_N8: TMenuItem
        Caption = '-'
      end
      object mi_CreateHTMLHelp: TMenuItem
        Action = ac_HTMLHelp
      end
      object mi_OpenHTMLHelpFile: TMenuItem
        Action = ac_OpenHTMLHelp
      end
    end
    object mi_GameServer: TMenuItem
      Caption = 'Game Server'
      object mi_Startserver: TMenuItem
        Action = ac_RunServer
      end
      object mi_Joinserver: TMenuItem
        Action = ac_JoinServer
      end
    end
    object mi_Output: TMenuItem
      Caption = 'Output modules'
      Visible = False
    end
    object mi_HelpMenu: TMenuItem
      Caption = 'Help'
      object mi_Help2: TMenuItem
        Caption = 'Help'
        ImageIndex = 23
        OnClick = mi_Help2Click
      end
      object mi_License: TMenuItem
        Action = ac_License
      end
      object mi_About: TMenuItem
        Action = ac_About
      end
    end
  end
  object tmr_StatusText: TTimer
    Interval = 500
    OnTimer = tmr_StatusTextTimer
    Left = 8
    Top = 168
  end
  object pm_ClassTree: TPopupMenu
    Images = il_Small
    OnPopup = pm_ClassTreePopup
    Left = 40
    Top = 72
    object mi_ClassName: TMenuItem
      AutoHotkeys = maManual
      AutoLineReduction = maManual
      Caption = 'Classname'
      Enabled = False
      OnDrawItem = mi_ClassNameDrawItem
    end
    object mi_PackageName: TMenuItem
      AutoHotkeys = maManual
      AutoLineReduction = maManual
      Caption = 'Packagename'
      Enabled = False
      OnDrawItem = mi_PackageNameDrawItem
    end
    object mi_OpenClass: TMenuItem
      Action = ac_OpenClass
      Default = True
    end
    object mi_Compile: TMenuItem
      Action = ac_CompileClass
    end
    object mi_Analyseclass: TMenuItem
      Caption = 'Analyse class'
      OnClick = mi_AnalyseclassClick
    end
    object mi_ShowProperties: TMenuItem
      Action = ac_Tags
    end
    object mi_DefProps: TMenuItem
      Action = ac_DefProps
      Visible = False
    end
    object mi_Properties: TMenuItem
      Action = ac_PackageProps
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mi_CreateSubClass: TMenuItem
      Action = ac_CreateSubClass
    end
    object mi_DeleteClass: TMenuItem
      Action = ac_DeleteClass
    end
    object mi_MoveClass: TMenuItem
      Action = ac_MoveClass
    end
    object mi_RenameClass: TMenuItem
      Action = ac_RenameClass
    end
    object mi_N15: TMenuItem
      Caption = '-'
    end
    object mi_Copyname: TMenuItem
      Action = ac_CopyName
    end
    object mi_SingleOutput: TMenuItem
      Caption = 'Output modules'
      Visible = False
    end
    object mi_N2: TMenuItem
      Caption = '-'
    end
    object mi_FindClass2: TMenuItem
      Action = ac_FindClass
    end
    object mi_FTS2: TMenuItem
      Action = ac_FullTextSearch
    end
    object mi_FindNext2: TMenuItem
      Action = ac_FindNext
    end
    object mi_SwitchTree: TMenuItem
      Action = ac_SwitchTree
    end
    object mi_N9: TMenuItem
      Caption = '-'
    end
    object mi_Expandall: TMenuItem
      Caption = 'Expand all'
      OnClick = mi_ExpandallClick
    end
    object mi_Collapseall: TMenuItem
      Caption = 'Collapse all'
      OnClick = mi_CollapseallClick
    end
  end
  object ae_AppEvent: TApplicationEvents
    OnException = ae_AppEventException
    OnHint = ae_AppEventHint
    OnMessage = ae_AppEventMessage
    Left = 8
    Top = 136
  end
  object al_Main: TActionList
    Images = il_Small
    Left = 8
    Top = 104
    object ac_RecreateTree: TAction
      Category = 'Class Tree'
      Caption = 'Rebuild Tree'
      Hint = 'Rebuild Tree|Creates the class tree from scratch'
      ImageIndex = 9
      OnExecute = ac_RecreateTreeExecute
    end
    object ac_FindOrphans: TAction
      Category = 'Class Tree'
      Caption = 'Find Orphans'
      Hint = 
        'Find orphans|Find classes with no assigned parent, usefull for c' +
        'onfiguring Package priorities'
      ImageIndex = 7
      OnExecute = ac_FindOrphansExecute
    end
    object ac_AnalyseAll: TAction
      Category = 'Class Tree'
      Caption = 'Analyse All Classes'
      Hint = 
        'Analyse all|Analyse the content of all classes for output proces' +
        'sing'
      ImageIndex = 10
      OnExecute = ac_AnalyseAllExecute
    end
    object ac_AnalyseModified: TAction
      Category = 'Class Tree'
      Caption = 'Analyse Modified Classes'
      Hint = 
        'Analyse Modified Classes|Only analyse classes that have been cha' +
        'nge since the last analyse'
      ImageIndex = 24
      OnExecute = ac_AnalyseModifiedExecute
    end
    object ac_CreateHTMLfiles: TAction
      Category = 'HTML'
      Caption = 'Create all files'
      Hint = 
        'Create HTML files|Create all HTML files (classes need to be anal' +
        'ysed)'
      ImageIndex = 15
      OnExecute = ac_CreateHTMLfilesExecute
    end
    object ac_Settings: TAction
      Category = 'Program'
      Caption = 'Settings'
      Hint = 'Settings|Adjust program preferences'
      ImageIndex = 14
      ShortCut = 16467
      OnExecute = ac_SettingsExecute
    end
    object ac_Abort: TAction
      Category = 'Program'
      Caption = 'Abort'
      Enabled = False
      Hint = 'Abort|Try to abort the current running thread'
      ImageIndex = 8
      ShortCut = 16430
      OnExecute = ac_AbortExecute
    end
    object ac_FindClass: TAction
      Category = 'Find'
      Caption = 'Find Class'
      Hint = 'Find class|Find a class in the selected tree'
      ImageIndex = 4
      ShortCut = 16454
      OnExecute = ac_FindClassExecute
    end
    object ac_OpenClass: TAction
      Category = 'Class Tree'
      Caption = 'Open'
      Hint = 'Open class|Open the selected class'
      ImageIndex = 2
      ShortCut = 13
      OnExecute = ac_OpenClassExecute
    end
    object ac_OpenOutput: TAction
      Category = 'HTML'
      Caption = 'Open output'
      Hint = 'Open ouput|Open the HTML output'
      ImageIndex = 16
      OnExecute = ac_OpenOutputExecute
    end
    object ac_SaveState: TAction
      Category = 'Program'
      Caption = 'Save state'
      Hint = 'Save state|Save the tree state'
      ImageIndex = 22
      OnExecute = ac_SaveStateExecute
    end
    object ac_LoadState: TAction
      Category = 'Program'
      Caption = 'Load state'
      Hint = 'Load State|Load the tree state from the disk'
      ImageIndex = 21
      OnExecute = ac_LoadStateExecute
    end
    object ac_About: TAction
      Category = 'Program'
      Caption = 'About ...'
      ImageIndex = 20
      OnExecute = ac_AboutExecute
    end
    object ac_HTMLHelp: TAction
      Category = 'HTML'
      Caption = 'Create HTML Help'
      Hint = 'Create HTML Help|Create a MS HTML Help file'
      ImageIndex = 17
      OnExecute = ac_HTMLHelpExecute
    end
    object ac_CompileClass: TAction
      Category = 'Compiler'
      Caption = 'Compile class'
      Hint = 'Compile class|Compile the selected class'
      ImageIndex = 13
      OnExecute = ac_CompileClassExecute
    end
    object ac_RunServer: TAction
      Category = 'Game Server'
      Caption = 'Run server'
      Hint = 'Run server|Run a game server on the local machine'
      ImageIndex = 18
      ShortCut = 16466
      OnExecute = ac_RunServerExecute
    end
    object ac_JoinServer: TAction
      Category = 'Game Server'
      Caption = 'Join server'
      Hint = 'Join Server|Join the game server'
      ImageIndex = 19
      ShortCut = 16458
      OnExecute = ac_JoinServerExecute
    end
    object ac_FindNext: TAction
      Category = 'Find'
      Caption = 'Find Next'
      Hint = 'Find Next|Find next class'
      ImageIndex = 5
      ShortCut = 114
      OnExecute = ac_FindNextExecute
    end
    object ac_FullTextSearch: TAction
      Category = 'Find'
      Caption = 'Full Text Search'
      Hint = 'Full Text Search|Search all class files'
      ImageIndex = 6
      ShortCut = 16468
      OnExecute = ac_FullTextSearchExecute
    end
    object ac_Tags: TAction
      Category = 'Class Tree'
      Caption = 'Show properties'
      ImageIndex = 11
      ShortCut = 32781
      OnExecute = ac_TagsExecute
    end
    object ac_CopyName: TAction
      Category = 'Class Tree'
      Caption = 'Copy name'
      Hint = 'Copy name|Copy the name of the selection to the clipboard'
      ImageIndex = 12
      OnExecute = ac_CopyNameExecute
    end
    object ac_Help: TAction
      Category = 'Program'
      Caption = 'Help'
      ImageIndex = 23
      ShortCut = 112
      OnExecute = ac_HelpExecute
    end
    object ac_Close: TAction
      Category = 'Program'
      Caption = 'Quit'
      Hint = 'Quit|Quit UnCodeX'
      OnExecute = ac_CloseExecute
    end
    object ac_VMenuBar: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Menu bar'
      Checked = True
      Hint = 'Menu bar|Show or hide the menu bar'
      ShortCut = 49229
      OnExecute = ac_VMenuBarExecute
    end
    object ac_VToolbar: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Toolbar'
      Checked = True
      ShortCut = 49236
      OnExecute = ac_VToolbarExecute
    end
    object ac_VPackageTree: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Package Tree'
      Checked = True
      ShortCut = 49232
      OnExecute = ac_VPackageTreeExecute
    end
    object ac_VLog: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Log'
      Checked = True
      ShortCut = 49228
      OnExecute = ac_VLogExecute
    end
    object ac_VSaveSize: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Save size'
      OnExecute = ac_VSaveSizeExecute
    end
    object ac_VSavePosition: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Save position'
      OnExecute = ac_VSavePositionExecute
    end
    object ac_VStayOnTop: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Stay on top'
      ShortCut = 49235
      OnExecute = ac_VStayOnTopExecute
    end
    object ac_VAutoHide: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Auto hide'
      ShortCut = 49217
      OnExecute = ac_VAutoHideExecute
    end
    object ac_VTRight: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Right'
      ShortCut = 49191
      OnExecute = ac_VTRightExecute
    end
    object ac_VTLeft: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Left'
      ShortCut = 49189
      OnExecute = ac_VTLeftExecute
    end
    object ac_SourceSnoop: TAction
      Category = 'Class Tree'
      Caption = 'Reload source snoop'
      OnExecute = ac_SourceSnoopExecute
    end
    object ac_VSourceSnoop: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Source Snoop'
      Hint = 'View the source code of a file'
      ShortCut = 49219
      OnExecute = ac_VSourceSnoopExecute
    end
    object ac_CopySelection: TAction
      Category = 'Source Snoop'
      Caption = 'Copy selection'
      Hint = 'Copy selection|Copy selected text to the clipboard'
      OnExecute = ac_CopySelectionExecute
    end
    object ac_SaveToRTF: TAction
      Category = 'Source Snoop'
      Caption = 'Save to RTF'
      Hint = 'Save to RTF|Save syntax hilighted code to a Rich Text File'
      OnExecute = ac_SaveToRTFExecute
    end
    object ac_SelectAll: TAction
      Category = 'Source Snoop'
      Caption = 'Select All'
      OnExecute = ac_SelectAllExecute
    end
    object ac_License: TAction
      Category = 'Program'
      Caption = 'License'
      OnExecute = ac_LicenseExecute
    end
    object ac_RebuildAnalyse: TAction
      Category = 'Class Tree'
      Caption = 'Rebuild and Analyse'
      Hint = 'Rebuild the class tree and analyse all classes'
      ShortCut = 16450
      OnExecute = ac_RebuildAnalyseExecute
    end
    object ac_OpenHTMLHelp: TAction
      Category = 'HTML'
      Caption = 'Open HTML Help file'
      Hint = 'Open the MS HTML Help file'
      OnExecute = ac_OpenHTMLHelpExecute
    end
    object ac_PropInspector: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Property Inspector'
      ShortCut = 49225
      OnExecute = ac_PropInspectorExecute
    end
    object ac_SwitchTree: TAction
      Category = 'Find'
      Caption = 'Switch Tree'
      ImageIndex = 26
      ShortCut = 16393
      OnExecute = ac_SwitchTreeExecute
    end
    object ac_CreateSubClass: TAction
      Category = 'Class Tree'
      Caption = 'Create subclass'
      OnExecute = ac_CreateSubClassExecute
    end
    object ac_DeleteClass: TAction
      Category = 'Class Tree'
      Caption = 'Delete class'
      OnExecute = ac_DeleteClassExecute
    end
    object ac_MoveClass: TAction
      Category = 'Class Tree'
      Caption = 'Move class'
      OnExecute = ac_MoveClassExecute
    end
    object ac_RenameClass: TAction
      Category = 'Class Tree'
      Caption = 'Rename class'
      OnExecute = ac_RenameClassExecute
    end
    object ac_PackageProps: TAction
      Category = 'Class Tree'
      Caption = 'Package Properties'
      ImageIndex = 11
      OnExecute = ac_PackagePropsExecute
    end
    object ac_DefProps: TAction
      Category = 'Class Tree'
      Caption = 'Defaultproperties'
      OnExecute = ac_DefPropsExecute
    end
  end
  object il_Small: TImageList
    Left = 40
    Top = 104
    Bitmap = {
      494C01011B001D00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000008000000001002000000000000080
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040000000000848684000402
      0400040204000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000040204000402040084868400049E
      9C000402040000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848204000000
      0000000000000000000084820400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040000000000848684008486
      84008486840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FCFE04008482
      04000000000000000000FCFE0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040000000000000000000000
      00000000000084868400040204000402040000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008080800000000000000000008080
      8000000000000000000000000000000000000000000084820400848204008482
      0400848204008482040084820400848204008482040084820400FCFE0400FCFE
      04008482040000000000FCFE0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008486840004020400040204000402040084868400000000000402
      04000402040084868400049E9C000402040000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000FFFF00008080
      80008080800000000000000000000000000000000000FCFE0400FCFE0400FCFE
      0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE
      0400FCFE040084820400FCFE0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848684000402040084FEFC0084FEFC0084FEFC0004020400000000000402
      04000000000084868400848684008486840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FCFE0400FCFE
      04000000000000000000FCFE0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000402040084FEFC0084FEFC0084FEFC0084FEFC0084FEFC00040204000402
      04000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFF000000000000000000008080
      8000000000000000000000000000000000000000000084820400000000000000
      0000000000008482040000000000000000000000000000000000FCFE04000000
      00000000000000000000FCFE0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000402040084FEFC0084FEFC0084FEFC0084FEFC0084FEFC00040204000402
      04000000000084868400040204000402040000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000FFFF0000FFFF0000000000008080
      80008080800000000000000000000000000000000000FCFE0400000000000000
      000084820400FCFE040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000040204000402040084FEFC0084FEFC0084FEFC0084FEFC00040204000402
      04000402040084868400049E9C000402040000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008080800000000000000000008080
      80000000000000000000000000000000000000000000FCFE0400000000008482
      0400FCFE0400FCFE040084820400848204008482040084820400848204008482
      0400848204008482040084820400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000402
      040004FEFC00040204000402040084FEFC0084FEFC0004020400000000000402
      04000000000084868400848684008486840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFE040084820400FCFE
      0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE
      0400FCFE0400FCFE0400FCFE0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000402040004FE
      FC00FCFEFC000402040004020400040204000402040000000000848684000402
      04000402040000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FCFE0400000000000000
      0000FCFE0400FCFE040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000402040004FEFC00FCFE
      FC0004020400040204000000000000000000040204000402040084868400049E
      9C000402040000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFE0400000000000000
      000000000000FCFE040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040004FEFC00FCFEFC00049E
      9C00040204000000000000000000000000000000000000000000848684008486
      84008486840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000004020400FCFEFC00049E9C000402
      0400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E4E2E40004020400040204000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000616161004C4A4C004C4A4C004C4A
      4C004C4A4C004C4A4C004C4A4C004C4A4C004C4A4C004C4A4C004C4A4C004C4A
      4C00616161000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000087723B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009C9A04009C9A04009C9A0400848684000000
      0000000000000000000000000000000000008A8A8A00BBBCBB00BBBCBB00BBBC
      BB00BBBCBB00BBBCBB00BBBCBB00BBBCBB00BBBCBB00BBBCBB00BBBCBB00BBBC
      BB004C4A4C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007E631700FC9E2C0087723B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000343234003432340034323400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000848684009C9A04009C9A0400000000009C9A04000000
      0000000000000000000000000000000000008A8A8A00DBDBDB00DBDBDB00BBBC
      BB00BBBCBB00BBBCBB00BBBCBB00BBBCBB00BBBCBB00BBBCBB00BBBCBB00BBBC
      BB004C4A4C00000000000000000000000000B6B7B60087723B0044413C004441
      3C0044413C0044413C00B6B7B6007E631700FC9E2C00DAA97800FC9E2C008772
      3B0087723B0087723B0044413C00919191000000000000000000000000000000
      000000000000343234003432340004A2AC0004A2AC0004A2AC00343234000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009C9A04009C9A04009C9A040000000000000000000000
      0000000000000000000000000000000000008A8A8A00DBDBDB00DBDBDB00BBBC
      BB00DBDBDB00DBDBDB00BBBCBB00DBDBDB00041EFC00DBDBDB0004BE0400A1A1
      A1006161610000000000000000000000000091919100AAFBF900AAFBF900AAFB
      F90054D3EE0054D3EE007E631700DAA97800DAA97800DAA97800DAA97800FC9E
      2C0087723B0054D3EE0054D3EE0044413C000000000000000000000000003432
      34003432340004A2AC0004A2AC0004F2FC0004F2FC0004F2FC0004A2AC003432
      3400000000000000000000000000000000000000000000000000000000000000
      000000000000000000009C9A04009C9A04009C9A040084868400000000000000
      0000000000000000000000000000000000008A8A8A00DBDBDB00DBDBDB00DBDB
      DB00DBDBDB00DBDBDB00DBDBDB00DBDBDB00DBDBDB00DBDBDB00DBDBDB00DBDB
      DB006161610000000000000000000000000091919100AAFBF900AAFBF900AAFB
      F900AAFBF9007E631700DAA97800FCFBBE00FCFBBE00DAA97800DAA97800DAA9
      7800FC9E2C0087723B0054D3EE0044413C0000000000343234003432340004A2
      AC0004A2AC0004F2FC0004F2FC00643604006436040004A2AC0004F2FC0004A2
      AC00343234000000000000000000000000000000000000000000000000000000
      00000000000000000000848684009C9A04009C9A040084868400000000000000
      000000000000000000000000000000000000A1A1A100BBBCBB00A1A1A100BBBC
      BB00A1A1A100BBBCBB00A1A1A100BBBCBB00A1A1A100BBBCBB00A1A1A100A1A1
      A100A1A1A10000000000000000000000000091919100AAFBF900AAFBF900AAFB
      F900DEC493007E63170087723B007E631700FCFBBE00FCFBBE00DAA978008772
      3B007E63170087723B00DEC4930087723B006436040004A2AC0004A2AC0004F2
      FC0004F2FC00643604007C5A0400DCA67C00DCA67C006436040004A2AC0004F2
      FC0004A2AC003432340000000000000000000000000000000000000000000000
      00000000000000000000848684009C9A04009C9A04009C9A0400000000000000
      000000000000000000000000000000000000DCDA040000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000091919100AAFBF900AAFBF900AAFB
      F900AAFBF900AAFBF900AAFBF900B28F4600FCFBBE00FCFBBE00FCFBBE008772
      3B00B6B7B600AAFBF90054D3EE0044413C006436040004F2FC0004F2FC006436
      04007C5A0400BC720400BC720400BC720400BC720400DCA67C006436040004A2
      AC0004F2FC0004A2AC0034323400000000000000000000000000000000000000
      0000000000000000000000000000848684009C9A04009C9A0400848684000000
      000000000000000000000000000000000000DCDA040000000000000000000000
      0000A1A1A1004C4A4C004C4A4C004C4A4C004C4A4C004C4A4C004C4A4C004C4A
      4C004C4A4C004C4A4C004C4A4C00A1A1A10091919100EBDFC900AAFBF900AAFB
      F900AAFBF900AAFBF900AAFBF900B28F4600FCFBBE00FCFBBE00DAA97800EBDF
      C900AAFBF90054D3EE00AAFBF90044413C00643604006436040064360400BC72
      0400BC720400BC72040004F2FC00BC720400BC720400BC720400DCA67C006436
      040004A2AC0004F2FC0004A2AC00343234000000000000000000000000000000
      0000000000000000000000000000000000009C9A04009C9A04009C9A04000000
      000000000000000000000000000000000000DCDA04000000000000000000DCDA
      0400A1A1A100A4FBFC00A4FBFC00A4FBFC0054DEFC00ACDED40054DEFC0054DE
      FC00ACDED40054DEFC0054BFD4004C4A4C0091919100AAFBF900AAFBF900AAFB
      F900AAFBF900AAFBF900B28F4600DAA97800FCFBBE00FCFBBE00B28F4600AAFB
      F900AAFBF900AAFBF90054D3EE0044413C00643604007C5A0400A4760400BC72
      0400BC720400BC7204006CF6FC00BC720400BC720400BC720400BC720400DCA6
      7C006436040004A2AC0034323400000000000000000000000000000000000000
      000000000000000000009C9A0400000000009C9A04009C9A04009C9A04000000
      00000000000000000000000000000000000000000000DCDA0400000000000000
      0000DCDA0400A4FBFC00A4FBFC00A4FBFC00A4FBFC00A4FBFC00A4FBFC00A4FB
      FC0054DEFC00ACDED40054DEFC004C4A4C00B6B7B600EBDFC900AAFBF900EBDF
      C900AAFBF900AAFBF900B28F4600EBDFC900FCFBBE00DEC49300DEC49300AAFB
      F900AAFBF900AAFBF900AAFBF90087723B000000000064360400FC9E2C00DCA6
      7C00BC720400BC720400BC720400BC72040004F2FC0004F2FC00BC720400BC72
      0400DCA67C006436040034323400000000000000000000000000000000000000
      00000000000000000000848684009C9A04009C9A04009C9A0400848684000000
      0000000000000000000000000000000000000000000000000000DCDA0400DCDA
      0400DCDA0400DCDA0400A4FBFC00A4FBFC00A4FBFC00A4FBFC00A4FBFC0054DE
      FC00A4FBFC0054DEFC00ACDED4004C4A4C00B6B7B600AAFBF900EBDFC900AAFB
      F900AAFBF900B28F4600DAA97800DEC49300DEC49300AAFBF900AAFBF900AAFB
      F900AAFBF900AAFBF900AAFBF90087723B00000000000000000064360400FC9E
      2C00DCA67C00BC720400BC720400BC720400BC7204006CF6FC0004F2FC0004F2
      FC00BC720400DCA67C0034323400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DCDA0400DBDBDB00A4FBFC00A4FBFC00A4FBFC00A4FBFC00A4FBFC00A4FB
      FC0054DEFC00A4FBFC0054DEFC0061616100B6B7B600EBDFC900AAFBF900EBDF
      C900DAA97800DAA97800DAA97800DEC49300DEC49300B6B7B600EBDFC900B6B7
      B60054D3EE0054D3EE0054D3EE00919191000000000000000000000000006436
      0400FCFE7C00DCA67C00BC7204006CF6FC00BC720400BC72040004F2FC0004F2
      FC00BC720400BC720400DCA67C00343234000000000000000000000000000000
      0000000000000000000000000000848684009C9A04009C9A0400848684000000
      000000000000000000000000000000000000000000000000000000000000DCDA
      0400BBBCBB00DBDBDB00DBDBDB00DBDBDB00A4FBFC00A1A1A1008A8A8A00A1A1
      A10054BFD40054BFD40054BFD40074727400EBDFC900B6B7B600B6B7B600B6B7
      B600B6B7B600AAFBF900AAFBF90054D3EE0054D3EE0060F8FC0054D3EE0054D3
      EE0054D3EE0054D3EE0054D3EE00B6B7B6000000000000000000000000000000
      000064360400FCFE7C00DCA67C00BC7204006CF6FC0004F2FC0004F2FC00BC72
      0400DCA67C00FC9E2C007C5A0400643604000000000000000000000000000000
      00000000000000000000000000009C9A04009C9A04009C9A04009C9A04000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A1A1A100BBBCBB00A1A1A100A1A1A100A1A1A10054DEFC0054DEFC0054DE
      FC0054DEFC0054DEFC0054BFD4008A8A8A0000000000EBDFC90004F2FC0004F2
      FC0004F2FC0004F2FC0054D3EE00EBDFC9009191910091919100919191009191
      9100919191009191910091919100000000000000000000000000000000000000
      00000000000064360400FCFE7C00DCA67C00BC720400BC720400DCA67C00FC9E
      2C007C5A04006436040000000000000000000000000000000000000000000000
      0000000000000000000000000000848684009C9A04009C9A0400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BBBCBB00A4FBFC0004F2FC0004F2FC0054BFD4008A8A8A008A8A8A008A8A
      8A008A8A8A008A8A8A008A8A8A00BBBCBB00000000009191910060F8FC0060F8
      FC0060F8FC0060F8FC0004F2FC00B6B7B6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000064360400FCFE7C00FCFE7C00FCFE7C007C5A04006436
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BBBCBB00A1A1A1008A8A8A008A8A8A00A1A1A100BBBCBB00000000000000
      0000000000000000000000000000000000000000000000000000919191009191
      9100919191009191910091919100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000643604006436040064360400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004B4B4B004B4B4B00000000000000
      000000000000000000004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B
      4B004B4B4B004B4B4B0000000000000000000000000000000000000000000000
      000000000000818181004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B
      4B004B4B4B004B4B4B004B4B4B00818181000000000000000000000000000000
      000000000000FC3E0400FC3E0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CC8E4400A45604006436040064360400A45604000000
      000000000000000000000000000000000000D9A77D004B4B4B00000000000000
      00004B4B4B004B4B4B0055DFFF00C6C6C60055DFFF0055DFFF0055DFFF0055DF
      FF0055DFFF0055DFFF004B4B4B00000000000000000000000000000000000000
      0000000000004B4B4B00D9A77D00D9A77D00D9A77D00D9A77D00D9A77D00D9A7
      7D00D9A77D00D9A77D00D9A77D004B4B4B000000000000000000000000000000
      0000FC720400FCD20400FCB20400FC3E04000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A4760400DCA67C00CC8E4400CC8E4400CC8E44006436
      040000000000000000000000000000000000D9A77D004B4B4B004B4B4B004B4B
      4B0055DFFF0055DFFF00C6C6C6004B4B4B00ADADAD0099F7FF0099F7FF0099F7
      FF00C6C6C600C6C6C60055DFFF004B4B4B000000000000000000000000000000
      0000818181004B4B4B00FFFF9900D9A77D004B4B4B00CB8C4400CB8C4400CB8C
      4400CB8C4400CB8C4400D9A77D004B4B4B000000000000000000000000000000
      0000FC720400FCD20400FCD20400FCB20400FC3E040000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A4760400DCA67C00DCA67C00CC8E4400CC8E4400A476
      0400A4560400000000000000000000000000D9A77D004B4B4B0055DFFF0055DF
      FF00C6C6C60099F7FF0099F7FF00A1A1A1004B4B4B004B4B4B004B4B4B004B4B
      4B0055DFFF0099F7FF0055DFFF004B4B4B0000000000000000004B4B4B004B4B
      4B002DB72D004B4B4B00FFFFCC00D9A77D004B4B4B004B4B4B004B4B4B004B4B
      4B004B4B4B004B4B4B00D9A77D004B4B4B000000000000000000000000000000
      0000FC720400FCD20400FCD20400FCD20400FCB20400FC3E0400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A4760400DCA67C00DCA67C00DCA67C00CC8E4400A476
      0400A4560400000000000000000000000000D9A77D004B4B4B0055DFFF0099F7
      FF0099F7FF0099F7FF0099F7FF0099F7FF00C6C6C60055DFFF00C6C6C600C6C6
      C6004B4B4B004B4B4B0055DFFF004B4B4B00000000004B4B4B0000800000CCCC
      9900FFFF00004B4B4B00FFFFFF00D9A77D00D9A77D00D9A77D00D9A77D00D9A7
      7D00D9A77D00D9A77D00D9A77D004B4B4B000000000000000000000000000000
      0000FC720400FCD20400FCF20400FCD20400FCD20400FCB20400FC3E04000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A4760400DCA67C00DCA67C00DCA67C00DCA67C00A476
      0400A4560400000000000000000000000000FF0000004B4B4B0055DFFF00C6C6
      C600C6C6C60099F7FF0099F7FF0099F7FF0099F7FF00C6C6C60099F7FF00C6C6
      C6004B4B4B000080000055DFFF004B4B4B00000000004B4B4B0000800000FFFF
      0000F0E736004B4B4B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFCC00FFFF9900D9A77D004B4B4B000000000000000000000000000000
      0000FC720400FCF20400FCD20400FCF20400FCD20400FCD20400FCB20400FC3E
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A4760400FCFECC00FCFECC00FCFECC00FCFE
      CC00A4760400000000000000000000000000D9A77D004B4B4B0055DFFF00C6C6
      C6004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B
      4B00996600000080000099F7FF00A0A0A0004B4B4B0000800000CCCC9900CCCC
      9900FFFF00004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B
      4B004B4B4B004B4B4B004B4B4B004B4B4B000000000000000000000000000000
      0000FC720400FCF20400FCF20400FCD20400FCF20400FCD20400FCD20400FCB2
      0400FC3E04000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A4760400A4760400A4760400A476
      0400CC8E4400000000000000000000000000FF0000004B4B4B004B4B4B004B4B
      4B004B4B4B0000800000CCCC9900CCCC9900FFFF0000CCCC9900008000009966
      0000CCCC990099660000008000004B4B4B004B4B4B00CCCC9900FFFF0000FFFF
      0000FFFF00004B4B4B00CB8C4400CB8C4400CB8C4400CB8C4400CB8C4400CB8C
      4400CB8C4400CB8C4400CB8C44004B4B4B000000000000000000000000000000
      0000FC720400FCF20400FCF20400FCF20400FCD20400FCF20400FCD20400FCD2
      0400FC7204000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005C5E
      0400000000000000000000000000000000004B4B4B004B4B4B00000000000000
      00004B4B4B00CCCC9900FFFF0000FFFF0000FFFF00000080000000800000FFFF
      000099660000CCCC9900996600004B4B4B004B4B4B00CCCC9900FFFF0000FFFF
      0000FFFF0000F0E736004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B
      4B004B4B4B004B4B4B004B4B4B00818181000000000000000000000000000000
      0000FC720400FCF20400FCF20400FCF20400FCF20400FCD20400FCF20400FC72
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FCFE04005C5E
      04005C5E04000000000000000000000000000000000000000000000000000000
      00004B4B4B00CCCC9900FFFF0000FFFF0000FFFF000000800000FFFF00000080
      00000080000000800000008000004B4B4B004B4B4B00CCCC9900FFFF0000FFFF
      FF00FFFF0000FFFF00002DB72D002DB72D002DB72D002DB72D002DB72D008181
      8100000000000000000000000000000000000000000000000000000000000000
      0000FC720400FCF20400FCF20400FCF20400FCF20400FCF20400FC7204000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFE0400FCFE0400FCFE
      04005C5E04005C5E040000000000000000000000000000000000000000000000
      00004B4B4B00CCCC9900FFFF0000FFFFFF00FFFF0000FFFF0000008000000080
      00000080000000800000008000004B4B4B00000000004B4B4B00CCCC9900FFFF
      0000FFFFFF0000800000008000000080000000800000008000004B4B4B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FC720400FCF20400FCF20400FCF20400FCF20400FC720400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCFE0400FCFE0400FCFE0400FCFE
      0400FCFE04000000000000000000000000000000000000000000000000000000
      0000000000004B4B4B00CCCC9900FFFF0000FFFFFF0000800000008000000080
      000000800000008000004B4B4B0000000000000000004B4B4B0000800000CCCC
      9900FFFF0000FFFF0000008000000080000000800000008000004B4B4B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FC720400FCF20400FCF20400FCF20400FC72040000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FCFE04000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004B4B4B0000800000CCCC9900FFFF0000FFFF0000008000000080
      000000800000008000004B4B4B000000000000000000000000004B4B4B004B4B
      4B00CCCC9900FFFF0000CCCC9900008000004B4B4B004B4B4B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FC720400FCF20400FCF20400FC7204000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C5E0400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004B4B4B004B4B4B00CCCC9900FFFF0000CCCC99000080
      00004B4B4B004B4B4B0000000000000000000000000000000000000000000000
      00004B4B4B004B4B4B004B4B4B004B4B4B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FC720400FCF20400FC720400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005C5E0400000000005C5E040000000000FCFE0400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004B4B4B004B4B4B004B4B4B004B4B
      4B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FC72040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FCFE040000000000FCFE04000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001C8A
      CC001C8ACC008D8461008D8461008D8461008D8461008D8461008D8461008D84
      61008D8461008D8461008D846100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001C8ACC0070C6
      E80070C6E800C5BCA300F8EECF00F8EECF00F8EECF00F8EECF00F8EECF00F8EE
      CF00F8EECF00F5E6AF008D846100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      BB00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001C8ACC0080E9FA0080E9
      FA0080E9FA00C4BEAC00F8EECF00F5E6AF00F5E6AF00F5E6AF00F5E6AF00F5E6
      AF00F5E6AF00000000008D846100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      BB008484840084848400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C6008484840084848400C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001C8ACC0080E9FA0080E9
      FA0080E9FA00C4BEAC0000000000F8EECF00F5E6AF00F5E6AF00F5E6AF00F5E6
      AF00F5E6AF00F5E6AF008D846100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      BB008484840084848400FFFFBB00FFFFBB00FFFFBB00FFFFBB00FFFFBB00FFFF
      BB008484840084848400FFFFBB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001C8ACC0080E9FA0080E9
      FA0080E9FA00C4BEAC0000000000F5E6AF00F5E6AF00F5E6AF00F5E6AF00F5E6
      AF00F5E6AF00000000008D846100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001C8ACC00A3ECF900A3EC
      F90080E9FA00C4BEAC00F8F8F400F8EECF00F5E6AF00F8EECF00F5E6AF00F5E6
      AF00F5E6AF00F5E6AF008D846100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      BB00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      0000848484000000000000000000000000008484840000000000000000000000
      000000000000000000000000000000000000000000001C8ACC00A3ECF900A3EC
      F900A3ECF900C4BEAC00F8EECF00F8EECF00F5E6AF00F5E6AF00F5E6AF00F5E6
      AF00F5E6AF00000000008D846100000000000000000000000000000000006453
      0000645300006453000064530000645300006453000064530000645300000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      BB00FFFFBB00FFFFBB00FFFFBB00FFFFBB00FFFFBB00FFFFBB00FFFFBB00FFFF
      BB00FFFFBB00FFFFBB00FFFFBB00000000000000000000000000848484000000
      000000000000FFFF0000FFFF0000FFFF00000000000084848400000000000000
      000000000000000000000000000000000000000000001C8ACC00A3ECF900C9F2
      F800A3ECF900C4BEAC00F8F8F400F8F8F400F8F8F400F8EECF00F8EECF00F8EE
      CF0000000000F5E6AF008D846100000000000000000000000000000000006453
      0000FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600645300000000
      00000000000000000000000000000000000000000000A4A40000C6C6C6008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400848484000000000084848400000000008484
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000000000848484000000
      000000000000000000000000000000000000000000001C8ACC00C9F2F800C9F2
      F800C9F2F800C4BEAC00F8F8F400F8F8F400F8F8F400F8F8F400F8F8F400F8EE
      CF00C4BEAC00BAAA74008D846100000000000000000000000000000000006453
      0000FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00645300000000
      000000000000000000000000000000000000A4A40000A4A40000A4A400000000
      0000000000000000000084848400000000000000000000000000000000008484
      8400000000000000000000000000000000008484840000000000FFFFFF00FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000
      000000000000000000000000000000000000000000001C8ACC00C9F2F800F8F8
      F400C9F2F800C4BEAC00F8F8F400F8F8F400F8F8F400F8F8F400F8F8F400C4BE
      AC00BAAA7400F4D6440000000000000000006453000064530000645300006453
      0000FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600645300000000
      000000000000000000000000000000000000A4A4000000000000A4A40000A4A4
      0000000000000000000000000000848484008484840084848400848484000000
      00000000000000000000000000000000000000000000FFFFFF0084840000FFFF
      0000FFFF0000FFFF000084848400000000000000000000000000000000000000
      000000000000000000000000000000000000000000001C8ACC00C9F2F800F8F8
      F400C9F2F800C4BEAC00F8F8F400F8F8F400F8F8F400F8F8F400F8F8F400C5BC
      A300BAAA74001C8ACC00000000000000000064530000FFFFFF00C6C6C6006453
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00645300000000
      000000000000000000000000000000000000000000000000000000000000A4A4
      0000A4A400000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484000084840000FFFF
      0000FFFF0000FFFF000084848400FFFFFF00FFFFFF00FFFFFF00848484000000
      000000000000000000000000000000000000000000001C8ACC00C9F2F800F8F8
      F400F8F8F400C4BEAC00C4BEAC00C5BCA300C4BEAC00C5BCA300C4BEAC00C5BC
      A30070C6E8001C8ACC00000000000000000064530000FFFFFF00FFFFFF006453
      0000DCDC0000DCDC0000DCDC0000DCDC0000DCDC0000DCDC0000645300000000
      00000000000000000000000000000000000000000000A4A40000000000000000
      0000A4A40000A4A4000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084840000FFFFFF00FFFF
      0000FFFF0000FFFF000084848400848484008484840084848400848484000000
      000000000000000000000000000000000000000000001C8ACC00C9F2F800F8F8
      F40096BAC20096BAC20096BAC20096BAC20096BAC20096BAC20096BAC200C9F2
      F80070C6E8001C8ACC00000000000000000064530000FFFFFF00C6C6C6006453
      0000645300006453000064530000645300006453000064530000645300000000
      000000000000000000000000000000000000A4A40000A4A40000A4A400000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848400008484
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000000000848484000000
      000000000000000000000000000000000000000000001C8ACC00F8F8F400C5BC
      A300BAAA7400C5BCA300C5BCA300C5BCA300C5BCA300C5BCA300BAAA74000000
      000070C6E8001C8ACC00000000000000000064530000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00645300000000000000000000000000000000
      000000000000000000000000000000000000A4A4000000000000A4A40000A4A4
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000848400008484
      0000FFFFFF00FFFF0000FFFF0000FFFF00000000000084848400000000000000
      00000000000000000000000000000000000000000000000000001C8ACC0096BA
      C20074868C00C4BEAC00F8F8F400F8F8F400F8F8F400C5BCA30074868C0070C6
      E8001C8ACC0000000000000000000000000064530000DCDC0000DCDC0000DCDC
      0000DCDC0000DCDC0000DCDC0000645300000000000000000000000000000000
      000000000000000000008484840000000000000000000000000000000000A4A4
      0000A4A400000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000000000FFFF
      FF00848400008484000000000000000000008484840000000000000000000000
      0000000000000000000084848400000000000000000000000000000000001C8A
      CC001C8ACC008D84610074868C008D84610074868C008D8461001C8ACC001C8A
      CC00000000000000000000000000000000006453000064530000645300006453
      0000645300006453000064530000645300000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A4A40000A4A4000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000005B7000005B7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000005B7000005B7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000005B7000005B700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004020400040204000402
      0400040204000402040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000402040004020400040204000402
      0400040204000402040004020400040204000402040004020400040204000402
      040000000000000000000000000000000000000000000005B7000005B7000005
      B700000000000000000000000000000000000000000000000000000000000000
      00000005B7000005B70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004020400E4E20400E4E2
      0400E4E204000402040000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400E1E1
      00000000000000000000000000000000000004020400FCFEAC00FCFEAC00FCFE
      AC00FCFEAC00FCFEAC00FCFEAC00FCFEAC00FCFEAC00FCFEAC00FCFEAC000402
      040000000000000000000000000000000000000000000005B7000005B6000005
      B7000005B7000000000000000000000000000000000000000000000000000005
      B7000005B7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040004020400E4E20400E4E2
      0400E4E204000402040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      84008484840000000000000000000000000004020400FCFEAC00040204000402
      0400FCFEAC000402040004020400040204000402040004020400FCFEAC000402
      04000000000000000000000000000000000000000000000000000006D7000005
      BA000005B7000005B700000000000000000000000000000000000005B7000005
      B700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000040204000000000004020400040204000402
      0400040204000402040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400000000000000000004020400FCFEAC00FCFEAC00FCFE
      AC00FCFEAC00FCFEAC00FCFEAC00FCFEAC00FCFEAC00FCFEAC00FCFEAC000402
      0400000000000000000000000000000000000000000000000000000000000000
      00000005B7000005B7000005B600000000000005B6000005B7000005B7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004020400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000084848400000000000000
      00000000000084848400E1E100000000000004020400FCFEAC00040204000402
      0400FCFEAC000402040004020400040204000402040004020400FCFEAC000402
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000000005B6000006C7000006C7000006CE000005B400000000000000
      0000000000000000000000000000000000000000000004020400040204000402
      0400040204000402040000000000000000000000000004020400040204000402
      0400040204000402040000000000000000000000000000000000000000000000
      00008484840000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000084848400848484008484840004020400FCFEAC00FCFEAC00FCFE
      AC00FCFEAC00FCFEAC00FCFEAC00FCFEAC00FCFEAC00FCFEAC00FCFEAC000402
      0400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000006C1000005C1000006DA0000000000000000000000
      0000000000000000000000000000000000000000000004020400E4E20400E4E2
      0400E4E204000402040000000000000000000000000004020400E4E20400E4E2
      0400E4E204000402040000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000004020400FCFEAC00FCFEAC00FCFE
      AC00FCFEAC00FCFEAC00FCFEAC00FCFEAC0004020400FCFEAC00FCFEAC000402
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000000005B6000006D7000006CE000006DA000006E900000000000000
      0000000000000000000000000000000000000000000004020400E4E20400E4E2
      0400E4E204000402040004020400040204000402040004020400E4E20400E4E2
      0400E4E204000402040000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000084848400000000000000000004020400FCFEAC00040204000402
      0400FCFEAC00FCFEAC00FCFEAC0004020400D4D2AC0004020400FCFEAC000402
      0400000000000000000000000000000000000000000000000000000000000000
      00000006E5000006DA000006D30000000000000000000006E5000006EF000000
      0000000000000000000000000000000000000000000004020400E4E20400E4E2
      0400E4E204000402040000000000000000000000000004020400040204000402
      0400040204000402040000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000084848400E1E100000000000004020400FCFEAC0004020400D4D2
      AC0004020400FCFEAC0004020400D4D2AC0004020400D4D2AC00040204000402
      04000402040000000000AC960400AC9604000000000000000000000000000006
      F8000006DA000006EF00000000000000000000000000000000000006F8000006
      F600000000000000000000000000000000000000000004020400040204000402
      0400040204000402040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C8C800000000000000000000FFFFFF00FFFFFF0000000000000000000000
      00000000000084848400848484008484840004020400FCFEAC00FCFEAC000402
      0400D4D2AC0004020400D4D2AC0004020400D4D2AC0004020400D4D2AC00D4D2
      AC00D4D2AC0004020400AC960400AC96040000000000000000000006F6000006
      F6000006F8000000000000000000000000000000000000000000000000000006
      F6000006F6000000000000000000000000000000000000000000000000000000
      0000000000000000000004020400000000000000000004020400040204000402
      040004020400040204000000000000000000000000000000000000000000C8C8
      0000FFFFFF000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000402040004020400040204000402
      040004020400D4D2AC0004020400D4D2AC0004020400D4D2AC00D4D2AC00D4D2
      AC00D4D2AC00D4D2AC00AC960400AC960400000000000006F6000006F6000006
      F600000000000000000000000000000000000000000000000000000000000000
      0000000000000006F60000000000000000000000000000000000000000000000
      0000000000000000000000000000040204000000000004020400E4E20400E4E2
      0400E4E204000402040000000000000000000000000000000000C8C80000FFFF
      FF0000000000000000000000000000000000000000000000000084848400E1E1
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000004020400D4D2AC0004020400D4D2AC00D4D2AC00D4D2AC00D4D2
      AC00D4D2AC00D4D2AC00AC960400AC9604000006F6000006F6000006F6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040004020400E4E20400E4E2
      0400E4E2040004020400000000000000000000000000C8C80000FFFFFF009696
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000004020400D4D2AC00D4D2AC00D4D2AC00D4D2AC00D4D2
      AC00D4D2AC0004020400AC960400AC9604000006F6000006F600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004020400040204000402
      04000402040004020400000000000000000000000000FFFFFF00969600000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000040204000402040004020400040204000402
      04000402040000000000AC960400AC9604000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E1E1E10000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      00000000000000FFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF008484840000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF00FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      000000000000000000000000000000FFFF00FFFFFF00000000000000000000FF
      FF00FFFFFF00000000000000000000FFFF000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF0000FFFF000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000008484840084848400848484000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF0084848400000000000000000000FF
      FF00FFFFFF008484840000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00000000000000
      00000000000084848400FFFFFF00000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF0084848400848484008484840000FF
      FF00FFFFFF008484840084848400848484000000000000000000000000000000
      000000000000C8C8000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000C8C8000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000C8C8000000000000FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000C8C8000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000C8C80000C8C8000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      000000000000C8C80000C8C8000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      000000000000C8C80000C8C8000000000000FFFFFF0000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000C8C80000C8C8000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000008484840000000000000000000000000000000000000000000000
      000084848400C8C80000C8C80000C8C8000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000084848400C8C80000C8C80000C8C8000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000084848400C8C80000C8C80000C8C8000000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000084848400C8C80000C8C80000C8C8000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00000000000000000000000000000000000000
      000084848400FFFFFF00C8C80000C8C80000C8C8000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      000084848400FFFFFF00C8C80000C8C80000C8C8000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      000084848400FFFFFF00C8C80000C8C80000C8C8000000000000FFFFFF000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      000084848400FFFFFF00C8C80000C8C80000C8C8000000000000FFFFFF0000FF
      FF00FFFFFF008484840084848400848484000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
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
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008486
      84000402040004020400FCFE0400FCFE0400FCFEFC00FCFE0400FC0204000402
      0400040204008486840000000000000000000000000000000000000000008486
      8400040204000402040004FEFC0004FEFC00FCFEFC0004FEFC000402FC000402
      0400040204008486840000000000000000008486840004020400040204000402
      0400040204000402040004020400040204000402040004020400040204000402
      0400040204000402040004020400000000008486840004020400040204000402
      0400040204000402040004020400040204000402040004020400040204000402
      0400040204000402040004020400000000000000000084868400040204000402
      0400FCFE04000402FC00FCFE0400FCFE0400C4C6C400FC020400FCFE04000402
      FC00FCFE04000402040004020400848684000000000084868400040204000402
      040004FEFC00FC02040004FEFC0004FEFC00C4C6C4000402FC0004FEFC00FC02
      040004FEFC0004020400040204008486840084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00040204000000000084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC0004020400000000000000000004020400FCFE0400FCFE
      0400FCFE04000402FC00FCFE0400FCFE0400FCFEFC00FCFE0400FC0204000402
      FC00FC020400FCFE0400FC02040004020400000000000402040004FEFC0004FE
      FC0004FEFC00FC02040004FEFC0004FEFC00FCFEFC0004FEFC000402FC00FC02
      04000402FC0004FEFC000402FC000402040084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C6C400040204000000000084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C6C40004020400000000000000000004020400FCFE0400FCFE
      0400FCFE04000402FC00FCFE0400FCFE0400C4C6C400FC020400FCFE04000402
      FC00FCFE0400FC020400FCFE040004020400000000000402040004FEFC0004FE
      FC0004FEFC00FC02040004FEFC0004FEFC00C4C6C4000402FC0004FEFC00FC02
      040004FEFC000402FC0004FEFC000402040084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00040204000000000084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC0004020400000000000000000004020400FCFE0400FCFE
      0400FCFE04000402FC00FCFE0400FCFE0400FCFEFC00FCFE0400FC0204000402
      FC00FC020400FCFE0400FC02040004020400000000000402040004FEFC0004FE
      FC0004FEFC00FC02040004FEFC0004FEFC00FCFEFC0004FEFC000402FC00FC02
      04000402FC0004FEFC000402FC000402040084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C6C400040204000000000084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C6C40004020400000000000000000004020400FCFE0400FCFE
      0400FCFE04000402FC00FCFE0400FCFE0400C4C6C400FC020400FCFE04000402
      FC00FCFE0400FC020400FCFE040004020400000000000402040004FEFC0004FE
      FC0004FEFC00FC02040004FEFC0004FEFC00C4C6C4000402FC0004FEFC00FC02
      040004FEFC000402FC0004FEFC000402040084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00040204000000000084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC0004020400000000000000000004020400FCFE0400FCFE
      0400FCFE04000402FC008486840084868400FCFEFC0084868400848684000402
      FC00FC020400FCFE0400FC02040004020400000000000402040004FEFC0004FE
      FC0004FEFC00FC0204008486840084868400FCFEFC008486840084868400FC02
      04000402FC0004FEFC000402FC000402040084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C6C400040204000000000084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C6C40004020400000000000000000004020400FCFE0400FCFE
      0400848684000402FC00FCFE0400FCFEFC00FCFE0400FCFEFC00FCFE04000402
      FC0084868400FC020400FCFE040004020400000000000402040004FEFC0004FE
      FC0084868400FC02040004FEFC00FCFEFC0004FEFC00FCFEFC0004FEFC00FC02
      0400848684000402FC0004FEFC000402040084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00040204000000000084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC0004020400000000000000000004020400848684008486
      8400FCFEFC00FCFE04000402FC00FCFE0400FCFEFC00FCFE04000402FC00FCFE
      0400FCFEFC008486840084868400040204000000000004020400848684008486
      8400FCFEFC0004FEFC00FC02040004FEFC00FCFEFC0004FEFC00FC02040004FE
      FC00FCFEFC0084868400848684000402040084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C6C400040204000000000084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C6C40004020400000000000000000004020400FCFE0400FCFE
      FC00FCFE0400FCFEFC00FCFE04000402FC000402FC000402FC00FCFE0400FCFE
      FC00FCFE0400FCFEFC00FCFE040004020400000000000402040004FEFC00FCFE
      FC0004FEFC00FCFEFC0004FEFC00FC020400FC020400FC02040004FEFC00FCFE
      FC0004FEFC00FCFEFC0004FEFC000402040084868400FCFEFC00FCFEFC00FCFE
      FC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFE
      FC00FCFEFC00FCFEFC00040204000000000084868400FCFEFC00FCFEFC00FCFE
      FC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFE
      FC00FCFEFC00FCFEFC0004020400000000000000000084868400040204000402
      0400FCFEFC00FCFE04000402FC00FCFEFC00FCFE0400FCFEFC000402FC00FCFE
      0400FCFEFC000402040004020400848684000000000084868400040204000402
      0400FCFEFC0004FEFC00FC020400FCFEFC0004FEFC00FCFEFC00FC02040004FE
      FC00FCFEFC0004020400040204008486840084868400B3B30000B3B30000B3B3
      0000B3B30000B3B30000B3B30000B3B30000B3B30000B3B30000B3B30000B3B3
      0000B3B30000B3B3000004020400000000008486840004D6D40004D6D40004D6
      D40004D6D40004D6D40004D6D40004D6D40004D6D40004D6D40004D6D40004D6
      D40004D6D40004D6D40004020400000000000000000000000000000000008486
      84000402040004020400FCFEFC00FCFE0400FCFEFC00FCFE0400FCFEFC000402
      0400040204008486840000000000000000000000000000000000000000008486
      84000402040004020400FCFEFC0004FEFC00FCFEFC0004FEFC00FCFEFC000402
      04000402040084868400000000000000000084868400FCFEFC00B3B30000B3B3
      0000B3B30000B3B30000B3B30000B3B30000B3B30000B3B30000B3B30000FCFE
      FC00B3B30000FCFEFC00040204000000000084868400FCFEFC0004D6D40004D6
      D40004D6D40004D6D40004D6D40004D6D40004D6D40004D6D40004D6D400FCFE
      FC0004D6D400FCFEFC0004020400000000000000000000000000000000000000
      000000000000848684000402040004020400FCFE040004020400040204008486
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000084868400040204000402040004FEFC0004020400040204008486
      8400000000000000000000000000000000008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400000000008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000848684000402040084868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848684000402040084868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000800000000100010000000000000400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF7FFFFFFFFF0000FF47000CFFFF0000
      FF070008FFDD0000FF470001FFCD0000FF78006380050000F82000C380010000
      F02801EBFFCD0000F00F016BBBDD0000F0080023B3FF0000F0000067A0010000
      E028000F80010000C047000FB3FF00008307000FBBFF000007C7005FFFFF0000
      0FFF003FFFFF00001FFF007FFFFF0000FFFF0007FFBFFFFFFE1F0007FF1FFE3F
      FC5F00070000F81FFC7F00070000E00FFC3F000700008007FC3F000700000003
      FC3F7FFF00000001FE1F700000000000FF1F600000000001FD1FB00000008001
      FC1FC0000000C001FFFFF0000000E000FE1FE0000000F000FE1FF0008001F803
      FE1FF00080FFFC0FFFFFF03FC1FFFE3FFFFFFFFFFFFFFFFF3C03F800F9FFFC1F
      3001F800F0FFFC0F0000F000F07FFC070000C000F03FFC0700008000F01FFC07
      00008000F00FFE0700000000F007FF0700000000F007FFEF30000000F00FFFC7
      F000000FF01FFF83F000801FF03FFF07F801801FF07FFFDFF801C03FF0FFFFBF
      FC03F0FFF1FFFABFFF0FFFFFFBFFFAFFE001EDB6C000EDB6C001EAAAC000EAAA
      8005EAAAC000EAAA8201EDB6C000EDB68205FFFFC000FFFF8001FFFFC000F07F
      8005E01FC000C03F8009E01F8000801F8001E01F1C0F001F800300194E1F0019
      80030010E7FF001080030019B3FF0019800300191FFF0019801300F94FFF0039
      C00700E1E7FF8061E00F00FFF3FFC1FFFFFCFFFFFF7FFFFF9FF9FF83FF47000F
      8FF3FF83FF07000F87E7FF03FF47000FC3CFFE83FF78000FF11FFDFFF820000F
      F83F8383F028000FFC7F8383F00F000FF83F8003F008000FF19F8383F0000004
      E3CF83FFE0280000C7E7FD83C04700008FFBFE838307F8001FFFFF0307C7FC00
      3FFFFF830FFFFE04FFFFFFFF1FFFFFFFF800F800F800F800F800F800F800F800
      F800F800F800F800F800F800F800F800F800F800F800F800F800F800F800F800
      F800F800F800F800F000F000F000F000F000F000F000F000E000E000E000E000
      E000E000E000E000C07FC07FC07FC07F81FF81FF81FF81FF07FF07FF07FF07FF
      0FFF0FFF0FFF0FFF9FFF9FFF9FFF9FFFFE3FFE3FFFFFFFFFF80FF80FFFFFFFFF
      E003E00300010001800080000001000180008000000100018000800000010001
      8000800000010001800080000001000180008000000100018000800000010001
      800080000001000180008000000100018000800000010001E003E00300010001
      F80FF80F00010001FE3FFE3FFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object pm_SourceSnoop: TPopupMenu
    AutoPopup = False
    Left = 72
    Top = 72
    object mi_FindSelection: TMenuItem
      Caption = 'Find selection'
      OnClick = mi_FindSelectionClick
    end
    object mi_CopyToCliptboard: TMenuItem
      Action = ac_CopySelection
    end
    object mi_SelectAll: TMenuItem
      Action = ac_SelectAll
    end
    object mi_N17: TMenuItem
      Caption = '-'
    end
    object mi_ClearHilight: TMenuItem
      Caption = 'Clear hilight'
      Hint = 'Clear hilight|Remove the background hilight'
      OnClick = mi_ClearHilightClick
    end
    object mi_N16: TMenuItem
      Caption = '-'
    end
    object mi_saveToFile: TMenuItem
      Action = ac_SaveToRTF
    end
  end
  object sd_SaveToRTF: TSaveDialog
    DefaultExt = '*.rtf'
    Filter = 'Rich Text Files|*.rtf|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 8
    Top = 200
  end
  object tmr_InlineSearch: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmr_InlineSearchTimer
    Left = 40
    Top = 168
  end
  object EXEC: TDdeServerConv
    Left = 8
    Top = 240
  end
  object cmd: TDdeServerItem
    ServerConv = EXEC
    Lines.Strings = (
      '')
    OnPokeData = cmdPokeData
    Left = 40
    Top = 240
  end
  object pm_Log: TPopupMenu
    OnPopup = pm_LogPopup
    Left = 104
    Top = 72
    object mi_OpenClass1: TMenuItem
      Caption = 'Open class'
      Default = True
      OnClick = lb_LogDblClick
    end
    object mi_SaveToFile1: TMenuItem
      Caption = 'Save to file'
      OnClick = mi_SaveToFile1Click
    end
    object mi_SortList: TMenuItem
      Caption = 'Sort'
      OnClick = mi_SortListClick
    end
  end
  object sd_SaveLog: TSaveDialog
    DefaultExt = '*.log'
    Filter = 'Log Files|*.log|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save log file'
    Left = 40
    Top = 200
  end
end
