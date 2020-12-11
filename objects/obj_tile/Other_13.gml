/// @description handle double click event

// clear the selected soldier things if this block is not a possible move or attack
if (global.selectedSoldier != -1){
	
	if (global.selectedSoldier.formation != -1){ 
		
		var sS = global.selectedSoldier.tilePos,
			formId = sS.soldier.formation,
			form = global.formation[formId],
			dR = getRow(pos) - getRow(sS.pos), dC = getCol(pos) - getCol (sS.pos),
			moveC = 0, n = array_length(form.tiles), moved = array_create(n, false);
		
		while (moveC < n){
			for (var i=0; i<n; i++){
				if (moved[i]) continue;
				else if (form.tiles[i] ==  -1) {
					moved[i] = true;
					moveC++;
					continue;
				}
				var tile = form.tiles[i], startPos = tile.pos,
					newPos = getPos(getRow(startPos)+dR, getCol(startPos)+dC)
				if (global.grid[newPos].soldier != -1) continue;
				
				global.formation[formId].tiles[i] = global.grid[newPos];
				++moveC; moved[i] = true;
				with(tile.soldier) can -= moveCost;
				
				soldier_execute_move(startPos, newPos, tile.soldier.direction);
			}
		}
		
	} else if (possible_move || possible_path) {  
		var path = [];
		var pathpoints = [];	// store pathpoints (for recon planes)
		
		for (var i = 0; i <= array_length(global.poss_paths)-2; i++)
			path[array_length(path)] = global.poss_paths[i];
			
		while (!ds_stack_empty(global.selectedPathpointsStack)) {
			var cur = ds_stack_pop(global.selectedPathpointsStack);
			
			path[array_length(path)] = cur[0];
			if (cur[0].possible_pathpoint || cur[0] == id)
				pathpoints[array_length(pathpoints)] = cur[0];
				
			cur[0].possible_path = 0;
			cur[0].possible_pathpoint = false;
		}
		
		
		with (global.selectedSoldier){	
			if (is_plane(id)) {
				
				var pathSize = array_length(pathpoints);
				planePath = array_create(pathSize);
				for (var i = pathSize-1; i >= 0; i--)
					planePath[pathSize-i-1] = pathpoints[i];
				
				finalize_deployment(id);
				
				
			} else if (array_length(path)>=1 ) {
					
				// if didn't clicked myself again (didn't deselect)
				if (array_length(path) > 1) {
					can -= moveCost;
				}
				
				var i; // i is index of first soldier encountered or  -1 of none
				var moveHereCost = 0;
				for (i = array_length(path)-2; i>=0; i--){
					if (path[i].soldier!=-1 && path[i] != global.selectedSoldier.tilePos) break;	
					moveHereCost += global.energy[unit_id][get_tile_type(path[i])];
				}
				
				move_range -= moveHereCost;
				
				
				
				
				// clear fog if encountered soldier (stuck and  can't move)
				if (i != -1){
					path[i].hide_soldier = false;
					error = true;
				}
				
				
				// calculate direction  assuming you arrived  
				//  at  the blocked  tile then  was pushed back
				if (error) i--;
				var diff = path[i+1] - path[i+2];
				switch (diff) {
					case 1: direction = 270; break;
					case -1: direction = 90; break;
					case global.mapWidth: direction = 180; break;
					default: direction = 0;
				}
					
				if (error) i++;
				
				
				soldier_execute_move(global.selectedSoldier.tilePos.pos,  path[i+1].pos, direction);
				// global.selectedSoldier = path[i+1];
				
				//clear fog if encountered soldier  (actually moved)
				if (i != -1) path[i].hide_soldier = false;
				
			}
			
		}
			
	}
	
	
}
// double click on a hut while there is no global selected soldier
else if (originHutPos != -1){
	// chagne auto state
	global.grid[originHutPos].hut.auto = !global.grid[originHutPos].hut.auto;
}

erase_blocks(true);
global.selectedSoldier = -1;
global.selectedFormation = -1
global.selectedSpawn = -1;
global.displayTileInfo = id;