/// @description Insert description here
// You can write your code in this editor

// some bs code to handle asynchros events
var i_d = ds_map_find_value(async_load, "id");

if i_d == hor && ds_map_find_value(async_load, "status"){
	hor = real(ds_map_find_value(async_load, "result"));
	ver = get_integer_async("How many tiles top to botton? ", 5);
}

if i_d == ver && ds_map_find_value(async_load, "status"){
	ver = real(ds_map_find_value(async_load, "result"));
	
	global.mapHeight = ver
	global.mapWidth = hor
	
	load_map_from_file("");
}



