[Setup]
AppName=UnCodeX
AppVerName=UnCodeX version 200
AppPublisher=Michiel 'El Muerte' Hendriks
AppPublisherURL=http://wiki.beyondunreal.com/wiki/UnCodeX
AppSupportURL=http://wiki.beyondunreal.com/wiki/UnCodeX
AppUpdatesURL=http://wiki.beyondunreal.com/wiki/UnCodeX
DefaultDirName={pf}\UnCodeX
DefaultGroupName=UnCodeX
AllowNoIcons=yes
LicenseFile=..\Bin\LICENSE.TXT
Compression=bzip/9
OutputBaseFilename=UnCodeX-setup
WizardImageFile=InstallLarge2.bmp
WizardSmallImageFile=InstallSmall2.bmp

[Types]
Name: "full"; Description: "Full installation"
Name: "compact"; Description: "Compact installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "main"; Description: "Main Files"; Types: full compact custom; Flags: fixed
Name: "commandline"; Description: "Commandline Unility"; Types: full
Name: "templates"; Description: "HTML Templates"; Types: full
Name: "help"; Description: "Help Files"; Types: full
Name: "customoutput"; Description: "Additional output modules"; Types: full

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"
Name: "quicklaunchicon"; Description: "Create a &Quick Launch icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Files]
Source: "..\Bin\UnCodeX.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: main
Source: "..\Bin\LICENSE.TXT"; DestDir: "{app}"; Flags: ignoreversion; Components: main
Source: "..\Bin\PackageDescriptions.ini"; DestDir: "{app}"; Flags: confirmoverwrite; Components: main
Source: "..\Bin\ucxcu.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: commandline
Source: "..\Bin\UnCodeX-help.chm"; DestDir: "{app}"; Flags: ignoreversion; Components: help
Source: "..\Bin\Templates\DocStyle2\*.*"; DestDir: "{app}\Templates\DocStyle2"; Flags: ignoreversion; Components: templates
Source: "..\Bin\out_sample\*.*"; DestDir: "{app}\out_sample"; Flags: ignoreversion; Components: customoutput
Source: "..\Bin\out_sample\Src\*.*"; DestDir: "{app}\out_sample\Src"; Flags: ignoreversion; Components: customoutput
Source: "..\Bin\out_wikifier.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: customoutput
Source: "..\Bin\out_graphviz.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: customoutput

[INI]
Filename: "{app}\UnCodeX.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://wiki.beyondunreal.com/wiki/UnCodeX"
Filename: "{app}\UnrealWiki.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://wiki.beyondunreal.com/wiki/"

[Icons]
Name: "{group}\UnCodeX"; Filename: "{app}\UnCodeX.exe"
Name: "{group}\UnCodeX Help"; Filename: "{app}\UnCodeX-help.chm"
Name: "{group}\License"; Filename: "{app}\LICENSE.TXT"
Name: "{group}\UnCodeX Website"; Filename: "{app}\UnCodeX.url"
Name: "{group}\UnrealWiki"; Filename: "{app}\UnrealWiki.url"
Name: "{group}\Uninstall UnCodeX"; Filename: "{uninstallexe}"
Name: "{userdesktop}\UnCodeX"; Filename: "{app}\UnCodeX.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\UnCodeX"; Filename: "{app}\UnCodeX.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\UnCodeX.exe"; Description: "Launch UnCodeX"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: files; Name: "{app}\UnCodeX.url"
Type: files; Name: "{app}\UnrealWiki.url"
Type: files; Name: "{app}\UnCodeX.ini"
Type: files; Name: "{app}\UnCodeX.ucx"
Type: files; Name: "{app}\keywords1.list"
Type: files; Name: "{app}\keywords2.list"

[Messages]
BeveledLabel=UnCodeX by Michiel 'El Muerte' Hendriks

