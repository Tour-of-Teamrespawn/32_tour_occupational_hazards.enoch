/* 
###MISSION_VERSION 3.0
*/

_d = execVM "scripts\debugRPT.sqf";
waitUntil {scriptDone _d};

_p = execVM "params.sqf";
waitUntil {scriptDone _p};

_a = TOUR_Core execVM "a2s_multitask.sqf";
waitUntil {scriptDone _a};

setViewDistance 2500;

enableRadio false;
{
	_x setVariable ["BIS_noCoreConversations",true];
} forEach allUnits;

TOUR_HQ = [WEST, "HQ"];

_fn = execVM "scripts\functions\functions_init.sqf";
waitUntil {scriptDone _fn};

_si = 
[
	TOUR_core,
	WEST,
	"(alive player) && ([player, ""ACRE_PRC152""] call acre_api_fnc_hasKindOfRadio)",
	"false",
	1,
	[
		[
			"artillery",
			"Artemis One",
			[
				["8rnd_82mm_mo_smoke_white", 30]
			]
		]
	],
	"TOUR_fnc_endRadio",
	{true}
] execVM "scripts\TOUR_SI\TOUR_SI_init.sqf";

execVM "scripts\general\intro.sqf";

if (isServer) then
{	
	_g = execVM "scripts\control\garbageLoop.sqf";
	
	_o = execVM "scripts\control\setupObjectives.sqf";

	_cp = ["TOUR_mkrAO"] execVM "scripts\ambientLife\createPedestrians.sqf";
	
	_cd = 5 execVM "scripts\control\mortarLoop.sqf";
	
	_fb = 5 execVM "scripts\control\flybyLoop.sqf";
	
	_cd = 5 execVM "scripts\ambientLife\createVehicles.sqf";
	
	_eh = ["TOUR_mkrAO", EAST, 8, 11] execVM "scripts\control\setupEnemyHouse.sqf";
	
	_e = execVM "scripts\control\setupEnemy.sqf";
	
	_sd = execVM "scripts\control\supplyDrop.sqf";
	
	execVM "scripts\control\ending.sqf";
};

if (!isDedicated) then
{
	#include "briefing.hpp"
	
	[] call A2S_tasksSync;

	TOUR_mission_color = ppEffectCreate ["Colorcorrections", 1200]; 
	TOUR_mission_color ppEffectAdjust [1, 0.8, -0.001, [0.0, 0.0, 0.0, 0.0], [0.3, 0.5, 0.7, 0.4], [0.3, 0.4, 0.8, 0.4]]; 
	TOUR_mission_color ppEffectCommit 0; 
	TOUR_mission_color ppEffectEnable true;

	player execVM "scripts\loadouts\init.sqf";
	
	player addEventHandler ["FIRED", 
	{
		if ((_this select 4) == "B_IRStrobe") then {TOUR_strobe = _this select 6; publicVariable "TOUR_strobe";};
	}];
};




