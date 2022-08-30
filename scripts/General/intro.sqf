
[]spawn
{
	if (!isdedicated) then
	{
		if (time > 5) exitWith
		{
		
		};
		
		cutText ["Loading Intro","BLACK FADED", 0];
		0 fadeSound 0;
		waituntil {player == player};
		//playSound "TOUR_introMusic";
		sleep 1;
		_pos1  = [1434.85,6983.37,50];
		_pos2  = [1425.4,7582.44,10];
		_pos3  = [2327.25,6399.66,20];
		
		_cam1 = "camera" camCreate _pos1;
		_cam1 camprepareTarget _pos2; 
		_cam1 camCommitprepared 0;
		_cam1 cameraEffect ["internal", "back"];
		"dynamicBlur" ppEffectEnable true;
		"dynamicBlur" ppEffectAdjust [5];
		"dynamicBlur" ppEffectCommit 0;
		sleep 8;
		cutText ["","BLACK FADED", 0];		
		sleep 7;	
		cutText [" ","BLACK IN", 5];
		"dynamicBlur" ppEffectAdjust [0];
		"dynamicBlur" ppEffectCommit 8;
		5 fadeSound 1;
		
		[player] call zade_boc_fnc_actionOnChest;
		player addBackpack "ACE_NonSteerableParachute";
		
		sleep 7;
		[]spawn 
		{
			_text = ["T","o","p","o","l","i","n"," ","B","r","i","d","g","e","\n","L","i","v","o","n","i","a"];
			_display = "";
			_pointer = 0;
			_sleepTime = 0.1;
			while {_pointer < count _text} do
			{
				_sleepTime = 0.1 + (random 0.05);
				_display = _display + (_text select _pointer);
				titleText [_display,"PLAIN down",_sleepTime];
				_pointer = _pointer + 1;
				if (_pointer == count _text) then
				{
					cutText [_display,"PLAIN down",1];
				}
				else
				{
					playSound "TOUR_key_noise";
				};
				sleep _sleepTime;
			};		

		};
		waitUntil {count (nearestObjects [position player, ["UK3CB_BAF_HERCULES_C4_DPMW"], 5000]) > 0};
		_plane = (nearestObjects [position player, ["UK3CB_BAF_HERCULES_C4_DPMW"], 5000]) select 0;
		sleep 5;
		_cam1 camSetTarget _plane;
		_cam1 camCommit 10;
		sleep 10;
		_cam1 camSetPos _pos3;
		_cam1 camCommit 15;
		sleep 10;
		cutText [" ","BLACK OUT", 2];
		sleep 2.2;
		_cam1 cameraEffect ["TERMINATE", "back"];
		camdestroy _cam1;
		"dynamicBlur" ppEffectAdjust [5];
		"dynamicBlur" ppEffectCommit 3;
		sleep 1;	
			
		_date = date;
		_year = _date select 0;
		_month = _date select 1;
		_day = _date select 2;
		_hour = _date select 3;
		_min = _date select 4;
		_text_date = [];

		if (_min < 10) then 
		{ 
			_text_date = format ["%1-%2-%3  %4h0%5m", _month, _day, _year, _hour, _min]; 
		} 
		else 
		{  
			if (_min == 60) then
			{
				_hour = _hour + 1;
				_min = 0;
				_text_date = format ["%1-%2-%3  %4h0%5m", _month, _day, _year, _hour, _min];
			}
			else
			{
				_text_date = format ["%1-%2-%3  %4h%5m", _month, _day, _year, _hour, _min]; 
			};
		};
		cutText ["", "BLACK IN", 2];
		"dynamicBlur" ppEffectAdjust [0];
		"dynamicBlur" ppEffectCommit 3;
		_text_1 = "Livonia";
		_text_2 = "[Tour] The Bridge";
		sleep 2;
		[_text_1, _text_date, _text_2] execVM "scripts\general\fn_infoText.sqf";	
	};
};

if (isServer) then
{
	sleep 30;
	_info = [[(getMarkerPos "marker_7") select 0, (getMarkerPos "marker_7") select 1,200],  249, "UK3CB_BAF_HERCULES_C4_DPMW", CIVILIAN] call BIS_fnc_spawnVehicle;
	_grp = _info select 2;
	sleep 1;
	_grp setbehaviour "CARELESS";
	_grp setCombatMode "BLUE";
	(_info select 0) flyInHeight 200;
	_grp setSpeedMode "LIMITED";
	_wp = _grp addWaypoint [[(getMarkerPos "m1") select 0, (getMarkerPos "m1") select 1,200], 200];
	
	waitUntil {(((getPosATL (_info select 0)) select 0) < 2500) or !(canMove (_info select 0))};
	
	{
		if !(isPlayer _x) then
		{
			[_x] call zade_boc_fnc_actionOnChest;
			_x addBackpack "ACE_NonSteerableParachute";
		};
	}forEach (playableunits + switchableUnits);
	
	[
		[],
		{
			_pos = getmarkerPos "TOUR_mkrStart";
			{
				_pos = _pos getPos [15, 249];
				if(backpack _x == "ACE_NonSteerableParachute") then
				{
					if (!isDedicated) then
					{
						if (player == _x) then
						{
							_x setPosATL [_pos select 0, _pos select 1, 150];	
							_x action ["OpenParachute", _x];
							[]spawn
							{
								while {((getPosATL (vehicle player)) select 2) > 5} do
								{
									setWind [0, 0, true];
									sleep 0.5;
								};
								setWind [0, 0, false];
							};
						};
					}else
					{
						if !(isPlayer _x) then
						{
							_x setPosATL [_pos select 0, _pos select 1, 150];	
							_x action ["OpenParachute", _x];					
						};
					};
				};
				sleep 0.5;
			}forEach playableUnits + switchableUnits;
		}
	] remoteExec ["spawn", 0, false];
	
	waitUntil {(((getMarkerPos "m1") distance (vehicle (leader _grp))) < 300) or !(canMove (_info select 0))};
	deleteVehicle (_info select 0);
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
	
	waitUntil {{((getPosATL _x) select 2) > 10}count playableUnits + switchableUnits == 0};
	TOUR_introDone = true;
	
};