object frm_UnCodeX: Tfrm_UnCodeX
  Left = 217
  Top = 117
  HelpType = htKeyword
  ActiveControl = tv_Classes
  AutoScroll = False
  ClientHeight = 597
  ClientWidth = 669
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = mm_Main
  OldCreateOrder = False
  Position = poDefault
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
    Height = 532
    Cursor = crHSplit
    AutoSnap = False
    Visible = False
  end
  object splTop: TSplitter
    Left = 0
    Top = 30
    Width = 669
    Height = 4
    Cursor = crVSplit
    Align = alTop
    AutoSnap = False
    Visible = False
  end
  object splBottom: TSplitter
    Left = 0
    Top = 566
    Width = 669
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Visible = False
  end
  object splRight: TSplitter
    Left = 665
    Top = 34
    Width = 4
    Height = 532
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
    Width = 661
    Height = 532
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
    HelpKeyword = 'window_main.html#packagetree'
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
    Top = 578
    Width = 669
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
    Top = 570
    Width = 669
    Height = 8
    Align = alBottom
    Min = 0
    Max = 100
    TabOrder = 4
  end
  object tb_Tools: TToolBar
    Left = 0
    Top = 0
    Width = 669
    Height = 30
    HelpType = htKeyword
    HelpKeyword = 'window_main.html#toolbar'
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
    object btn_CProp: TToolButton
      Left = 23
      Top = 2
      Action = ac_Tags
    end
    object btn_PProp: TToolButton
      Left = 46
      Top = 2
      Action = ac_PackageProps
    end
    object tb_Sep4: TToolButton
      Left = 69
      Top = 2
      Width = 8
      ImageIndex = 9
      Style = tbsSeparator
    end
    object btn_FindClass: TToolButton
      Left = 77
      Top = 2
      Action = ac_FindClass
    end
    object tb_FullTextSearch: TToolButton
      Left = 100
      Top = 2
      Action = ac_FullTextSearch
    end
    object btn_Sep6: TToolButton
      Left = 123
      Top = 2
      Width = 8
      Caption = 'btn_Sep6'
      ImageIndex = 9
      Style = tbsSeparator
    end
    object tb_FindNext: TToolButton
      Left = 131
      Top = 2
      Action = ac_FindNext
    end
    object btn_Sep1: TToolButton
      Left = 154
      Top = 2
      Width = 8
      Caption = 'btn_Sep1'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object btn_RebuildTree: TToolButton
      Left = 162
      Top = 2
      Action = ac_RecreateTree
    end
    object btn_FindOrphan: TToolButton
      Left = 185
      Top = 2
      Action = ac_FindOrphans
    end
    object btn_AnalyseAll: TToolButton
      Left = 208
      Top = 2
      Action = ac_AnalyseAll
    end
    object btn_AnalyseModified: TToolButton
      Left = 231
      Top = 2
      Action = ac_AnalyseModified
    end
    object btn_Sep2: TToolButton
      Left = 254
      Top = 2
      Width = 8
      Caption = 'btn_Sep2'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object btn_CreateHTML: TToolButton
      Left = 262
      Top = 2
      Action = ac_CreateHTMLfiles
    end
    object btn_OpenOutput: TToolButton
      Left = 285
      Top = 2
      Action = ac_OpenOutput
    end
    object btn_HTMLHelp: TToolButton
      Left = 308
      Top = 2
      Action = ac_HTMLHelp
    end
    object btn_Sep5: TToolButton
      Left = 331
      Top = 2
      Width = 8
      Caption = 'btn_Sep5'
      ImageIndex = 11
      Style = tbsSeparator
    end
    object tb_RunServer: TToolButton
      Left = 339
      Top = 2
      Action = ac_RunServer
    end
    object tb_JoinServer: TToolButton
      Left = 362
      Top = 2
      Action = ac_JoinServer
    end
    object btn_Sep3: TToolButton
      Left = 385
      Top = 2
      Width = 8
      Caption = 'btn_Sep3'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object btn_Settings: TToolButton
      Left = 393
      Top = 2
      Action = ac_Settings
    end
    object btn_Sep4: TToolButton
      Left = 416
      Top = 2
      Width = 8
      Caption = 'btn_Sep4'
      ImageIndex = 5
      Style = tbsSeparator
    end
    object btn_Abort: TToolButton
      Left = 424
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
    HelpKeyword = 'window_main.html#sourcesnoop'
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
    WordWrap = False
    OnEndDock = re_SourceSnoopEndDock
    OnMouseMove = re_SourceSnoopMouseMove
    OnMouseUp = re_SourceSnoopMouseUp
    GutterWidth = 50
    HighlightColor = clYellow
  end
  object tv_Classes: TTreeView
    Left = 108
    Top = 70
    Width = 173
    Height = 243
    HelpType = htKeyword
    HelpKeyword = 'window_main.html#classtree'
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
    Width = 669
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
    Top = 570
    Width = 669
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
    Height = 532
    Align = alLeft
    BevelOuter = bvNone
    DockSite = True
    TabOrder = 7
    OnDockDrop = dckLeftDockDrop
    OnUnDock = dckLeftUnDock
  end
  object dckRight: TPanel
    Left = 669
    Top = 34
    Width = 0
    Height = 532
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
    HelpKeyword = 'window_main.html#log'
    Style = lbOwnerDrawFixed
    DragKind = dkDock
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 18
    ParentFont = False
    PopupMenu = pm_Log
    TabOrder = 11
    OnClick = lb_LogClick
    OnDblClick = lb_LogDblClick
    OnDrawItem = lb_LogDrawItem
  end
  inline fr_Props: Tfr_Properties
    Left = 408
    Top = 88
    Width = 193
    Height = 272
    HelpType = htKeyword
    HelpKeyword = 'window_tags.html'
    DragKind = dkDock
    TabOrder = 12
    inherited bvl_Nothing: TBevel
      Width = 193
    end
    inherited lv_Properties: TListView
      Width = 193
      HelpType = htKeyword
      HelpKeyword = 'window_tags.html'
    end
    inherited pnl_Ctrls: TPanel
      Width = 193
      inherited ed_InheritanceLevel: TEdit
        HelpType = htKeyword
        HelpKeyword = 'window_tags.html'
      end
    end
    inherited btn_ShowBar: TBitBtn
      HelpType = htKeyword
      HelpKeyword = 'window_tags.html'
    end
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
      object mi_FindNew: TMenuItem
        Action = ac_FindNewClasses
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
    object mi_Browse: TMenuItem
      AutoHotkeys = maManual
      AutoLineReduction = maAutomatic
      Caption = 'Browse history'
      Enabled = False
      Hint = 'Past viewed lines'
      Visible = False
    end
    object mi_Bookmarks: TMenuItem
      Caption = 'Bookmarks'
      Visible = False
      object mi_ManageBookmarks: TMenuItem
        Caption = 'Manage bookmarks'
      end
      object mi_NB1: TMenuItem
        Caption = '-'
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
      Caption = 'Launch Game'
      object mi_Startserver: TMenuItem
        Action = ac_RunServer
      end
      object mi_Joinserver: TMenuItem
        Action = ac_JoinServer
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mi_Run: TMenuItem
        Action = ac_Run
      end
      object mi_RunPresets: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Presets'
        Visible = False
      end
    end
    object mi_Output: TMenuItem
      Caption = 'Plug-ins'
      object mi_Refresh: TMenuItem
        Action = ac_PluginRefresh
      end
      object mi_PascalScript: TMenuItem
        Action = ac_PSEditor
      end
      object mi_PluginDiv1: TMenuItem
        Caption = '-'
      end
      object mi_PluginDiv2: TMenuItem
        Caption = '-'
      end
    end
    object mi_HelpMenu: TMenuItem
      Caption = 'Help'
      object mi_Help2: TMenuItem
        Caption = 'Help'
        ImageIndex = 23
        OnClick = mi_Help2Click
      end
      object mi_N31: TMenuItem
        Caption = '-'
      end
      object mi_License: TMenuItem
        Action = ac_License
      end
      object mi_Donate: TMenuItem
        Caption = 'Donate!'
        OnClick = mi_DonateClick
      end
      object mi_N21: TMenuItem
        Caption = '-'
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
      Caption = 'Plug-ins'
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
      Checked = True
      OnExecute = ac_VSaveSizeExecute
    end
    object ac_VSavePosition: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Save position'
      Checked = True
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
      Caption = 'Dock on the right'
      ShortCut = 49191
      OnExecute = ac_VTRightExecute
    end
    object ac_VTLeft: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Dock on the left'
      ShortCut = 49189
      OnExecute = ac_VTLeftExecute
    end
    object ac_SourceSnoop: TAction
      Category = 'Class Tree'
      Caption = 'Reload source snoop'
      ImageIndex = 28
      OnExecute = ac_SourceSnoopExecute
    end
    object ac_VSourceSnoop: TAction
      Category = 'Layout'
      AutoCheck = True
      Caption = 'Source Preview'
      Checked = True
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
      ImageIndex = 29
      OnExecute = ac_CreateSubClassExecute
    end
    object ac_DeleteClass: TAction
      Category = 'Class Tree'
      Caption = 'Delete class'
      ImageIndex = 30
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
      ImageIndex = 27
      OnExecute = ac_PackagePropsExecute
    end
    object ac_DefProps: TAction
      Category = 'Class Tree'
      Caption = 'Defaultproperties'
      Hint = 'Show this class'#39' defaultproperties values'
      OnExecute = ac_DefPropsExecute
    end
    object ac_Run: TAction
      Category = 'Game Server'
      Caption = 'Run...'
      Hint = 'Prompt for run arguments'
      ShortCut = 16472
      OnExecute = ac_RunExecute
    end
    object ac_PSEditor: TAction
      Category = 'Program'
      Caption = 'PascalScript editor'
      ImageIndex = 31
      ShortCut = 16464
      OnExecute = ac_PSEditorExecute
    end
    object ac_PluginRefresh: TAction
      Category = 'Program'
      Caption = 'Refresh plug-ins'
      Hint = 'Refresh the plug-in list'
      OnExecute = ac_PluginRefreshExecute
    end
    object ac_FindNewClasses: TAction
      Category = 'Class Tree'
      Caption = 'Find new classes'
      OnExecute = ac_FindNewClassesExecute
    end
    object ac_GoToReplication: TAction
      Category = 'Source Snoop'
      Caption = 'Replication'
      Enabled = False
      Hint = 'Go to the replication block'
      OnExecute = ac_GoToReplicationExecute
    end
    object ac_GoToDefaultproperties: TAction
      Category = 'Source Snoop'
      Caption = 'Defaultproperties'
      Enabled = False
      Hint = 'Go to the defaultproperties block'
      OnExecute = ac_GoToDefaultpropertiesExecute
    end
  end
  object il_Small: TImageList
    Left = 40
    Top = 104
    Bitmap = {
      494C010121002200040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009000000001002000000000000090
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005E5E5E00252425002524250025242500252425005E5E5E00FC3E
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005E5E
      5E0025242500403F4000403F4000403F40002524250025242500FC720400FCD2
      0400FC3E04000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005E5E5E002524
      25007576750075767500757675005E5E5E005E5E5E00403F4000FC720400FCD2
      0400FCB20400FC3E040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075767500403F40002524
      2500403F40007576750075767500757675005E5E5E00403F4000FC720400FCD2
      0400FCD20400FCD20400FC3E0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000403F4000403F4000403F
      4000403F4000403F40008C8A8C00757675007576750025242500FC720400FCF2
      0400FCD20400FCF20400FCD20400FC7204000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8A8C005E5E5E00ACAEAC007576
      75009B9C9B0075767500757675008C8A8C007576750025242500FC720400FCF2
      0400FCF20400FCD20400FC7204005E5E5E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005E5E5E008C8A8C00D5D3D500BEBE
      BE00BEBEBE009B9C9B005E5E5E009B9C9B008C8A8C0025242500FC720400FCF2
      0400FCF20400FC72040025242500403F40000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005E5E5E009B9C9B00D5D3D500D5D3
      D500BEBEBE00BEBEBE005E5E5E009B9C9B009B9C9B0025242500FC720400FCF2
      0400FC7204005E5E5E0025242500252425000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005E5E5E009B9C9B00D5D3D500BEBE
      BE00D5D3D500BEBEBE005E5E5E00ACAEAC009B9C9B00403F4000FC720400FC72
      0400757675005E5E5E00403F4000252425000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000757675009B9C9B00D5D3D500ACAE
      AC00D5D3D500BEBEBE0075767500BEBEBE00ACAEAC00403F400025242500403F
      4000757675007576750025242500403F40000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8A8C0075767500F0F0F0007576
      75008C8A8C009B9C9B005E5E5E00757675008C8A8C00403F4000403F4000403F
      40005E5E5E005E5E5E0025242500757675000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075767500BEBEBE00F0F0
      F0008C8A8C007576750075767500757675005E5E5E005E5E5E005E5E5E005E5E
      5E00403F4000403F400025242500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C8A8C0075767500D5D3
      D500F0F0F000F0F0F000F0F0F000D5D3D500D5D3D500BEBEBE00BEBEBE00ACAE
      AC0075767500403F40008C8A8C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000757675007576
      7500BEBEBE00F0F0F000F0F0F000F0F0F000D5D3D500D5D3D500BEBEBE007576
      7500403F40005E5E5E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009B9C
      9B005E5E5E00757675008C8A8C009B9C9B009B9C9B00757675005E5E5E00403F
      40009B9C9B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009B9C9B00757675005E5E5E005E5E5E00757675008C8A8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000040204000402
      0400040204000402040004020400040204000402040004020400040204000402
      0400040204000402040004020400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000686868001E1E1E001E1E1E0016161600101010003A3A3A000000
      000000000000000000000000000000000000000000000000000084868400C4C6
      C400C4C6C400C4C6C400C4C6C400C4C6C400C4C6C400C4C6C400C4C6C400C4C6
      C400C4C6C400C4C6C400040204000000000000000000FCFEFC0000000000FCFE
      FC0000000000FCFEFC0000000000FCFEFC0000000000FCFEFC0000000000FCFE
      FC0000000000FCFEFC0000000000FCFEFC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000406B4000000000000000000000000006565
      65002C2C2C0030303000414141003A3A3A00303030002C2C2C00161616001010
      100030303000000000000000000000000000000000000000000084868400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400C4C6C4000402040000000000000000000000000004FEFC000482
      8400048284000482840004828400048284000482840004828400048284000482
      8400048284000482840004828400000000008486840004020400040204000402
      040004020400040204000406B4000406BC000402040004020400040204000402
      0400040204000406B4000406BC000000000000000000000000005E5E5E003A3A
      3A00656565008080800072727200656565005E5E5E004C4C4C003A3A3A002C2C
      2C0010101000161616000000000000000000000000000000000084868400FCFE
      FC00FCFEFC00C4C6C400FCFEFC00C4820400C4820400C4820400C4820400C482
      0400FCFEFC00C4C6C400040204000000000000000000FCFEFC0004FEFC00FCFE
      FC00C4C2C400FCFEFC00C4C2C400FCFEFC00C4C2C400FCFEFC00C4C2C400FCFE
      FC00C4C2C400FCFEFC0004828400FCFEFC0084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC000406B4000406B400C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C4000406B4000402040000000000000000007E7E7E003A3A3A004141
      4100535353007E7E7E007E7E7E0072727200656565004C4C4C002C2C2C002222
      22001E1E1E00101010003030300000000000000000000000000084868400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400C4C6C4000402040000000000000000000000000004FEFC00FCFE
      FC00FCFEFC00C4C2C400FCFEFC00C4C2C400FCFEFC00C4C2C400FCFEFC00C4C2
      C400FCFEFC00C4C2C400048284000000000084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C4000406DC000406BC000406B400C4C6C400FCFEFC00C4C6
      C4000406BC00C4C6C4000402040000000000000000004C4C4C00656565003A3A
      3A003A3A3A00414141008080800080808000727272002C2C2C001E1E1E002C2C
      2C0030303000222222001010100000000000000000000000000084868400FCFE
      FC00FCFEFC00C4820400C4820400C4820400C4820400C4820400C4820400C482
      0400FCFEFC00C4C6C400040204000000000000000000FCFEFC0004FEFC00FCFE
      FC00C4C2C400FCFEFC00C4C2C400FCFEFC00C4C6C400FCFEFC00C4C2C400FCFE
      FC00C4C2C400FCFEFC0004828400FCFEFC0084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC000406B4000406CC000406CC000406
      B400C4C6C400FCFEFC0004020400000000009D9D9D0053535300BCBCBC006868
      68007272720080808000727272008C8C8C00808080002C2C2C00222222003A3A
      3A004C4C4C0041414100161616003A3A3A00000000000000000084868400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400C4C6C4000402040000000000000000000000000004FEFC00FCFE
      FC00FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C2C400048284000000000084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC000406C4000406DC00C4C6
      C400FCFEFC00C4C6C40004020400000000007E7E7E0072727200D3D3D300C8C8
      C800BCBCBC00B1B1B1005E5E5E009D9D9D008C8C8C002C2C2C00222222004141
      41005E5E5E004C4C4C002C2C2C0010101000000000000000000084868400FCFE
      FC00FCFEFC00C4C6C400FCFEFC00C4820400C4820400C4820400C4820400C482
      0400FCFEFC00C4C6C400040204000000000000000000FCFEFC0004FEFC00FCFE
      FC00C4C2C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C2C400FCFEFC0004828400FCFEFC0084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC000406B4000406D4000406D4000406
      EC00C4C6C400FCFEFC0004020400000000005E5E5E009D9D9D00DEDEDE00D3D3
      D300C8C8C800BCBCBC0065656500A2A2A20098989800303030002C2C2C004C4C
      4C00656565005E5E5E003030300016161600000000000000000084868400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400C4C6C4000402040000000000000000000000000004FEFC00FCFE
      FC00FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C2C400048284000000000084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C400FCFEFC000406FC000406EC00C4C6C400FCFEFC00C4C6
      C4000406F400C4C6C4000402040000000000656565009D9D9D00E8E8E800BCBC
      BC00D3D3D300C8C8C8007E7E7E00B1B1B100A2A2A20030303000303030005353
      530072727200656565003A3A3A001E1E1E00000000000000000084868400FCFE
      FC00FCFEFC00C4C6C400FCFEFC00C4820400C4820400C4820400C4820400C482
      0400FCFEFC00C4C6C400040204000000000000000000FCFEFC0004FEFC00FCFE
      FC00C4C2C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C2C400FCFEFC0004828400FCFEFC0084868400FCFEFC00C4C6C400FCFE
      FC00C4C6C400FCFEFC000406F4000406F400C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C4000406F40004020400000000008C8C8C0080808000F2F2F2009898
      9800C8C8C800D3D3D3008C8C8C00BCBCBC00B1B1B1003A3A3A003A3A3A005E5E
      5E008080800072727200414141001E1E1E00000000000000000084868400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFE
      FC00C4C6C400C4C6C4000402040000000000000000000000000004FEFC00A4A6
      0400A4A60400A4A60400A4A60400A4A60400A4A60400A4A60400A4A60400A4A6
      0400A4A60400A4A60400048284000000000084868400FCFEFC00FCFEFC00C4C6
      C400FCFEFC00C4C6C4000406F4000406FC00FCFEFC00C4C6C400FCFEFC00C4C6
      C400FCFEFC00C4C6C4000406F40000000000A8A8A80065656500E8E8E800C8C8
      C80065656500727272005E5E5E0065656500656565003A3A3A003A3A3A004141
      410041414100656565003030300068686800000000000000000084868400FCFE
      FC00FCFEFC00C4820400C4820400C4820400C4820400C4820400FCFEFC000402
      04000402040004020400040204000000000000000000FCFEFC0004FEFC00FCFE
      FC00A4A60400A4A60400A4A60400A4A60400A4A60400A4A60400A4A60400A4A6
      0400A4A60400FCFEFC0004828400FCFEFC0084868400FCFEFC00FCFEFC00FCFE
      FC00FCFEFC000406F400FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFE
      FC00FCFEFC00FCFEFC000402040000000000000000006868680098989800FAFA
      FA00DEDEDE00C8C8C800B1B1B100B1B1B100A8A8A800A2A2A200989898008C8C
      8C00808080005E5E5E002C2C2C0000000000000000000000000084868400FCFE
      FC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400FCFEFC00C4C6C400C4C6
      C400FCFEFC00848684000000000000000000000000000000000004FEFC0004FE
      FC0004FEFC0004FEFC0004FEFC0004FEFC0004FEFC0004FEFC0004FEFC0004FE
      FC0004FEFC0004FEFC0004FEFC000000000084868400B4B20400B4B20400B4B2
      0400B4B20400B4B20400B4B20400B4B20400B4B20400B4B20400B4B20400B4B2
      0400B4B20400B4B204000402040000000000000000000000000065656500C8C8
      C800FAFAFA00F2F2F200E8E8E800DEDEDE00D3D3D300C8C8C800BCBCBC00B1B1
      B1008C8C8C00303030007272720000000000000000000000000084868400FCFE
      FC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00FCFEFC00C4C6
      C4008486840000000000000000000000000000000000FCFEFC0000000000FCFE
      FC0000000000FCFEFC0000000000FCFEFC0000000000FCFEFC0000000000FCFE
      FC0000000000FCFEFC0000000000FCFEFC0084868400FCFEFC00B4B20400B4B2
      0400B4B20400B4B20400B4B20400B4B20400B4B20400B4B20400B4B20400FCFE
      FC00B4B20400FCFEFC0004020400000000000000000000000000A2A2A2006565
      65009D9D9D00DEDEDE00F2F2F200E8E8E800DEDEDE00D3D3D300C8C8C8007E7E
      7E003A3A3A006565650000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400000000000000000000000000000000000000
      000068686800686868008C8C8C009D9D9D009D9D9D00727272004C4C4C004141
      41008C8C8C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A8A8A8008C8C8C00656565005E5E5E007E7E7E009D9D9D000000
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
      0000000000000000000000000000000000000402040004020400040204000402
      0400040204000402040004020400040204000402040004020400040204000402
      0400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000040204000402040084868400049E
      9C000402040000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848204000000
      00000000000000000000848204000000000004020400ACFEFC00ACFEFC00ACFE
      FC00ACFEFC00ACFEFC00ACFEFC00ACFEFC00ACFEFC00ACFEFC00ACFEFC000402
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040000000000848684008486
      84008486840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FCFE04008482
      04000000000000000000FCFE04000000000004020400ACFEFC00040204000402
      0400ACFEFC000402040004020400040204000402040004020400ACFEFC000402
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040000000000000000000000
      00000000000084868400040204000402040000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008080800000000000000000008080
      8000000000000000000000000000000000000000000084820400848204008482
      0400848204008482040084820400848204008482040084820400FCFE0400FCFE
      04008482040000000000FCFE04000000000004020400ACFEFC00ACFEFC00ACFE
      FC00ACFEFC00ACFEFC00ACFEFC00ACFEFC00ACFEFC00ACFEFC00ACFEFC000402
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000008486840004020400040204000402040084868400000000000402
      04000402040084868400049E9C000402040000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000FFFF00008080
      80008080800000000000000000000000000000000000FCFE0400FCFE0400FCFE
      0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE
      0400FCFE040084820400FCFE04000000000004020400ACFEFC00040204000402
      0400ACFEFC000402040004020400040204000402040004020400ACFEFC000402
      0400000000000000000000000000000000000000000000000000000000000000
      0000848684000402040084FEFC0084FEFC0084FEFC0004020400000000000402
      04000000000084868400848684008486840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FCFE0400FCFE
      04000000000000000000FCFE04000000000004020400ACFEFC00ACFEFC00ACFE
      FC00ACFEFC00ACFEFC00ACFEFC00ACFEFC00ACFEFC00ACFEFC00ACFEFC000402
      0400000000000000000000000000000000000000000000000000000000000000
      00000402040084FEFC0084FEFC0084FEFC0084FEFC0084FEFC00040204000402
      04000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFF000000000000000000008080
      8000000000000000000000000000000000000000000084820400000000000000
      0000000000008482040000000000000000000000000000000000FCFE04000000
      00000000000000000000FCFE04000000000004020400ACFEFC00ACFEFC00ACFE
      FC00ACFEFC00ACFEFC00ACFEFC00ACFEFC0004020400ACFEFC00ACFEFC000402
      0400000000000000000000000000000000000000000000000000000000000000
      00000402040084FEFC0084FEFC0084FEFC0084FEFC0084FEFC00040204000402
      04000000000084868400040204000402040000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000FFFF0000FFFF0000000000008080
      80008080800000000000000000000000000000000000FCFE0400000000000000
      000084820400FCFE040000000000000000000000000000000000000000000000
      00000000000000000000000000000000000004020400ACFEFC00040204000402
      0400ACFEFC00ACFEFC00ACFEFC0004020400ACD2D40004020400ACFEFC000402
      0400000000000000000000000000000000000000000000000000000000000000
      0000040204000402040084FEFC0084FEFC0084FEFC0084FEFC00040204000402
      04000402040084868400049E9C000402040000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008080800000000000000000008080
      80000000000000000000000000000000000000000000FCFE0400000000008482
      0400FCFE0400FCFE040084820400848204008482040084820400848204008482
      04008482040084820400848204000000000004020400ACFEFC0004020400ACD2
      D40004020400ACFEFC0004020400ACD2D40004020400ACD2D400040204000402
      040004020400000000000496AC000496AC000000000000000000000000000402
      040004FEFC00040204000402040084FEFC0084FEFC0004020400000000000402
      04000000000084868400848684008486840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFE040084820400FCFE
      0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE0400FCFE
      0400FCFE0400FCFE0400FCFE04000000000004020400ACFEFC00ACFEFC000402
      0400ACD2D40004020400ACD2D40004020400ACD2D40004020400ACD2D400ACD2
      D400ACD2D400040204000496AC000496AC0000000000000000000402040004FE
      FC00FCFEFC000402040004020400040204000402040000000000848684000402
      04000402040000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FCFE0400000000000000
      0000FCFE0400FCFE040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000402040004020400040204000402
      040004020400ACD2D40004020400ACD2D40004020400ACD2D400ACD2D400ACD2
      D400ACD2D400ACD2D4000496AC000496AC00000000000402040004FEFC00FCFE
      FC0004020400040204000000000000000000040204000402040084868400049E
      9C000402040000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFE0400000000000000
      000000000000FCFE040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000004020400ACD2D40004020400ACD2D400ACD2D400ACD2D400ACD2
      D400ACD2D400ACD2D4000496AC000496AC000402040004FEFC00FCFEFC00049E
      9C00040204000000000000000000000000000000000000000000848684008486
      84008486840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004020400ACD2D400ACD2D400ACD2D400ACD2D400ACD2
      D400ACD2D400040204000496AC000496AC0004020400FCFEFC00049E9C000402
      0400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000040204000402040004020400040204000402
      040004020400000000000496AC000496AC00E4E2E40004020400040204000000
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
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF00F80F000000000000E007000000000000
      C003000000000000800100000000000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000080010000000000008001000000000000C003000000000000
      E007000000000000F81F000000000000C001FFFFFFFFF81FC001AAAAFFFEE007
      C001C0010001C003C001800000018001C001C00100018001C001800000010000
      C001C00100010000C001800000010000C001C00100010000C001800000010000
      C001C00100010000C001800000018001C003C0010001C001C007AAAA0001C003
      C00FFFFF0001F007FFFFFFFFFFFFF81FFF7FFFFFFFFFFFFFFF47000CFFFF000F
      FF070008FFDD000FFF470001FFCD000FFF7800638005000FF82000C38001000F
      F02801EBFFCD000FF00F016BBBDD000FF0080023B3FF000FF0000067A0010004
      E028000F80010000C047000FB3FF00008307000FBBFFF80007C7005FFFFFFC00
      0FFF003FFFFFFE041FFF007FFFFFFFFFFFFF0007FFBFFFFFFE1F0007FF1FFE3F
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
    object mi_Replication1: TMenuItem
      Action = ac_GoToReplication
    end
    object mi_Defaultproperties1: TMenuItem
      Action = ac_GoToDefaultproperties
    end
    object N3: TMenuItem
      Caption = '-'
    end
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
      Caption = 'Clear highlight'
      Hint = 'Clear hilight|Remove the background highlight'
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
      Caption = 'Open file'
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
    object mi_Clear: TMenuItem
      Caption = 'Clear log'
      OnClick = mi_ClearClick
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
  object ps_Main: TPSScript
    CompilerOptions = [icAllowNoBegin, icAllowUnit, icAllowNoEnd, icBooleanShortCircuit]
    OnLine = ps_MainLine
    OnCompile = ps_MainCompile
    OnExecute = ps_MainExecute
    Plugins = <
      item
        Plugin = psi_Classes
      end
      item
        Plugin = psi_DateUtils
      end
      item
        Plugin = psi_miscclasses
      end
      item
        Plugin = psi_unit_uclasses
      end
      item
        Plugin = ps_dll
      end>
    UsePreProcessor = True
    Left = 8
    Top = 280
  end
  object psi_Classes: TPSImport_Classes
    EnableStreams = True
    EnableClasses = True
    Left = 8
    Top = 312
  end
  object psi_DateUtils: TPSImport_DateUtils
    Left = 8
    Top = 344
  end
  object psi_unit_uclasses: TPSImport_unit_uclasses
    Left = 40
    Top = 344
  end
  object psi_miscclasses: TPSImport_miscclasses
    Left = 40
    Top = 312
  end
  object ps_dll: TPSDllPlugin
    Left = 8
    Top = 376
  end
  object il_LogEntries: TImageList
    Left = 72
    Top = 104
    Bitmap = {
      494C010104000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
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
      00000000000000000000000000000000000085695E008F6F5B00000000000000
      000000000000000000000000000000000000000000009E9194006D494E006F56
      5C0071595E00715A5E006E5E64006B5F6600705A5F0071595E0071595E007059
      5E006D5F660072474800964D4600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000083786D0083786D0083786D000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000966B4B00CE9F6F00AB784D0085695E000000
      00000000000000000000000000000000000032CAEF0000BFEE0000C4F70000C6
      F80000C6F90000D1FF0000D7FF0000CCFE0000D3FF0000C7FC0000C6F80000C5
      F80000CEFF0000D5FF0061303100000000000000000000000000000000000000
      0000000000002C2C6C0005056300000065000000600000004F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000083786D00C39B7300AB85610083786D000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000966B4B00CAAA8700FFF7C4009463410085695E000000
      0000000000000000000000000000000000001EC6EB0000CBF70001DFFF0000D9
      FF0000E0FF0000E9FF0011192000AB2F3F0035D0EE0000E8FF0000D9FF0000E4
      FF0003E7FF0000E7FF0065434500000000000000000000000000000000002929
      AC000000840000008E0000008E0000008F0000008C0000008800000081000101
      5400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000083786D00B1998100DCB792009E856B006B6B6B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000937565008A644C00E7CAA800FFDCB300FFDCB300AF87640055280E006844
      360085695E0000000000000000000000000000E5F20002C6EC000CE5FF0000D7
      FF0000DEFF0000E8FF00070000003D0000001CAAC20000F0FF0000F8FF0002F9
      FF0005FDFF0012AECE00B57473000000000000000000000000002929AC000000
      96000000970000009B0000009F000000A00000009D000000970000008F000000
      8800000062000000000000000000000000000000000000000000000000000000
      0000877D7300937E6900A28C7600C6A98900EAC49F00BE9E7C00675A4C005252
      5200707070000000000000000000000000000000000000000000BAA79D00BAA7
      9D00D2B69900E7CAA800FDE4BF00FFE9C700FFF8D100F5D6B300D8B89300AD89
      64005E2F150085695E0000000000000000000000000000C3E8000EDFFC0007E4
      FF0000D9FF0000ECFF0000D3E70000B7C40000EDFF0000F5FF0000F9FF0012FE
      FF0000F9FF00574F55000000000000000000000000002929AC000101A3000808
      9E009999D4006868D0000000AC000000AE000000A9004848B800B7B7E3002727
      A50000008C000101520000000000000000000000000000000000AB907400AB90
      7400C1A48A00CFAF9200DEBF9D00F3CEAA00FFE7C000E4C3A000C4A68500B190
      6E006F5E4D005C5C5C00000000000000000000000000C9B6A700E8DBC700EDD5
      B800FFEBCC00F8D6B700C0704F00E9956300DD8D5C00DFA67B00FFE7C300F4D6
      B100D7B6940073472900896F6500000000000000000000E5F20003CEEC000EED
      FF0000DFFF0000EAFF0006D6F3001B92AD0000FAFF0000F4FF000DF4FF0006FF
      FF0010B7D300B57473000000000000000000000000002929AC000000AB002828
      A300DEDED200FEFEFF006464D4000000B3004646C000E7E7EC00FFFFF7005E5E
      B70000009A0002028700000000000000000000000000AB907400B9A28900DCC3
      A900FCDCBD00FFEFCE00E3B693009D3A1100C8754700FFDDB800FFDEBA00E4C5
      A500C3A48600856D54005D5D5D0000000000CBB8A200E8DBC700EED8C100FFEF
      D100FFEECF00FFFFE200B4816200790000008F2E0600F7E5C400FFEDCB00FFE7
      C300F5D7B700DABD9B005B2D140000000000000000000000000005CCE8000AE3
      F80005EBFF0000FCFF0019A0A9003D3B490013B7BE0002F2FA0010FEFF0000FC
      FF00564D51000000000000000000000000004B4BD3000707B1000303B9000000
      C2004C4CA700E6E6D900FCFCFF009E9EE600E8E9F400FFFFF1007575B9000606
      B1000101AB000202A00013145D000000000000000000B8A59000E3CDB700FFEA
      CD00FFE8CB00FFF4D700D3A9880049000000701F0000FFE1BC00FFE8C700FFE3
      BF00EDCDAF00C2A587006E60520065656500C5B2A000E8DBC700FFF0D700FFEC
      D200FFE7CE00FFFFED00CFB295006F000000A4583700FFFFF000FFE7C900FFE5
      C600FFEAC900FCE3C500AD8A6B0090766D00000000000000000000E5F20002D2
      EA000AF4FF0000FFFF0024778200721422002477820006FBFF0005FFFF000EBD
      D500B57473000000000000000000000000004B4BD3000808BB000707C8000505
      D1000000C8005353B600F2F2ED00FFFFFF00FFFFFC007575C9000000BE000101
      C3000303B8000303AC0010106F0000000000B8A59000D9C7B500FFECD400FFEB
      D100FFE6CD00FFE9CF00FFEFD600DCB69900F1D1B600FFEFD200FFE3C500FFE3
      C500FFE5C600E5CAAD00B5997C0044444400CFBFAE00F8E7D500FFF4DF00FFEC
      D600FFECD600FFFFF300CDAF940074000000A5573600FFFFF100FFE8CF00FFE5
      CA00FFEACF00FFEBD100E4CAAF00886A5C0000000000000000000000000000D2
      E9000CF6FF0000FFFF001F3D45006A000F004453630012FFFF0000FFFF00544D
      5100000000000000000000000000000000004B4BD3000C0CC9000D0DD8000B0B
      DC000000D6003C3DCE00EEEFED00FFFFFF00FFFFFD005858DB000000CA000303
      CB000606C5000606B8001212790000000000CAB8A900F6E2D100FFF1DD00FFEB
      D600FFEAD500FFEBD400FFFBE600CB896000E8BF9F00FFFFE900FFE7CD00FFE4
      CA00FFE8CB00FBE1C400D6BBA0005D5B5800CFC2B700FDEFE000FFF4E300FFEF
      DE00FFF0DC00FFFFFF00D6C1AA0077000000A6583600FFFFF800FFEDD500FFE9
      D000FFECD200FFF2D900ECD7C000866A5C0000000000000000000000000000E5
      F20004EBFB0006FFFF0013000000550004004E3B490003FFFF000ECEDE00B574
      7300000000000000000000000000000000004B4BD3001414D8001717EA000B0B
      F1004343DB00E4E4EA00FDFDF500BABAD400EAEAE800FEFEFF006363E5000303
      D7000A0ACF000A0AC30021217F0000000000CFC5B900FBECDD00FFF3E300FFEE
      DE00FFEEDC00FFF1DF00FFFFF800CEA08200A5461900FFEBCF00FFF8E400FFE9
      D300FFEAD000FFE8CE00DEC6B000847D7500D0C7BD00FDF5E900FFF8EB00FFF2
      E600FFFDEF00EFE6DA008C3D1E00650000008C3C2300FFFFFE00FFF0DD00FFEB
      D600FFEED900FFFAE500F2DEC900977E72000000000000000000000000000000
      000000E5F20009FFFF00080000003A0003004C4F5A0000FFFF004C565A000000
      0000000000000000000000000000000000004B4BD3002626E5002222FB003F3F
      E900DCDCE500FDFDEE007373C5000303D7005151B000E3E3D600FFFFFE006161
      E5000808DB000F0FCA001212790000000000D2C9BF00FCF1E600FFF7EB00FFF2
      E500FFF4E700FFF6E700FFF2DE00FFFEEF0088340F00A73B0F00EDD2B800FFF8
      E700FFEDD900FFF0DA00DDC7B200807B7600DFD4C800F7F4EF00FFFFF900FFF6
      EC00FFFFF900E6D9C900B3938200BAA59A00C2AEA300FFFFF800FFF4E300FFEE
      DC00FFFAEB00FFFFFC00E2CAB400977E72000000000000000000000000000000
      000000E5F20003F7FF0006DBDE0001AFB20009FFFF0007E4EA00B57473000000
      000000000000000000000000000000000000000000003131FB003232FF005252
      ED00B3B3C2007777CA000000EA000000EC000000E8005252B400ADADB0004D4D
      E1001818ED001818B1000000000000000000D2C9BF00F4EFE900FFFFF600FFF7
      ED00FFFFFF00C5997F008D1D0000EBD3BE00AB7A5E0064000000BD886A00FFFF
      F800FFF9E900FAF0E100D6C0AB00847D750000000000E4E5E500FFFFFF00FFFF
      FA00FFFBF300FFFFFF00FFFFFA00F9C8A600FFFEEE00FFFFFF00FFF5E800FFFA
      EF00FFFFFF00FFFFFF00AF978700000000000000000000000000000000000000
      00000000000000E3EA0009FFFF001DFFFF0000FFFF0046616100000000000000
      000000000000000000000000000000000000000000003131FB003E3EFB005353
      FF006868EF005757F9003838FF002525FD002929FF003838FC004242EB003232
      FF001F1FE9003131FB00000000000000000000000000E3E2E000FFFEFC00FFFF
      FB00FFFFFF00BD9885005C000000E2C5B200853E210057000000D2B39D00FFFF
      FF00FFFFFD00F0E5DA00B5A799000000000000000000ECE7E200EDEDEF00FFFF
      FF00FFFFFF00FFFFFF008E574E005D0000009A452800FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00D1BDAD0000000000000000000000000000000000000000000000
      00000000000000E5F20014F3F5002DFFFF0002E9EC00B5747300000000000000
      00000000000000000000000000000000000000000000000000003131FB004949
      FD006E6EFF009191FF009393FF008484FF007676FF006767FF005151FF003131
      FB003131FB0000000000000000000000000000000000D2C9BF00EBEBEC00FFFF
      FF00FFFFFF00FFFFFF00C59A8400B9714D00904E3600C2A79700FFFFFF00FFFF
      FF00F5F1ED00D4C6B80000000000000000000000000000000000F1EBE600F2F4
      F500FFFFFF00FFFFFF00D7CEC90062414400C5B5AF00FFFFFF00FFFFFF00FFFF
      FE00E8DED5000000000000000000000000000000000000000000000000000000
      0000000000000000000000E5F20000FFFF008F97970000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003131
      FB003131FB006969FE008787FF009292FF007676FF005353FF005151F3003131
      FB00000000000000000000000000000000000000000000000000D2C9BF00EFED
      EC00FAFCFE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F5F0
      EC00DDD3C9000000000000000000000000000000000000000000000000000000
      0000EAE3DC00F6F3EF00FFFFFF00FFFFFF00FFFFFF00FBF8F400D8CBC3000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003131FB003131FB003131FB003131FB003131FB00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D2C9BF00EFECE800F5F5F600F6F9FA00F8F9F900F4EFEA00EDE8E200D2C9
      BF0000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF3F8001FFFFFF1FFE1F0001F83FFE1F
      FC1F0001E00FFC1FF0070001C007F007C00380038003C0038001800380038001
      0001C007000180000000C007000100000000E00F000100000000E00F00010000
      0000F01F000100000000F01F800300008001F83F800380018003F83FC0078003
      C007FC7FE00FC007F01FFFFFF83FF00F00000000000000000000000000000000
      000000000000}
  end
end
