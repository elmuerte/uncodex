[Setup]
AppName=UnCodeX
AppVerName=UnCodeX version 204
AppVersion=204
AppPublisher=Michiel 'El Muerte' Hendriks
AppPublisherURL=http://wiki.beyondunreal.com/wiki/UnCodeX
AppSupportURL=http://wiki.beyondunreal.com/wiki/UnCodeX
AppUpdatesURL=http://wiki.beyondunreal.com/wiki/UnCodeX
DefaultDirName={pf}\UnCodeX
DefaultGroupName=UnCodeX
AllowNoIcons=true
LicenseFile=..\Bin\LICENSE.TXT
Compression=lzma
SolidCompression=true
OutputBaseFilename=UnCodeX-setup
WizardImageFile=InstallLarge2.bmp
WizardSmallImageFile=InstallSmall2.bmp
AppCopyright=Copyright 2003, 2004 Michiel Hendriks
ShowLanguageDialog=yes
UninstallDisplayIcon={app}\UnCodeX.exe
UninstallDisplayName=UnCodeX
AppID={FDD6ED8B-DB77-43BC-B0B2-608A1F27AABC}
VersionInfoVersion=2.0.2.204

[Types]
Name: full; Description: Full installation
Name: compact; Description: Compact installation
Name: commandline; Description: Commandline only
Name: custom; Description: Custom installation; Flags: iscustom

[Components]
Name: main; Description: Main Files; Types: full compact custom commandline; Flags: fixed
Name: gui; Description: Graphical User Interface; Types: full compact custom
Name: gui\customoutput; Description: Additional output modules; Types: full
Name: commandline; Description: Commandline Utility; Types: full commandline
Name: templates; Description: HTML Templates; Types: full commandline
Name: help; Description: Help Files; Types: full

[Tasks]
Name: desktopicon; Description: Create a &desktop icon; GroupDescription: Additional icons:; Components: gui
Name: desktopicon\common; Description: For all users; GroupDescription: Additional icons:; Components: gui; Flags: exclusive
Name: desktopicon\user; Description: For the current user only; GroupDescription: Additional icons:; Components: gui; Flags: exclusive unchecked
Name: quicklaunchicon; Description: Create a &Quick Launch icon; GroupDescription: Additional icons:; Components: gui; Flags: unchecked

[Files]
Source: ..\Bin\UnCodeX.exe; DestDir: {app}; Flags: ignoreversion; Components: gui
Source: ..\Bin\LICENSE.TXT; DestDir: {app}; Flags: ignoreversion; Components: main
Source: ..\Bin\PackageDescriptions.ini; DestDir: {app}; Flags: ignoreversion; Components: main
Source: ..\Bin\ucxcu.exe; DestDir: {app}; Flags: ignoreversion; Components: commandline
Source: ..\Bin\UnCodeX-help.chm; DestDir: {app}; Flags: ignoreversion; Components: help
Source: ..\Bin\Templates\*.*; DestDir: {app}\Templates\DocStyle2; Flags: ignoreversion recursesubdirs; Components: templates
Source: ..\Bin\out_wikifier.dll; DestDir: {app}; Flags: ignoreversion; Components: gui\customoutput
Source: ..\Bin\out_graphviz.dll; DestDir: {app}; Flags: ignoreversion; Components: gui\customoutput

Source: ..\Bin\out_sample\*.*; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\out_sample\*.pas; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\out_sample\*.dfm; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\out_sample\*.dpr; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\out_sample\*.cfg; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\out_sample\*.dof; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\unit_outputdefs.pas; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\unit_uclasses.pas; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\FastShareMem.pas; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput

[INI]
Filename: {app}\UnCodeX.url; Section: InternetShortcut; Key: URL; String: http://wiki.beyondunreal.com/wiki/UnCodeX
Filename: {app}\UnrealWiki.url; Section: InternetShortcut; Key: URL; String: http://wiki.beyondunreal.com/wiki/
Filename: {app}\Unreal Developers Network.url; Section: InternetShortcut; Key: URL; String: http://udn.epicgames.com/

[Icons]
Name: {group}\UnCodeX; Filename: {app}\UnCodeX.exe; WorkingDir: {app}; IconIndex: 0
Name: {group}\UnCodeX Help; Filename: {app}\UnCodeX-help.chm
Name: {group}\License; Filename: {app}\LICENSE.TXT
Name: {group}\UnCodeX Website; Filename: {app}\UnCodeX.url
Name: {group}\UnrealWiki; Filename: {app}\UnrealWiki.url
Name: {group}\Unreal Developers Network; Filename: {app}\Unreal Developers Network.url
Name: {group}\Uninstall UnCodeX; Filename: {uninstallexe}
Name: {userdesktop}\UnCodeX; Filename: {app}\UnCodeX.exe; Tasks: desktopicon\user
Name: {commondesktop}\UnCodeX; Filename: {app}\UnCodeX.exe; Tasks: desktopicon\common
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\UnCodeX; Filename: {app}\UnCodeX.exe; Tasks: quicklaunchicon

[Run]
Filename: {app}\UnCodeX.exe; Description: Launch UnCodeX; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: files; Name: {app}\UnCodeX.url
Type: files; Name: {app}\UnrealWiki.url
Type: files; Name: {app}\Unreal Developers Network.url
Type: files; Name: {app}\UnCodeX.ini
Type: files; Name: {app}\UnCodeX.ucx
Type: files; Name: {app}\keywords1.list
Type: files; Name: {app}\keywords2.list

[Messages]
BeveledLabel=UnCodeX by Michiel 'El Muerte' Hendriks
