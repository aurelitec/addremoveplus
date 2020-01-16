{ --------------------------------------------------------------------------
                     CTMgmt.pas

 Copyright 1999. Conducent Technologies, Inc. All Rights Reserved.
  -------------------------------------------------------------------------- }
unit CTMgmt;

interface

{ ---------------------------- (includes) ---------------------------------- }
  uses CTError, CTTypes;
{ --------------------------- (end of includes) ---------------------------- }

{ Constant Variable Declaration }
var
{ --------------------------- (bitvector flags) ----------------------------
  OR-able flags to be sent to CT_MgmtSetCallbacks
  bits 6-31 - reserved }

 CT_MGMTADDISPLAY : LongWord			=(1 shl 0);
 const CT_MGMTADSTARTDISPLAYING : LongWord            =(1 shl 1);
 const CT_MGMTADSTOPDISPLAYING : LongWord		=(1 shl 2);
 const CT_MGMTALSTATUSCHANGE : LongWord               =(1 shl 3);
 const CT_MGMTALCLCK : LongWord                      =(1 shl 4);
 const CT_MGMTALDISPRESULT : LongWord              =(1 shl 5);
 { The constant assignment cannot be created like this
 CT_MGMTALLCALLBACKS : LongWord                 =((CT_MGMTADDISPLAY) or
                                                  (CT_MGMTADSTARTDISPLAYING) or
                                                  (CT_MGMTADSTOPDISPLAYING) or
                                                  (CT_MGMTALSTATUSCHANGE) or
                                                  (CT_MGMTALCLCK) or
                                                  (CT_MGMTALDISPRESULT));
  Declaration converted as below with actual values }
 const CT_MGMTALLCALLBACKS : LongWord                  =((1 shl 0) or
                                                   (1 shl 1) or
                                                   (1 shl 2) or
                                                   (1 shl 3) or
                                                   (1 shl 4) or
                                                   (1 shl 5));
{ OR-able flags to be passed to CT_MgmtInit
  bits 1-31 - reserved }
 const CT_MGMTWORKOFFLINE : LongWord        		 =(1 or 0);
{ --------------------------- (end of bitvector flags) --------------------- }

{ --------------------------- (ad types) ----------------------------------- }
 const CT_ADTYPE_FULLPAGE : AdType_t = (0);
 const CT_ADTYPE_IAB_CASIE_FULLBANNER : AdType_t      = (1);
 const CT_ADTYPE_IAB_CASIE_FULLBANNER_VNB : AdType_t	= (2);
 const CT_ADTYPE_IAB_CASIE_HALFBANNER : AdType_t	= (3);
 const CT_ADTYPE_IAB_CASIE_SQUAREBUTTON : AdType_t	= (4);
 const CT_ADTYPE_IAB_CASIE_BUTTON1 : AdType_t		= (5);
 const CT_ADTYPE_IAB_CASIE_BUTTON2 : AdType_t		= (6);
 const CT_ADTYPE_IAB_CASIE_MICROBUTTON : AdType_t 	= (7);
 const CT_ADTYPE_IAB_CASIE_VERTICALBANNER : AdType_t  = (8);
 const CT_ADTYPE_APPLICATION_BUTTON : AdType_t 	= (10);
{ --------------------------- (end of ad types) ---------------------------- }

{ --------------------------- (ad orientations) ---------------------------- }
 const CT_ADORIENT_NORMAL : AdOrientation_t		= chr(1);
 const CT_ADORIENT_VERTICAL : AdOrientation_t		= chr(2);
 const CT_ADORIENT_SW_TO_NE : AdOrientation_t		= chr(3);
 const CT_ADORIENT_NW_TO_SE : AdOrientation_t		= chr(4);
{ --------------------------- (end of ad orientations) --------------------- }

{ --------------------------- (ad timeslots) ------------------------------- }
 const CT_ADTIMESLOT_STARTUP : AdTimeslot_t		= (1);
 const CT_ADTIMESLOT_RUNNING : AdTimeslot_t		= (2);
 const CT_ADTIMESLOT_SHUTDOWN : AdTimeslot_t		= (3);
{ -------------------------- (end of ad timeslots) ------------------------- }

{ -------------------------- (ad positions) -------------------------------- }
 const CT_ADPOSITION_NONE_SPECIFIED : AdPosition_t	= (0);

{ ad positions for specialized advertising (row of 4) }
 const CT_ADPOSITION_SPECIAL1 : AdPosition_t		= (1);
 const CT_ADPOSITION_SPECIAL2 : AdPosition_t		= (2);
 const CT_ADPOSITION_SPECIAL3 : AdPosition_t		= (3);
 const CT_ADPOSITION_SPECIAL4 : AdPosition_t		= (4);

{ ad positions for application services
 these positions are named for the most likely application services
 that will occupy the positions }
 const CT_ADPOSITION_CHAT  : AdPosition_t		= (5);
 const CT_ADPOSITION_SEARCH : AdPosition_t		= (6);
{ -------------------------- (end of ad positions) ------------------------- }

{ -------------------------- (ad location flags) --------------------------- }
{  OR-able flags to be sent to CT_MgmtCreateAL3
   bits 1-31 - reserved
   Allow the location use CT_ADPOSITION_NONE_SPECIFIED in the event that no
   ads are available for the specified position value. If the specified
   position value is CT_ADPOSITION_NONE_SPECIFIED,
   then this flag has no effect }
 const CT_AL_DO_POSITION_FALLBACK : LongWord          = (1 SHL 0);
{ -------------------------- (end of ad location flags) -------------------- }

{ -------------------------- (Standard Gfx Types) -------------------------- }
 const CT_GFXFORMAT_GIF : LongWord                    = (2);
 const CT_GFXFORMAT_BMP : LongWord                    = (3);
 const CT_GFXFORMAT_BMZ : LongWord                    = (4);
 const CT_GFXFORMAT_JPG : LongWord                    = (7);
{ -------------------------- (end of Standard Gfx Types) ------------------- }

{ -------------------------- (Standard Snd Types) -------------------------- }
 const CT_SNDFORMAT_WAV : LongWord = (1);
{ -------------------------- (end of Standard Snd Types) ------------------- }

{ -------------------------- (flags for CT_MgmtAdDisplayCB) ---------------- }
 const CT_MGMTLOOPAD : LongWord = (1 SHL 0);
{ -------------------------- (end of flags for CT_MgmtAdDisplayCB) --------- }

{ -------------------------- (ALStatus flags) ------------------------------ }
{ Status constants for the AdLocations
  Passed into CT_MgmtSetALStatus
 	STATUS BITS
	-----------
	bit 0(LSB)  = CT_AL_ACTIVE - Ad Location is Active
	  ...
	bit 31(MSB) = CT_AL_HASADS - There are some ads available
                                     for this location to display
	bits 1-30  = reserved }
 const CT_AL_ACTIVE : LongWord	        =(1 SHL 0);

{ These flags are NOT user settable. They are for user information ONLY!
  Change = Operator SHL cannot work with 1 SHL 31 since it violates
  sunrange bounds so direct value has been assigned }
 const CT_AL_HASADS : LongWord	        =(1 SHL 30);

 const CT_AL_ALLSTATUSBITS : LongWord         = ((1 SHL 0) or (1 SHL 30));
 const CT_AL_READONLYSTATUSBITS : LongWord	= (1 SHL 30);
{ -------------------------- (end of ALStatus flags) ----------------------- }

{ -------------------------- (typedefs) ------------------------------------ }
{ Enum Declaration }

type
  DisplayResult_t = (CT_MGMTDISPLAY_COMPLETE,
                     CT_MGMTDISPLAY_PARTIAL,
                     CT_MGMTDISPLAY_NOTDONE,
                     CT_MGMTDISPLAY_ERROR);
{ -------------------------- (end of typedefs) ----------------------------- }

{ -------------------------- (callback typedef) --------------------------- }
  CT_MgmtALCallbacks_t = record
	StructSize : LongWord;
	BitVect : LongWord;
        CT_MgmtAdDisplay : LongWord;
	CT_MgmtAdDisplayParm : pointer;
	CT_MgmtAdStartDisplay : LongWord;
	CT_MgmtAdStartDisplayParm : pointer;
	CT_MgmtAdStopDisplay : LongWord;
	CT_MgmtAdStopDisplayParm : pointer;
	CT_MgmtALStatusChange : LongWord;
	CT_MgmtALStatusChangeParm : pointer;
	CT_MgmtALClick : LongWord;
        CT_MgmtALClickParm : pointer;
	CT_MgmtALDisplayResult : LongWord;
	CT_MgmtALDisplayResultParm : pointer;
   end;

   PCT_MgmtALCallbacks_t = ^CT_MgmtALCallbacks_t;
{ -------------------------- (end of callback typedef) -------------------- }

{ -------------------------- (API functions) ------------------------------- }
{ Function CT_MgmtInit }
Function CT_MgmtInit (const application : pChar;
		 const appPassword : pChar;
		 const flags : LongWord) : Integer;
                 stdcall;
                 external 'tsad.dll'
                 name '_CT_MgmtInit@12';

{ Function CT_MgmtShutdown }
Function CT_MgmtShutdown () : Integer;
                         stdcall;
                         external 'tsad.dll'
                         name '_CT_MgmtShutdown@0';

{ Function CT_MgmtProgress }
Function CT_MgmtProgress () : Integer;
                         stdcall;
                         external 'tsad.dll'
                         name '_CT_MgmtProgress@0';

{ Function CT_MgmtCreateAL3 }
Function CT_MgmtCreateAL3 (const adTypes : pAdType_t;
			   adTypesCount : longint;
			   const adOrientation : AdOrientation_t;
			   const adTimeSlot : AdTimeslot_t;
			   const adPosition : AdPosition_t;
			   const flags : LongWord) : CT_ALHANDLE;
                           stdcall;
                           external 'tsad.dll'
                           name '_CT_MgmtCreateAL3@24';

{ Function CT_MgmtTakeALOwnership }
Function CT_MgmtTakeALOwnership (adLoc : CT_ALHANDLE) : Integer;
                                 stdcall;
                                 external 'tsad.dll'
                                 name '_CT_MgmtTakeALOwnership@4';

{ Function CT_MgmtDestroyAL }
Function CT_MgmtDestroyAL (adLoc : CT_ALHANDLE) : Integer;
                           stdcall;
                           external 'tsad.dll'
                           name '_CT_MgmtDestroyAL@4';

{ Function CT_MgmtSetAlCallbacks }
Function CT_MgmtSetALCallbacks (adLoc :CT_ALHANDLE;
			        const cb : PCT_MgmtALCallbacks_t) : Integer;
                                stdcall;
                                external 'tsad.dll'
                                name '_CT_MgmtSetALCallbacks@8';

{ Function CT_MgmtALDisplayResult }
Function CT_MgmtALDisplayResult (adLoc : CT_ALHANDLE;
			         dispResult : DisplayResult_t) : Integer;
                                 stdcall;
                                 external 'tsad.dll'
                                 name '_CT_MgmtALDisplayResult@8';

{ Function CT_MgmtALClick }
Function CT_MgmtALClick (adLoc : CT_ALHANDLE) : Integer;
                         stdcall;
                         external 'tsad.dll'
                         name '_CT_MgmtALClick@4';

{ Function CT_MgmtSetALStatus }
Function CT_MgmtSetALStatus (adLoc : CT_ALHANDLE ;
	   		     const status : LongWord) : Integer;
                             stdcall;
                             external 'tsad.dll'
                             name '_CT_MgmtSetALStatus@8';

{ Function CT_MgmtGetALStatus }
Function CT_MgmtGetALStatus (adLoc : CT_ALHANDLE) : LongWord;
                             stdcall;
                             external 'tsad.dll'
                             name '_CT_MgmtGetALStatus@4';

{ Function CT_MgmtGetAdType }
Function CT_MgmtGetAdType (schedID : SchedID_t) : AdType_t;
                           stdcall;
                           external 'tsad.dll'
                           name '_CT_MgmtGetAdType@4';

{ Function CT_MgmtGetAdPriority }
Function CT_MgmtGetAdPriority (schedID : SchedID_t) : AdPriority_t;
                               stdcall;
                               external 'tsad.dll'
                               name '_CT_MgmtGetAdPriority@4';

{ Function CT_MgmtGetAdStartTime }
Function CT_MgmtGetAdStartTime (schedID : SchedID_t) : TDateTime;
                                stdcall;
                                external 'tsad.dll'
                                name '_CT_MgmtGetAdStartTime@4';

{ Function CT_MgmtGetAdStopTime }
Function CT_MgmtGetAdStopTime (schedID : SchedID_t) : TDateTime;
                               stdcall;
                               external 'tsad.dll'
                               name '_CT_MgmtGetAdStopTime@4';

{ Function CT_MgmtGetAdClickThroughURL }
Function CT_MgmtGetAdClickThroughURL (schedID : SchedID_t) : pChar;
                                      stdcall;
                                      external 'tsad.dll'
                                      name '_CT_MgmtGetAdClickThroughURL@4';
{ -------------------------- (end of API functions) ------------------------ }

implementation
  
end.
