/*
	ENMEY HOUSE SCRIPT
	by Mr.Ben
	
	params passed to script through an array:
	0 = marker name, string
	1 = side, side

*/

private ["_centrepos", "_marker", "_array_type", "_skill", "_side", "_pos", "_test", "_buildingsnew", "_buildings", "_building", "_grp", "_unit", "_size", "_type", "_posarray", "_count", "_min", "_max"];

_marker = _this select 0;
_centrepos = getMarkerPos _marker;
_side = _this select 1;
_min = _this select 2;
_max = _this select 3;
_array_type = 
[
	"rhs_vdv_flora_engineer",
	"rhs_vdv_flora_driver",
	"rhs_vdv_flora_efreitor",
	"rhs_vdv_flora_strelok_rpg_assist",
	"rhs_vdv_flora_driver_armored",
	"rhs_vdv_flora_grenadier_rpg",
	"rhs_vdv_flora_aa","rhs_vdv_mflora_sergeant",
	"rhs_vdv_flora_at","rhs_vdv_mflora_RShG2",
	"rhs_vdv_flora_machinegunner_assistant",
	"rhs_vdv_flora_junior_sergeant",
	"rhs_vdv_flora_rifleman_lite",
	"rhs_vdv_flora_medic",
	"rhs_vdv_flora_LAT",
	"rhs_vdv_flora_grenadier",
	"rhs_vdv_flora_rifleman",
	"rhs_vdv_flora_marksman",
	"rhs_vdv_flora_machinegunner",
	"rhs_vdv_flora_officer_armored"
];

_pos = [0,0,0];
_test = 0;
_buildingsnew = [];
_posarray = [];

if ((markerSize _marker) select 0 > (markerSize _marker) select 1) then
{
	_size = (markerSize _marker) select 0;
}else
{
	_size = (markerSize _marker) select 1;
};

_positions = [];
_buildings = [];

{
	if (_x inArea _marker) then
	{
		_buildings set [count _buildings, _x];
	};
}forEach (nearestObjects [_centrepos,["Building","House"], _size]);

if ((count _buildings) == 0) exitWith
{
	_pos
};

{
	if ((getposATL _x) inArea _marker) then 
	{
		_buildingsnew set [count _buildingsnew, _x];
	};
}forEach _buildings;

if (count _buildingsnew == 0) exitWith
{
	_pos
};

{
	_building = _buildingsnew select _forEachIndex;
	_test = 0;
	while {_test < 50} do {if (format ["%1", _building buildingPos _test] != "[0,0,0]") then {_posarray set [count _posarray, _building buildingPos _test];};_test = _test + 1};

}forEach _buildingsnew;

if ((count _posarray) < _max) then
{
	_max = count _posarray;
};

if (_min > _max) then
{
	_min = _max;
};

if (_max < 1) then
{
	_max = 1;
	_min = 1;
};

if (count _posarray == 0) exitWith {};

waitUntil {!isNil "TOUR_introDone"};

for "_i" from 1 to (_min + (ceil (random (_max - _min)))) do
{
	_pos = [0,0,0];
	_pos = (_posarray call BIS_fnc_selectRandom);
	_posarray = _posarray - [_pos];
	_type = _array_type call BIS_fnc_selectRandom;
	if (typeName _type == "ARRAY") then
	{
		_type = _type select 1;
	};
	_grp = createGroup _side;
	waitUntil {!isNull _grp};
	_unit = _grp createUnit [_type, _pos, [], (_centrepos getDir _pos), "NONE"];
	_unit setPos _pos;
	_unit setDir (_centrepos getDir _pos);
	_unit call Tour_fnc_garbageEH;
	_unit call TOUR_fnc_loadouts;
	_unit addEventHandler ["Firednear",{_this call TDMC_fnc_houseunitactive;}]; 
	_unit addEventHandler ["HIT",{_this call TDMC_fnc_houseunitactive;}];
	_unit setVariable ["lambs_danger_disableAI", true];
};
