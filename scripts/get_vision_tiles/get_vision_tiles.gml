/// @description Returns all the tiles that can be seen from the given tile & soldier
/// @param tile_id Tile with soldier to calculate vision from
function get_vision_tiles(unitInst) {

	// data to be stored in queue: (grid pos, leftover vision cost)
	// calculate using proportions, estimate proportions by dividing each
	// grid into nine, and then from each grid find the next grid it passes through
	// if a line is drawn from the center of that grid to the center of destination;
	// this will cause the "line drawn" to be jagged, so will be a rough estimate at most
	// maybe change the # of grids to resolve some problems as well

	var startx = unitInst.tilePos.pos % global.mapWidth;
	var starty = floor(unitInst.tilePos.pos / global.mapWidth);

	var res = [];	// array of results
	var cnt = 0;	// size of results
	
	var soldier_vision = unitInst.vision + 1.25*(unitInst.tilePos.elevation-1);
	
	
	var range = floor(soldier_vision);
	for (var nextx = startx-range; nextx <= startx+range; nextx++) {
		for (var nexty = starty-range; nexty <= starty+range; nexty++) {
			if (!point_in_rectangle(nextx,nexty,0,0,global.mapWidth-1,global.mapHeight-1))
				continue;
		
			var cost = 0;								// vision cost
			var gridx = nextx, gridy = nexty;			// grid coordaintes of current cell
			var entryx = nextx, entryy = nexty;			// point where we entered current cell
		
			var ydiff = starty-nexty, xdiff = startx-nextx;
			var signy = sign(ydiff), signx = sign(xdiff);
		
			var yintercept = nexty - nextx*ydiff/xdiff;
		
			while (entryx != startx || entryy != starty) {
				var gridid = gridy*global.mapWidth + gridx;
			
				var diagonalx = gridx + 0.5*signx;
				var diagonaly = gridy + 0.5*signy;
					
				var tempy = diagonalx*ydiff/xdiff + yintercept;
				var tempx = (diagonaly - yintercept)*xdiff/ydiff;
			
				if (xdiff == 0 || ydiff == 0) {
					tempx = diagonalx;
					tempy = diagonaly;
				}
			
				var exitx, exity;
				if (gridx == startx && gridy == starty) {
					exitx = startx;
					exity = starty;
				} else if (abs(tempy - gridy) <= 0.5) {
					exitx = diagonalx;
					exity = tempy;
				} else if (abs(tempx - gridx) <= 0.5) {
					exitx = tempx;
					exity = diagonaly;
				} else {
					show_error("none of the calculated exit coordinates for vision are valid!", true);
				}

				var add = 1;
				if (unitInst.tilePos.elevation < global.grid[gridid].elevation) {
					switch(global.grid[gridid].sprite_index) {
						case spr_tile_flat: 
						case spr_tile_road:
						case spr_tile_ocean:
							add = 1; break;
					
						case spr_tile_mountain: add = 2; break;
						case spr_tile_rough: add = 1.1; 
					}
				}
		
				var dist = sqrt((exitx-entryx)*(exitx-entryx)+(exity-entryy)*(exity-entryy));
				cost += dist*add;
			
			
			
				entryx = exitx;
				entryy = exity;
			
				// determine gridx, gridy for next grid
				gridx = round(entryx);
				gridy = round(entryy);
			
				// check whether entryx or entryy lie on the border
				// if so, determine grid coord by slope
				if (abs(gridx - entryx) - 0.5 == 0) { // signx should never be 0 
					gridx = round(entryx + 0.5*signx);
					if (signx == 0)
						show_error("signx not supposed to be zero!", true);
				}
				if (abs(gridy - entryy) - 0.5 == 0) { // signy should never be 0
					gridy = round(entryy + 0.5*signy);
					if (signy == 0)
						show_error("signy not supposed to be zero!", true);
				}
			}
		
		
			if (cost <= soldier_vision)// argument[0].soldier.vision)
				res[cnt++] = global.grid[nexty*global.mapWidth + nextx];
		}
	}

	return res;



}
