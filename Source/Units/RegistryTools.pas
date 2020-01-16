unit RegistryTools;

interface

uses Windows, Classes, Registry;

type
  TBinRegIniFile = class(TRegIniFile)
  public
    function ReadBinaryData(const Section, Ident: string; var Buffer; BufSize: Integer) : Integer;
    procedure WriteBinaryData(const Section, Ident: string; var Buffer; BufSize: Integer);
    function GetDataSize(const Section, Ident: string) : Integer;
  end;

procedure SaveStringsToRegistry(const KeyName, Section : string; S : TStrings);
procedure LoadStringsFromRegistry(const KeyName, Section : string; S : TStrings);

procedure DirectRegWriteInteger(const KeyName, Section, Ident : string; Value : Integer);
function DirectRegReadInteger(const KeyName, Section, Ident : string; Default : Integer) : Integer;

function DirectRegReadBool(const KeyName, Section, Ident : string; Default : Boolean) : Boolean;
procedure DirectRegWriteBool(const KeyName, Section, Ident : string; Value : Boolean);

procedure DirectRegWriteString(const KeyName, Section, Ident, Value : string);
function DirectRegReadString(const KeyName, Section, Ident, Default : string) : string;

procedure DirectRegWriteBinaryData(const KeyName, Section, Ident : string; var Buffer; BufSize: Integer);
function DirectRegReadBinaryData(const KeyName, Section, Ident : string; var Buffer; BufSize: Integer) : Integer;

implementation

uses SysUtils;

function TBinRegIniFile.ReadBinaryData(const Section, Ident: string;
                            var Buffer; BufSize: Integer) : Integer;
var
  Key, OldKey: HKEY;
begin
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      if ValueExists(Ident) then
        Result := inherited ReadBinaryData(Ident, Buffer, BufSize) else
        Result := 0;
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end
  else Result := 0;
end;

procedure TBinRegIniFile.WriteBinaryData(const Section, Ident: string;
                             var Buffer; BufSize: Integer);
var
  Key, OldKey: HKEY;
begin
  CreateKey(Section);
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      inherited WriteBinaryData(Ident, Buffer, BufSize);
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end;
end;

function TBinRegIniFile.GetDataSize(const Section, Ident: string) : Integer;
var
  Key, OldKey: HKEY;
begin
  Key := GetKey(Section);
  if Key <> 0 then
  try
    OldKey := CurrentKey;
    SetCurrentKey(Key);
    try
      if ValueExists(Ident) then
        Result := inherited GetDataSize(Ident) else
        Result := -1;
    finally
      SetCurrentKey(OldKey);
    end;
  finally
    RegCloseKey(Key);
  end
  else Result := -1;
end;

procedure SaveStringsToRegistry(const KeyName, Section : string; S : TStrings);
var
  Reg : TBinRegIniFile;
  I : Integer;
begin
  Reg := TBinRegIniFile.Create(KeyName);
  try
    Reg.WriteInteger(Section, '', S.Count);
    for I := 0 to S.Count - 1 do Reg.WriteString(Section, IntToStr(I), S[I]);
  finally
    Reg.Free;
  end;
end;

procedure LoadStringsFromRegistry(const KeyName, Section : string; S : TStrings);
var
  Reg : TBinRegIniFile;
  Count, I : Integer;
  TempS : string;
begin
  Reg := TBinRegIniFile.Create(KeyName);
  try
    Count := Reg.ReadInteger(Section, '', 0);
    for I := 0 to Count - 1 do
    begin
      TempS := Reg.ReadString(Section, IntToStr(I), '');
      if TempS <> '' then S.Add(TempS);
    end;
  finally
    Reg.Free;
  end;
end;

(*--------------------------------------------------------------------*)
{ Read/write integers                                                  }
(*--------------------------------------------------------------------*)

procedure DirectRegWriteInteger(const KeyName, Section, Ident : string; Value : Integer);
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create(KeyName);
  try
    Reg.WriteInteger(Section, Ident, Value);
  finally
    Reg.Free;
  end;
end;

function DirectRegReadInteger(const KeyName, Section, Ident : string; Default : Integer) : Integer;
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create(KeyName);
  try
    Result := Reg.ReadInteger(Section, Ident, Default);
  finally
    Reg.Free;
  end;
end;

(*--------------------------------------------------------------------*)
{ Read/write bools                                                     }
(*--------------------------------------------------------------------*)

function DirectRegReadBool(const KeyName, Section, Ident : string; Default : Boolean) : Boolean;
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create(KeyName);
  try
    Result := Reg.ReadBool(Section, Ident, Default);
  finally
    Reg.Free;
  end;
end;

procedure DirectRegWriteBool(const KeyName, Section, Ident : string; Value : Boolean);
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create(KeyName);
  try
    Reg.WriteBool(Section, Ident, Value);
  finally
    Reg.Free;
  end;
end;

(*--------------------------------------------------------------------*)
{ Read/write strings                                                   }
(*--------------------------------------------------------------------*)

procedure DirectRegWriteString(const KeyName, Section, Ident, Value : string);
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create(KeyName);
  try
    Reg.WriteString(Section, Ident, Value);
  finally
    Reg.Free;
  end;
end;

function DirectRegReadString(const KeyName, Section, Ident, Default : string) : string;
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create(KeyName);
  try
    Result := Reg.ReadString(Section, Ident, Default);
  finally
    Reg.Free;
  end;
end;

(*--------------------------------------------------------------------*)
{ Read/write binary data                                               }
(*--------------------------------------------------------------------*)

procedure DirectRegWriteBinaryData(const KeyName, Section, Ident : string; var Buffer; BufSize: Integer);
var
  Reg : TBinRegIniFile;
begin
  Reg := TBinRegIniFile.Create(KeyName);
  try
    Reg.WriteBinaryData(Section, Ident, Buffer, BufSize);
  finally
    Reg.Free;
  end;
end;

function DirectRegReadBinaryData(const KeyName, Section, Ident : string; var Buffer; BufSize: Integer) : Integer;
var
  Reg : TBinRegIniFile;
begin
  Reg := TBinRegIniFile.Create(KeyName);
  try
    Result := Reg.ReadBinaryData(Section, Ident, Buffer, BufSize);
  finally
    Reg.Free;
  end;
end;

end.
