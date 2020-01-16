unit FormUninstall;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TUninstallBox = class(TForm)
    imgAppImage: TImage;
    TheBevel: TBevel;
    cmdCancel: TButton;
    Image1: TImage;
    Image2: TImage;
    ThePages: TNotebook;
    txtAction: TLabel;
    panAppName: TPanel;
    cmdAddRemove: TBitBtn;
    Label1: TLabel;
    cmdRemove: TBitBtn;
    txtCPError: TLabel;
    txtStart: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cmdDone: TButton;
    Label4: TLabel;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure cmdAddRemoveClick(Sender: TObject);
    procedure cmdDoneClick(Sender: TObject);
  private
    { Private declarations }
  public
    uninstCommand : string;
    entryName : string;
    fSomethingUninstalled : Boolean;
    { Public declarations }
  end;

var
  UninstallBox: TUninstallBox;

implementation

uses VCLToolsStd, UninstallKeyTools, configuration;

{$R *.DFM}

resourcestring
  sExecError = 'There was an error executing the program. ' +
    'Make sure the path and filename are correct and that all required ' +
    'libraries are available.';

procedure TUninstallBox.FormCreate(Sender: TObject);
begin
  fSomethingUninstalled := False;
  CenterChildForm(Application.MainForm, Self);
end;

procedure TUninstallBox.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TUninstallBox.FormActivate(Sender: TObject);
begin
  ThePages.PageIndex := 0;
  if optConfirmUninstall.Bool = False then
  begin
    cmdAddRemove.OnClick(Self);
    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;
end;

procedure TUninstallBox.cmdRemoveClick(Sender: TObject);
begin
  fSomethingUninstalled := True;
  DeleteUninstallKey(entryName); Close;
end;

procedure TUninstallBox.cmdAddRemoveClick(Sender: TObject);
begin
  fSomethingUninstalled := True;

  Image1.Visible := False;
  ThePages.PageIndex := 1;
  TheBevel.Visible := False; cmdCancel.Visible := False;
  if WinExec(PAnsiChar(uninstCommand), SW_SHOWNORMAL) <= 31 then
  begin
    Application.MessageBox(PChar(sExecError), PChar(uninstCommand), MB_ICONERROR);
    cmdDone.OnClick(Self);
  end;

{  Image1.Visible := False;
  cmdCancel.Visible := False;
  cmdAddRemove.Visible := False;
  txtAction.Caption := 'The Uninstall program is now running. Please wait until it completes.';
  txtStart.Visible := False;
  panAppName.Visible := False;
  Application.ProcessMessages;}

{  if not optExecAndWait.Bool then
  begin
    if WinExec(PChar(uninstCommand), SW_SHOWNORMAL) <= 31 then
      Application.MessageBox(PChar(sExecError), PChar(uninstCommand), MB_ICONERROR);
    Close;
    Exit;
  end;}

{  if WinExecAndWait32(PChar(uninstCommand), SW_SHOWNORMAL) = 0 then
    Application.MessageBox(PChar(sExecError), PChar(uninstCommand), MB_ICONERROR);

  if optWarnCPKey.Bool and UninstallKeyExists(entryName) then
  begin
    Image2.Visible := True;
    cmdCancel.Visible := True;
    cmdRemove.Visible := True;
    txtCPError.Visible := True;
    txtAction.Caption := 'The Uninstall program has completed. However, it did not remove the application from the Add/Remove Programs list.';
    panAppName.Visible := True;
  end
  else
  begin
    Close; Exit;
  end;

  }
end;

procedure TUninstallBox.cmdDoneClick(Sender: TObject);
begin
  TheBevel.Visible := True; cmdCancel.Visible := True;

  if optWarnCPKey.Bool and UninstallKeyExists(entryName) then
  begin
    Image2.Visible := True;
    ThePages.PageIndex := 2;
  end
  else
  begin
    Image3.Visible := True;
    ThePages.PageIndex := 3;
    cmdCancel.Caption := 'Close';
  end;
end;

end.
