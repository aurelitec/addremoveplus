unit VCLRegSavers;

interface

uses Controls, Forms;

procedure LoadControlPlacement(Control : TControl; const KeyName, Section : string);
procedure SaveControlPlacement(Control : TControl; const KeyName, Section : string);

procedure LoadWindowState(Form : TForm; const KeyName, Section : string);
procedure SaveWindowState(Form : TForm; const KeyName, Section : string);

implementation

uses Registry, RegistryTools;

resourcestring
  sLeft   = 'Left';
  sTop    = 'Top';
  sWidth  = 'Width';
  sHeight = 'Height';
  sWindowState = 'WindowState';

procedure LoadControlPlacement(Control : TControl; const KeyName, Section : string);
var
  ALeft, ATop, AWidth, AHeight : Integer;
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create(KeyName);
  try
    with Reg do
    begin
      ALeft   := ReadInteger(Section, sLeft,   MaxInt);
      ATop    := ReadInteger(Section, sTop,    MaxInt);
      AWidth  := ReadInteger(Section, sWidth,  MaxInt);
      AHeight := ReadInteger(Section, sHeight, MaxInt);
    end;
    with Control do
    begin
      if ALeft   <> MaxInt then Left   := ALeft;
      if ATop    <> MaxInt then Top    := ATop;
      if AWidth  <> MaxInt then Width  := AWidth;
      if AHeight <> MaxInt then Height := AHeight;
    end;
  finally
    Reg.Free;
  end;
end;

procedure SaveControlPlacement(Control : TControl; const KeyName, Section : string);
var
  Reg : TRegIniFile;
begin
  Reg := TRegIniFile.Create(KeyName);
  try
    with Control do
      with Reg do
      begin
        WriteInteger(Section, sLeft,   Left);
        WriteInteger(Section, sTop,    Top);
        WriteInteger(Section, sWidth,  Width);
        WriteInteger(Section, sHeight, Height);
      end;
  finally
    Reg.Free;
  end;
end;

procedure LoadWindowState(Form : TForm; const KeyName, Section : string);
var
  AWindowState : Integer;
begin
  AWindowState := DirectRegReadInteger(KeyName, Section, sWindowState, MaxInt);
  if (AWindowState >= ord(wsNormal)) and (AWindowState <= ord(wsMaximized)) then
    Form.WindowState := TWindowState(AWindowState);
end;

procedure SaveWindowState(Form : TForm; const KeyName, Section : string);
begin
  DirectRegWriteInteger(KeyName, Section, sWindowState, Integer(Form.WindowState));
end;

end.