/// @description Updates the prospective path for the selected soldier
/// @param clear_path Boolean whether to clear the paths

// argument0: 0 if update based on hovered tile, 1 if erase
if (global.selectedSoldier) {

	with(global.selectedSoldier.soldier) {
		
		// if the variable that stores paths exists, reset it
		if (variable_instance_exists(id, "poss_paths") && poss_paths != -1) 
			for (var i = 0; i < array_length_1d(poss_paths); i++) 
				poss_paths[i].possible_path = false;
	
		poss_paths = -1;
	
		
		if (argument[0] == 0 && global.prevHoveredTiles[0].possible_move) {
			var throughPrev = [];			
			var mobility = global.movement[get_soldier_id(other.soldier)];
			
			if (global.prevHoveredTiles[1] != -1) {
				with(global.prevHoveredTiles[1]) {
					var diff = abs(pos - global.prevHoveredTiles[0].pos);
					
					// we check whether we can draw a path that
					// goes through the previously hovered tils
					if(possible_move && (diff == 1 || diff == global.mapWidth)) {
						
						var cost = get_energy_to_cross(get_soldier_id(other.id),id);
						var holder = get_path_to(global.prevHoveredTiles[1].pos, mobility-cost);
													
						throughPrev[0] = global.prevHoveredTiles[0];
						for (var i = 0; i < array_length_1d(holder); i++)
							throughPrev[i+1] = holder[i];
					}
				}
			}
			
			if (array_length_1d(throughPrev) > 1)
				poss_paths = throughPrev;
			else 
				poss_paths = get_path_to(global.prevHoveredTiles[0].pos,mobility);
			
				
			for (var i = 0; i < array_length_1d(poss_paths); i++)
				poss_paths[i].possible_path = true;
		}
	}
}