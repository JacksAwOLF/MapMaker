/// @description Insert description here
// You can write your code in this editor

var add = 0;
if (mouse_y < y + sprite_height/3) add = 1;
else if (mouse_y > y + sprite_height/3*2) add = -1;

global.soldier_vars[ind] = max(global.soldier_vars[ind]+add, 0);