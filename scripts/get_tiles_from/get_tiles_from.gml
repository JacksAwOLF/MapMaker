// return array of obj_tile_parent that are (arg1) away from (arg0) 
// arg2:
// -1 => excluding tiles that have a soldier in it
// 0 => all tiles in bounds
// 1 => only tiles that have a soldier

// arg3:
// true: take into account of mountians/tivers
// false: nah


// data that  goes on the stack stores 3 variables in 1 integer
// data%(argument2+1) = #steps left
// data/(argument2+1) = ypos*global.mapWidth + xpos

// however we only return an array of integers that only
// represent the position


var possible_terrain = array(spr_tile_flat, spr_tile_mountain, spr_tile_ocean);
var energy; // 2d array [i,j]   energy required travelling from i to j
energy[0,0] = 1; energy[1,1] = 1; energy[2,2] = 1;
energy[0,1] = 2; energy[1,0] = 2; 
energy[0,2] = 2; energy[2,0] = 2;
energy[1,2] = 3; energy[2,1] = 3;


var start = argument0;
var z = argument1;

var res; var count = 0;
res[count++] = global.grid[start];
if (z == 0) return res;

var vis = array_create(global.mapWidth * global.mapHeight);	// each entry is initialized to 0
vis[start] = 1;

// helps with  neighbor kids
var dx = array(0,0,-1,1);		 
var dy = array(-1,1,0,0);	

start = start*z
var s = ds_stack_create();			
ds_stack_push(s, start);

while(!ds_stack_empty(s)){

	// pop off and get data
	var cur = ds_stack_pop(s);
	var steps = z-cur%z;
	var pos = floor(cur/z);
	var row = floor(pos/global.mapWidth);
	var col =  pos % global.mapWidth;
	
	// add the neighbors
	for (var i=0; i<4; i++){
		
		// check if off map
		var nr = row + dx[i];
		var nc = col + dy[i];
		if (nr<0 || nc<0 || nr==global.mapHeight || nc==global.mapWidth) continue;
		
		// check if visited
		var np =  nr * global.mapWidth + nc;
		if (vis[np] == 1) continue;
		vis[np] = 1;
		
		
		
		// if htere's  a  soldier blocking  here, can't  go
		if (argument2 == -1 && global.grid[np].soldier != -1) continue;
		
		
		
		// add to queue only if it can possibly add more kids
		var dis = 1, from, to;
		if (argument3){
			from = posInArray(possible_terrain, global.grid[pos].sprite_index);
			to = posInArray(possible_terrain, global.grid[np].sprite_index);
			dis = energy[from, to];	
		}
		var ns =  z - steps + dis;
		if (ns < z) ds_stack_push(s, np*z+(ns));
		
		
		
		if (argument2 == 1 && global.grid[np].soldier == -1) continue;
		if (!argument3 || ns<z+1) res[count++] = global.grid[np];
	}
}

return res;