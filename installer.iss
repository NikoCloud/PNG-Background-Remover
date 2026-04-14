; Inno Setup script for Persona Asset Forge
; Requires Inno Setup 6+ — https://jrsoftware.org/isinfo.php
; Build: open this file in Inno Setup Compiler and click Compile,
;        or run: iscc installer.iss
; Output: dist\PersonaAssetForge_Setup.exe

#define AppName      "Persona Asset Forge"
#define AppVersion   "1.3.0"
#define AppPublisher "NikoCloud"
#define AppURL       "https://github.com/NikoCloud/Persona-Asset-Forge"
#define AppExeName   "PersonaAssetForge.exe"
#define SetupExeName "PersonaAssetForge_Setup"

[Setup]
AppId={{A7F3C2D1-4B8E-4F2A-9C6D-1E5B7A3D8F90}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}/issues
AppUpdatesURL={#AppURL}/releases
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputDir=dist
OutputBaseFilename={#SetupExeName}
SetupIconFile=icon.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequiredOverridesAllowed=dialog
UninstallDisplayIcon={app}\{#AppExeName}
UninstallDisplayName={#AppName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional shortcuts:"; Flags: unchecked

[Files]
Source: "dist\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}";       Filename: "{app}\{#AppExeName}"
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#AppName}";   Filename: "{app}\{#AppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent
