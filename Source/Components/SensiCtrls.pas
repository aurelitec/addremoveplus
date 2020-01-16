unit SensiCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TSensitiveActivation = procedure (Sender: TControl; var Message: TMessage) of object;

type
  TSensitivePanel = class(TPanel)
  private
    { Private declarations }
    FOnSensitiveActivate : TSensitiveActivation;
    FOnSensitiveDeactivate : TSensitiveActivation;
    procedure CmMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CmMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
  public
  published
    property OnSensitiveActivate : TSensitiveActivation read FOnSensitiveActivate write FOnSensitiveActivate;
    property OnSensitiveDeactivate : TSensitiveActivation read FOnSensitiveDeactivate write FOnSensitiveDeactivate;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Aurelitec', [TSensitivePanel]);
end;

procedure TSensitivePanel.CmMouseEnter(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnSensitiveActivate) then FOnSensitiveActivate(Self, Message);
end;

procedure TSensitivePanel.CmMouseLeave(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnSensitiveDeactivate) then FOnSensitiveDeactivate(Self, Message);
end;

end.
