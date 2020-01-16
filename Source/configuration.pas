unit Configuration;

interface

uses Options, Classes;

resourcestring
  REG_AppRoot = 'Software\Aurelitec\Add Remove Plus'; { app root entry }
  REG_optGen = 'Options'; { general options }
  REG_optDesk = 'Desktop';

var
  optGen   : TOptions;
  optDesk  : TOptions;

{ General options }
var
  optConfirmUninstall  : TBoolOption;
  optConfirmDeletion   : TBoolOption;
  optWarnCPKey         : TBoolOption;
  optShowBadPrograms   : TBoolOption;

{ Desktop options }
var
  optDeskShowLeftMenu        : TBoolOption;
  optDeskShowStatusBar       : TBoolOption;
  optDeskViewStyle           : TIntOption;

procedure CreateOptions;
procedure FreeOptions;

implementation

uses SysUtils, Forms, RegistryTools, Globals;

procedure CreateOptions;
begin
  { Create general options }
  optGen := TOptions.Create(REG_AppRoot, REG_optGen);
  with optGen do
  begin
    optConfirmDeletion   := AddBool('ConfirmDeletion', True);
    optConfirmUninstall  := AddBool('ConfirmUninstall', True);
    optWarnCPKey         := AddBool('CheckControlPanelList', True);
    optShowBadPrograms   := AddBool('ShowMissingUninstallers', True);
  end;

  { Create desktop options }
  optDesk := TOptions.Create(REG_AppRoot, REG_optDesk);
  with optDesk do
  begin
    optDeskShowLeftMenu  := AddBool('ViewLeftMenu', True);
    optDeskShowStatusBar := AddBool('ViewStatusBar', True);
    optDeskViewStyle     := AddInt('MainViewStyle', 0);
  end;

  { Load options from registry }
  optGen.LoadFromRegistry;
  optDesk.LoadFromRegistry;
end;

procedure FreeOptions;
begin
  try
    optGen.SaveToRegistry;
    optDesk.SaveToRegistry;
  finally
    optGen.Free;
    optDesk.Free;
  end;
end;

end.
