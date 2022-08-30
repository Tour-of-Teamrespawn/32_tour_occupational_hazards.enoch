if (isServer) then
{
	[]spawn
	{
		TOUR_endingStart = true;
		sleep 7;
		if ("TOUR_objBridge" call A2S_taskState != "SUCCEEDED") then
		{
			["TOUR_objBridge", "failed"] call A2S_setTaskState;
			"TOUR_objBridge" call A2S_taskCommit;
			sleep 2;
			"TOUR_objBridge" call A2S_taskHint;
			sleep 3;
		};
		if ("TOUR_objFriendly" call A2S_taskState != "failed") then
		{
			["TOUR_objFriendly", "SUCCEEDED"] call A2S_setTaskState;
			"TOUR_objFriendly" call A2S_taskCommit;
			sleep 2;
			"TOUR_objFriendly" call A2S_taskHint;
		};
		sleep 12;
		if ("TOUR_objBridge" call A2S_taskState == "SUCCEEDED") then
		{
			if ("TOUR_objFriendly" call A2S_taskState != "SUCCEEDED") then
			{
				"PARTIAL" remoteExecCall ["BIS_fnc_endMissionServer", 0, true];
			}else
			{
				"complete" remoteExecCall ["BIS_fnc_endMissionServer", 0, true];
			};
		}else
		{
			"failed" remoteExecCall ["BIS_fnc_endMissionServer", 0, true];
		};
	};
};

if (!isDedicated) then
{
	_this spawn
	{
		private ["_unit", "_group", "_groupstring", "_mission"];
		_unit = _this select 0;
		enableRadio true;
		sleep 2;
		_group = group _unit;
		_groupstring = (str _group) call TOUR_SI_fnc_groupNameFix;
		_unit sideChat format ["HQ this is %1, do you read? OVER", _groupstring];
		sleep 5;
		TOUR_HQ sideChat format ["Loud and clear %1, go ahead. OVER", _groupstring];
		sleep 5;
		if ("TOUR_objBridge" call A2S_taskState != "SUCCEEDED") then
		{
			_unit sideChat format ["HQ, we were unable to destroy the bridge. OVER", _groupstring];
		}else
		{
			_unit sideChat format ["HQ, bridge is down, repeat the bridge is down! OVER", _groupstring];
		};
		sleep 5;
		if ("TOUR_objBridge" call A2S_taskState != "SUCCEEDED") then
		{
			TOUR_HQ sideChat format ["Crikey %1, what the hell happened out there?! Get back to base ASAP for a debrief! OVER", _groupstring];
		}else
		{
			TOUR_HQ sideChat format ["Great job old boy! Get back to base for a well earned break, you must have given them hell! OVER", _groupstring];
		};	
		sleep 5;
		_unit sideChat format ["Copy that HQ, we are RTB! %1 OUT", _groupstring];
		sleep 2;
		enableRadio false;
	};
};