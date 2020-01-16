unit EditProgram;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TEditProgramBox = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    ediName: TEdit;
    Label1: TLabel;
    ediCommand: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditProgramBox: TEditProgramBox;

implementation

{$R *.DFM}

uses VCLToolsStd;

procedure TEditProgramBox.FormCreate(Sender: TObject);
begin
  CenterChildForm(Application.MainForm, Self);
end;

end.
