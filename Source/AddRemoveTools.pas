unit AddRemoveTools;

interface

function AllPathsExist(const Path : string) : Boolean;

implementation

uses Windows, SysUtils;

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

function GetParamStr(P: PChar; var Param: string): PChar;
var
  Len: Integer;
  Buffer: array[Byte] of Char;
begin
  while True do
  begin
    while (P[0] <> #0) and (P[0] <= ' ') do Inc(P);
    if (P[0] = '"') and (P[1] = '"') then Inc(P, 2) else Break;
  end;
  Len := 0;
  while P[0] > ' ' do
    if P[0] = '"' then
    begin
      Inc(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Buffer[Len] := P[0];
        Inc(Len);
        Inc(P);
      end;
      if P[0] <> #0 then Inc(P);
    end else
    begin
      Buffer[Len] := P[0];
      Inc(Len);
      Inc(P);
    end;
  SetString(Param, Buffer, Len);
  Result := P;
end;

function CheckPathFromString(const Param : string) : Boolean;
var
  I : Integer;
  FileName : string;
begin
  Result := True;
  I := Pos(':\', Param);
  if (I <= 1) then Exit;
  FileName := Copy(Param, I - 1, Length(Param) - I + 2);
  Result := FileFound(FileName);
end;

function AllPathsExist(const Path : string) : Boolean;
var
  UpPath : string;
  P, StartP : PChar;
  Param : string;
  EXE : array[0..MAX_PATH] of Char;
begin
  Result := True;
  UpPath := UpperCase(Path);
  if Pos('RUNDLL', UpPath) > 0 then Exit;
  Result := False;

  P := PChar(UpPath); P := StrPos(P, '.EXE');
  if P = nil then Exit;

  StartP := PChar(UpPath); if StartP[0] = '"' then StartP := StartP + 1;
  StrLCopy(EXE, StartP, Integer(P - StartP) + 4);
  if CheckPathFromString(EXE) = False then Exit;

  Result := True;
  P := P + 4;
  if P[0] = '"' then P := P + 1;
  while True do
  begin
    P := GetParamStr(P, Param);
    if (Param = '') then Break;
    if CheckPathFromString(Param) = False then
      begin Result := False; Exit; end;
  end;
end;

(*function AllPathsExist(const Path : string) : Boolean;
var
  I : Integer;
  S, NewPath : string;
  EndChar : Char;
begin
  S := Path;
  Result := True;
  Exit;
  while True do
  begin
    I := Pos(':\', S);
    if I = 0 then Break;
    if S[I - 1] = '"' then EndChar := '"'
    else EndChar := ' ';
    NewPath := Copy(S, I, 255);

  end;
end;*)

end.
