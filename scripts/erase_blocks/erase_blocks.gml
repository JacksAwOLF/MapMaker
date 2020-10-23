/// replaces soldier_erase_attack/move
/// @param clear_pathpoints If true, clear all pathpoints and costs

function erase_blocks() {
	
	with(obj_tile){
		possible_move = false;
		possible_attack = false;
		possible_teleport = false;
	}
	global.poss_moves = -1;
	global.poss_attacks = -1;
	
	/* if (global.selectedSoldier > 0){
		with(global.selectedSoldier.soldier){
			
			if (global.poss_moves != -1){
				for (var i=0; i<array_length(global.poss_moves); i++)
					global.poss_moves[i].possible_move = false;
				global.poss_moves = -1;
			}
		
			if (global.poss_attacks != -1){
				for (var i=0; i<array_length(global.poss_attacks); i++)
					global.poss_attacks[i].possible_attack = false;
				global.poss_attacks = -1;
			}
		}
	}*/
	
	if (argument_count > 0 && argument[0] == true) {
		global.pathCost = 0;
		
		while (!ds_stack_empty(global.selectedPathpointsStack)) {
			var cur = ds_stack_pop(global.selectedPathpointsStack);
			cur[0].possible_path = 0;
			cur[0].possible_pathpoint = false;
		}
	}
	
	soldier_update_path(true);
}



