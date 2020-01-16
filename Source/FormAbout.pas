unit FormAbout;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, URL;

type
  TAboutBox = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    cmdOK: TButton;
    URL1: TURL;
    URL2: TURL;
    Image1: TImage;
    UrlLabel: TLabel;
    FreePanel: TPanel;
    FreeLabel: TLabel;
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UrlLabelClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var AboutBox: TAboutBox;

implementation

uses VCLToolsStd, Globals, main;

{$R *.DFM}

procedure TAboutBox.cmdOKClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  CenterChildForm(Application.MainForm, Self);
end;

procedure TAboutBox.UrlLabelClick(Sender: TObject);
begin
  URL1.Execute;
end;

procedure TAboutBox.Image1Click(Sender: TObject);
begin
  URL2.Execute;
end;

end.
