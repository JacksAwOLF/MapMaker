

// return if tileId is a possible move for selected soldier or not
// can't see through fog
function possible_move_tiles(tileId) {
	var s = global.grid[tileId];

	// cant go here if there is a visible soldier blocking path
	if (s.soldier != -1 && !s.hide_soldier) return false;

	// cant go if enemy tower is here
	if (s.tower != -1 && !is_my_team(s.tower)) return false;

	// cant go if enemy hut is here (or nuetral one)
	if (s.hut != -1 && s.hut.team != -1 && !is_my_team(s.hut)) return false;

	return true;
}

function possible_move_tiles_including_selected(tileId) {
	var s = global.grid[tileId];

	// cant go here if there is a visible soldier blocking path
	if (s.soldier != -1 && s != global.selectedSoldier.tilePos && !s.hide_soldier &&
		(s.soldier.formation == -1 || s.soldier.formation != global.selectedSoldier.formation ) )
		return false;

	// cant go if enemy tower is here
	if (s.tower != -1 && !is_my_team(s.tower)) return false;

	// cant go if enemy hut is here (or nuetral one)
	if (s.hut != -1 && (s.hut.team == -1 || !is_my_team(s.hut) ) ) return false;

	return true;
}

function soldier_init_move() {
	if (global.selectedSoldier == -1) return;
	
	with (global.selectedSoldier){
		var source = (argument_count > 0 ? argument[0] : tilePos);
		move_range -= global.pathCost;
		global.poss_moves = get_movement_tiles_at(id, source);
		move_range += global.pathCost;
	
		// path point selection: handles corner case when new path can reach starting soldier pos
		if (source != tilePos && global.dist[tilePos.pos] != -1)
			global.poss_moves[array_length(global.poss_moves)] = tilePos;

		for (var i=0; i<array_length(global.poss_moves); i++)
			global.poss_moves[i].possible_move = true;
		
		// this is the carrier popup thing i shall boldly assume
		global.unitOptionsBar.unit_options = global.unitOptions[unit_id];
	}
}


function soldier_init_move_formation(pos){

	var arr = global.formation[soldier.formation].tiles,
		mapSize = global.mapWidth * global.mapHeight,
		delta = array_create(mapSize, 0);
	var n = 0;

	// find the delta's
	for (var i=0; i<array_length(arr); i++){
		if (arr[i] == -1)
			continue;

		global.selectedSoldier = arr[i].soldier;
		if (arr[i] == -1) continue;
		soldier_init_move();

		var pmove = global.poss_moves;
		for (var j=0; j<array_length(pmove); j++){
			 delta[getPos(
				getRowDiff(arr[i].pos, pmove[j].pos),
				getColDiff(arr[i].pos, pmove[j].pos) )] += 1;
		}

		n++;
		erase_blocks(true);
	}

	// light up the tiles that are possible moves
	for (var i=0; i<mapSize; i++)
		if (delta[i] == n)
			global.grid[ updatePos(pos, getRow(i), getCol(i)) ].possible_move = true;

	global.selectedSoldier = global.grid[pos].soldier;


}
