{ --------------------------------------------------------------------------
                     CTError.pas

 Copyright 1999. Conducent Technologies, Inc. All Rights Reserved.
  -------------------------------------------------------------------------- }
unit CTError;

interface

{ Constant Variable Declaration }
var

 CT_WARN_ACTIVEAL : Integer          = 1;

 const CT_RET_OK : Integer           = 0;

 const CT_ERR_UNSPECIFIED: Integer   = -1;
 const CT_ERR_BADPARAM : Integer     = -2;
 const CT_ERR_THREAD : Integer       = -3;
 const CT_ERR_COMMSTART : Integer    = -4;
 const CT_ERR_COMMSTOP : Integer     = -5;
 const CT_ERR_ADSTATS : Integer	     = -6;
 const CT_ERR_BADAL : Integer	     = -7;
 const CT_ERR_MGMTNOTSTARTED : Integer = -8;
 const CT_ERR_MGMTSTARTED : Integer    = -9;
 const CT_ERR_PUSHNOTSTARTED : Integer = -10;
 const CT_ERR_PUSHSTARTED : Integer    = -11;
 const CT_ERR_APPCONFLICT : Integer    = -12;
 const CT_ERR_OFFLINEREGFAILED : Integer   = -13;
 const CT_ERR_NODLL : Integer		   = -14;
 const CT_ERR_OFFLINEUNREGFAILED : Integer = -15;
 const CT_ERR_REGISTRY : Integer           = -16;
 const CT_ERR_SYSTEMDISABLED : Integer     = -17;

 const CT_RET_CBOK : Integer         = 0;
 const CT_ERR_CBSTOP : Integer	     = -1;

{ -------------------------- (API functions) ------------------------------- }
{ Function CT_PushGetLibError }
 Function CT_PushGetLibError () : pChar;
                             stdcall;
                             external 'tsad.dll'
                             name '_CT_PushGetLibError@0';

{ Function CT_PushGetErrorString }
 Function CT_PushGetErrorString (errCode : Integer) : pChar;
                                                      stdcall;
                                                      external 'tsad.dll'
                                 name '_CT_PushGetErrorString@4';

{ Function TS_MgmtGetErrorString }
 Function CT_MgmtGetErrorString (errCode : Integer) : pChar;
                                 stdcall;
                                 external 'tsad.dll'
                                 name '_CT_MgmtGetErrorString@4';

{ Function TS_MgmtGetLibError }                              
 Function CT_MgmtGetLibError () : pChar;
                             stdcall;
                             external 'tsad.dll'
                             name '_CT_MgmtGetLibError@0';

 { -------------------------- (end of API functions) ------------------------ }

implementation

end.                    
