// finished updating global selected soldier

// return if tileId is a possible attack for selected soldier or not
// can't see through fog
function possible_attack_tiles(tileId) { 
	
	var s = global.grid[tileId];
	if (s.hide_soldier || s.soldier + s.tower + s.hut == -3) return false;
	
	// in the order that you will attack them
	var targets = array("soldier", "tower", "hut")
	
	for (var i=0; i<array_length(targets); i++){
		var oth = variable_instance_get(s, targets[i]);
		if (oth != -1 && oth.team != global.selectedSoldier.team)
			return true;
	}

	return false;
}

function return_true(tileId){
	return true;
}



// returns if an attack is found or not
function soldier_init_attack(attack_cond) {
	var found = false;

	if (attack_cond == undefined)
		attack_cond = possible_attack_tiles;
		
	if (global.selectedSoldier != -1){

		var p = global.selectedSoldier.tilePos.pos;
	

		with (global.selectedSoldier){
			if (can-attackCost>=0){
				
				// find possible attack tiles
				var num_soldiers = instance_number(obj_infantry);
				if (attack_range*attack_range*4 < num_soldiers)
					global.poss_attacks = get_tiles_from_euclidean(p, attack_range, attack_cond);
				else {
					
					global.poss_attacks = [];
					var cur_x = tilePos.pos % global.mapWidth;
					var cur_y = floor(tilePos.pos / global.mapHeight);
					
					with (obj_infantry) {
						if (is_active) {
							
							var test_x = tilePos.pos % global.mapWidth;
							var test_y = floor(tilePos.pos / global.mapHeight);
						
							if (attack_cond(tilePos.pos) &&
								(cur_x-test_x)*(cur_x-test_x) + (cur_y-test_y)*(cur_y-test_y) <= other.attack_range*other.attack_range) {
							
								global.poss_attacks[array_length(global.poss_attacks)] = tilePos;
							}
						}
					}
					
				}
				
				for (var i=0; i<array_length(global.poss_attacks); i++){
					global.poss_attacks[i].possible_attack = true;
					found  = true;
				}
				
			}
		}



	}

	return found;
}
