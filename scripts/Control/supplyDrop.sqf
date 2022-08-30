_time = time + (900 + (random 900));

waitUntil {time > _time};
_centre = [[1660.91,6472.78,0],[1444.8,7042.85,0],[2264.19,7109.83,0]] call BIS_fnc_SelectRandom;
_dir = (ceil random 360);
_pos = _centre getPos [4000, _dir]; 
_pos = [_pos select 0, _pos select 1, 100];
_type = ["UK3CB_BAF_CHINOOK_HC2_DPMW"]call BIS_fnc_selectRandom;
_info = [_pos,  _dir + 180, _type, CIVILIAN] call BIS_fnc_spawnVehicle;
_grp = _info select 2;
sleep 1;
_grp setbehaviour "CARELESS";
_grp setCombatMode "BLUE";
{
	_x disableAI "target";
	_x disableAI "autotarget";
	_x disableAI "fsm";
}forEach units _grp;
_pos2 = _centre getPos [4000, (_dir + 180)]; 
_wp = _grp addWaypoint [_centre, 0];
_wp setWaypointCompletionRadius 100;
_wp2 = _grp addWaypoint [_pos2, 0];
_wp2 setWaypointCompletionRadius 100;
(_info select 0) flyInHeight 100;
TOUR_ammo attachTo [(_info select 0), [0,0,-4]];

[
	[],
	{
		if (!isDedicated) then
		{
			enableRadio true;
			sleep 2;
			TOUR_HQ sideChat "All elements be advised, a supply drop is enroute! OUT";
			sleep 2;
			enableRadio false;
		};
	}
] remoteExec ["spawn", 0, false];


waitUntil {[(getPosATL (_info select 0)) select 0, (getPosATL (_info select 0)) select 1] distance [_centre select 0, _centre select 1] < 200};

[
	[(_info select 0)],
	{
		if (!isDedicated) then
		{
			enableRadio true;
			sleep 2;
			(_this select 0) sideChat "Package away! OUT";
			sleep 2;
			enableRadio false;
		};
	}
] remoteExec ["spawn", 0, false];

[]spawn 
{
	detach TOUR_ammo;
	sleep 1.5;
	_chute = createVehicle ["B_Parachute_02_F", [getPosATL TOUR_ammo select 0, getposatl TOUR_ammo select 1, (getposatl TOUR_ammo select 2) + 2], [], 0, ""]; 
	TOUR_ammo attachTo [_chute, [0, 0, 0]]; 
	_light = createVehicle ["Chemlight_red", position _chute, [], 0, 'NONE']; 
	_light attachTo [_chute, [0, 0, 0.2]];
	TOUR_ammo allowdamage false; 
	waitUntil {(getPosATL TOUR_ammo select 2) < 2};
	detach TOUR_ammo;
	detach _light;
};

_mkrSupply = createMarker ["TOUR_mkrSupply", getPos TOUR_ammo];
_mkrSupply setMarkerType "b_support";

waitUntil {((_pos2 distance (vehicle (leader _grp))) < 300) or !(canMove (_info select 0))};
if !(canMove (_info select 0)) then
{
	sleep 300;
};
if (!isNull (_info select 0)) then
{
	deleteVehicle (_info select 0);
};
{
	if (!isNull _x) then
	{
		deleteVehicle _x;
	};
}forEach (_info select 1);		
if (!isNull (_info select 2)) then
{
	deleteGroup (_info select 2);
};

