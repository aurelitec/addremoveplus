unit FormAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, URL;

type
  TAboutBox = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cmdOK: TButton;
    URL1: TURL;
    URL2: TURL;
    Label8: TLabel;
    Image1: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    txtFreeEdition: TLabel;
    panAdEdition: TPanel;
    txtFree1: TLabel;
    txtFree2: TLabel;
    txtFree3: TLabel;
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure txtFree2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

uses VCLToolsStd, Globals, main, FormOrder;

{$R *.DFM}

procedure TAboutBox.cmdOKClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  {$IFNDEF ARPLUS_AD}
  txtFree1.Visible := False;
  txtFree2.Visible := False;
  txtFree3.Visible := False;
  panAdEdition.Caption := 'Non-Sponsored (Registered) Edition';
  panAdEdition.Height := 24;
  txtFreeEdition.Visible := False;
  cmdOK.Top := 214;
  Height := 270;
  {$ENDIF}
  CenterChildForm(Application.MainForm, Self);
end;

procedure TAboutBox.Label9Click(Sender: TObject);
begin
  Url1.Execute;
end;

procedure TAboutBox.Image1Click(Sender: TObject);
begin
  Url2.Execute;
end;

procedure TAboutBox.txtFree2Click(Sender: TObject);
begin
  with TOrderBox.Create(Self) do try ShowModal; finally Free; end;
end;

end.
