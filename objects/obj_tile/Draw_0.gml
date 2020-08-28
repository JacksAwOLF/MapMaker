/// @description Drawing sprites with size


var alpha_value = 1;
if (hide_soldier) alpha_value = 0.5;

// draw the terrain
draw_sprite_stretched_ext(sprite_index, 0, x, y, size, size, c_white, alpha_value);										// the tile on the bottom

// draw the road if needed
if (road){
	var ind = 0;
	// up, right, down, left
	//debug(pos, pos/global.mapWidth);
	if (floor(pos/global.mapWidth)>0 && global.grid[pos-global.mapWidth].road) ind += 1;
	if ((pos+1)%global.mapWidth>0 && global.grid[pos+1].road) ind += 2;
	if (floor(pos/global.mapWidth)<global.mapHeight-1 && global.grid[pos+global.mapWidth].road) ind += 4;
	if (pos%global.mapWidth>0 && global.grid[pos-1].road) ind += 8;
	
	draw_sprite_stretched_ext(spr_tile_road, ind, x, y, size, size, c_white, alpha_value);
}



// draw borders around it
if (mouseIn) draw_sprite_stretched_ext(spr_select_underMouse, 0, x, y, size, size, c_white, 1);					// mouse in gray box
if (possible_move) draw_sprite_stretched_ext(spr_select_possibleMove, 0, x, y, size, size, c_white, 1);			// a possible move, yellow box
if (possible_attack && !hide_soldier) draw_sprite_stretched_ext(spr_select_possibleAttack, 0, x, y, size, size, c_white, 1);		// a possible attack, red box
if (possible_path) draw_sprite_stretched_ext(spr_select_possiblePath, 0, x, y, size, size, c_white, 1);			// possible path
if (possible_pathpoint) draw_sprite_stretched_ext(spr_select_possiblePathPoint, 0, x, y, size, size, c_white, 1);




	
// draw the  hut if needed
if (hut != -1 /*&& !hide_soldier*/ ){
	
	with(hut){
		var ss = other.size;
		var scale_factor = ss/sprite_get_width(soldier_sprite);
	
		if (other.soldier == -1) draw_sprite_ext(soldier_sprite, 0, x, y, scale_factor, scale_factor, 0, c_white, 0.4);
		draw_sprite_ext(sprite_index, 0, x, y, scale_factor, scale_factor, 0, c_white, 1);

		draw_healthbar(x, y, x+ss, y+(ss)/8, (steps/limit)*100, c_gray, c_purple, c_blue, 0, true,false);
		
	}
}



// draw soldiers if needed
if (soldier != -1 && !hide_soldier){	
	
	var spr_index = soldier.sprite_index;
	var scale_factor = size/sprite_get_width(spr_index);
	
	// index to draw
	var soldier_index = 0; 
	if (global.selectedSoldier == id) soldier_index = 1;
	with(soldier) if (error){
		soldier_index = (floor(error_count/error_wait)+1) % 2
		if (error_count == error_limit * error_wait){
			error = false;
			error_count = 0;
		}
		error_count += 1;
	}

	
	var xx = x, yy = y;
	
	// we need to reposition x, y based on rotation
	if (soldier.direction == 180 || soldier.direction == 270) xx += size;
	if (soldier.direction == 90 || soldier.direction == 180) yy += size;
		
	draw_sprite_ext(spr_index, soldier_index, xx, yy, scale_factor, scale_factor, soldier.direction, c_white, 1);				// the soldier on this tile
	draw_healthbar(x, y, x+size, y+(size)/8, (soldier.my_health/soldier.max_health)*100, c_black, c_red, c_green, 0, true,false);
}



// the soldier thingy while moving
//if (draw_temp_soldier != -1)
	//draw_sprite_stretched_ext(draw_temp_soldier, 0,  x, y, size, size, c_navy, 0.8);								// the iamge of potential soldier placed here
	
	


// draw tower
if (tower != -1){
	var scale_factor = size/sprite_get_width(spr_tower);
	var spIndex = global.edit ?  real(tower.team != global.turn%2) : 
		real(tower.team!=real(global.action!="playw"))
	draw_sprite_ext(spr_tower, spIndex, x, y, scale_factor, scale_factor, 0, c_white, 1);
	draw_healthbar(x, y+size/8, x+size, y+size/4, (tower.my_health/tower.max_health)*100, c_white, c_yellow, c_maroon,0, true, false);
}





