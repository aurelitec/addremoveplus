unit Options;

interface

uses Classes, Registry;

type
  TOption = class(TObject)
  private
    FIdent : string;
  protected
    procedure LoadFromRegistry(Reg : TRegIniFile; const Section : string); virtual; abstract;
    procedure SaveToRegistry(Reg : TRegIniFile; const Section : string); virtual; abstract;
    constructor Create(const Ident : string);
  end;

  TIntOption = class(TOption)
  private
    FInt        : Integer;
    FDefaultInt : Integer;
  protected
    procedure LoadFromRegistry(Reg : TRegIniFile; const Section : string); override;
    procedure SaveToRegistry(Reg : TRegIniFile; const Section : string); override;
  public
    constructor Create(const Ident : string; DefaultValue : Integer); virtual;
    property Int : Integer read FInt write FInt;
  end;

  TBoolOption = class(TOption)
  private
    FBool        : Boolean;
    FDefaultBool : Boolean;
  protected
    procedure LoadFromRegistry(Reg : TRegIniFile; const Section : string); override;
    procedure SaveToRegistry(Reg : TRegIniFile; const Section : string); override;
  public
    constructor Create(const Ident : string; DefaultValue : Boolean); virtual;
    property Bool : Boolean read FBool write FBool;
  end;

  TStrOption = class(TOption)
  private
    FStr        : string;
    FDefaultStr : string;
  protected
    procedure LoadFromRegistry(Reg : TRegIniFile; const Section : string); override;
    procedure SaveToRegistry(Reg : TRegIniFile; const Section : string); override;
  public
    constructor Create(const Ident : string; const DefaultValue : string); virtual;
    property Str : string read FStr write FStr;
  end;

  TOptions = class(TObject)
  private
    FOptionsList : TList;
    FKey, FSection : string;
    function GetItem(Index : Integer) : TOption;
  public
    constructor Create(const Key, Section : string); virtual;
    destructor Destroy; override;
    function AddInt(const Ident : string; DefaultValue : Integer) : TIntOption;
    function AddBool(const Ident : string; DefaultValue : Boolean) : TBoolOption;
    function AddStr(const Ident : string; const DefaultValue : string) : TStrOption;
    property Items[Index : Integer] : TOption read GetItem; default;
    procedure LoadFromRegistry;
    procedure SaveToRegistry;
  end;

procedure LoadOptionsInDialogBox(Box : TComponent; Options : TOptions; StartTag : Integer);
procedure SaveOptionsFromDialogBox(Box : TComponent; Options : TOptions; StartTag : Integer);

implementation

uses stdctrls, comctrls;

{ TOption }

constructor TOption.Create(const Ident : string);
begin
  FIdent := Ident;
end;

{ TIntOption }

constructor TIntOption.Create(const Ident : string; DefaultValue : Integer);
begin
  inherited Create(Ident);
  FDefaultInt := DefaultValue;
  FInt := DefaultValue;
end;

procedure TIntOption.LoadFromRegistry(Reg : TRegIniFile; const Section : string);
begin
  FInt := Reg.ReadInteger(Section, FIdent, FDefaultInt);
end;

procedure TIntOption.SaveToRegistry(Reg : TRegIniFile; const Section : string);
begin
  Reg.WriteInteger(Section, FIdent, FInt);
end;

{ TBoolOption }

constructor TBoolOption.Create(const Ident : string; DefaultValue : Boolean);
begin
  inherited Create(Ident);
  FDefaultBool := DefaultValue;
  FBool := DefaultValue;
end;

procedure TBoolOption.LoadFromRegistry(Reg : TRegIniFile; const Section : string);
begin
  FBool := Reg.ReadBool(Section, FIdent, FDefaultBool);
end;

procedure TBoolOption.SaveToRegistry(Reg : TRegIniFile; const Section : string);
begin
  Reg.WriteBool(Section, FIdent, FBool);
end;

{ TStrOption }

constructor TStrOption.Create(const Ident : string; const DefaultValue : string);
begin
  inherited Create(Ident);
  FDefaultStr := DefaultValue;
  FStr := DefaultValue;
end;

procedure TStrOption.LoadFromRegistry(Reg : TRegIniFile; const Section : string);
begin
  FStr := Reg.ReadString(Section, FIdent, FDefaultStr);
end;

procedure TStrOption.SaveToRegistry(Reg : TRegIniFile; const Section : string);
begin
  Reg.WriteString(Section, FIdent, FStr);
end;

{ TOptions }

function TOptions.GetItem(Index : Integer) : TOption;
begin
  if (Index < 0) or (Index >= FOptionsList.Count) then Result := nil
  else Result := FOptionsList.Items[Index];
end;

constructor TOptions.Create(const Key, Section : string);
begin
  FKey := Key;
  FSection := Section;
  FOptionsList := TList.Create;
end;

destructor TOptions.Destroy;
var
  I : Integer;
begin
  try { destroy options }
    with FOptionsList do
      for I := 0 to Count - 1 do
        TOption(Items[I]).Free;
  finally
    FOptionsList.Free; { clear options list }
    inherited Destroy;
  end;
end;

function TOptions.AddInt(const Ident : string; DefaultValue : Integer) : TIntOption;
begin
  Result := TIntOption.Create(Ident, DefaultValue);
  FOptionsList.Add(Result);
end;

function TOptions.AddBool(const Ident : string; DefaultValue : Boolean) : TBoolOption;
begin
  Result := TBoolOption.Create(Ident, DefaultValue);
  FOptionsList.Add(Result);
end;

function TOptions.AddStr(const Ident : string; const DefaultValue : string) : TStrOption;
begin
  Result := TStrOption.Create(Ident, DefaultValue);
  FOptionsList.Add(Result);
end;

procedure TOptions.LoadFromRegistry;
var
  Reg : TRegIniFile;
  I : Integer;
begin
  Reg := TRegIniFile.Create(FKey);
  try
    with FOptionsList do
      for I := 0 to Count - 1 do
        TOption(Items[I]).LoadFromRegistry(Reg, FSection);
  finally
    Reg.Free;
  end;
end;

procedure TOptions.SaveToRegistry;
var
  Reg : TRegIniFile;
  I : Integer;
begin
  Reg := TRegIniFile.Create(FKey);
  try
    with FOptionsList do
      for I := 0 to Count - 1 do
        TOption(Items[I]).SaveToRegistry(Reg, FSection);
  finally
    Reg.Free;
  end;
end;

procedure LoadOptionsInDialogBox(Box : TComponent; Options : TOptions; StartTag : Integer);
var
  I : Integer;
  Cur : TComponent;
  CurTag : Integer;
begin
  for I := 0 to Box.ComponentCount - 1 do
  begin
    Cur := Box.Components[I];
    CurTag := Cur.Tag - StartTag;
    if CurTag < 0 then Continue;
    if Cur is TCheckBox then { check box }
    begin
      if Options[CurTag] is TBoolOption then
        TCheckBox(Cur).Checked := TBoolOption(Options[CurTag]).Bool
      else
        if Options[CurTag] is TIntOption then
          TCheckBox(Cur).Checked := TIntOption(Options[CurTag]).Int <> 0;
    end
    else
      if Cur is TRadioButton then { radio button }
      begin
        if Options[CurTag] is TIntOption then { on if taborder = int option}
          TRadioButton(Cur).Checked := (TIntOption(Options[CurTag]).Int = TRadioButton(Cur).TabOrder);
      end
      else
        if Cur is TEdit then { edit field }
        begin
          if Options[CurTag] is TStrOption then { string option }
            TEdit(Cur).Text := TStrOption(Options[CurTag]).Str;
        end
        else
          if Cur is TListBox then { list box }
          begin
            if Options[CurTag] is TIntOption then { integer option }
              TListBox(Cur).ItemIndex := TIntOption(Options[CurTag]).Int;
          end
          else
            if Cur is TComboBox then { combo box }
            begin
              if Options[CurTag] is TIntOption then { integer option }
                TComboBox(Cur).ItemIndex := TIntOption(Options[CurTag]).Int;
            end
            else
              if Cur is TUpDown then { up down }
              begin
                if Options[CurTag] is TIntOption then { integer option }
                  TUpDown(Cur).Position := TIntOption(Options[CurTag]).Int;
              end
  end;
end;

procedure SaveOptionsFromDialogBox(Box : TComponent; Options : TOptions; StartTag : Integer);
var
  I : Integer;
  Cur : TComponent;
  CurTag : Integer;
begin
  for I := 0 to Box.ComponentCount - 1 do
  begin
    Cur := Box.Components[I];
    CurTag := Cur.Tag - StartTag;
    if CurTag < 0 then Continue;
    if Cur is TCheckBox then { check box }
    begin
      if Options[CurTag] is TBoolOption then
        TBoolOption(Options[CurTag]).Bool := TCheckBox(Cur).Checked
      else
        if Options[CurTag] is TIntOption then
          TIntOption(Options[CurTag]).Int := Ord(TCheckBox(Cur).Checked)
    end
    else
      if Cur is TRadioButton then { radio button }
      begin
        if Options[CurTag] is TIntOption then { on if taborder = int option }
          if TRadioButton(Cur).Checked then
            TIntOption(Options[CurTag]).Int := TRadioButton(Cur).TabOrder;
      end
      else
        if Cur is TEdit then { edit field }
        begin
          if Options[CurTag] is TStrOption then { string option }
            TStrOption(Options[CurTag]).Str := TEdit(Cur).Text
        end
        else
          if Cur is TListBox then { list box }
          begin
            if Options[CurTag] is TIntOption then { integer option }
              TIntOption(Options[CurTag]).Int := TListBox(Cur).ItemIndex
          end
          else
            if Cur is TComboBox then { combo box }
            begin
              if Options[CurTag] is TIntOption then { integer option }
                TIntOption(Options[CurTag]).Int := TComboBox(Cur).ItemIndex
            end
            else
              if Cur is TUpDown then { up down }
              begin
                if Options[CurTag] is TIntOption then { integer option }
                  TIntOption(Options[CurTag]).Int := TUpDown(Cur).Position
              end
  end;
end;

end.
