unit ShellFiles;

interface

uses Windows;

function GetShortcutPath(const LinkFile : string) : string;

function Shell_GetFileName(const Path : string) : string;
function Shell_GetFileType(const Path : string) : string;
function Shell_GetFileIcon(const Path : string; IconType : UINT) : HICON;
function Shell_GetFileIconIndex(const Path : string; IconType : UINT) : Integer;
function Shell_GetSystemImageList(IconType : UINT) : Integer;
function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
function WinExecAndWait32(FileName:String; Visibility : integer):DWORD;

implementation

uses SysUtils, ShellAPI, ShlObj, ActiveX, Forms;

function CreateShellLinkInstance(var ShellLink: IShellLink): hresult;
begin
  Result := CoCreateInstance(CLSID_SHELLLINK, nil, CLSCTX_INPROC_SERVER, IID_ISHELLLINKA, ShellLink)
end;

function GetShortcutPath(const LinkFile : string) : string;
var
  Buffer     : array [0..MAX_PATH] of char;
  FilenameW  : array [0..MAX_PATH] of WideChar;
  ShellLink  : IShellLink;
  TargetInfo : TWin32FindData;
begin
  Result := '';
  if CreateShellLinkInstance(ShellLink) = NOERROR then
  begin
    StringToWideChar(LinkFile, FilenameW, MAX_PATH);
    if (ShellLink as IPersistFile).Load(@FilenameW, STGM_READ) = NOERROR then
      if ShellLink.GetPath(@Buffer, MAX_PATH, TargetInfo, SLGP_UNCPRIORITY) = NOERROR then
        Result := StrPas(Buffer);
  end;
end;

function Shell_GetFileName(const Path : string) : string;
var
  Info : TSHFileInfo;
begin
  SHGetFileInfo(PChar(Path), 0, Info, sizeof(Info), SHGFI_DISPLAYNAME);
  Result := Info.szDisplayName;
end;

function Shell_GetFileType(const Path : string) : string;
var
  Info : TSHFileInfo;
begin
  SHGetFileInfo(PChar(Path), 0, Info, sizeof(Info), SHGFI_TYPENAME);
  Result := Info.szTypeName;
end;

function Shell_GetFileIcon(const Path : string; IconType : UINT) : HICON;
var
  Info : TSHFileInfo;
begin
  SHGetFileInfo(PChar(Path), 0, Info, sizeof(Info), SHGFI_ICON + IconType);
  Result := Info.hIcon;
end;

function Shell_GetFileIconIndex(const Path : string; IconType : UINT) : Integer;
var
  Info : TSHFileInfo;
begin
  SHGetFileInfo(PChar(Path), 0, Info, sizeof(Info), SHGFI_ICON + IconType);
  Result := Info.iIcon;
end;

function Shell_GetSystemImageList(IconType : UINT) : Integer;
var
  Info : TSHFileInfo;
begin
  Result := SHGetFileInfo(PChar(GetCurrentDir), 0, Info, sizeof(Info), SHGFI_SYSICONINDEX + IconType);
end;

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..255] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function WinExecAndWait32(FileName:String; Visibility : integer):DWORD;
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir:String;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
begin
  StrPCopy(zAppName,FileName);
  GetDir(0,WorkDir);
  StrPCopy(zCurDir,WorkDir);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);

  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName,                      { pointer to command line string }
    nil,                           { pointer to process security attributes }
    nil,                           { pointer to thread security attributes }
    false,                         { handle inheritance flag }
    CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo) then Result := 0  { pointer to PROCESS_INF }

  else begin
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess,Result);
  end;
end;

end.
