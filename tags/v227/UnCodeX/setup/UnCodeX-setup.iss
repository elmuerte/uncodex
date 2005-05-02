[Setup]
AppName=UnCodeX
AppVerName=UnCodeX version 227
AppVersion=227
AppPublisher=Michiel 'El Muerte' Hendriks
AppPublisherURL=http://sourceforge.net/projects/uncodex/
AppSupportURL=http://sourceforge.net/tracker/?group_id=120421
AppUpdatesURL=http://sourceforge.net/project/showfiles.php?group_id=120421&package_id=131207
DefaultDirName={pf}\UnCodeX
DefaultGroupName=UnCodeX
AllowNoIcons=true
LicenseFile=..\Bin\LICENSE.TXT
Compression=lzma/ultra
SolidCompression=true
OutputBaseFilename=UnCodeX-setup
WizardImageFile=InstallLarge2.bmp
WizardSmallImageFile=InstallSmall2.bmp
AppCopyright=Copyright 2003-2005 Michiel Hendriks
ShowLanguageDialog=no
UninstallDisplayIcon={app}\UnCodeX.exe
UninstallDisplayName=UnCodeX
AppID={{FDD6ED8B-DB77-43BC-B0B2-608A1F27AABC}}
VersionInfoVersion=2.1.3.227
InternalCompressLevel=ultra
MinVersion=4.0.950,4.0.1381
ShowTasksTreeLines=true
VersionInfoCompany=Michiel "El Muerte" Hendriks
VersionInfoDescription=UnCodeX Installer

[Types]
Name: full; Description: Full installation
Name: compact; Description: Compact installation
Name: commandline; Description: Commandline only
Name: custom; Description: Custom installation; Flags: iscustom

[Components]
Name: main; Description: Main Files; Types: full compact custom commandline; Flags: fixed
Name: gui; Description: Graphical User Interface; Types: full compact custom
Name: gui\customoutput; Description: Additional output modules; Types: full custom
Name: commandline; Description: Commandline Utility; Types: full commandline custom
Name: templates; Description: HTML Templates; Types: full commandline custom
Name: pascalscript; Description: PascalScript Examples; Types: full custom
Name: help; Description: Help Files; Types: full custom

[Tasks]
Name: desktopicon; Description: Create a &desktop icon; GroupDescription: Additional icons:; Components: gui
Name: desktopicon\common; Description: For all users; GroupDescription: Additional icons:; Components: gui; Flags: exclusive
Name: desktopicon\user; Description: For the current user only; GroupDescription: Additional icons:; Components: gui; Flags: exclusive unchecked
Name: quicklaunchicon; Description: Create a &Quick Launch icon; GroupDescription: Additional icons:; Components: gui; Flags: unchecked

[Files]
Source: ..\Bin\UnCodeX.exe; DestDir: {app}; Flags: ignoreversion; Components: gui
Source: ..\Bin\LICENSE.TXT; DestDir: {app}; Flags: ignoreversion overwritereadonly; Components: main
Source: ..\Bin\PackageDescriptions.ini; DestDir: {app}; Flags: ignoreversion confirmoverwrite; Components: main
Source: ..\Bin\ExternalComments.ini; DestDir: {app}; Flags: ignoreversion confirmoverwrite; Components: main
Source: ..\Bin\ucxcu.exe; DestDir: {app}; Flags: ignoreversion; Components: commandline
Source: ..\Bin\UnCodeX-help.chm; DestDir: {app}; Flags: ignoreversion; Components: help
Source: ..\Bin\Templates\*.*; DestDir: {app}\Templates; Flags: ignoreversion recursesubdirs; Components: templates; Excludes: CVS
Source: ..\Bin\out_wikifier.dll; DestDir: {app}; Flags: ignoreversion; Components: gui\customoutput
Source: ..\Bin\out_graphviz.dll; DestDir: {app}; Flags: ignoreversion; Components: gui\customoutput
Source: ..\Bin\out_ctags.dll; DestDir: {app}; Flags: ignoreversion; Components: gui\customoutput
Source: ..\Bin\out_unrealwiki.dll; DestDir: {app}; Flags: ignoreversion; Components: gui\customoutput

Source: ..\src\out_sample\*.pas; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\out_sample\*.dfm; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\out_sample\*.dpr; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\out_sample\*.cfg; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\out_sample\*.dof; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\unit_outputdefs.pas; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\unit_uclasses.pas; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput
Source: ..\src\FastShareMem.pas; DestDir: {app}\out_sample; Flags: ignoreversion recursesubdirs; Components: gui\customoutput

Source: ..\Bin\Macros\Examples\*.ups; DestDir: {app}\Macros\Examples; Flags: ignoreversion recursesubdirs; Components: pascalscript

[INI]
Filename: {app}\UnCodeX.url; Section: InternetShortcut; Key: URL; String: http://sourceforge.net/projects/uncodex/
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
Filename: {app}\UnCodeX.exe; Description: Launch UnCodeX; Flags: nowait postinstall skipifsilent skipifdoesntexist; WorkingDir: {app}

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
