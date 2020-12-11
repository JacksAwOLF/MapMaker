// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function get_movement_tiles_at(soldierInst, tileInst){
	var res = [], tilePos = tileInst.pos;
	
	with(soldierInst) if (can-moveCost>=0){
		res = get_tiles_from(
			tilePos, move_range, global.energy[unit_id], true,
			(is_plane(id) ? return_true : possible_move_tiles_including_selected)
		);
	}

	return res;
}

// assumption: update_fog() is called when we switch to the ai side
function can_be_attacked(tileInst) {
	
	var n = instance_number(obj_infantry),
		rr = getRow(tileInst.pos),
		cc = getCol(tileInst.pos);
		
	for (var i=0; i<n; i++){
		var obj = instance_find(obj_infantry, i),
			xx = getRow(obj.tilePos.pos),
			yy = getCol(obj.tilePos.pos);
		if (obj.tilePos.hide_soldier) continue;						// assumption line
		if ((rr-xx)*(rr-xx) + (cc-yy)*(cc-yy) >= obj.attack_range)
			return true;
	}
	return false;
}