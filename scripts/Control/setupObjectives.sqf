["TOUR_objBridge", {"Destroy Bridge"}] call A2S_createSimpleTask;
["TOUR_objBridge", {"Destroy the <marker name=""TOUR_mkrbridge"">bridge in Toplin</marker>. Throw an IR grenade on the bridge to allow CAS to find the target."}, {"Destroy Bridge"}, {"Destroy Bridge"}] call A2S_setSimpleTaskDescription;
"TOUR_objBridge" call A2S_taskCommit;

["TOUR_objFriendly", {"Protect Friendlies"}] call A2S_createSimpleTask;
["TOUR_objFriendly", {"Ensure there are no casulaties for either allied forces or non-combatants."}, {"Protect Friendlies"}, {"Protect Friendlies"}] call A2S_setSimpleTaskDescription;
"TOUR_objFriendly" call A2S_taskCommit;

_destroyed = false;
TOUR_strobe = objnull;

while {!_destroyed} do
{
	if (TOUR_strobe != Objnull) then
	{
		sleep 1;
		if (TOUR_strobe distance (getMarkerPos "TOUR_mkrBridge") < 40) then
		{
			//call CAS
			_pos = (getMarkerPos "TOUR_mkrBridge") getPos [4000, 90]; 
			_pos = [_pos select 0, _pos select 1, 500];
			_grp = createGroup WEST;
			_vehicle = [_pos, 270, "B_plane_CAS_01_DynamicLoadout_F", _grp] call BIS_fnc_spawnVehicle;
			sleep 1;
			_wp = _grp addWaypoint [getMarkerPos "TOUR_mkrBridge", 0];
			(leader _grp) setSkill 1;
			{
				(leader _grp) setSkill _x;
			}forEach [["aimingSpeed",1],["commanding",1],["courage",1],["reloadSpeed",1],["spotDistance",1],["spotTime",1],["aimingAccuracy", 1],["general",1]];
			sleep 5;
			[
				_vehicle,
				{
					if (!isDedicated) then
					{
						(_this select 2) setGroupID ["Eagle Seven"];
						enableRadio true;
						sleep 2;
						(_this select 0) sideChat "This is Eagle Seven, eyes on target, we are inbound. OUT";
						sleep 2;
						enableRadio false;
					};
				}
			] remoteExec ["spawn", 0, false];
			waitUntil {((getMarkerPos "TOUR_mkrBridge") distance (vehicle (leader _grp))) < 400};
			sleep 3;
			_bomb = "bomb_04_f" createvehicle [1430.54,7577.53,7.1058];
			sleep 2;
			[
				[],
				{
					{
						if (_x isKindOf "man") then
						{
						}else
						{
							hideObject _x;
						};
					}forEach (nearestObjects [getMarkerPos "TOUR_mkrBridge",[], 20]);
				}
			] remoteExec ["spawn", 0, true];
			_destroyed = true;
			sleep 2;
			_wp = _grp addWaypoint [getMarkerPos "TOUR_mkrBase", 0];
		};
	};
};

["TOUR_objBridge", "SUCCEEDED"] call A2S_setTaskState;
"TOUR_objBridge" call A2S_taskCommit;
sleep 2;
"TOUR_objBridge" call A2S_taskHint;

[
	[],
	{
		if (!isDedicated) then
		{
			enableRadio true;
			sleep 2;
			TOUR_HQ sideChat "All elements be advised, the bridge is destroyed, repeat the bridge is destroyed!";
			sleep 3;
			TOUR_HQ sideChat "Evac the area and get back to base immediately! OUT";
			sleep 2;
			enableRadio false;
		};
	}
] remoteExec ["spawn", 0, false];