// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function update_stored_plane(new_unit_id) {
	with (global.selectedSoldier) {
		if (storedPlaneInst == -1)
			storedPlaneInst = instance_create_depth(0,0,0,obj_infantry);
		
		storedPlaneInst.unit_id = new_unit_id;
		storedPlaneInst.is_active = false;
		init_global_soldier_vars(storedPlaneInst);
	}
}

function switch_to_bomber() {
	if (global.selectedSoldier == -1)
		show_error("Switch to bomber called when no global soldier selected.", true);
	else if (global.selectedSoldier.unit_id != Units.CARRIER)
		show_error("Switch to bomber called when seaplane carrier isn't selected", true);
	update_stored_plane(Units.BOMBER);
}

function switch_to_recon() {
	if (global.selectedSoldier == -1)
		show_error("Switch to recon called when no global soldier selected.", true);
	else if (global.selectedSoldier.unit_id != Units.CARRIER)
		show_error("Switch to recon called when seaplane carrier isn't selected", true);
	update_stored_plane(Units.RECON);
}

function switch_to_fighter() {
	if (global.selectedSoldier == -1)
		show_error("Switch to fighter called when no global soldier selected.", true);
	else if (global.selectedSoldier.unit_id != Units.CARRIER)
		show_error("Switch to fighter called when seaplane carrier isn't selected", true);
	update_stored_plane(Units.FIGHTER);
}

function possible_fighter_attack(toTilePos) {
	for (var i = 0; i < array_length(global.grid[toTilePos].planeArr); i++) {
		var planeInst = global.grid[toTilePos].planeArr[i];
		
		if (planeInst != -1 && !is_my_team(planeInst))
			return true;
	}
	
	return false;
}

function deploy_plane() {
	if (global.selectedSoldier.unit_id != Units.CARRIER)
		show_error("Deploy plane called when seaplane carrier isn't selected", true);
	else if (global.selectedSoldier.storedPlaneInst == -1)
		return;
		
	with (global.selectedSoldier) {
		
		storedPlaneInst.bindedCarrier = id;
		storedPlaneInst.tilePos = tilePos;
		
		erase_blocks(true);
		
		global.selectedSoldier = storedPlaneInst;
		switch(storedPlaneInst.unit_id) {
			
			// in the case of recon, deployment not finalized until player
			// finishes choosing the plane path
			case Units.RECON:	
				soldier_init_move();
				break;
				
			case Units.BOMBER:
				soldier_init_attack();
				break;
			
			case Units.FIGHTER:
				soldier_init_attack(possible_fighter_attack);
				break;
				
			default:
				event_perform_object(obj_map_helper, ev_keypress, vk_space);
		}
	}
}

function finalize_deployment(planeInst) {
	
	with (planeInst.bindedCarrier) {
		switch(planeInst.unit_id) {
			case Units.RECON:
				var spr_index = asset_get_index("spr_recon" + (team == 1 ? "1" : ""));
				bindedPlane = create_soldier(spr_index, tilePos.pos, -1, false, Units.RECON);
				bindedPlane.planePath = planeInst.planePath;
				planeInst.planePath = -1;
				
				break;
			case Units.BOMBER:
				var spr_index = asset_get_index("spr_bomber" + (team == 1 ? "1" : ""));
				bindedPlane = create_soldier(spr_index, tilePos.pos, -1, false, Units.BOMBER);
				bindedPlane.unitLockedOn = planeInst.unitLockedOn;
			
				event_perform_object(obj_map_helper, ev_keypress, vk_space);
				break;
				
			case Units.FIGHTER:
				var spr_index = asset_get_index("spr_fighter" + (team == 1 ? "1" : ""));
				bindedPlane = create_soldier(spr_index, tilePos.pos, -1, false, Units.FIGHTER);
				bindedPlane.unitLockedOn = planeInst.unitLockedOn;
				
				event_perform_object(obj_map_helper, ev_keypress, vk_space);
				break;
				
			default:
				event_perform_object(obj_map_helper, ev_keypress, vk_space);
		}	
		
		can = 0;
		bindedPlane.planeFinished = false;
		bindedPlane.bindedCarrier = planeInst.bindedCarrier;
	}
}

