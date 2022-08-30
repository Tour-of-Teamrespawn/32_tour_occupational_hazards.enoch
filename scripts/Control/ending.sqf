sleep 5;

while {(!TOUR_RC_WEST_dead)} do
{
	// if and everyone is incapacitated then Number of tickets left are equal to 0 
	sleep 2;
};

if (!isNil "TOUR_endingStart") then
{
	if ("TOUR_objFriendly" call A2S_taskState != "failed") then
	{
		["TOUR_objFriendly", "SUCCEEDED"] call A2S_setTaskState;
		"TOUR_objFriendly" call A2S_taskCommit;
		sleep 2;
		"TOUR_objFriendly" call A2S_taskHint;
		sleep 3;
	};

	if ("TOUR_objBridge" call A2S_taskState != "SUCCEEDED") then
	{
		["TOUR_objBridge", "failed"] call A2S_setTaskState;
		"TOUR_objBridge" call A2S_taskCommit;
		sleep 2;
		"TOUR_objBridge" call A2S_taskHint;
		sleep 3;
	};

	"kia" remoteExecCall ["BIS_fnc_endMissionServer", 0, true];	
};