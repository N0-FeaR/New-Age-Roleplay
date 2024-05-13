#include <a_npc>

new gStoppedForTraffic = 0,
gPlaybackFileCycle=0;

public ScanTimer();

#define AHEAD_OF_CAR_DISTANCE    9.0
#define SCAN_RADIUS     		 9.0

main()
{
	printf("NPC: Bus Route Loaded.");
}

stock GetXYInfrontOfMe(Float:distance, &Float:x, &Float:y)
{
    new Float:z, Float:angle;
    GetMyPos(x,y,z);
    GetMyFacingAngle(angle);
    x += (distance * floatsin(-angle, degrees));
    y += (distance * floatcos(-angle, degrees));
}

public OnNPCModeInit()
{
	SetTimer("ScanTimer",200,1);
}

LookForAReasonToPause()
{
  	new Float:X,Float:Y,Float:Z;
	GetMyPos(X,Y,Z);
	GetXYInfrontOfMe(AHEAD_OF_CAR_DISTANCE,X,Y);

	for(new x=0; x<MAX_PLAYERS; x++)
	{
	    if(IsPlayerConnected(x) && IsPlayerStreamedIn(x) && GetPlayerVehicleID(x) != 104 && GetPlayerVehicleID(x) != 105)
	    {
			if( GetPlayerState(x) == PLAYER_STATE_DRIVER || GetPlayerState(x) == PLAYER_STATE_ONFOOT )
			{
				if(IsPlayerInRangeOfPoint(x,SCAN_RADIUS,X,Y,Z))
				{
				    return 1;
				}
			}
		}
	}
	return 0;
}

public ScanTimer()
{
    new ReasonToPause = LookForAReasonToPause();
	if(ReasonToPause && !gStoppedForTraffic)
	{
		PauseRecordingPlayback();
		gStoppedForTraffic = 1;
	}
	else if(!ReasonToPause && gStoppedForTraffic)
	{
	    ResumeRecordingPlayback();
	    gStoppedForTraffic = 0;
	}
}

StartPlayback()
{
	if(gPlaybackFileCycle == 10) gPlaybackFileCycle=0;
	switch(gPlaybackFileCycle)
	{
	    case 0: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route21"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	    case 1: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route22"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	    case 2: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route23"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	    case 3: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route24"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	    case 4: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route25"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	    case 5: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route26"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	    case 6: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route27"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	    case 7: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route28"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	    case 8: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route29"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	    case 9: StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"route210"), CallRemoteFunction("StopSpot", "s", "BusDriver2");
	}
	gPlaybackFileCycle++;
	gStoppedForTraffic = 0;
}

public OnRecordingPlaybackEnd()
{
    StartPlayback();
}

public OnNPCEnterVehicle(vehicleid, seatid)
{
    StartPlayback();
}

public OnNPCExitVehicle()
{
    StopRecordingPlayback();
    gPlaybackFileCycle = 0;
}
