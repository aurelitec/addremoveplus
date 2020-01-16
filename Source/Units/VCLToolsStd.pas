
{*********************************************************************}
{                                                                     }
{  VCLTools Delphi Unit                                               }
{  Helper routines for working with VCL components                    }
{                                                                     }
{  Copyright © 1997-1998 Horatiu A. Tanescu                           }
{  Personal E-mail: t-horatio@usa.net                                 }
{                                                                     }
{*********************************************************************}

unit VCLToolsStd;

interface

uses Windows, Controls, Forms, Dialogs;

(************ Form center routines ***********************************)

function GetFormCenterX(FormWidth : Integer) : Integer;
function GetFormCenterY(FormHeight : Integer) : Integer;
{ Centers the Child form in the Parent form space }
procedure CenterChildForm(Parent, Child : TForm);

(************ Misc routines *******************************************)

{ Changes the current mouse cursor and forces screen update }
procedure ChangeCursor(Control : TControl; Cursor : TCursor; ForceUpdate : Boolean);
procedure SetFormAlwaysOnTop(Handle : HWND; AlwaysOnTop : Boolean);

function CMessageDlg(Parent : TForm; const Msg: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons) : Integer;

function CustomMessageBox(AHwndOwner: HWND; AInstance: HINST;
  AText, ACaption: PChar; AType: UINT; AIcon: PWideChar): Integer;

implementation

(*********************************************************************)
(*  Form center routines                                             *)
(*********************************************************************)

function GetFormCenterX(FormWidth : Integer) : Integer;
begin
  Result := (Screen.Width - FormWidth) div 2;
  if Result < 0 then Result := 0;
end;

function GetFormCenterY(FormHeight : Integer) : Integer;
begin
  Result := (Screen.Height - FormHeight) div 2;
  if Result < 0 then Result := 0;
end;

{ Centers the Child form in the Parent form space }
procedure CenterChildForm(Parent, Child : TForm);

  function Min(A, B : Integer) : Integer;
  begin if A > B then Result := B else Result := A; end;

begin
  if (Parent = nil) or (Child = nil) then Exit;
  Child.Left := Parent.Left +
    (Min(Parent.Width, Screen.Width - Parent.Left) - Child.Width) div 2;
  Child.Top := Parent.Top +
    (Min(Parent.Height, Screen.Height - Parent.Top) - Child.Height) div 2;
  with Child do
  begin
    if Left < 0 then Left := 0;
    if Top < 0 then Top := 0;
    if Left + Width > Screen.Width then Left := Screen.Width - Width;
    if Top + Height > Screen.Height then Top := Screen.Height - Height;
  end;
end;

(*********************************************************************)
(*  Misc routines                                                    *)
(*********************************************************************)

{ Changes the current mouse cursor and forces screen update }
procedure ChangeCursor(Control : TControl; Cursor : TCursor; ForceUpdate : Boolean);
begin
  if Control.Cursor <> Cursor then
  begin
    if ForceUpdate then Windows.SetCursor(Screen.Cursors[Cursor]);
    Control.Cursor := Cursor;
  end;
end;

procedure SetFormAlwaysOnTop(Handle : HWND; AlwaysOnTop : Boolean);
begin
  if AlwaysOnTop then
    SetWindowPos(handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE)
  else
    SetWindowPos(handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE);
end;

function CMessageDlg(Parent : TForm; const Msg: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons) : Integer;
var
  Dlg : TForm;
begin
  Dlg := CreateMessageDialog(Msg, DlgType, Buttons);
  try
    CenterChildForm(Parent, Dlg);
    Result := Dlg.ShowModal;
  finally
    Dlg.Free;
  end;
end;

function CustomMessageBox(AHwndOwner: HWND; AInstance: HINST;
  AText, ACaption: PChar; AType: UINT; AIcon: PWideChar): Integer;
var
  MsgBoxParams : TMsgBoxParams;
begin
  with MsgBoxParams do
  begin
    cbSize := SizeOf(MsgBoxParams);
    hwndOwner := AHwndOwner;
    hInstance := AInstance;
    lpszText := AText;
    lpszCaption := ACaption;
    dwStyle := AType or MB_USERICON;
    lpszIcon := AIcon;
    dwContextHelpId := 0;
    lpfnMsgBoxCallback := nil;
    dwLanguageId := 0;
  end;
  Result := Integer(MessageBoxIndirect(MsgBoxParams));
end;

end.
