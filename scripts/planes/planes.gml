// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function advance_planes() {
	for (var i = 0; i < ds_list_size(global.allPlanes[global.turn % 2]); i++) {
		
		var planeInst = global.allPlanes[global.turn % 2][|i];
		
		if (planeInst.planeFinished) {
			if (plane_navigate_to(planeInst, planeInst.bindedCarrier.tilePos)) 
				destroy_soldier(planeInst);
			
		} else with (planeInst) {
			switch (unit_id) {
				case Units.BOMBER:
				case Units.FIGHTER:
					if (unitLockedOn.tilePos.hide_soldier) {
						planeFinished = true;
					} else if (plane_navigate_to(id, unitLockedOn.tilePos)) {
						soldier_execute_attack(id, unitLockedOn);
						planeFinished = true;
					}
					
					break;
					
				case Units.RECON:
					var index = 0;
					while (index < array_length(planePath) && planePath[index] == -1)
						index++;
						
					if (index < array_length(planePath)) {
						plane_execute_move(id, planePath[index].pos);
						planePath[index] = -1;
					}
					
					planeFinished = (index == array_length(planePath));
					break;
			}
		}
		
		
	}
}


// returns whether the plane has arrived at dest after moving
function plane_navigate_to(planeInst, toTileInst) {
	var plane_x = planeInst.tilePos.pos % global.mapWidth;
	var plane_y = floor(planeInst.tilePos.pos / global.mapHeight);
	
	var dest_x = toTileInst.pos % global.mapWidth;
	var dest_y = floor(toTileInst.pos / global.mapHeight);
	
	// assuming all tile movement is cost one
	var energy = global.movement[planeInst.unit_id];
	var new_x = plane_x + (plane_x < dest_x ? 1 : -1) * min(abs(dest_x - plane_x), energy);
	
	energy = max(0, energy - abs(dest_x - plane_x));
	var new_y = plane_y + (plane_y < dest_y ? 1 : -1) * min(abs(dest_y - plane_y), energy);
	
	plane_execute_move(planeInst, new_y * global.mapHeight + new_x);
	return (new_x == dest_x && new_y == dest_y);
}