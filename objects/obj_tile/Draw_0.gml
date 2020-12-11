/// @description Drawing sprites with size


var alpha_value = 1;
if (hide_soldier) alpha_value = 0.5;

// draw the terrain
draw_sprite_stretched_ext(sprite_index, 0, x, y, size, size, c_white, alpha_value);										// the tile on the bottom

// draw the road if needed
if (road){
	var ind = 0;
	// up, right, down, left
	if (floor(pos/global.mapWidth)>0 && global.grid[pos-global.mapWidth].road) ind += 1;
	if ((pos+1)%global.mapWidth>0 && global.grid[pos+1].road) ind += 2;
	if (floor(pos/global.mapWidth)<global.mapHeight-1 && global.grid[pos+global.mapWidth].road) ind += 4;
	if (pos%global.mapWidth>0 && global.grid[pos-1].road) ind += 8;
	
	draw_sprite_stretched_ext(spr_tile_road, ind, x, y, size, size, c_white, alpha_value);
}



// draw borders around it


if (mouseIn) draw_sprite_stretched_ext(spr_select_underMouse, 0, x, y, size, size, c_white, 1);					// mouse in gray box
if (possible_move) draw_sprite_stretched_ext(spr_select_possibleMove, 0, x, y, size, size, c_white, 1);			// a possible move, yellow box
if ((possible_attack && !hide_soldier)) draw_sprite_stretched_ext(spr_select_possibleAttack, 0, x, y, size, size, c_white, 1);		// a possible attack, red box
if (possible_path || (possible_move && mouseIn)) draw_sprite_stretched_ext(spr_select_possiblePath, 0, x, y, size, size, c_white, 1);			// possible path
if (possible_pathpoint) draw_sprite_stretched_ext(spr_select_possiblePathPoint, 0, x, y, size, size, c_white, 1);
if (possible_teleport || global.selectedSpawn == id) draw_sprite_stretched_ext(spr_select_teleport, 0, x, y, size, size, c_white, 1);

if (possible_enemy_attack) draw_sprite_stretched_ext(spr_orange, 0, x+1/10*size, y+1/10*size, size*4/5, size*4/5, c_white, 1);
if (enemy_vision) draw_sprite_stretched_ext(spr_dark_blue, 0, x+3/20*size, y+3/20*size, size*7/10, size*7/10, c_white, 1);
if (possible_enemy_move) draw_sprite_stretched_ext(spr_dark_green, 0, x+1/5*size, y+1/5*size, size*3/5, size*3/5, c_white, 1);






	
// draw the  hut if needed


if (hut != -1 && (is_my_team_sprite(hut.soldier_sprite) || !hide_soldier || hut.team == -1)) {

	with(hut){
		var ss = other.size;
		var scale_factor = ss/sprite_get_width(other.sprite_index);
		var color = get_team(soldier_sprite) ? c_gray : c_white;
		
		// myself
		draw_sprite_ext(sprite_index, 0, x, y, scale_factor, scale_factor, 0, color, 1);
		// health bar
		draw_healthbar(x, y+ss*3/4, x+ss, y+ss*7/8, (my_health/max_health)*100, c_black, c_red, c_green, 0, true,false);		
		
	}
}


if (originHutPos != -1 && (is_my_team_sprite(global.grid[originHutPos].hut.soldier_sprite) || !hide_soldier)) {
	var gridOriginal = global.grid[originHutPos];
	var hutOriginal = gridOriginal.hut;
	
	with (hutOriginal) {
		var ss = other.size;
		var scale_factor = ss/sprite_get_width(other.sprite_index);
		var color = get_team(soldier_sprite) ? c_gray : c_white;

		if (hutOriginal.steps >= 0){
			// ghost soldier
			if (other.soldier == -1) {
				var xx = other.x, yy = other.y;
				var width = scale_factor*sprite_get_width(soldier_sprite);
	
				// we need to reposition x, y based on rotation
				if (sprite_dir == 180 || sprite_dir == 270) xx += ss;
				if (sprite_dir == 90 || sprite_dir == 180) yy += ss;
	
				draw_sprite_ext(soldier_sprite, 0, xx, yy, scale_factor, scale_factor, sprite_dir, c_white, 0.4); // the soldier on this tile
				
				// draw colored circles for melee, ranged, scouts
				var soldier_class = floor(soldier_unit / 3);
				if (soldier_unit < 3) 
					draw_circle_color(other.x+width/4.5,other.y+width/3.75,width/8,global.colors[soldier_class],global.colors[soldier_class],false);
				
			}
			
			// loading bar
			draw_healthbar(other.x, other.y+ss*7/8, other.x+ss, other.y+ss, (steps/limit)*100, c_gray, c_purple, c_blue, 0, true,false);
		}
		
		
		// auto-genearte indication
		if (auto) draw_set_color(c_green);
		else draw_set_color(c_red);
		draw_circle(other.x+ss/2, other.y+ss/2, ss/8, false);	
		
		
		
		draw_set_color(c_black);
	}
}




// draw tower
if (tower != -1){
	var scale_factor = size/sprite_get_width(spr_tower);	
	var spIndex = global.edit ?  real(tower.team != global.turn%2) : 
		real(tower.team!=global.playas)
		
	if (tower.my_health <= 0) {
		spIndex += 2;
		tower.my_health = 0; // because -1 is a special number in save files :(
	}
	else draw_healthbar(x, y+size*7/8, x+size, y+size, (tower.my_health/tower.max_health)*100, c_white, c_yellow, c_maroon,0, true, false);
	draw_sprite_ext(spr_tower, spIndex, x, y, scale_factor, scale_factor, 0, c_white, 1);
}





// draw soldiers if needed
if (soldier != -1 && !hide_soldier){	
	
	var spr_index = soldier.sprite_index;
	var scale_factor = size/sprite_get_width(spr_index);
	
	
	
	// index to draw
	var soldier_index = 0; 
	if (global.selectedSoldier != -1 && global.selectedSoldier.tilePos == id) soldier_index = 1;
	if (!(soldier.can && soldier.move_range)) soldier_index = 2;
	
	// formation 
	var ccc = c_white;
	if (soldier.formation != -1 && soldier.formation == global.selectedFormation) {
		soldier_index = 1;
		if (global.selectedSoldier.tilePos != id)
			ccc = c_aqua;
	}
	

	
	var xx = x, yy = y;
	// we need to reposition x, y based on rotation
	if (soldier.direction == 180 || soldier.direction == 270) xx += size;
	if (soldier.direction == 90 || soldier.direction == 180) yy += size;
		
	var width = scale_factor*sprite_get_width(spr_index); 
	var class = floor(soldier.unit_id / 3);
	
	draw_sprite_ext(spr_index, soldier_index, xx, yy, scale_factor, scale_factor, soldier.direction, ccc, 1);				// the soldier on this tile
	if (class < 3) draw_circle_color(x+width/4.5,y+width/3.75,width/8,global.colors[class],global.colors[class],false);
	draw_healthbar(x, y, x+size, y+(size)/8, (soldier.my_health/soldier.max_health)*100, c_black, c_red, c_green, 0, true,false);
	

	if (soldier.unit_id == Units.CARRIER && soldier.storedPlaneInst != -1 && soldier.bindedPlane == -1) {
		var planeName = string_char_at(global.unitNames[soldier.storedPlaneInst.unit_id],1);
			
		draw_rectangle_color(x+size*2/3,y+size*2/3,x+size,y+size,c_orange,c_orange,c_orange,c_orange,false);
		draw_text(x+size*13/18,y+size*13/18,planeName);
	}
}

// draw planes
if (array_length(planeArr) > 0) {
	var planeName = "";
	var planeCount = 0;
	
	for (var i = 0; i < array_length(planeArr); i++) {
		if (planeArr[i] != -1 && (is_my_team(planeArr[i]) || !hide_soldier)) {
			planeName = string_char_at(global.unitNames[planeArr[i].unit_id],1);
			planeCount += 1;
		}
	}
	
	if (planeCount > 1) 
		planeName = string(planeCount);
	if (planeName != "") {
		draw_rectangle_color(x,y+size*2/3,x+size*1/3,y+size,c_orange,c_orange,c_orange,c_orange,false);
		draw_text(x+size*1/18,y+size*13/18,planeName);
	}
}