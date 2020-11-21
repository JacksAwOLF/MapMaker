function next_move() {
	
	formationReset();
	
	// reset all soldiers variables
	var n = instance_number(obj_infantry);
	for (var i=0; i<n; i++)
		with(instance_find(obj_infantry, i)){
			can = 2;
			move_range = global.movement[unit_id];
			
			if (is_my_team_sprite(sprite_index) && moveCost == 6969){
				init_global_soldier_vars(id);
			}
		}
	
	
	// increment the hut spawn times
	n = instance_number(obj_hut);
	for (var i=0; i<n; i++)
		with(instance_find(obj_hut, i))
			if ((!global.edit || global.hutOn) && 
				steps!=-1 && get_team(soldier_sprite) == global.turn%2){
				steps = min(steps+1, limit);
			}
	
	
	if (!global.edit && network_my_turn())
		send_buffer(BufferDataType.yourMove, []);
			
			
	global.turn++; // relative positioning is important

	with(obj_tile) {
		if (hut != -1) with (hut) {
			if (auto && steps == limit)
				hut_createSoldier(spawnPos);
		}
	}
	
	//n = instance_number(obj_tile);
	//for (var i=0; i<n; i++)
	//	with(instance_find(obj_tile, i)){
	//		if (hut != -1) {
	//			with(hut) {
	//			if (auto && steps == limit)	
	//				hut_createSoldier(other.pos);
	//			}
	//		}
	//	}
	
	
	
	// deselect soldiers and clear  drawings
	erase_blocks(true);


	if  (global.edit){
		global.changeSprite = -1;
		global.selectedSoldier = -1;
		global.selectedSpawn = -1;
		global.selectedFormation = -1;
		update_fog();
	} 
	
	
	update_won();
}
