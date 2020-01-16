{ --------------------------------------------------------------------------
                     CTTypes.pas

 Copyright 1999. Conducent Technologies, Inc. All Rights Reserved.
  -------------------------------------------------------------------------- }

unit CTTypes;

interface

 uses Windows;

type

{ ---------------------------- (typedefs) ---------------------------------- }
  CT_ALHANDLE = pointer; { Declaration changed from *void }
  SchedID_t   = longint;
  AdType_t = longint;
  AdPriority_t = longint;
  AdOrientation_t = char;
  AdTimeslot_t = longint;
  AdPosition_t = longint;
  PBITMAPINFOHEADER = ^BITMAPINFOHEADER;
  PBITMAPINFO = ^BITMAPINFO;
  pAdType_t = ^AdType_t;
  pInteger = ^Integer;
  PLOGPALETTE = ^LOGPALETTE;
  PRGBQUAD = ^RGBQUAD;

var
 TEMP : INTEGER = (-1);
 CT_NOHANDLE : CT_ALHANDLE	   = @TEMP;
 TEMP1 : INTEGER = (-2);
 CT_ALLHANDLES : CT_ALHANDLE       = @TEMP1;
 TEMP2 : INTEGER = (-3);
 CT_ALLFUTUREHANDLES : CT_ALHANDLE = @TEMP2;

{ constant defining "no online service" }
 CT_NOSERVICE : pChar	= (nil);

{ constant defining "no account" }
 CT_NOACCOUNT : pChar	= (nil);
{ ---------------------------- (typedefs) ---------------------------------- }

implementation

end.
