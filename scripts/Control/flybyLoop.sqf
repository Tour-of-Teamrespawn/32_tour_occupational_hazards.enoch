waitUntil {!isNil "TOUR_introDone"};
_time = time + 5;

while {true} do
{
	waitUntil {time > _time};
	_dir = (ceil random 360);
	_pos = (getMarkerPos "TOUR_mkrAO") getPos [5000, _dir]; 
	_pos = [_pos select 0, _pos select 1, 500];
	_type = ["B_plane_CAS_01_DynamicLoadout_F","rhs_mig29s_vmf","RHS_Mi24V_vdv","RHS_Mi24V_vdv","RHS_Mi8MTV3_vdv","UK3CB_BAF_Army_DPMW_Merlin_HC3_18_GPMG","UK3CB_BAF_Army_DPMW_Merlin_HC3_18_GPMG"]call BIS_fnc_selectRandom;
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
	_pos2 = (getMarkerPos "TOUR_mkrAO") getPos [5000, (_dir + 180)]; 
	_wp = _grp addWaypoint [_pos2, 1000];
	
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
	sleep 2;
};