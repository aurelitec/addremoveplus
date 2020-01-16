{ --------------------------------------------------------------------------
                     CTPush.pas

 Copyright 1999. Conducent Technologies, Inc. All Rights Reserved.
  -------------------------------------------------------------------------- }
unit CTPush;

interface
{ ---------------------------- (includes) ---------------------------------- }
  uses CTError, CTTypes;
{ --------------------------- (end of includes) ---------------------------- }

{ Constant Variable Declaration }
var
{ --------------------------- (bitvector flags) ---------------------------- }
{ OR-able flags to be sent to CT_PushSetCallbacks
  bits 7-31 - reserved }
  { Values for setting the process priority in CT_PushLimitProcessing() }
 CT_PROCLEVEL_HIGH : Integer;
 CT_PROCLEVEL_NORM : Integer;
 CT_PROCLEVEL_LOW : Integer;
 CT_PROCLEVEL_LOWEST : Integer;
 CT_PROCLEVEL_IDLE : Integer;

 const CT_PUSHADRECEIVED : LongWord				=(1 SHL 0);
 const CT_PUSHDOWNLOADSTARTED	: LongWord                      =(1 SHL 1);
 const CT_PUSHDOWNLOADDONE	: LongWord                 	=(1 SHL 2);
 const CT_PUSHCHUNKDOWNLOADSTARTED : LongWord		        =(1 SHL 3);
 const CT_PUSHCHUNKDOWNLOADDONE : LongWord                    =(1 SHL 4);
 const CT_PUSHADKILLED : LongWord                            	=(1 SHL 5);
 const CT_PUSHSTATUS : LongWord				=(1 SHL 6);
 const CT_PUSHALLCALLBACKS : LongWord                         =((1 SHL 0) or
                                                         (1 SHL 1) or
                                                         (1 SHL 2) or
                                                         (1 SHL 3) or
                                                         (1 SHL 4) or
                                                         (1 SHL 5) or
                                                         (1 SHL 6));

 { OR-able flags to be passed to CT_PushInit
   bits 1-31 - reserved }
 const CT_PUSHWORKOFFLINE : LongWord		=(1 SHL 0);
{ --------------------------- (end of bitvector flags) --------------------- }

{ Values for status in CT_PushStatus Callback }
 const CT_PUSHNETERR : LongWord		=($000000001);
 const CT_PUSHNOACTIVITY : LongWord     =($000000002);
 const CT_PUSHAUTHFAIL : LongWord	=($000000003);

{ --------------------------- (callback typedefs) --------------------------- }
type

  CT_PushCallbacks_t = record
	StructSize : Longword;
	BitVect : LongWord;
	CT_PushAdReceived : Longword;
	CT_PushAdReceivedParm :  pointer;
	CT_PushDownloadStarted : Longword;
	CT_PushDownloadStartedParm :  pointer;
	CT_PushDownloadDone : Longword;
	CT_PushDownloadDoneParm :  pointer;
	CT_PushChunkDownloadStarted : Longword;
	CT_PushChunkDownloadStartedParm :  pointer;
	CT_PushChunkDownloadDone : Longword;
	CT_PushChunkDownloadDoneParm :  pointer;
	CT_PushAdKilled : Longword;
	CT_PushAdKilledParm : pointer;
	CT_PushStatus : Longword;
	CT_PushStatusParm : pointer;
  end;
  PCT_PushCallbacks_t = ^CT_PushCallbacks_t;
{ --------------------------- (end of callback typedefs) ------------------- }

{ ------------------- -------- (API functions) ------------------------------ }

  { 1. Function CT_PushInit }
Function CT_PushInit (const application : pChar;
		      const appPassword : pChar;
		      const flags : LongWord ) : integer;
                      stdcall;
                      external 'tsad.dll'
                      name '_CT_PushInit@12';

{ 2. Function CT_PushShutdown }
Function CT_PushShutdown () : Integer;
                      stdcall;   
                      external 'tsad.dll'
                      name '_CT_PushShutdown@0';

{ 5. Function CT_PushSetCallbacks }
Function CT_PushSetCallbacks (const cb : PCT_PushCallbacks_t) : Integer;
                              stdcall;
                              external 'tsad.dll'
                              name '_CT_PushSetCallbacks@4';

{ 3. Function CT_PushLimitBandwidth }
Function CT_PushLimitBandwidth (burstLimit : LongWord;
			   	averageLimit : LongWord;
	 		        timeQuantum : TDateTime) : Integer;
                                stdcall;
                                external 'tsad.dll'
                                name '_CT_PushLimitBandwidth@12';

{ 4. Function CT_PushLimitProcessing }
Function CT_PushLimitProcessing (level : Integer) : integer;
                                 stdcall;
                                 external 'tsad.dll'
                                 name '_CT_PushLimitProcessing@4';
{ ------------------------- (API functions) -------------------------------- }

implementation

end.
