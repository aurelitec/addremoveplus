unit uShortcut;

interface

uses
  ShlObj, Windows;

type
  TShortcutInfo = record
    Arguments:      AnsiString;
    Description:    AnsiString;
    Target:         AnsiString;
    IconLocation:   AnsiString;
    WorkingDir:     AnsiString;
    HotKey:         byte;
    HotKeyModifier: byte;
    iIcon:          integer;
    ShowCmd:        integer;
    ItemIDList:     PItemIDList;
    TargetInfo:     TWin32FindData;
    end;

  TShortcutProperty =
    (
    spAll, spArguments, spDescription, spHotKey, spIcon, spPidl, spShowCmd, spTarget, spWorkingDir
    );

  TUsedProperties = set of TShortCutProperty;

function ReadShortcut(const hCaller: hwnd; const Filename: AnsiString;
  const UsedProperties: TUsedProperties; var ShortcutInfo: TShortcutInfo): hresult;
function WriteShortcut(const hCaller: hwnd; const Filename: AnsiString;
  const UsedProperties: TUsedProperties;  const ShortcutInfo: TShortcutInfo): hresult;

implementation


uses
  ActiveX, SysUtils;

function CreateShellLinkInstance(var ShellLink: IShellLink): hresult; forward;
function IsUsedProperty(const UsedProperties: TUsedProperties;
  const ShortcutProperty: TShortcutProperty): boolean; forward;

{
Returns an instance of the IShellLink interface
}
function CreateShellLinkInstance(var ShellLink: IShellLink): hresult;
  begin
  Result := CoCreateInstance(CLSID_SHELLLINK, nil, CLSCTX_INPROC_SERVER, IID_ISHELLLINKA, ShellLink)
  end;

{
Returns true if spAll or the specified property is in the set of used properties
}
function IsUsedProperty
  (
  const UsedProperties:   TUsedProperties;
  const ShortcutProperty: TShortcutProperty
  ): boolean;

  begin
  Result := (spAll in UsedProperties) or (ShortcutProperty in UsedProperties);
  end;


{
Returns the shortcut information read from the specified shortcut file
}
function ReadShortcut
  (
  const hCaller:          hwnd;
  const Filename:         AnsiString;
  const UsedProperties: TUsedProperties;
  var   ShortcutInfo:     TShortcutInfo
  ): hresult;

  var
    Buffer:         array [0..MAX_PATH] of char;
    FilenameW:      array [0..MAX_PATH] of WideChar;
    ShellLink:      IShellLink;
    CombinedHotKey: word;

  begin
  Result := NOERROR;

  if CreateShellLinkInstance(ShellLink) = NOERROR
    then begin

    StringToWideChar(Filename, FilenameW, MAX_PATH);

    if (ShellLink as IPersistFile).Load(@FilenameW, STGM_READ) = NOERROR
      then begin

      with ShortcutInfo, ShellLink do
        begin

        if IsUsedProperty(UsedProperties, spArguments)
          then begin
          Result := GetArguments(@Buffer, MAX_PATH);
          if Result = NOERROR
            then begin
            Arguments := StrPas(Buffer);
            end
            else begin
            Exit;
            end;
          end;

        if IsUsedProperty(UsedProperties, spDescription)
          then begin
          Result := GetDescription(@Buffer, MAX_PATH);
          if Result = NOERROR
            then begin
            Description := StrPas(Buffer);
            end
            else begin
            Exit;
            end;
          end;

        if IsUsedProperty(UsedProperties, spHotKey)
          then begin
          Result := GetHotKey(CombinedHotKey);
          if Result = NOERROR
            then begin
            HotKey :=         lo(CombinedHotKey);
            HotKeyModifier := hi(CombinedHotKey);
            end
            else begin
            Exit;
            end;
          end;

        if IsUsedProperty(UsedProperties, spIcon)
          then begin
          Result := GetIconLocation(Buffer, MAX_PATH, iIcon);
          if Result = NOERROR
            then begin
            IconLocation := StrPas(Buffer);
            end
            else begin
            Exit;
            end;
          end;

        if IsUsedProperty(UsedProperties, spPidl)
          then begin
          Result := GetIDList(ItemIDList);
          if Result <> NOERROR
            then begin
            Exit;
            end;
          end;

        if IsUsedProperty(UsedProperties, spTarget)
          then begin
          Result := GetPath(@Buffer, MAX_PATH, TargetInfo, SLGP_UNCPRIORITY);
          if Result = NOERROR
            then begin
            Target := StrPas(Buffer);
            end
            else begin
            Exit;
            end;
          end;

        if IsUsedProperty(UsedProperties, spShowCmd)
          then begin
          Result := GetShowCmd(ShowCmd);
          if Result <> NOERROR
            then begin
            Exit;
            end;
          end;

        if IsUsedProperty(UsedProperties, spWorkingDir)
          then begin
          Result := GetWorkingDirectory(Buffer, MAX_PATH);
          if Result = NOERROR
            then begin
            WorkingDir := StrPas(Buffer);
            end
            else begin
            Exit;
            end;
          end;

        end;

      end;

    end;

  end;

{
Writes the given shortcut information to the shortcut with the specified filename
If the given filename doesn't exist, creates a new shortcut with that name
}

function WriteShortcut
  (
  const hCaller:        hwnd;
  const Filename:       AnsiString;
  const UsedProperties: TUsedProperties;
  const ShortcutInfo:   TShortcutInfo
  ): hresult;

  var
    FilenameW:      array [0..MAX_PATH] of WideChar;
    ShellLink:      IShellLink;
    CombinedHotKey: word;

  begin
  Result := NOERROR;

  if CreateShellLinkInstance(ShellLink) = NOERROR
    then begin

    with ShortcutInfo, ShellLink do
      begin

      if IsUsedProperty(UsedProperties, spArguments)
        then begin
        Result := SetArguments(pchar(Arguments) );
        if Result <> NOERROR
          then begin
          Exit;
          end;
        end;

      if IsUsedProperty(UsedProperties, spDescription)
        then begin
        Result := SetDescription(pchar(Description) );
        if Result <> NOERROR
          then begin
          Exit;
          end;
        end;

      if IsUsedProperty(UsedProperties, spHotKey)
        then begin
        CombinedHotKey := (HotKey shl 8) + HotKeyModifier;
        Result := SetHotKey(CombinedHotKey);
        if Result <> NOERROR
          then begin
          Exit;
          end;
        end;

      if IsUsedProperty(UsedProperties, spIcon)
        then begin
        Result := SetIconLocation(pchar(IconLocation), iIcon);
        if Result <> NOERROR
          then begin
          Exit;
          end;
        end;

      if IsUsedProperty(UsedProperties, spPidl)
        then begin
        Result := SetIDList(ItemIDList);
        if Result <> NOERROR
          then begin
          Exit;
          end;
        end;

      if IsUsedProperty(UsedProperties, spTarget)
        then begin
        Result := SetPath(pchar(Target) );
        if Result <> NOERROR
          then begin
          Exit;
          end;
        end;

      if IsUsedProperty(UsedProperties, spShowCmd)
        then begin
        Result := SetShowCmd(ShowCmd);
        if Result <> NOERROR
          then begin
          Exit;
          end;
        end;

      if IsUsedProperty(UsedProperties, spWorkingDir)
        then begin
        Result := SetWorkingDirectory(pchar(WorkingDir) );
        if Result = NOERROR
          then begin
          Exit;
          end;
        end;

      StringToWideChar(Filename, FilenameW, MAX_PATH);
      (ShellLink as IPersistFile).Save(FilenameW, true);
      end;


    end;

  end;

initialization
  begin
  CoInitialize(nil);
  end;

finalization
  begin
  CoUnInitialize;
  end;

end.
