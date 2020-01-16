unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ToolWin, Globals, StdCtrls, ExtCtrls, ImgList, Buttons,
  SensiControls, URL
  {$IFDEF ARPLUS_AD}, CTError, CTMgmt, CTPush, CTTypes, CTUtils, GenericFunctions {$ENDIF};

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    TheStatusBar: TStatusBar;
    File1: TMenuItem;
    mnuView: TMenuItem;
    Tools1: TMenuItem;
    SmallImages: TImageList;
    mnuKey: TMenuItem;
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
    LH2: TMenuItem;
    cmdHelpTopics: TMenuItem;
    TheAdvice: TMemo;
    LH1: TMenuItem;
    cmdHelpPurchase: TMenuItem;
    LH3: TMenuItem;
    cmdHelpAurelitec: TMenuItem;
    cmdHelpAurelitecHome: TMenuItem;
    N13: TMenuItem;
    cmdHelpAurelitecArplus: TMenuItem;
    cmdHelpAurelitecProducts: TMenuItem;
    urlHome: TURL;
    urlProducts: TURL;
    urlArplus: TURL;
    ActivityTimer: TTimer;
    panTop: TPanel;
    PaintBox1: TPaintBox;
    imgadarea1: TPanel;
    imgAdarea2: TPanel;
    imgAdarea3: TPanel;
    panBottom: TPanel;
    PaintBox2: TPaintBox;
    imgAdarea4: TPanel;
    imgAdarea5: TPanel;
    imgAdarea6: TPanel;
    imgAdarea7: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure cmdKeyEditClick(Sender: TObject);
    procedure mnuKeyClick(Sender: TObject);
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
    procedure cmdHelpPurchaseClick(Sender: TObject);
    procedure cmdHelpAurelitecHomeClick(Sender: TObject);
    procedure cmdHelpAurelitecProductsClick(Sender: TObject);
    procedure cmdHelpAurelitecArplusClick(Sender: TObject);
    procedure Tools1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ActivityTimerTimer(Sender: TObject);
    procedure imgAdarea1Click(Sender: TObject);
    procedure imgAdarea1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgAdarea3Click(Sender: TObject);
    procedure imgAdarea3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgAdarea2Click(Sender: TObject);
    procedure imgAdarea2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgAdarea4Click(Sender: TObject);
    procedure imgAdarea4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgAdarea5Click(Sender: TObject);
    procedure imgAdarea5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgAdarea6Click(Sender: TObject);
    procedure imgAdarea6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgAdarea7Click(Sender: TObject);
    procedure imgAdarea7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
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
  FormUninstall, VCLRegSavers, AddRemoveTools, FormOrder, FormDeleteKey;

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
    if OpenKey(sUninstallSection, False) then
    begin
      Keys := TStringList.Create;
      try
        if TheEntry <> '' then Keys.Add(TheEntry)
        else GetKeyNames(Keys); { read all keys }
        for I := 0 to Keys.Count - 1 do
        begin
          CloseKey;
          if OpenKey(sUninstallSection + '\' + Keys.Strings[I], False) then
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

procedure TfrmMain.mnuKeyClick(Sender: TObject);
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
  mnuView.Items[I + 3].Checked := True;
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

procedure TfrmMain.cmdHelpPurchaseClick(Sender: TObject);
begin
  with TOrderBox.Create(Self) do try ShowModal; finally Free; end;
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
  {$IFDEF ARPLUS_AD}

  { initialize the ad system }
  if CT_InitAdSystem () then
  begin
    ActivityTimer.Enabled := true;
    ActivityTimer.Interval := 50;

    { Initialize Ad Areas }
    CT_InitAdSpace();
  end;

  {$ELSE}
  panTop.Visible := False;
  panBottom.Visible := False;
  {$ENDIF}

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
  { shut down the ad system if the application is exiting }
  {$IFDEF ARPLUS_AD}
  CT_ShutdownAdSystem ();
  ActivityTimer.Enabled := false;
  {$ENDIF}

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

  mnuView.Items[3 + optDeskViewStyle.Int].Checked := True;
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

procedure TfrmMain.Tools1Click(Sender: TObject);
begin
  {$IFNDEF ARPLUS_AD}
  cmdHelpPurchase.Visible := False; LH1.Visible := False;
  {$ENDIF}
end;

(***********************************************************************)
(* CONDUCENT                                                           *)
(***********************************************************************)

procedure TfrmMain.imgAdarea1Click(Sender: TObject);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea1.Cursor := crHourglass;
  if (t_Banner.adLoc <> CT_NOHANDLE) then
    CT_MgmtALClick(t_Banner.adLoc);
  imgAdarea1.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea1.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea3Click(Sender: TObject);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea3.Cursor := crHourglass;
  if (t_Button1.adLoc <> CT_NOHANDLE) then
    CT_MgmtALClick(t_Button1.adLoc);
  imgAdarea3.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea2.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea2Click(Sender: TObject);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea2.Cursor := crHourglass;
  if (t_Button2.adLoc <> CT_NOHANDLE) then
    CT_MgmtALClick(t_Button2.adLoc);
  imgAdarea2.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea3.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea4Click(Sender: TObject);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea4.Cursor := crHourglass;
  if (t_MButton1.adLoc <> CT_NOHANDLE) then
    CT_MgmtALClick(t_MButton1.adLoc);
  imgAdarea4.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea4MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea4.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea5Click(Sender: TObject);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea5.Cursor := crHourglass;
  if (t_MButton2.adLoc <> CT_NOHANDLE) then
    CT_MgmtALClick(t_MButton2.adLoc);
  imgAdarea5.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea5MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea5.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea6Click(Sender: TObject);
begin
  {$IFDEF ARPLUS_AD}
   imgAdarea6.Cursor := crHourglass;
   if (t_MButton3.adLoc <> CT_NOHANDLE) then
     CT_MgmtALClick(t_MButton3.adLoc);
   imgAdarea6.Cursor := crHandpoint;
   {$ENDIF}
end;

procedure TfrmMain.imgAdarea6MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea6.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.imgAdarea7Click(Sender: TObject);
begin
  {$IFDEF ARPLUS_AD}
   imgAdarea7.Cursor := crHourglass;
   if (t_MButton4.adLoc <> CT_NOHANDLE) then
     CT_MgmtALClick(t_MButton4.adLoc);
   imgAdarea7.Cursor := crHandpoint;
   {$ENDIF}
end;

procedure TfrmMain.imgAdarea7MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  {$IFDEF ARPLUS_AD}
  imgAdarea7.Cursor := crHandpoint;
  {$ENDIF}
end;

procedure TfrmMain.FormResize(Sender: TObject);
{$IFDEF ARPLUS_AD}
var
  BannerWidth, BannerHeight  : Integer;
  ButtonWidth : Integer;
  MicroButtonWidth, MicroButtonHeight : Integer;
  EquiDistBottom, EquiDistTop : Integer;
  MinFrmHeight, MinFrmWidth : Integer;
{$ENDIF}
begin
{$IFDEF ARPLUS_AD}
    BannerWidth       := 468;
    BannerHeight      := 60;
    ButtonWidth       := 55;
    MicroButtonWidth  := 88;
    MicroButtonHeight := 31;
    EquiDistBottom    := 60;
    EquiDistTop       := 18;
    MinFrmHeight      := BannerHeight + MicroButtonHeight + 72;
    MinFrmWidth       := BannerWidth + ButtonWidth + 80;

    if (frmMain.Width < MinFrmWidth) then
        frmMain.Width := MinFrmWidth;

    if (frmMain.Height < MinFrmHeight) then
    begin
      frmMain.Height := MinFrmHeight;
      frmMain.panClient.Visible := false;
    end
    else
      frmMain.panClient.Visible := true;

    if (frmMain.Width >= MinFrmWidth) then
    begin
      imgAdArea1.Left  := (frmMain.Width - (BannerWidth + ButtonWidth +
                         EquiDistTop)) div 2;
      imgAdArea2.Left := imgAdArea1.Left + BannerWidth + EquiDistTop;
      imgAdArea3.Left := imgAdArea2.Left;

      imgAdArea4.Left := (frmMain.Width - ((MicroButtonWidth * 4) +
                         (EquiDistBottom * 3))) div 2;
      imgAdArea5.Left := imgAdArea4.Left + MicroButtonWidth +
                         EquiDistBottom;
      imgAdArea6.Left := imgAdArea5.Left + MicroButtonWidth +
                         EquiDistBottom;
      imgAdArea7.Left := imgAdArea6.Left + MicroButtonWidth +
                         EquiDistBottom;
    end;
{$ENDIF}
end;

{----------------- Delphisample3 Application initialization ----------------- }

procedure TfrmMain.FormPaint(Sender: TObject);
begin
  {$IFDEF ARPLUS_AD}
  frmMain.Update;
  CT_DrawAd(@t_Banner);
  CT_DrawAd(@t_Button1);
  CT_DrawAd(@t_Button2);
  CT_DrawAd(@t_MButton1);
  CT_DrawAd(@t_MButton2);
  CT_DrawAd(@t_MButton3);
  CT_DrawAd(@t_MButton4);
  {$ENDIF}
end;

procedure TfrmMain.ActivityTimerTimer(Sender: TObject);
begin
  {$IFDEF ARPLUS_AD}
  CT_AdProgress ();
  {$ENDIF}
end;

end.
