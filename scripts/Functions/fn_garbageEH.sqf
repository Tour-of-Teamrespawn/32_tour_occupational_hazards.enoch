_this addEventHandler ["KILLED", {_this spawn TOUR_fnc_garbage;}];
if ((side _this == CIVILIAN)or(side _this == INDEPENDENT)) then
{
	_this addEventHandler ["KILLED", 
	{
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		if ((("TOUR_objFriendly" call A2S_getTaskState) != "failed") && (side _instigator == WEST)) then 
		{	
			["TOUR_objFriendly", "failed"] call A2S_setTaskState;
			"TOUR_objFriendly" call A2S_taskCommit;
			[] spawn
			{
				sleep 4;
				"TOUR_objFriendly" call A2S_taskHint;
			};
		};
	}];
};