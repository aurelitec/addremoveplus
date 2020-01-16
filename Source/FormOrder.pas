unit FormOrder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, URL;

type
  TOrderBox = class(TForm)
    cmdOrderOnline: TBitBtn;
    Label1: TLabel;
    cmdOrderOffline: TBitBtn;
    Label2: TLabel;
    cmdClose: TButton;
    Bevel1: TBevel;
    urlOrder: TURL;
    procedure cmdOrderOnlineClick(Sender: TObject);
    procedure cmdOrderOfflineClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrderBox: TOrderBox;

implementation

{$R *.DFM}
uses ShellFiles, Globals;

procedure TOrderBox.cmdOrderOnlineClick(Sender: TObject);
begin
  urlOrder.Execute;
end;

procedure TOrderBox.cmdOrderOfflineClick(Sender: TObject);
begin
  ExecuteFile(ExtractFilePath(Application.ExeName) + sOrderFileName, '',
    '', SW_SHOWNORMAL);
end;

end.
