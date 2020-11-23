// @function Destroys the soldier at pos
// @param positionToDestroy
function destroy_soldier(pos) {
	with (global.grid[pos]){
		if (soldier != -1){
			var index = ds_list_find_index(global.allSoldiers[soldier.team], soldier);
			ds_list_delete(global.allSoldiers[soldier.team], index);
			removeFromFormation(soldier.formation, id);
			
			if (!refreshFocus()) 
				global.shouldFocusTurn = -1;
			
			
			with(soldier) instance_destroy();
			soldier = -1;
			update_fog();
		}
	}
}


// @function Initialize the global soldier variables; class should be set already
// @param soldierObjId
function init_global_soldier_vars(soldierId){
	with(soldierId){
		//var type = get_solier_type_from_sprite(sprite_index);
		
		
		attack_range = global.attack_range[unit_id];
		max_health = global.max_health[unit_id];
		max_damage = global.max_damage[unit_id];
		vision = global.vision[unit_id];
		if (my_health == 0) my_health = max_health;
		
		if (global.map_loaded) move_range = global.movement[unit_id];
		if (is_ifv(id)) moveCost = 1;
		else moveCost = 2;
	}
}


// @function Creates a soldier from hut
// @param sind
// @param pos
// @param fromHut
// @param [updateFog=true]
function create_soldier(sind, pos, fromHutPos, updateFog) {

	//if (fromHut == undefined) fromHut = false;
	if (updateFog == undefined) updateFog = true;
	
	var s_unit_id = -1;
	if (fromHutPos != -1) {
		s_unit_id = global.grid[fromHutPos].hut.soldier_unit;
	} else { // edit mode
		s_unit_id = posInArray(global.soldierSelectTile[get_team(sind)].binded_dropdown.options, sind);
		s_unit_id += global.soldier_vars[Svars.unit_page] * 3;
	}
	
	with (global.grid[pos]) { 
		if (soldier == -1){
			soldier = instance_create_depth(x,y,0,obj_infantry);
			
			with(soldier){
				sprite_index = sind;
				team = get_team(sprite_index);
				unit_id = s_unit_id;
				tilePos = global.grid[pos];
			}
			
			ds_list_add(global.allSoldiers[soldier.team], soldier);	
			init_global_soldier_vars(soldier);
			
			if (fromHutPos != -1){
				with (global.grid[fromHutPos].hut){
					if (sprite_dir != -1)
						other.soldier.direction = sprite_dir;
				}
				
				
			} else with (soldier) { 
				attack_range = global.soldier_vars[Svars.attack_range];
				max_health = global.soldier_vars[Svars.max_health];
				max_damage = global.soldier_vars[Svars.max_damage];
				vision = global.soldier_vars[Svars.vision];
				my_health = max_health;
			}
			
			if (updateFog) update_fog();
			send_buffer(BufferDataType.soldierCreated, array(sind, pos, fromHutPos));
		}
	}
}



// @function actually execute an attack
function soldier_execute_attack(frTilePos, toTilePos){
	
	var fr = global.grid[frTilePos], to = global.grid[toTilePos]; 
	
	var attacked;
	if (to.soldier != -1) attacked = to.soldier;
	else if (to.tower != -1) attacked = to.tower;
	else attacked = to.hut;
	
	var damage = calculate_damage(fr.soldier, attacked); 
	
	// process attacking from the side
	if (attacked == to.soldier && to.soldier != -1 && to.tower == -1) {
		var ohko = false, posdiff = frTilePos - toTilePos;
		if (posdiff == 1 || posdiff == -1)
			ohko = (to.soldier.direction % 180 == 0);
		if (posdiff == global.mapWidth || posdiff == -global.mapWidth)
			ohko = (to.soldier.direction == 90 || to.soldier.direction == 270);
			
		if (ohko && !is_tank(attacked))
			damage = to.soldier.my_health;
	}
	
	attacked.my_health -= damage;
	fr.soldier.can -= fr.soldier.attackCost;
	
						
	if (attacked.my_health <= 0){
		
		if (attacked.object_index == obj_hut && attacked.nuetral == true) {
			
			//debug("the hut has to be nuetral!", attacked.nuetral, global.hutlimit[fr.soldier.unit_id])
			
			// conquer the hut, or destroy it (based on the attacking unit's hut limit)
			if (global.hutlimit[fr.soldier.unit_id] == -1) {
				instance_destroy(attacked);
				attacked.hut = -1;
			} else {
				attacked.soldier = fr.soldier;
				with(attacked) event_user(10);
			}
			
		} else if (attacked.object_index == obj_tower) {
			
			// if someone was teleporting to this place already
			if (to.originHutPos != -1) {
				var originGrid = global.grid[to.originHutPos];	
				originGrid.hut.spawnPos = originGrid.pos;
				originGrid.originHutPos = originGrid.pos;
			
				to.originHutPos = -1;
				
				
			} 
			
			// if it is a teleport location
			if (attacked.my_health + damage <= 0) {
				for (var i = 0; i < array_length(global.conqueredTowers[attacked.team]); i++) {
					if (global.conqueredTowers[attacked.team][i] == to) {
						global.conqueredTowers[attacked.team][i] = -1;
						break;
					}
				}
				
				to.tower = -1;
				instance_destroy(attacked);
				
			} else {
				// make this tower into a teleport place
				attacked.team = (attacked.team+1)%2;
				append(global.conqueredTowers[fr.soldier.team], to);
			}
			
			
			
		}
		
		else{
			switch(attacked.object_index){
				case obj_infantry:
					destroy_soldier(toTilePos); break;
					
				case obj_hut:
					global.grid[attacked.spawnPos].originHutPos = -1;
					to.hut = -1; 
					
				default:
					instance_destroy(attacked);
			}
			
			
			
		
			if (global.edit) update_fog();
			
			// if you got this through a buffer,
			// then you update the fog for yourself
			else if (!network_my_turn()){
				global.turn++;
				update_fog();
				global.turn--;
			} else {
				update_enemy_outline();
			}
		}
		
	}
	
	// melee unit fixing ability
	// this is returned back to default in next_move
	else if (is_infantry(fr.soldier) && attacked.object_index == obj_infantry){
		if (are_tiles_adjacent(frTilePos, toTilePos)) // implemented in grid_helper_functions
			attacked.moveCost = 6969;
	}
	
	send_buffer(BufferDataType.soldierAttacked, array(frTilePos, toTilePos));

	erase_blocks(true);
	if (fr == global.selectedSoldier) global.selectedSoldier = -1;
}


function soldier_execute_move(frTilePos, toTilePos, dir){

	
	// move to the pushed back tile (not  changing x or y)]
	var fr = global.grid[frTilePos], to = global.grid[toTilePos];
	
	var t = fr.soldier;
	fr.soldier = -1;
	to.soldier = t;
	
	t.tilePos = to;
	

	
	with(to.soldier) direction = dir;
	send_buffer(BufferDataType.soldierMoved, array(frTilePos, toTilePos, dir));
	
	if (global.edit || network_my_turn()) update_fog();
	else {
		update_enemy_outline();
	}
}


function exchange_hut_spawn_position(originHutPosition, newSpawnPosition){
	
	//var relatedHut = global.grid[global.selectedSpawn.originHutPos].hut;
	var relatedHut = global.grid[originHutPosition].hut,
		newSpawnTile = global.grid[newSpawnPosition];
			
	newSpawnTile.originHutPos = global.grid[relatedHut.spawnPos].originHutPos;
	global.grid[relatedHut.spawnPos].originHutPos = -1;	
	relatedHut.spawnPos = newSpawnTile.pos;
	
	send_buffer(BufferDataType.changeHutPosition, array(originHutPosition, newSpawnPosition));
			
	//global.selectedSpawn = -2;
}