
{*********************************************************************}
{                                                                     }
{  FileUtils Delphi Unit                                              }
{  Helper routines for getting file information                       }
{                                                                     }
{*********************************************************************}

unit FileUtils;

interface

uses Windows;

(************ File existence test routines ***************************)

function FileFound(const FileName : string) : Boolean;
function FileDataFound(const FileName : string; var FindData : TWin32FindData) : Boolean;
function FolderFound(const FolderName : string) : Boolean;

(************ File attributes/date routines **************************)
function FileAttributes(const FileName : string) : DWORD;
function IsSpecialFile(const FileName : string) : Boolean;
function FileCreationTime(const FileName: string) : DWORD;

function FileSize(const FileName : string) : Integer;

function CanChangeDir(const NewDir : string) : Boolean;

implementation

uses SysUtils;

(*********************************************************************)
(*  File existence test routines                                     *)
(*********************************************************************)

{ FileFound tests if FileName exists }
function FileFound(const FileName : string) : Boolean;
var
  FindHandle : THandle;
  FindData : TWin32FindData;
begin
  FindHandle := FindFirstFile(PChar(FileName), FindData);
  Result := FindHandle <> INVALID_HANDLE_VALUE;
  if Result then Windows.FindClose(FindHandle);
end;

{ Same as FileFound but if the file is found the WIN32_FIND_DATA file }
{ structure is returned in FindData.                                  }
function FileDataFound(const FileName : string; var FindData: TWin32FindData) : Boolean;
var
  FindHandle : THandle;
begin
  FindHandle := FindFirstFile(PChar(FileName), FindData);
  Result := FindHandle <> INVALID_HANDLE_VALUE;
  if Result then Windows.FindClose(FindHandle);
end;

{ FolderFound tests if FolderName exists and it is a folder }
function FolderFound(const FolderName : string) : Boolean;
var
  FindHandle : THandle;
  FindData : TWin32FindData;
begin
  FindHandle := FindFirstFile(PChar(FolderName), FindData);
  Result := (FindHandle <> INVALID_HANDLE_VALUE) and
    (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY > 0);
  if Result then Windows.FindClose(FindHandle);
end;

(*********************************************************************)
(*  File attributes/date routines                                    *)
(*********************************************************************)

{ Returns the attributes of a file/folder }
function FileAttributes(const FileName : string) : DWORD;
var
  FindData : TWin32FindData;
begin
  Result := 0;
  if FileDataFound(FileName, FindData) then Result := FindData.dwFileAttributes;
end;

{ Tests if a file has a H, RO or S attribute }
function IsSpecialFile(const FileName : string) : Boolean;
var
  FileAttr : DWORD;
begin
  FileAttr := FileAttributes(FileName);
  Result := (FileAttr and FILE_ATTRIBUTE_HIDDEN > 0) or
            (FileAttr and FILE_ATTRIBUTE_READONLY > 0) or
            (FileAttr and FILE_ATTRIBUTE_SYSTEM > 0);
end;

{ Returns the file's creation time as an integer DOS date/time }
function FileCreationTime(const FileName: string) : DWORD;
var
  Handle: THandle;
  FindData: TWin32FindData;
  LocalFileTime: TFileTime;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
        LongRec(Result).Lo) then Exit;
  end;
  Result := MAXDWORD;
end;

function FileSize(const FileName : string) : Integer;
var
  FindData : TWin32FindData;
begin
  if FileDataFound(FileName, FindData) then
    Result := FindData.nFileSizeLow
  else Result := 0;
end;

function CanChangeDir(const NewDir : string) : Boolean;
var
  OldMode : UINT;
  OldDir : string;
begin
  OldDir := GetCurrentDir;
  OldMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    Result := SetCurrentDir(NewDir);
  finally
    SetCurrentDir(OldDir);
    SetErrorMode(OldMode);
  end;
end;

end.
