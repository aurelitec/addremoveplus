; Add/Remove Plus! Inno Setup Script

[Setup]
AppName=Add/Remove Plus!
AppVerName=Add/Remove Plus!
AppCopyright=Produced and distributed by Aurelitec Software Network
DefaultDirName={autopf}\Add Remove Plus!
DefaultGroupName=Add Remove Plus!
OutputBaseFilename=addremoveplus-install

[Files]
Source: "Files\arplus.exe"; DestDir: "{app}"
Source: "Files\arplus.hlp"; DestDir: "{app}"
Source: "Files\arplus.cnt"; DestDir: "{app}"
Source: "Files\Readme.txt"; DestDir: "{app}"; Flags: isreadme
Source: "Files\License.txt"; DestDir: "{app}"
Source: "Files\Aurelitec.url"; DestDir: "{app}"

[Icons]
Name: "{group}\Add Remove Plus!"; Filename: "{app}\arplus.exe"; WorkingDir: "{app}"
Name: "{group}\OnLine Help"; Filename: "{app}\arplus.hlp"; WorkingDir: "{app}"
Name: "{group}\ReadMe Information"; Filename: "{app}\Readme.txt"; WorkingDir: "{app}"
Name: "{group}\License Information"; Filename: "{app}\License.txt"; WorkingDir: "{app}"
Name: "{userdesktop}\Add Remove Plus!"; Filename: "{app}\arplus.exe"; WorkingDir: "{app}"

[Registry]
Root: HKCU; Subkey: "Software\Aurelitec"; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: "Software\Aurelitec\Add Remove Plus"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Aurelitec"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Aurelitec\Add Remove Plus"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Aurelitec\Add Remove Plus\Settings"; ValueType: string; ValueName: "Path"; ValueData: "{app}"
