/// @description initialize mouseIn, soldier


event_inherited();

mouseIn = false;
soldier = -1;					// the soldier instance that is in this position
planeArr = [];					// array of plane instances that are in this position
								// constantly altered, so may include -1's (empty slots)
	

possible_path = 0;			// this tile is along the current selected path
possible_pathpoint = false;		// this tile is selected as one of the key points of the path

possible_move = false;			// this tile is a possible move
possible_attack = false;		// this tile is a possible attack

possible_enemy_move = false;
possible_enemy_attack = false;
possible_teleport = false;

enemy_vision = false;

draw_temp_soldier = -1;			// what sprite of temporary soldier to draw


elevation = 1;

hide_soldier = true;
road = false;

hut = -1;
originHutPos = -1;	// holds hut information for spawning

tower = -1;

// other variables are initialized in script create_map




edit = global.edit;
preMouseIn  = false;