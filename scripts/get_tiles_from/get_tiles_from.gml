// @func  get all tiles up to 'distance' away from 'startTile' with dijkstra and weighted edges described in energyTo (not including 0 distance)

function get_tiles_from(start, maxDis, energyTo, shouldStoreDist, canMoveOnto) {
	if (shouldStoreDist == undefined)
		shouldStoreDist = false;
	if (canMoveOnto == undefined) 
		canMoveOnto = possible_move_tiles;
	
	energyTo[Tiles.others] = 100;
	
	
	if (shouldStoreDist) {
		global.distStored = start;
		global.dist = array_create(global.mapWidth * global.mapHeight, -1);
		global.from = array_create(global.mapWidth * global.mapHeight, -1);
		
		global.from[start] = start;
		global.dist[start] = 0;
	}
	
	
	var res = [], count = 0;
	var vis = array_create(global.mapWidth * global.mapHeight, 0);
	
	var dx = array(0,0,-1,1);		 
	var dy = array(-1,1,0,0);	

	var s = ds_priority_create();
	ds_priority_add(s, start, 0);

	while(!ds_priority_empty(s)){

		// get row and col and steps taken to get to this tile
		var cur = ds_priority_find_min(s);
		var steps = ds_priority_find_priority(s, cur);
		ds_priority_delete_min(s);
		
		
		if (vis[cur]) continue;
		
		vis[cur] = true;
		if (cur != start) 
			res[count++] = global.grid[cur];

		// add 4 neighbors
		var row = floor(cur/global.mapWidth);
		var col = cur % global.mapWidth;		
		
		for (var i=0; i<4; i++){
		
			// check if off map
			var nr = row + dx[i];
			var nc = col + dy[i];
			if (nr<0 || nc<0 || nr==global.mapHeight || nc==global.mapWidth) 
				continue;
			
			// add to pqueue, checking special condition
			var np = nr * global.mapWidth + nc;
			var ns = steps+energyTo[get_tile_type(global.grid[np])];
			
			if (ns <= maxDis && !vis[np] && canMoveOnto(np)) {
				if (shouldStoreDist && (ns < global.dist[np] || global.dist[np] == -1)) {
					global.dist[np] = ns;
					global.from[np] = cur;
				}
				
				ds_priority_add(s, np, ns);
			}
		}
	}

	ds_priority_destroy(s);
	return res;
}


// returns all tiles (including its own) within a certain
// distance of a tile. if with_soldiers is true, only tiles
// with soldiers will be returned
function get_tiles_from_euclidean(tile_pos, dist, canMoveOnto) {
	
	if (canMoveOnto == undefined)
		canMoveOnto = possible_attack_tiles;
	
	var row = floor(tile_pos / global.mapWidth);
	var col = tile_pos % global.mapWidth;
	
	var res = [], len = 0;
	for (var xx = col-ceil(dist); xx <= col+ceil(dist); xx++) {
		for (var yy = row-ceil(dist); yy <= row+ceil(dist); yy++) {
			if ((xx == col && yy == row) || !point_in_rectangle(xx,yy,0,0,global.mapWidth-1,global.mapHeight-1))
				continue;
			else if ((xx-col)*(xx-col)+(yy-row)*(yy-row) <= dist*dist) {
				var np = global.mapWidth*yy + xx;
				if (canMoveOnto == undefined || canMoveOnto(np)) 
					res[len++] = global.grid[np];
			}
		}
	}
	
	return res;
}
