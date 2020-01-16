unit UninstallKeyTools;

interface

const
  sUninstallSection = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  sDisplayName = 'DisplayName';
  sUninstallString = 'UninstallString';

function SetUninstallKey(const AKey, ADisplayName,
  AUninstallString : string; CanCreateKey : Boolean) : Boolean;
function DeleteUninstallKey(const AKey : string) : Boolean;
function UninstallKeyExists(const AKey : string) : Boolean;

implementation

uses Windows, Registry;

function SetUninstallKey(const AKey, ADisplayName,
  AUninstallString : string; CanCreateKey : Boolean) : Boolean;
var
  Reg : TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create;
  with Reg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey(sUninstallSection + '\' + AKey, CanCreateKey) then
    try
      WriteString(sDisplayName, ADisplayName);
      WriteString(sUninstallString, AUninstallString);
      Result := True;
    finally
      CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function DeleteUninstallKey(const AKey : string) : Boolean;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    Result := DeleteKey(sUninstallSection + '\' + AKey);
  finally
    Reg.Free;
  end;
end;

function UninstallKeyExists(const AKey : string) : Boolean;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    Result := KeyExists(sUninstallSection + '\' + AKey);
  finally
    Reg.Free;
  end;
end;

end.
