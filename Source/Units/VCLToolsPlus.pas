
{*********************************************************************}
{                                                                     }
{  VCLTools Delphi Unit                                               }
{  Extended helper routines for working with VCL components           }
{                                                                     }
{*********************************************************************}

unit VCLToolsPlus;

interface

uses Windows, Comctrls;

function GetNodePath(Node : TTreeNode; CurDrive : Char) : string;
function GetNodePathDrive(Node : TTreeNode) : string;
function GetUpmostParent(Node : TTreeNode) : TTreeNode;
function GetChildNodeWithText(ParentNode : TTreeNode; const S : string;
  CaseSensitive : Boolean) : TTreeNode;
function FindNodePath(ParentNode : TTreeNode; const Path : string;
  CaseSensitive : Boolean) : TTreeNode;

type
  TErrorBoxType = (ebtFatal, ebtStartUp, ebtApplication);

procedure ShowAppMsgBox(Msg : string);
function ShowAppQueryBox(Msg : string; Buttons : Integer) : Integer;
procedure ShowAppErrorBox(Msg : string; ErrorType : TErrorBoxType);

implementation

uses Forms, SysUtils;

function GetNodePath(Node : TTreeNode; CurDrive : Char) : string;
var
  N : TTreeNode;
begin
  Result := ''; N := Node; if N = nil then Exit;
  while True do
  begin
    if N.Parent = nil then
    begin
      Result := CurDrive + ':\' + Result;
      Break;
    end;
    Result := N.Text + '\' + Result;
    N := N.Parent;
  end;
  if Node.Parent <> nil then SetLength(Result, Length(Result) - 1);
end;

function GetNodePathDrive(Node : TTreeNode) : string;
var
  N : TTreeNode;
begin
  Result := ''; N := Node; if N = nil then Exit;
  while True do
  begin
    if N.Parent = nil then
    begin
      Result := Chr(Hi(N.StateIndex)) + ':\' + Result;
      Break;
    end;
    Result := N.Text + '\' + Result;
    N := N.Parent;
  end;
  if Node.Parent <> nil then SetLength(Result, Length(Result) - 1);
end;

function GetUpmostParent(Node : TTreeNode) : TTreeNode;
begin
  Result := Node; if Node = nil then Exit;
  while True do
  begin
    if Result.Parent <> nil then Result := Result.Parent
    else Exit;
  end;
end;

function GetChildNodeWithText(ParentNode : TTreeNode; const S : string;
  CaseSensitive : Boolean) : TTreeNode;
var
  Node : TTreeNode;
begin
  Node := ParentNode.GetFirstChild;
  while Node <> nil do
  begin
    if CaseSensitive then
    begin
      if Node.Text = S then begin Result := Node; Exit; end;
    end
    else
      if UpperCase(Node.Text) = UpperCase(S) then begin Result := Node; Exit; end;
    Node := ParentNode.GetNextChild(Node);
  end;
  Result := nil;
end;

function FindNodePath(ParentNode : TTreeNode; const Path : string;
  CaseSensitive : Boolean) : TTreeNode;

  function FirstDirectoryFromPath(var Path : string) : string;
  var
    I : Integer;
  begin
    I := Pos('\', Path);
    if I > 0 then
    begin
      Result := Copy(Path, 1, I - 1);
      Path := Copy(Path, I + 1, MaxInt);
    end
    else begin Result := Path; Path := '' end;
  end;

var
  CurDir, CurPath : string;
begin
  Result := nil; if (ParentNode = nil) then Exit;
  if Path = '' then begin Result := ParentNode; Exit; end;

  CurPath := Path;
  while True do
  begin
    CurDir := FirstDirectoryFromPath(CurPath);

    ParentNode := GetChildNodeWithText(ParentNode, CurDir, CaseSensitive);
    if ParentNode = nil then Exit;
    if CurPath = '' then begin Result := ParentNode; Exit; end;
  end;
end;

procedure ShowAppMsgBox(Msg : string);
begin
  Application.MessageBox(PChar(Msg), PChar(Application.Title), MB_ICONINFORMATION or MB_OK);
end;

function ShowAppQueryBox(Msg : string; Buttons : Integer) : Integer;
begin
  Result := Application.MessageBox(PChar(Msg), PChar(Application.Title), MB_ICONQUESTION or Buttons);
end;

procedure ShowAppErrorBox(Msg : string; ErrorType : TErrorBoxType);
const
  ErrorTypeStr : array[TErrorBoxType] of string = ('Fatal', 'Initialization', '');
var
  BoxCaption : string;
begin
  if ErrorType = ebtApplication then BoxCaption := Application.Title
  else BoxCaption := ErrorTypeStr[ErrorType] + ' error';
  Application.MessageBox(PChar(Msg), PChar(BoxCaption), MB_ICONERROR);
end;

end.
