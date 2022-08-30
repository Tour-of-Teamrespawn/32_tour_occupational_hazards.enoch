Private ["_magsEnd", "_target"];
_target = [0,0,0];

while {canfire TOUR_eMortar} do
{
	while {true} do
	{
		_target = (getMarkerPos "TOUR_mkrAO") getPos [800, (random 360)];
		if (count (nearestObjects [_target, ["man"], 75]) == 0) exitWith {};
	};
	_magsStart = str (magazinesAmmoFull TOUR_eMortar);
	_magsEnd = str (magazinesAmmoFull TOUR_eMortar);
	(gunner TOUR_eMortar) doArtilleryFire [_target, "rhs_mag_3vo18_10", 1];
	sleep 5;
	_magsEnd = str (magazinesAmmoFull TOUR_eMortar);
	TOUR_eMortar setvehicleAmmo 1;
	sleep 10 + (random 10);
};