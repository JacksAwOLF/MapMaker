function get_soldier_type(soldier_instance) {
	// returns index in global.energy for a given soldier instance (arg0)
	return get_soldier_type_from_sprite(soldier_instance.sprite_index);
}

function get_soldier_type_from_sprite(sprite_index) {
	switch(sprite_index) {
		case spr_infantry: 
		case spr_infantry1:
			return Units.INFANTRY_M;
			
		case spr_tanks:
		case spr_tanks1:
			return Units.TANK_M;
				
		case spr_ifvs:
		case spr_ifvs1:
			return Units.IFV_M;
		
		default:
			return -1;
	}
}

function is_tank(soldier) {
	return (soldier.unit_id == Units.TANK_M || soldier.unit_id == Units.TANK_R ||
			soldier.unit_id == Units.TANK_S);
}

function is_infantry(soldier) {
	return (soldier.unit_id == Units.INFANTRY_M || soldier.unit_id == Units.INFANTRY_R ||
			soldier.unit_id == Units.INFANTRY_S);
}

function is_ifv(soldier) {
	return (soldier.unit_id == Units.IFV_M || soldier.unit_id == Units.IFV_R ||
			soldier.unit_id == Units.IFV_S);
}

function is_plane(soldier) {
	return (soldier.unit_id == Units.BOMBER || soldier.unit_id == Units.RECON ||
			soldier.unit_id == Units.FIGHTER);
}

function get_tile_type(tile) {
	
	if (tile.road) return Tiles.road;
	
	switch (tile.sprite_index) {
		case spr_tile_flat:
			return Tiles.open;
		
		case spr_tile_mountain:
			return Tiles.mountain;
			
		case spr_tile_rough:
			return Tiles.rough;
			
		case spr_tile_ocean:
			return Tiles.ocean;
			
		default:
			return Tiles.others;
	}
}