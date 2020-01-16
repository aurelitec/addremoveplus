unit AddProgram;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TAddProgramBox = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    ediName: TEdit;
    Label1: TLabel;
    ediCommand: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    ediEntry: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddProgramBox: TAddProgramBox;

implementation

{$R *.DFM}

uses VCLToolsStd;

procedure TAddProgramBox.FormCreate(Sender: TObject);
begin
  CenterChildForm(Application.MainForm, Self);
end;

procedure TAddProgramBox.OKBtnClick(Sender: TObject);
begin
  if (ediEntry.Text = '') or (ediName.Text = '') or (ediCommand.Text = '') then
    Application.MessageBox('Please fill in all the fields', nil, MB_ICONERROR)
  else
  begin
    ModalResult := mrOK;
  end;
end;

end.
