unit FormOptions;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TOptionsBox = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    TheOptionPages: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    chkConfirmUninstall: TCheckBox;
    chkConfirmDeletion: TCheckBox;
    chkExecAndWait: TCheckBox;
    cmdHelp: TButton;
    chkShowBadPrograms: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure cmdHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses VCLToolsStd, Options, Configuration, Globals;

{$R *.DFM}

procedure TOptionsBox.FormCreate(Sender: TObject);
begin
  CenterChildForm(Application.MainForm, Self);
  LoadOptionsInDialogBox(Self, optGen, 100); { Load general options }
end;

procedure TOptionsBox.OKBtnClick(Sender: TObject);
begin
  SaveOptionsFromDialogBox(Self, optGen, 100); { Save general options }
end;

procedure TOptionsBox.cmdHelpClick(Sender: TObject);
begin
  Application.HelpContext(IDH_ARP_OPTIONS);
end;

end.
