{ --------------------------------------------------------------------------
                     CTUtils.pas

 Copyright 1999. Conducent Technologies, Inc. All Rights Reserved.
  -------------------------------------------------------------------------- }
unit CTUtils;

interface

{ ---------------------------- (includes) ---------------------------------- }
  uses windows,CTError, CTTypes;

{ --------------------------- (end of includes) ---------------------------- }
{ Constant Variable Declaration }
var
{ --------------------------- (System Config Attributes) ------------------- }
{ Values for status in CT_PushStatus Callback }
 CT_CFGSYS_ENABLE : Longword	=($000000001);
 CT_CFGSYS_DISABLE : Longword	=($000000002);
{ --------------------------- (end of System Config Attributes) ------------ }

{ --------------------------- (API functions) ------------------------------ }
Function CT_UtilReadBMZ (const bmzFile : pChar) : PBITMAPINFOHEADER;
                         stdcall;
                         external 'tsad.dll'
                         name '_CT_UtilReadBMZ@4';

Function CT_UtilFreeBMZ (p : PBITMAPINFOHEADER) : pointer;
                         stdcall;
                         external 'tsad.dll'
                         name '_CT_UtilFreeBMZ@4';

Function CreateDIBitmap(hdc           :  HDC;	           // handle to device context
                        const lpbmih  : PBITMAPINFOHEADER; // pointer to bitmap size and format data
                        fdwInit       : DWORD;	           // initialization flag
                        const lpbInit : pointer;	   // pointer to initialization data
                        const lpbmi   : PBITMAPINFO;	   // pointer to bitmap color-format data
                        fuUsage       : UINT ) : HBITMAP;
                        external 'c:\windows\system\gdi32.dll';

Function CT_UtilConfigSystem (const appName : pChar;
			      const appPassword : pChar;
			      attribute : LongWord;
			      param : pointer) : Integer;
                              stdcall;
                              external 'tsad.dll'
                              name '_CT_UtilConfigSystem@16';

{ --------------------------- (end of API functions) ----------------------- }



implementation



end.
