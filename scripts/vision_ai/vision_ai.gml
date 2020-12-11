// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_visible_tiles_at(soldier, tileInstance){
	var currentTile = soldier.tilePos;
	soldier.tilePos = tileInstance;
	
	var visionTiles = get_vision_tiles(soldier);
	
	soldier.tilePos = currentTile;
	return visionTiles;
}


// marks all visible 
function mark_visible_tiles_for(soldiers) {
	for (var i = 0; i < array_length(global.grid); i++) 
		global.grid[i].vision_flag = false;
	for (var i = 0; i < array_length(soldiers); i++) {
		var visionTiles = get_vision_tiles(soldiers[i]);
		
		for (var j = 0; j < array_length(visionTiles); j++) 
			visionTiles[j].vision_flag = true;
	}
}

// return all the visible tile instances for an array of soldiers
function get_visible_tiles_for(soldiers) {
	mark_visible_tiles_for(soldiers);
	
	var allVisibleTiles = []
	for (var i = 0; i < array_length(global.grid); i++)
		if (global.grid[i].vision_flag == true)
			allVisibleTiles[array_length(allVisibleTiles)] = global.grid[i];
			
	return allVisibleTiles;
}

// get all visible tiles for the current team assuming update fog
function get_visible_tiles_team() {
	var allVisibleTiles = [];
	for (var i = 0; i < array_length(global.grid); i++) 
		if (!global.grid[i].hide_soldier)
			allVisibleTiles[array_length(allVisibleTiles)] = global.grid[i];
	
	return allVisibleTiles;
}

// get all visible enemy soldiers for the current team assuming update fog
function get_visible_enemy_soldiers() {
	var allVisibleEnemies = [];
	for (var i = 0; i < array_length(global.grid); i++)
		if (!global.grid[i].hide_soldier && global.grid[i].soldier != -1 && !is_my_team(global.selectedSoldier))
			allVisibleEnemies[array_length(allVisibleEnemies)] = global.grid[i].soldier;
			
	return allVisibleEnemies;
}