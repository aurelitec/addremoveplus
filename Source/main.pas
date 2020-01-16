unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ToolWin, Globals, StdCtrls, ExtCtrls, ImgList, Buttons,
  System.ImageList, URL, SensiCtrls;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    TheStatusBar: TStatusBar;
    FileMenu: TMenuItem;
    ViewMenu: TMenuItem;
    HelpMenu: TMenuItem;
    SmallImages: TImageList;
    AddRemoveMenu: TMenuItem;
    cmdKeyEdit: TMenuItem;
    N1: TMenuItem;
    cmdKeyUninstall: TMenuItem;
    cmdKeyDelete: TMenuItem;
    N2: TMenuItem;
    cmdKeyNew: TMenuItem;
    cmdViewStatusBar: TMenuItem;
    N3: TMenuItem;
    cmdViewList: TMenuItem;
    cmdViewDetails: TMenuItem;
    N4: TMenuItem;
    cmdViewRefresh: TMenuItem;
    LargeImages: TImageList;
    Exit1: TMenuItem;
    cmdViewLargeIcons: TMenuItem;
    cmdViewSmallIcons: TMenuItem;
    ToolbarImages: TImageList;
    AppPopupMenu: TPopupMenu;
    popAddRemove: TMenuItem;
    N6: TMenuItem;
    popDelete: TMenuItem;
    N7: TMenuItem;
    popModify: TMenuItem;
    popNew: TMenuItem;
    N8: TMenuItem;
    popRefresh: TMenuItem;
    DefPopupMenu: TPopupMenu;
    NewKey2: TMenuItem;
    N9: TMenuItem;
    Refresh2: TMenuItem;
    cmdHelpAbout: TMenuItem;
    cmdFileOptions: TMenuItem;
    N5: TMenuItem;
    panClient: TPanel;
    TheListView: TListView;
    panLeftMenu: TPanel;
    Panel1: TPanel;
    panMenuDelete: TSensitivePanel;
    Bevel1: TBevel;
    panMenuAddRemove: TSensitivePanel;
    Bevel2: TBevel;
    panMenuModify: TSensitivePanel;
    Bevel3: TBevel;
    panMenuNew: TSensitivePanel;
    Bevel4: TBevel;
    panMenuRefresh: TSensitivePanel;
    cmdViewLeftMenu: TMenuItem;
    cmdHelpTopics: TMenuItem;
    TheAdvice: TMemo;
    LH1: TMenuItem;
    LH3: TMenuItem;
    cmdHelpAurelitec: TMenuItem;
    cmdHelpAurelitecHome: TMenuItem;
    N13: TMenuItem;
    cmdHelpAurelitecArplus: TMenuItem;
    cmdHelpAurelitecProducts: TMenuItem;
    urlHome: TURL;
    urlProducts: TURL;
    urlArplus: TURL;
    procedure FormCreate(Sender: TObject);
    procedure cmdKeyEditClick(Sender: TObject);
    procedure AddRemoveMenuClick(Sender: TObject);
    procedure cmdKeyNewClick(Sender: TObject);
    procedure cmdKeyUninstallClick(Sender: TObject);
    procedure cmdKeyDeleteClick(Sender: TObject);
    procedure cmdViewLargeIconsClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure TheListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdViewRefreshClick(Sender: TObject);
    procedure TheListViewKeyPress(Sender: TObject; var Key: Char);
    procedure cmdHelpAboutClick(Sender: TObject);
    procedure TheStatusBarResize(Sender: TObject);
    procedure ShowHint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdFileOptionsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cmdViewStatusBarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure panMenuDeleteSensitiveActivate(Sender: TControl;
      var Message: TMessage);
    procedure panMenuDeleteSensitiveDeactivate(Sender: TControl;
      var Message: TMessage);
    procedure cmdViewLeftMenuClick(Sender: TObject);
    procedure cmdHelpTopicsClick(Sender: TObject);
    procedure TheAdviceEnter(Sender: TObject);
    procedure TheListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cmdHelpAurelitecHomeClick(Sender: TObject);
    procedure cmdHelpAurelitecProductsClick(Sender: TObject);
    procedure cmdHelpAurelitecArplusClick(Sender: TObject);
  protected
    procedure WMDropFiles(var msg : TMessage); message WM_DROPFILES;
  private
    procedure LoadEntries(const TheEntry : string);
    procedure AddUninstallKey(const EntryName, KeyName, Command : string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses Registry, Clipbrd, EditProgram, ShellFiles, AddProgram,
  UninstallKeyTools, FormAbout, VCLToolsPlus, ShellAPI,
  uShortCut, FileInfoUtils, FileUtils, FormOptions, configuration,
  FormUninstall, VCLRegSavers, AddRemoveTools, FormDeleteKey;

procedure TfrmMain.LoadEntries(const TheEntry : string);
var
  Reg : TRegistry;
  Keys : TStrings;
  I, SelIdx, KeyCount : Integer;
begin
  SelIdx := 0;
  Screen.Cursor := crHourGlass;
  TheListView.Items.BeginUpdate;
  try

  KeyCount := 0;
  with TheListView do
  begin
    if SelCount > 0 then SelIdx := Selected.Index;
    if TheEntry = '' then TheListView.Items.Clear
    else
    begin
      for I := 0 to Items.Count - 1 do
        if Items[I].SubItems[1] = TheEntry then
          begin Items.Delete(I); Break; end;
    end;
  end;

  Reg := TRegistry.Create;
  with Reg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly(sUninstallSection) then
    begin
      Keys := TStringList.Create;
      try
        if TheEntry <> '' then Keys.Add(TheEntry)
        else GetKeyNames(Keys); { read all keys }
        for I := 0 to Keys.Count - 1 do
        begin
          CloseKey;
          if OpenKeyReadOnly(sUninstallSection + '\' + Keys.Strings[I]) then
          begin
            if ValueExists(sDisplayName) and ValueExists(sUninstallString) then
            with TheListView.Items.Add do
            begin
              Caption := ReadString(sDisplayName);
              if Caption = '' then Caption := ReadString('<no name>');
              SubItems.Add(ReadString(sUninstallString));
              SubItems.Add(Keys.Strings[I]);
              ImageIndex := 0;
              if optShowBadPrograms.Bool and
                (not AllPathsExist(SubItems[0])) then ImageIndex := 1;
              Inc(KeyCount);
            end;
            CloseKey;
          end;
        end;
      finally
        Keys.Free;
      end;
    end;
  finally
    Reg.Free;
  end;

  if TheEntry = '' then
    TheStatusBar.Panels[1].Text := IntToStr(KeyCount) + ' programs';

  finally
    try
      TheListView.Items.EndUpdate;
      if (SelIdx >= 0) and (SelIdx < TheListView.Items.Count) then { reselect previous selected item }
        with TheListView do
        begin
          if SelIdx < Items.Count then
            with Items[SelIdx] do
            begin
              Selected := True; Focused := True; MakeVisible(False);
            end;
        end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

(*********************************************************************)
(* The File Menu                                                      *)
(*********************************************************************)

procedure TfrmMain.cmdFileOptionsClick(Sender: TObject);
var
  MR : Integer;
begin
  with TOptionsBox.Create(Self) do try MR := ShowModal; finally Free; end;
  if MR = mrOk then LoadEntries('');
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

(*********************************************************************)
(* The Add/Remove Menu                                               *)
(*********************************************************************)

procedure TfrmMain.AddRemoveMenuClick(Sender: TObject);
var
  AnyKey : Boolean;
begin
  AnyKey := TheListView.SelCount > 0;
  cmdKeyUninstall.Enabled := AnyKey;
  cmdKeyDelete.Enabled := AnyKey;
  cmdKeyEdit.Enabled := AnyKey;
end;

procedure TfrmMain.cmdKeyUninstallClick(Sender: TObject);
var
  AppName : string;
begin
  if TheListView.SelCount <= 0 then Exit;

  AppName := TheListView.Selected.Caption;
  if AppName = '' then AppName := TheListView.Selected.SubItems[1];

  with TUninstallBox.Create(Self) do
  try
    panAppName.Caption := AppName;
    uninstCommand := TheListView.Selected.SubItems[0];
    entryName := TheListView.Selected.SubItems[1];
    ShowModal;
    if fSomethingUninstalled then LoadEntries('');
  finally
    Free;
  end;
end;

procedure TfrmMain.cmdKeyDeleteClick(Sender: TObject);
var
  TheKey : string;
begin
  if TheListView.SelCount <= 0 then Exit;
  TheKey := TheListView.Selected.SubItems[1];

  DeleteKeyBoxNameInAdvice := TheListView.Selected.Caption;
  with TDeleteKeyBox.Create(Self) do
  try
    ShowModal;
    case DeleteDecision of
      0: begin cmdKeyUninstall.OnClick(Self); Exit; end; // uninstall
//    1: continue
      2: Exit; // cancel
    end;
  finally
    Free;
  end;

{  if optConfirmDeletion.Bool then
    if Application.MessageBox(PChar(Format(sConfirmKeyDeletion, [TheListView.Selected.Caption])),
      PChar(sConfirmKeyDeletionTitle), MB_ICONQUESTION or MB_YESNOCANCEL or MB_DEFBUTTON3) <> IDYES then Exit;}

  if DeleteUninstallKey(TheKey) = False then
    Application.MessageBox('Unable to delete key', nil, MB_ICONERROR);
  LoadEntries('');
end;

procedure TfrmMain.cmdKeyEditClick(Sender: TObject);
var
  TheKey : string;
begin
  if TheListView.SelCount <= 0 then Exit;
  with TEditProgramBox.Create(Self) do
  try
    ediName.Text := TheListView.Selected.Caption;
    ediCommand.Text := TheListView.Selected.SubItems[0];
    ShowModal;
    if ModalResult = mrOK then
    begin { update the key }
      TheKey := TheListView.Selected.SubItems[1];
      if not SetUninstallKey(TheKey, ediName.Text, ediCommand.Text, False) then
        ShowAppErrorBox(sUnableToEditKey, ebtApplication);
      LoadEntries(TheKey);
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.AddUninstallKey(const EntryName, KeyName, Command : string);
var
  TheKey : string;
begin
  while True do
  begin

  with TAddProgramBox.Create(Self) do
  try
    ediEntry.Text := EntryName;
    ediName.Text := KeyName;
    ediCommand.Text := Command;
    ShowModal;

    if ModalResult = mrOK then
    begin { add the key }
      TheKey := ediEntry.Text;
      if UninstallKeyExists(TheKey) then { key already exists }
        case ShowAppQueryBox(Format(sConfirmKeyOverwrite, [TheKEy]), MB_YESNOCANCEL) of
          ID_NO: Continue;
          ID_CANCEL: Break;
        end;

       if not SetUninstallKey(TheKey, ediName.Text, ediCommand.Text, True) then
        ShowAppErrorBox(sUnableToCreateKey, ebtApplication);
      LoadEntries('');
      Break;
    end
    else Break;

  finally
    Free;
  end;

  end;
end;

procedure TfrmMain.cmdKeyNewClick(Sender: TObject);
var
  I : Integer;
  S : string;
begin
  for I := 0 to 1000 do
  begin
    S := 'Application' + IntToStr(I);
    if UninstallKeyExists(S) then Continue;
    AddUninstallKey(S, '', ''); Exit;
  end;
  AddUninstallKey('', '', '');
end;

(*********************************************************************)
(* The View Menu                                                     *)
(*********************************************************************)

procedure TfrmMain.cmdViewLeftMenuClick(Sender: TObject);
begin
  cmdViewLeftMenu.Checked := not cmdViewLeftMenu.Checked;
  optDeskShowLeftMenu.Bool := cmdViewLeftMenu.Checked;
  panLeftMenu.Visible := optDeskShowLeftMenu.Bool;
end;

procedure TfrmMain.cmdViewStatusBarClick(Sender: TObject);
begin
  cmdViewStatusBar.Checked := not cmdViewStatusBar.Checked;
  optDeskShowStatusBar.Bool := cmdViewStatusBar.Checked;
  TheStatusBar.Visible := optDeskShowStatusBar.Bool;
end;

procedure TfrmMain.cmdViewLargeIconsClick(Sender: TObject);
var
  I : Integer;
begin
  I := (Sender as TComponent).Tag;
  TheListView.ViewStyle := TViewStyle(I);
  ViewMenu.Items[I + 3].Checked := True;
end;

procedure TfrmMain.cmdViewRefreshClick(Sender: TObject);
begin
  LoadEntries('');
end;

(*********************************************************************)
(* The Help Menu                                                     *)
(*********************************************************************)

procedure TfrmMain.cmdHelpAboutClick(Sender: TObject);
begin
  with TAboutBox.Create(Self) do try ShowModal; finally Free; end;
end;

procedure TfrmMain.cmdHelpTopicsClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TfrmMain.cmdHelpAurelitecHomeClick(Sender: TObject);
begin
  urlHome.Execute;
end;

procedure TfrmMain.cmdHelpAurelitecProductsClick(Sender: TObject);
begin
  urlProducts.Execute;
end;

procedure TfrmMain.cmdHelpAurelitecArplusClick(Sender: TObject);
begin
  urlArplus.Execute;
end;

(*********************************************************************)
(* Main List View routines                                           *)
(*********************************************************************)

procedure TfrmMain.TheListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var { display context menu }
  P : TPoint;
begin
  if (Button = mbRight) then
  begin
    P.X := X; P.Y := Y; P := TheListView.ClientToScreen(P);
    if TheListView.GetItemAt(X, Y) <> nil then AppPopupMenu.Popup(P.X, P.Y)
    else DefPopupMenu.Popup(P.X, P.Y)
  end;
end;

procedure TfrmMain.TheListViewKeyPress(Sender: TObject; var Key: Char);
begin { uninstall when Enter key }
  if Key = Char(VK_RETURN) then cmdKeyUninstall.OnClick(Self);
end;

procedure TfrmMain.TheStatusBarResize(Sender: TObject);
begin
  TheStatusBar.Panels[0].Width := TheStatusBar.Width - 100;
end;

procedure TfrmMain.TheListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if not optShowBadPrograms.Bool then Exit;
  if Change = ctState then
    if TheListView.Selected <> nil then
      with TheListView.Selected do
        if ImageIndex = 1 then
          TheAdvice.Text := Format(sAdviceBadProgram, [Caption])
        else
          TheAdvice.Text := '';
end;

(*********************************************************************)
(* Main Form routines (constructors, etc.)                           *)
(*********************************************************************)

procedure TfrmMain.WMDropFiles(var msg : TMessage);
var { Drag-and-Drop Interface with the Explorer }
  hDrop : UINT;
  I, Count, BufSize  : UINT;
  FName : String;

  procedure AddLNKFile(const FileName : string);
  var
    SI : TShortcutInfo;
    FD : TWin32FindData;
  begin
    ReadShortcut(Self.Handle, FileName, [spAll], SI);
    FileDatafound(FileName, FD);
    AddUninstallKey(ExtractFileNameWithoutExt(FD.cAlternateFileName),
      ExtractFileNameWithoutExt(ExtractFileName(FileName)), SI.Target + ' ' + SI.Arguments);
  end;

begin
  hDrop := Msg.wParam;
  try
    Application.BringToFront; // bring program to front
    Count := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);
    for I := 0 to Count - 1 do
    begin
      BufSize := DragQueryFile(hDrop, I, nil, 0);
      SetLength(FName, BufSize);
      DragQueryFile(hDrop, I, PChar(FName), BufSize + 1);
      if UpperCase(ExtractFileExt(FName)) = '.LNK' then AddLNKFile(FName);
    end;
    Msg.Result := 0;
  finally
    inherited;
    DragFinish(hDrop);
  end;
end;

procedure TfrmMain.ShowHint(Sender: TObject);
begin
  if (Application.Hint <> '') and (Application.Hint <> ':') then
  begin
    with TheStatusBar.Panels[0] do
    begin
      Width := TheStatusBar.Width; Bevel := pbNone; Text := Application.Hint;
    end;
  end
  else
    with TheStatusBar.Panels[0] do
    begin
      Width := TheStatusBar.Width - 100; Bevel := pbLowered;
      Text := sStatusBarAdvice;
    end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  try
    Application.OnHint := ShowHint;       { hint event-handler }
    Application.HelpFile := ExtractFilePath(Application.ExeName) + 'ARPLUS.HLP';
    DragAcceptFiles(Handle, True); { init drag-and-drop }
    with TheListView do { set-up the list view }
      begin RowSelect := True; SortType := stText; ReadOnly := True; end;
    TheStatusBar.Panels[0].Text := sStatusBarAdvice;
  finally
    CreateOptions;
    LoadEntries('');
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DragAcceptFiles(Handle, false);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  try
    SaveWindowState(Self, REG_AppRoot, REG_optDesk); { save window state and position }
    if WindowState = wsNormal then SaveControlPlacement(Self, REG_AppRoot, REG_optDesk);
    optDeskViewStyle.Int := Integer(TheListView.ViewStyle);
  finally
    FreeOptions;
  end;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  LoadWindowState(Self, REG_AppRoot, REG_optDesk); { window state }
  cmdViewStatusBar.Checked := optDeskShowStatusbar.Bool;
  TheStatusBar.Visible := optDeskShowStatusBar.Bool;

  cmdViewLeftMenu.Checked := optDeskShowLeftMenu.Bool;
  panLeftMenu.Visible := optDeskShowLeftMenu.Bool;

  ViewMenu.Items[3 + optDeskViewStyle.Int].Checked := True;
  TheListView.ViewStyle := TViewStyle(optDeskViewStyle.Int);

  { Hints }
  panMenuAddRemove.Hint := cmdKeyUninstall.Hint;
  panMenuDelete.Hint := cmdKeyDelete.Hint;
  panMenuModify.Hint := cmdKeyEdit.Hint;
  panMenuNew.Hint := cmdKeyNew.Hint;
  panMenuRefresh.Hint := cmdViewRefresh.Hint;

  popAddRemove.Hint := cmdKeyUninstall.Hint;
  popDelete.Hint := cmdKeyDelete.Hint;
  popModify.Hint := cmdKeyEdit.Hint;
  popNew.Hint := cmdKeyNew.Hint;
  popRefresh.Hint := cmdViewRefresh.Hint;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  LoadControlPlacement(Self, REG_AppRoot, REG_optDesk); { window position and size }
end;

procedure TfrmMain.panMenuDeleteSensitiveActivate(Sender: TControl;
  var Message: TMessage);
begin
  (Sender As TPanel).Color := clHighlight;
  (Sender As TPanel).Font.Color := clWhite;
end;

procedure TfrmMain.panMenuDeleteSensitiveDeactivate(Sender: TControl;
  var Message: TMessage);
begin
  (Sender As TPanel).Color := clBtnFace;
  (Sender As TPanel).Font.Color := clBlack;
end;

procedure TfrmMain.TheAdviceEnter(Sender: TObject);
begin
  try TheListView.SetFocus; except end;
end;

end.
