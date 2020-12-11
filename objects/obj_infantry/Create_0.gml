/// @description Insert description here
// You can write your code in this editor


// these vars are updated in next_move


can = 2;
moveCost = 2;
attackCost = 2;

move_range = -1;   // to implement ifvs move twice


display_if_enemy = false;

team = get_team(sprite_index);
unit_id = -1;

my_health = 0;
tilePos = -1;


error = false;					// when set to true, flash the soldier
error_count = 0;				// increment this until reaches limit
error_limit = 3;				// how many times to flash
error_wait = 5;					// how many frames per flash


storedPlaneInst = -1;			// for seaplane carrierss
bindedPlane = -1;

bindedCarrier = -1;				// for planes deployed from plane carriers
planePath = -1;					// path for recon
unitLockedOn = -1;				// unit locked on for bombers and fighters
planeFinished = true;			// returning back to base

formIndication = false;
formation = -1;

is_active = true;				// whether this unit is currently in game
								// if isn't, probably used for some helper thing