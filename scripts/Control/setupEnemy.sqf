private ["_faction", "_marker", "_types_array", "_class_type", "_group_type", "_type", "_number", "_rndpos", "_safepos", "_grp", "_pat_distance", "_initdone", "_guardpos"];

_faction = "rhs_faction_vdv";
_marker = "TOUR_spawn";
_skill = 1;
_initdone = false;
_count =  0;
_safepos = getMarkerPos "TOUR_enemySpawn";
TOUR_mission_groups = [];
TOUR_mission_units = [];

waitUntil {!isNil "TOUR_introDone"};

_group_type = 				
[
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_fireteam"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_MANEUVER"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_section_AA"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_section_AT"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_section_marksman"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_section_mg"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_squad"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_squad_2mg"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_squad_mg_sniper"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_squad_sniper"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_fireteam"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_MANEUVER"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_section_AA"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_section_AT"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_section_marksman"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_section_mg"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_squad"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_squad_2mg"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_squad_mg_sniper"],
	["rhs_group_rus_vdv_infantry_flora", "rhs_group_rus_vdv_infantry_flora_squad_sniper"],
	["rhs_group_rus_vdv_infantry_recon", "rhs_group_rus_vdv_infantry_recon_fireteam"],
	["rhs_group_rus_vdv_infantry_recon", "rhs_group_rus_vdv_infantry_recon_MANEUVER"],
	["rhs_group_rus_vdv_infantry_recon", "rhs_group_rus_vdv_infantry_recon_squad"],
	["rhs_group_rus_vdv_infantry_recon", "rhs_group_rus_vdv_infantry_recon_squad_2mg"],
	["rhs_group_rus_vdv_infantry_recon", "rhs_group_rus_vdv_infantry_recon_squad_mg_sniper"],
	["rhs_group_rus_vdv_infantry_recon", "rhs_group_rus_vdv_infantry_recon_squad_sniper"]
];

_patPoints = [[1127.16,7454.53,0],[1256.34,7181.89,0],[1632.41,7230.41,0],[1531.09,7485.31,0],[1898.03,7514.82,0],[2125.11,7636.89,0],[2208.47,7402.42,0],[2264.42,7048.05,0],[1912.18,7172.12,0],[1791.2,6799.68,0],[1458.64,6800.46,0]];

for "_i" from 1 to 6 do
{
	_spawn = _patPoints call BIS_fnc_selectRandom;
	_patPoints = _patPoints - [_spawn];
	_type = _group_type call BIS_fnc_selectRandom;
	_grp = [_spawn, EAST, (configFile >> "CfgGroups" >> "EAST" >> _faction >> (_type select 0) >> (_type select 1))] call BIS_fnc_spawnGroup;
	waitUntil {(count units _grp > 0)};
	{
		//sort out accuracy and skill and loadouts if needed
		_x call Tour_fnc_garbageEH;
		_x call TOUR_fnc_loadouts;
	}forEach units _grp;
	[_grp, _spawn, 120]spawn TOUR_fnc_rndpatrol;
	sleep 2;
};
//sleep 200;
_guardpos = getMarkerPos "TOUR_mkrGuard";
while {true} do
{
	while {count TOUR_mission_units < 15} do
	{
		_safepos = [0,0,0];
		while {str _safepos == "[0,0,0]"} do
		{
			{
				_pos = _x;
				if ({(alive _x) && (_x distance _pos < 300)}count playableUnits + switchableUnits == 0) exitWith
				{
					_safePos = _pos;
				};
			}forEach [[827.986,7459.75,0],[2057.38,7755.11,0]]
		};
		waitUntil {count (nearestObjects [_safepos, ["man"], 25]) == 0};
		_type = _group_type call BIS_fnc_selectRandom;
		if (count _type > 0) then 
		{
			_grp = [_safepos, EAST, (configFile >> "CfgGroups" >> "EAST" >> _faction >> (_type select 0) >> (_type select 1))] call BIS_fnc_spawnGroup;
			TOUR_mission_groups set [count TOUR_mission_groups, _grp];
			waitUntil {(count units _grp > 0)};
			{
				//sort out accuracy and skill and loadouts if needed
				_x call Tour_fnc_garbageEH;
				_x call TOUR_fnc_loadouts;
				Tour_mission_units set [count Tour_mission_units, _x];
			}forEach units _grp;
		
			if (str _guardpos == str (getMarkerPos "TOUR_mkrGuard")) then
			{
				_guardpos = getMarkerPos "TOUR_mkrGuard2";
			}else
			{
				_guardpos = getMarkerPos "TOUR_mkrGuard";
			};
			
	
			_wp1 = _grp addWaypoint [_guardpos, 0];
			_wp1 setWaypointType "MOVE";
			_wp1 setWaypointBehaviour "AWARE";
			_wp1 setWaypointSpeed "FULL";
			_wp2 = _grp addWaypoint [_guardpos, 20];
			_wp2 setWaypointType "GUARD";
			_wp2 setWaypointSpeed "NORMAL";
			_wp2 setWaypointBehaviour "AWARE";
		};
	};
	sleep 200;
};