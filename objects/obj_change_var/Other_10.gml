/// @description Insert description here
// You can write your code in this editor

var add = 0;
if (mouse_y < y + sprite_height/3) add = 1;
else if (mouse_y > y + sprite_height/3*2) add = -1;


if (text == "Class"){
	global.soldier_vars[ind] = (global.soldier_vars[ind]+3+add)%3;
	
	// changing class means loading default values
	
	var c = global.soldier_vars[ind];
	global.soldier_vars[Svars.attack_range] = global.ranges[c];
	global.soldier_vars[Svars.vision] = global.vision[c];
}
else global.soldier_vars[ind] = max(global.soldier_vars[ind]+add, 0);