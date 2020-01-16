{ --------------------------------------------------------------------------
                     GenericFunctions.pas

 Copyright 1999. Conducent Technologies, Inc. All Rights Reserved.
  -------------------------------------------------------------------------- }
unit GenericFunctions;

interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, ShellAPI,CTError, CTMgmt,
  CTPush, CTTypes, CTUtils;

type

  TAdDisplay    = Record
    imgArea     : TPanel;
    adLoc       : CT_ALHANDLE;
    adImg       : PBITMAPINFOHEADER;
    adPalette   : HPALETTE;
  end;

  PTAdDisplay = ^TAdDisplay;

var
  { globals.}
  t_Banner, t_Button1, t_Button2 : TAdDisplay;
  t_MButton1, t_MButton2, t_MButton3, t_MButton4 : TAdDisplay;

 Function CT_InitAdSystem() : BOOLEAN;stdcall;

 Function CT_ShutdownAdSystem () : Integer;stdcall;

 Function CT_InitAdSpace() : Integer;

 Function CT_CreateAdLocation (adType     : AdType_t;
                               adPosition : AdPosition_t;
                               adSpace    : Pointer) : CT_ALHANDLE;stdcall;

 Function CT_AdDisplayCallback(adLoc            : CT_ALHANDLE;
                               schedID          : SchedID_t;
                               gfxFile          : PChar;
                               gfxFormat        : DWORD;
                               sndFile          : PChar;
                               sndFormat        : DWORD;
                               maxAdDisplayTime : LongInt;
                               flags            : DWORD;
                               userContext      : pointer) :Integer;stdcall;

 Function CT_ClickCallback (adLoc       : CT_ALHANDLE;
                            schedID     : SchedID_t;
                            userContext : Integer): Integer;stdcall;


 Function  CT_AdProgress() : Integer;stdcall;

 Function LoadAdImage(gfxFile : pChar;
                      pnlHandle : PTAdDisplay) : BOOLEAN;

 Function CT_DrawAd(adArea : PTAdDisplay) :integer;

implementation

/////////////////////////////////////////////////////////////////////////////////////
//
//			AD SYSTEM INITIALIZATION AND CLEANUP FUNCTIONS
//
//
/////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

uses Main;

{ ------------------------- (CT_InitAdSystem Function) --------------------- }
Function CT_InitAdSystem() : BOOLEAN;
var
  rc : Integer;
  err : String;
begin          
  { initialize the push component }
  rc := CT_PushInit ('ARPLUS', { registered application name }
                     'LAPIOVRA294',      { developer password }
                     0);              { flags }
  if CT_RET_OK <> rc then             { error initializing push system? }
  begin
    err := 'Ad Push system init error: ' + CT_PushGetErrorString(rc)
            + CT_PushGetLibError();
    MessageDlg(err, mtError,[mbOk], 0);
    CT_InitAdSystem := False;
    Exit;
  end;

  { initialize the management component }
  rc := CT_MgmtInit ('ARPLUS', { registered application name }
                     'LAPIOVRA294',      { developer password }
                     0);              { flags }
  if CT_RET_OK <> rc then             { error initializing management system? }
  begin
    err := 'Ad Management system init error: ' + CT_MgmtGetErrorString(rc)
           + CT_MgmtGetLibError();
    MessageDlg (err, mterror, [mbok], 0);
    CT_InitAdSystem := False;
    Exit;
  end;

  CT_InitAdSystem := True;

end;
{ ------------------------- (end of CT_InitAdSystem Function) -------------- }

{ ------------------------- (CT_ShutdownAdSystem Function) ----------------- }
Function CT_ShutdownAdSystem () : Integer;
var
      adLocStatus : Longword;
begin

  adLocStatus := CT_MgmtGetALStatus (t_Banner.adLoc);
  adLocStatus := (adLocStatus and (not CT_AL_ACTIVE));{ mark the ad location as inactive}
  CT_MgmtSetALStatus (t_Banner.adLoc, adLocStatus);
  CT_MgmtDestroyAL(t_Banner.adLoc);

  adLocStatus := CT_MgmtGetALStatus (t_Button1.adLoc);
  adLocStatus := (adLocStatus and (not CT_AL_ACTIVE));{ mark the ad location as inactive}
  CT_MgmtSetALStatus (t_Button1.adLoc, adLocStatus);
  CT_MgmtDestroyAL(t_Button1.adLoc);

  adLocStatus := CT_MgmtGetALStatus (t_Button2.adLoc);
  adLocStatus := (adLocStatus and (not CT_AL_ACTIVE));{ mark the ad location as inactive}
  CT_MgmtSetALStatus (t_Button2.adLoc, adLocStatus);
  CT_MgmtDestroyAL(t_Button2.adLoc);

  adLocStatus := CT_MgmtGetALStatus (t_MButton1.adLoc);
  adLocStatus := (adLocStatus and (not CT_AL_ACTIVE));{ mark the ad location as inactive}
  CT_MgmtSetALStatus (t_MButton1.adLoc, adLocStatus);
  CT_MgmtDestroyAL(t_MButton1.adLoc);

  adLocStatus := CT_MgmtGetALStatus (t_MButton2.adLoc);
  adLocStatus := (adLocStatus and (not CT_AL_ACTIVE));{ mark the ad location as inactive}
  CT_MgmtSetALStatus (t_MButton2.adLoc, adLocStatus);
  CT_MgmtDestroyAL(t_MButton2.adLoc);

  adLocStatus := CT_MgmtGetALStatus (t_MButton3.adLoc);
  adLocStatus := (adLocStatus and (not CT_AL_ACTIVE));{ mark the ad location as inactive}
  CT_MgmtSetALStatus (t_MButton3.adLoc, adLocStatus);
  CT_MgmtDestroyAL(t_MButton3.adLoc);

  adLocStatus := CT_MgmtGetALStatus (t_MButton4.adLoc);
  adLocStatus := (adLocStatus and (not CT_AL_ACTIVE));{ mark the ad location as inactive}
  CT_MgmtSetALStatus (t_MButton4.adLoc, adLocStatus);
  CT_MgmtDestroyAL(t_MButton4.adLoc);

  CT_MgmtShutdown(); { shut down management Operations }
  CT_PushShutdown (); { shut down Push Operations }
  CT_ShutdownAdSystem := 0;

end;
{ ------------------------- (end of CT_ShutdownAdSystem Function) ---------- }

{ ------------------------- (InitAdSpace Function) ------------------------- }
function CT_InitAdSpace() : Integer;
begin

  { create ad location for Ad-1 }
  t_Banner.imgarea := frmMain.imgadarea1;
  t_Banner.adImg := nil;
  t_Banner.adPalette := 0;
  t_Banner.adLoc := CT_NOHANDLE;
  t_Banner.adLoc := CT_CreateAdLocation(CT_ADTYPE_IAB_CASIE_FULLBANNER,
                                        CT_ADPOSITION_NONE_SPECIFIED,
                                        @t_Banner);
  if (CT_NOHANDLE = t_Banner.adLoc) then
  begin
    Messagedlg('Unable to initialize advertising banner space, Advertising Space Creation Error',
               MTERROR,[MBOK],0);
    CT_InitAdSpace := -1;
    Exit;
  end;

  { create ad location for Ad-2 }
  t_Button1.imgarea := frmMain.imgadarea2;
  t_Button1.adImg := nil;
  t_Button1.adPalette := 0;
  t_Button1.adLoc := CT_NOHANDLE;
  t_Button1.adLoc := CT_CreateAdLocation(CT_ADTYPE_APPLICATION_BUTTON,
                                         CT_ADPOSITION_CHAT,
                                         @t_Button1);
  if (CT_NOHANDLE = t_Button1.adLoc) then
  begin
    Messagedlg('Unable to initialize advertising banner space, Advertising Space Creation Error',
    	       MTERROR,[MBOK],0);
    CT_InitAdSpace := -1;
    Exit;
  end;

  { create ad location for Ad-3 }
  t_Button2.imgarea := frmMain.imgadarea3;
  t_Button2.adImg := nil;
  t_Button2.adPalette := 0;
  t_Button2.adLoc := CT_NOHANDLE;
  t_Button2.adLoc := CT_CreateAdLocation(CT_ADTYPE_APPLICATION_BUTTON,
                     	                 CT_ADPOSITION_SEARCH,
                                         @t_Button2);
  if (CT_NOHANDLE = t_Button2.adLoc) then
  begin
    Messagedlg('Unable to initialize advertising banner space, Advertising Space Creation Error',
     	       MTERROR,[MBOK],0);
    CT_InitAdSpace := -1;
    Exit;
  end;

  { create ad location for Ad-4 }
  t_MButton1.imgarea := frmMain.imgadarea4;
  t_MButton1.adImg := nil;
  t_MButton1.adPalette := 0;
  t_MButton1.adLoc := CT_NOHANDLE;
  t_MButton1.adLoc := CT_CreateAdLocation(CT_ADTYPE_IAB_CASIE_MICROBUTTON,
                   			  CT_ADPOSITION_SPECIAL1,
                                          @t_MButton1);
  if (CT_NOHANDLE = t_MButton1.adLoc) then
  begin
    MessageDlg('Unable to initialize first specialized adverting space, Advertising Space Creation Error',
               MTERROR,[MBOK],0);
    CT_InitAdSpace := -1;
    Exit;
  end;

  { create ad location for Ad-5 }
  t_MButton2.imgarea := frmMain.imgadarea5;
  t_MButton2.adImg := nil;
  t_MButton2.adPalette := 0;
  t_MButton2.adLoc := CT_NOHANDLE;
  t_MButton2.adLoc := CT_CreateAdLocation(CT_ADTYPE_IAB_CASIE_MICROBUTTON,
                                          CT_ADPOSITION_SPECIAL2,
                                          @t_MButton2);
  if (CT_NOHANDLE = t_MButton2.adLoc) then
  begin
    MessageDlg('Unable to initialize second specialized adverting space, Advertising Space Creation Error',
               MTERROR,[MBOK],0);
    CT_InitAdSpace := -1;
    Exit;
  end;

  { create ad location for Ad-6 }
  t_MButton3.imgarea := frmMain.imgadarea6;
  t_MButton3.adImg := nil;
  t_MButton3.adPalette := 0;
  t_MButton3.adLoc := CT_NOHANDLE;
  t_MButton3.adLoc := CT_CreateAdLocation(CT_ADTYPE_IAB_CASIE_MICROBUTTON,
     			                  CT_ADPOSITION_SPECIAL3,
                                          @t_MButton3);
  if (CT_NOHANDLE = t_MButton3.adLoc) then
  begin
    MessageDlg('Unable to initialize third specialized adverting space, Advertising Space Creation Error',
               MTERROR,[MBOK],0);
    CT_InitAdSpace := -1;
    Exit;
  end;

  { create ad location for Ad-7 }
  t_MButton4.imgarea := frmMain.imgadarea7;
  t_MButton4.adImg := nil;
  t_MButton4.adPalette := 0;
  t_MButton4.adLoc := CT_NOHANDLE;
  t_MButton4.adLoc := CT_CreateAdLocation(CT_ADTYPE_IAB_CASIE_MICROBUTTON,
                                          CT_ADPOSITION_SPECIAL4,
                                          @t_MButton4);
  if (CT_NOHANDLE = t_MButton4.adLoc) then
  begin
    MessageDlg('Unable to initialize fourth specialized adverting space, Advertising Space Creation Error',
               MTERROR,[MBOK],0);
    CT_InitAdSpace := -1;
    Exit;
  end;

  CT_InitAdSpace := 0;
  
end;
{ ------------------------- (End of InitAdSpace Function) ------------------------- }

{ ------------------------- (CT_CreateAdLocation Function) ------------------ }
Function CT_CreateAdLocation (adType : AdType_t;
                              adPosition : AdPosition_t;
                              adSpace : Pointer) : CT_ALHANDLE;
var
   adTypebuf   : array[1..1] of AdType_t;
   err         : String;
   cbBuf       : CT_MgmtALCallbacks_t;
   rc          : Integer;
   adLocStatus : Longword;
   adLoc       : CT_ALHANDLE;
begin

   adTypebuf[1] := adtype;
   adLoc := CT_MgmtCreateAL3(addr(adtypebuf),
                             1,
                             CT_ADORIENT_NORMAL,
                             CT_ADTIMESLOT_RUNNING,
                             adPosition,
                             0);
   if CT_NOHANDLE = adLoc then { couldn't get a handle? }
   begin
     err := 'Cannot create ad location ' + CT_MgmtGetLibError();
     MessageDlg (err, MTWARNING,[MBOK], 0);
     CT_CreateAdLocation := CT_NOHANDLE;
     Exit;
   end;

   if CT_NOHANDLE <> adLoc then { could get a handle? }
   begin
     FillChar(cbBuf, 0, sizeof(CT_MgmtALCallbacks_t)); { clear the struct }
     cbBuf.StructSize           := sizeof (CT_MgmtALCallbacks_t); { record its size }
     cbBuf.BitVect              := (CT_MGMTADDISPLAY) or (CT_MGMTALCLCK);
     cbBuf.CT_MgmtAdDisplay     := Longword(@CT_AdDisplayCallback); { callback to do ad display }
     cbBuf.CT_MgmtAdDisplayParm := adSpace;  { cache ad window handle }
     cbBuf.CT_MgmtALClick       := Longword(@CT_ClickCallback); { callback to deal with ad clicks }
     cbBuf.CT_MgmtALClickParm   := adSpace; { cache ad window handle }

     rc := CT_MgmtSetALCallbacks(adLoc, @cbBuf);

     if CT_RET_OK <> rc then
     begin
       CT_MgmtDestroyAL(adLoc); { destroy the ad location }
       err := 'Cannot set ad location callbacks: ' +
              CT_MgmtGetErrorString(rc) + CT_MgmtGetLibError();
       MessageDlg (err, MTINFORMATION, [MBOK], 0);
       CT_CreateAdLocation := CT_NOHANDLE;
       Exit;
     end;

     { the ad location starts out active because the entire purpose of the window
       is to show ads, so as long as the window exists, the location is active }
     adLocStatus := CT_MgmtGetALStatus (adLoc);
     adLocStatus := adLocStatus or CT_AL_ACTIVE; { mark the ad location as active}
     CT_MgmtSetALStatus (adLoc, adLocStatus);
   end;
   CT_CreateAdLocation := adLoc;

end;
{ ------------------------- (end of CT_CreateAdLocation Function) ----------------- }

/////////////////////////////////////////////////////////////////////////////////////
//
//			AD SYSTEM OPERATIONS (CALLBACKS AND STATE PROGRESSION)
//
//
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

{ ------------------------- (CT_AdDisplayCallback Function) --------------- }
Function CT_AdDisplayCallback (adLoc            : CT_ALHANDLE;
                               schedID          : SchedID_t;
                               gfxFile          : PChar;
                               gfxFormat        : DWORD;
                               sndFile          : PChar;
                               sndFormat        : DWORD;
                               maxAdDisplayTime : LongInt;
                               flags            : DWORD;
                               userContext      : pointer) : Integer;stdcall;
var
   imgarea : PTAdDisplay;
begin

  { if we can't get the user context, give up immediately }
   if (nil = userContext) then
   begin
     CT_AdDisplayCallback := CT_ERR_CBSTOP;
     Exit;
   end;

   { if we weren't called to deal with graphics, or the graphics format was wrong
     do nothing }
   if (nil = gfxFile) or (CT_GFXFORMAT_BMZ <> gfxFormat) then
   begin
     CT_AdDisplayCallback := CT_RET_CBOK;
     Exit;
   end;

   imgarea := PTAdDisplay(userContext);

   if (false = LoadAdImage(gfxFile, imgarea)) then
   begin
     CT_MgmtALDisplayResult (imgarea.adLoc,
                             CT_MGMTDISPLAY_ERROR);
     CT_AdDisplayCallback := CT_ERR_CBSTOP; { stop processing this ad }
     Exit;
   end;

   { force a redraw }
   frmMain.Repaint;

   CT_AdDisplayCallback := CT_RET_CBOK;

end;
{ ------------------------- (end of CT_AdDisplayCallback Function) --------- }

{ ------------------------- (CT_ClickCallback Function) -------------------- }
Function CT_ClickCallback (adLoc       : CT_ALHANDLE;
                           schedID     : SchedID_t;
                           userContext : Integer) : Integer;
var
  clickURL : LPCTSTR;
begin

  { It is VERY IMPORTANT that the user-specific work to handle an
   ad click through (ie., launching the web browser) be done
   in this callback, and not when the application originally
   detects that the ad was clicked on (in OnLButtonDown or a similar
   place), as the management component MUST get first crack at dealing
   with an ad being clicked on. }

  { if we can't get the user context, give up immediately }
  if (NULL = userContext) then
  begin
    CT_ClickCallback := CT_ERR_CBSTOP;
    Exit;
  end;

  { get the click thru URL for the ad }
  clickURL := LPCTSTR(CT_MgmtGetAdClickThroughURL (schedID));

  if (nil <> clickURL) then { if the URL exists }
  begin
    { start up the user's default web browser on the URL }
    ShellExecute (frmMain.handle, 'open', clickURL, nil, nil, SW_SHOW);
  end;
  CT_ClickCallback := CT_RET_CBOK;

end;
{ ------------------------- (end of CT_ClickCallback Function) ------------- }

{ ------------------------- (CT_AdProgress Function) ----------------------- }
Function CT_AdProgress(): Integer; { system time }
begin

  { this function is a timer callback that gets called whenever the timer
    we set in InitInstance goes off }
  { at this point, we still need to show ads
   call CT_MgmtProgress to progress the state of the ad system }
  CT_MgmtProgress ();

  CT_AdProgress := 0;

end;
{ ------------------------- (end of CT_AdProgress Function) ---------------- }

/////////////////////////////////////////////////////////////////////////////////////
//
//			AD SYSTEM DISPLAY OPERATIONS (Display Functions)
//
//
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

{ ------------------------- (LoadAdImage Function) ------------------------- }
Function LoadAdImage(gfxFile : pChar;
                     pnlHandle : PTAdDisplay) : BOOLEAN;
var
   pal        : PLOGPALETTE;
   bmpinfo    : PBITMAPINFO;
   i,clrsUsed : integer;
   rgbq       : array[1..3000] of RGBQUAD;
begin

   { load new ad image }
   if (nil <> pnlHandle.adImg) then
   begin
     CT_UtilFreeBMZ (pnlHandle.adImg);
     pnlHandle.adImg := nil;
   end;

   if (0 <> pnlHandle.adPalette) then
   begin
     DeleteObject (pnlHandle.adPalette);
     pnlHandle.adPalette := 0;
   end;

   { load the new ad image }
   pnlHandle.adImg := CT_UtilReadBMZ (gfxFile);

   if (pnlHandle.adImg = nil) then
   begin
     LoadAdImage := False;
     Exit;
   end;

   { create the palette }
   If pnlHandle.adImg.biClrUsed = 0 then
     clrsUsed := 256
   else
     clrsUsed := pnlHandle.adImg.biClrUsed;

   bmpinfo := PBITMAPINFO(pnlHandle.adImg);
   for i := 0 to clrsUsed do
   begin
     rgbq[i].rgbBlue := bmpinfo.bmicolors[i].rgbBlue;
     rgbq[i].rgbGreen  := bmpinfo.bmicolors[i].rgbGreen;
     rgbq[i].rgbRed  := bmpinfo.bmicolors[i].rgbRed;
     rgbq[i].rgbReserved  := bmpinfo.bmicolors[i].rgbReserved;
   end;

   GetMem(pal, (sizeof(LOGPALETTE) + sizeof(PALETTEENTRY) * clrsUsed));
   with pal^ do
   begin
     palVersion := $0300;
     palNumEntries := clrsUsed;
     for i := palNumEntries - 1 downto 0 do
        with palPalEntry[i] do
        begin
          peRed := rgbq[i].rgbRed;
          peGreen := rgbq[i].rgbGreen;
          peBlue := rgbq[i].rgbBlue;
          peFlags := PC_NOCOLLAPSE;
        end;
   end;
   pnlHandle.adPalette := CreatePalette(pal^);
   FreeMem(pal, SizeOf(LogPalette) + clrsUsed * SizeOf(PaletteEntry));
  
   LoadAdImage := True;
end;
{ ------------------------- (end of LoadAdImage Function) ------------------- }

{ ------------------------- (CT_DrawAd() Function) -------------------------- }
Function CT_DrawAd(adArea : PTAdDisplay) :integer;
var
   dc                   : HDC;
   bmpinfo              : PBITMAPINFO;
   adLocStatus          : Longword;
   deviceCaps, clrsUsed : Integer;
   nlines               : Integer;
begin

  if (CT_NOHANDLE = adArea.adLoc) then
  begin
    CT_DrawAd := -1;
    Exit; { no ad location or no image, return }
  end;

  if (adArea.adImg = nil) then
  begin
    CT_DrawAd := -1;
    Exit;
  end;

  adLocStatus := CT_MgmtGetALStatus (adArea.adloc);
  if (CT_AL_ACTIVE <> (adLocStatus and CT_AL_ACTIVE)) then
  begin
    CT_DrawAd := -1;
    Exit;
  end;

  { get a device context to draw into, given a hwnd }
  dc := GetDC(adArea.imgArea.handle);
  if (dc = NULL) then
  begin
    CT_DrawAd := -1;
    Exit;
  end;

  { figure out how many colors used }
  if (adArea.adImg.biClrUsed = 0) then
    clrsUsed := 256
  else
    clrsUsed := adArea.adImg.biClrUsed;

  { make sure the view is capable of supporting bit blt'ing, palettes, and large
    bitmaps }
  deviceCaps := GetDeviceCaps (dc, RASTERCAPS);
  if ((deviceCaps and RC_BITBLT) = 0) or
     ((deviceCaps and RC_BITMAP64) = 0) then
  begin
    CT_DrawAd := -1;
    Exit;
  end;

  { set the palette }
  if (NULL <> adArea.adPalette) then
  begin
    SelectPalette (dc, adArea.adPalette, True);
    RealizePalette (dc);
  end;

  { draw the bitmap }
  bmpinfo := PBITMAPINFO(adArea.adImg);

  nlines := SetDIBitsToDevice (dc,
                               0,
                               0,
                               DWORD(adArea.adImg.biWidth),
                               DWORD(adArea.adImg.biHeight),
                               0,
                               0,
                               0,
                               longint(adArea.adImg.biHeight),
                               PByte(longint(pChar(adArea.adImg)) +
                               sizeof (BITMAPINFOHEADER) +
			       clrsUsed * sizeof(RGBQUAD)),
                               bmpinfo^,
                               DIB_RGB_COLORS);

  { tell the advertising system the result of the display. It is VERY IMPORTANT
    that this not be omitted: the management component MUST know the result
    of trying to draw an ad because it takes that into account in deciding
    whether or not to register an impression. }
  if (nlines <= 0) then { error drawing? }
    CT_MgmtALDisplayResult (adArea.adLoc, CT_MGMTDISPLAY_ERROR)
  else if (nlines < adArea.adImg.biHeight) then { didn't draw everything? }
    CT_MgmtALDisplayResult (adArea.adLoc, CT_MGMTDISPLAY_PARTIAL)
  else  { drew everything }
    CT_MgmtALDisplayResult (adArea.adLoc, CT_MGMTDISPLAY_COMPLETE);

  ReleaseDC(adArea.imgArea.Handle,dc);
  CT_DrawAd := 0;

end;
{ ------------------------- (CT_DrawAd() Function) --------------------------- }

end.


