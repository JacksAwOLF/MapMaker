
/// @description Updates the prospective path for the selected soldier
/// @param shouldClearPath Boolean whether to clear the paths

// global selected soldier finished updating
function soldier_update_path(shouldClearPath) {

	if (global.selectedSoldier != -1) {
		// reset poss_paths if exists
		if (global.poss_paths != -1) {
			for (var i = 0; i < array_length(global.poss_paths); i++)
				global.poss_paths[i].possible_path = max(0, global.poss_paths[i].possible_path-1);
			global.poss_paths = -1;
		}
		
		if (!shouldClearPath && global.prevHoveredTile.possible_move) {
			var mobility = global.movement[global.selectedSoldier.unit_id] - global.pathCost;
			global.poss_paths = get_path_to(global.prevHoveredTile.pos,mobility);
				
			for (var i = 0; i < array_length(global.poss_paths); i++)
				global.poss_paths[i].possible_path += 1;
		}
		
	}
}
