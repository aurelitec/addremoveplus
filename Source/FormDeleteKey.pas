unit FormDeleteKey;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TDeleteKeyBox = class(TForm)
    ediAdvice: TMemo;
    cmdUninstall: TButton;
    cmdDelete: TButton;
    cmdCancel: TButton;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ediAdviceEnter(Sender: TObject);
    procedure cmdUninstallClick(Sender: TObject);
  private
    { Private declarations }
  public
    DeleteDecision : Integer;
    { Public declarations }
  end;

var
  DeleteKeyBox: TDeleteKeyBox;

implementation

uses main, Globals, VCLToolsStd;

{$R *.DFM}

procedure TDeleteKeyBox.FormCreate(Sender: TObject);
begin
  DeleteDecision := 2; // cancel
  ediAdvice.Text := Format(sConfirmKeyDeletion,
    [frmMain.TheListView.Selected.Caption]);
  CenterChildForm(Application.MainForm, Self);
end;

procedure TDeleteKeyBox.ediAdviceEnter(Sender: TObject);
begin
  try cmdCancel.SetFocus; except end;
end;

procedure TDeleteKeyBox.cmdUninstallClick(Sender: TObject);
begin
  DeleteDecision := (Sender As TButton).Tag;
  Close;
end;

end.
