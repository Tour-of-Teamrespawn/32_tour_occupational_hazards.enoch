private ["_faction", "_marker", "_types_array", "_class_type", "_number", "_rndpos", "_grp", "_pat_distance", "_initdone"];

_faction = "rhs_faction_vdv";
_marker = "TOUR_spawn";
_skill = 1;
_initdone = false;

waitUntil {!isNil "TOUR_introDone"};

_patPoints = [[2164.78,6058.69,0],[414.169,6839.48,0],[3036.7,8126.43,0]];

//sleep 200;
while {true} do
{
	while {count TOUR_friendly_units < 2} do
	{
		_spawn = _patPoints call BIS_fnc_selectRandom;
		if (count _type > 0) then 
		{
			_grp = [_spawn, INDEPENDENT, (configfile >> "CfgGroups" >> "Indep" >> "IND_L_F" >> "Infantry" >> "I_L_LooterGang"] call BIS_fnc_spawnGroup;
			waitUntil {(count units _grp > 0)};
			{
				//sort out accuracy and skill and loadouts if needed
				_x call TOUR_fnc_garbageEH;
				_x call TOUR_fnc_loadouts;
			}forEach units _grp;
			_wp1 = _grp addWaypoint [getMarkerPos "TOUR_mkr_AO", 0];
			_wp1 setWaypointType "GUARD";
			_wp1 setWaypointBehaviour "AWARE";
			_wp1 setWaypointStatements ["true", ""];
		};
		waitUntil {{alive _x}count units _grp == 0};
	};
	sleep 300;
};