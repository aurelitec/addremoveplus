program arplus;

uses
  Forms,
  main in 'main.pas' {MainForm},
  EditProgram in 'EditProgram.pas' {EditProgramBox},
  AddProgram in 'AddProgram.pas' {AddProgramBox},
  UninstallKeyTools in 'UninstallKeyTools.pas',
  Globals in 'Globals.pas',
  FormAbout in 'FormAbout.pas' {AboutBox},
  FormOptions in 'FormOptions.pas' {OptionsBox},
  configuration in 'configuration.pas',
  FormUninstall in 'FormUninstall.pas' {UninstallBox},
  AddRemoveTools in 'AddRemoveTools.pas',
  FormDeleteKey in 'FormDeleteKey.pas' {DeleteKeyBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Add/Remove Plus!';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TUninstallBox, UninstallBox);
  Application.CreateForm(TDeleteKeyBox, DeleteKeyBox);
  Application.Run;
end.
