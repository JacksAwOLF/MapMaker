enum VisualState
{
	active,
	deactivating,
	inactive,
	activating
}


function init_map(medium, dataSrc) {
	
	
	global.edit = global.action == "new" || global.action == "load";
	
	
	// needed to decide on variables for the change_vars
	// since we have to possible choices of soldier types at any moment
	
	global.objectiveOptions = [all_huts_destroyed, all_towers_destroyed, all_soldiers_destroyed];
	global.winFunction = 0;
	
	global.turn = 0;
	
	global.conqueredTowers = array(array(), array());
	
	
	global.poss_moves = -1;
	global.poss_paths = -1;
	global.poss_attacks = -1;
	
	
	init_game_vars();
	global.colors[0] = c_aqua;
	global.colors[1] = c_orange;
	global.colors[2] = c_purple;
	
	
	global.formation = []
	

	// load the saveVersion
	global.saveVersion = 8;
	if (dataSrc != undefined) {
		if (medium == Mediums.file) dataSrc = file_text_open_read(dataSrc);
		variable_global_set("saveVersion", real(get_data(medium, dataSrc))); // ignore warning
	}
	
	
	// load global variables
	global.global_save_order = ["saveVersion", "mapWidth", "mapHeight", "turn", "winFunction"];
	load_global_vars(medium, dataSrc);
	
	
	

	var tb_padd = 128;  // top bottom padding betweeen the buttons and the obj_tile
	var lr_padd = 64;
	var hor_spacing = 90;   // x distance between each button on the top row
	var y_axis = 30;    // of the top row on the top
	var tile_size = 64;
	//min((room_height-tb_padd*2)/global.mapHeight, (room_width-lr_padd*2)/global.mapWidth);
	var xx, yy, sp_index;
	
	
	
	
	if (global.edit){
		
		global.hutOn = true;
		global.fogOn = true;
		global.soundOn = true;

		// create the tile selections on the top left
		global.changeSprite = -1;
		var possibleTiles = array(
			array(spr_tile_flat, spr_tile_mountain, spr_tile_rough, spr_tile_border, spr_tile_ocean),
			array(spr_tile_road, spr_soldier_generate, spr_tower),
			array(spr_infantry, spr_tanks, spr_ifvs), 
			array(spr_infantry1, spr_tanks1, spr_ifvs1), 
			array(spr_infantry_delete)
		);
		
		var tileInfo = [
			"tiles",
			"addon",
			"units",
			"units",
			"delete"
		];

		global.soldierSelectTile = [-1, -1];
		for (var index = 0; index<array_length(possibleTiles); index++){
			with(instance_create_depth(hor_spacing*(index)+hor_spacing/2, y_axis, -1, obj_selectTile)){
				sprite_index = possibleTiles[index][0];
				description = tileInfo[index];
				
				var xx = x, yy = y + sprite_height
				with(instance_create_depth(xx, yy, -1, obj_sprite_dropdown)) {
					x  = other.x;
					y =  other.y + other.sprite_height;
					
					binded_button = other.id;
					other.binded_dropdown = id;
					options = possibleTiles[index];
				}
				
				// save the select tiles for soldiers in respective team indices
				if (tileInfo[index] == "units") {
					global.soldierSelectTile[0] = global.soldierSelectTile[1];
					global.soldierSelectTile[1] = id;
				}
			}
		}
		
		var xx = hor_spacing*array_length(possibleTiles) + hor_spacing/2;
		instance_create_depth(xx, y_axis/2, -1, obj_edit_status);
		

		// create the soldier modification vars on top right
		var names; 

		enum Svars {
			attack_range, max_health, max_damage, vision, unit_page, win, move_range
		};
		
		global.soldier_vars[Svars.unit_page] = 0; names[Svars.unit_page] = "Select";
		
		// [0,1] stands for scout, infantry, which is default in edit mode
		global.soldier_vars[Svars.attack_range] = global.attack_range[Units.TANK_M]; names[Svars.attack_range] = "attack range";   
		global.soldier_vars[Svars.max_health] = global.max_health[Units.TANK_M]; names[Svars.max_health] = "max health";   // probably  dependent on class too
		global.soldier_vars[Svars.max_damage] = global.max_damage[Units.TANK_M]; names[Svars.max_damage] = "max damage";   // probably  dependent on class too
		
		global.soldier_vars[Svars.vision] = global.vision[0]; names[Svars.vision] = "vision";   // can delete... vision  is dependent on class
		global.soldier_vars[Svars.win] = global.winFunction; names[Svars.win] = "Win";
		// global.soldier_vars[0] = 2; names[0] = "move range";   // can delete... dedpendent on unit type

		hor_spacing = 60;
		for (var index=array_length(names)-1; index>=0; index--){
			with(instance_create_depth(
			room_width-(array_length(names)-index)*hor_spacing, 
			16, -1, obj_change_var)){
				ind = index;
				text = names[index];
			}
		}
		
		
	


		// bottom/top bar 
		sp_index = object_get_sprite(obj_gui_bottom_bar);
		xx = 0;
		yy = room_height - sprite_get_height(sp_index);

		instance_create_depth(xx, yy, -10, obj_gui_bottom_bar);
		instance_create_depth(0, 0, -1, obj_gui_bottom_bar);

	
		
	}


	// back button bottom left
	sp_index = object_get_sprite(obj_button_backMenu);
	xx = 0;
	yy = room_height - sprite_get_height(sp_index);
	instance_create_depth(0, yy, -100, obj_button_backMenu);
	
	
	// bottom, middle next step button
	sp_index = object_get_sprite(obj_button_nextStep);
	xx = (room_width - sprite_get_width(sp_index)) / 2;
	yy = room_height - sprite_get_height(sp_index);
	instance_create_depth(xx, yy, -100, obj_button_nextStep);
	
	// create soldier focus button
	sp_index = object_get_sprite(obj_button_focus);
	xx = (room_width - sprite_get_width(sp_index)) / 2;
	yy = yy - sprite_get_height(sp_index) - 20;
	instance_create_depth(xx, yy, -100, obj_button_focus);
	
	// create the saving button on bottom right
	sp_index = object_get_sprite(obj_button_saveMap);
	xx = room_width - sprite_get_width(sp_index);
	yy = room_height - sprite_get_height(sp_index)
	instance_create_depth(xx, yy, -100, obj_button_saveMap);
	
	// create soldier info screen
	sp_index = object_get_sprite(obj_gui_info_screen);
	xx = room_width - sprite_get_width(sp_index) - 30;
	yy = (1/6*room_height);// - sprite_get_height(sp_index))/2;
	instance_create_depth(xx, yy, -100, obj_gui_info_screen);
	
	// create unit options screen
	sp_index = object_get_sprite(obj_unit_options);
	xx = 10;
	yy = (room_height - sprite_get_height(sp_index)) / 2;
	global.unitOptionsBar = instance_create_depth(xx, yy, -100, obj_unit_options);
	global.unitOptionsBar.toggle_active();
	
	
	

	// create the actual tiles
	// global.grid[pos]: the 2darray that represents the map grid on the battlefield
	// pos: y * global.mapWidth + x
	global.selectedSoldier = -1;
	global.selectedSpawn = -1;
	global.selectedFormation = -1;
	global.displayTileInfo = -1;
	
	global.selectedPathpointsStack = ds_stack_create();
	global.pathCost = 0;
	
	global.prevHoveredTile = -1;

	for (var j=0; j<global.mapHeight; j+=1){
		for (var i=0; i<global.mapWidth; i+=1){
		
			var p = j * global.mapWidth + i;
			global.grid[p] = instance_create_depth(lr_padd+i*(tile_size), 
				tb_padd+j*(tile_size), 0, obj_tile);
			
			with(global.grid[p]){
				sprite_index = spr_tile_flat;
				image_xscale = tile_size / sprite_get_width(sprite_index);
				image_yscale = tile_size / sprite_get_height(sprite_index);
			
				size = tile_size;						// the size of the sprite to draw
				pos = p;								// position in global.grid
			}
		
		}
	}
	
	with (obj_camera) {
		window_max_h = max(window_max_h, global.mapHeight*tile_size + 400);
		window_max_w = max(window_max_w, global.mapWidth*tile_size + 100);
	}

	
	
	
	// if the file input is specified
	// open the file and update the tile_sprites and add soldiers if neccessary
	
	// btw the first variable of an object to  save
	// can't have a negative 1  value
	
	global.tiles_save_objects = array(-1, -1, obj_infantry, obj_hut, obj_tower);
	
	
	if (global.saveVersion == 4){
		global.tiles_save_order = array(
			"sprite_index", 
			"road", 
			array("soldier", "attack_range",  "max_health", "max_damage", "my_health", "sprite_index", "can", "class", "direction", "vision", "team"), 
			array("hut", "max_health", "steps", "limit", "soldier_sprite", "def_attack_range", "def_max_health",  "def_max_damage", "def_class", "def_vision", "team", "my_health"),
			array("tower", "my_health", "team", "max_health")
		);
	} else if (global.saveVersion == 5){
		global.tiles_save_order = array(
			"sprite_index", 
			"road", 
			array("soldier", "attack_range",  "max_health", "max_damage", "my_health", "sprite_index", "can", "class", "direction", "vision", "team"), 
			array("hut", "max_health", "steps", "limit", "soldier_sprite", "def_attack_range", "def_max_health",  "def_max_damage", "def_class", "def_vision", "team", "my_health", "sprite_dir"),
			array("tower", "my_health", "team", "max_health")
		);
	} else if (global.saveVersion == 6){
		global.tiles_save_order = array(
			"sprite_index", 
			"road", 
			array("soldier", "my_health", "sprite_index", "can", "class", "direction", "team"), 
			array("hut", "max_health", "my_health", "steps", "limit", "soldier_sprite", "soldier_class", "team", "sprite_dir"),
			array("tower", "my_health", "team", "max_health")
		);
	} else if (global.saveVersion == 7){
		global.tiles_save_order = array(
			"sprite_index", 
			"road", 
			array("soldier", "my_health", "sprite_index", "can", "class", "direction", "team", "move_range"), 
			array("hut", "max_health", "my_health", "steps", "limit", "soldier_sprite", "soldier_class", "team", "sprite_dir"),
			array("tower", "my_health", "team", "max_health")
		);
	} else if (global.saveVersion >= 8){
		global.tiles_save_order = array(
			"sprite_index", 
			"road", 
			"originHutPos",
			array("soldier", "my_health", "sprite_index", "can", "class", "direction", "team", "move_range"), 
			array("hut", "max_health", "my_health", "steps", "limit", "soldier_sprite", "soldier_class", "team", "sprite_dir", "spawnPos"),
			array("tower", "my_health", "team", "max_health")
		);
		
		global.tiles_save_objects = array(-1, -1, -1, obj_infantry, obj_hut, obj_tower);
	}
	
	
	
	
	// load soldiers and things on tiles
	load_tiles(medium, dataSrc);
	
	
	// load the teleport areas
	for (var i = 0; i < array_length(global.grid); i++){
		with(global.grid[i])
			if (tower != -1 && tower.my_health <= 0)
				append(global.conqueredTowers[tower.team], id);
	}
		
	
	// identifiers for click detection
	global.mouseEventId = -1;
	global.mouseInstanceId = -1;
	

	// set the elevation
	for (var i = 0; i < array_length(global.grid); i++)
		global.grid[i].elevation = global.elevation[get_tile_type(global.grid[i])];


	// change the fog to your view if neede	
	if (!global.edit && !network_my_turn()){
		global.turn += 1;
		update_fog();
		global.turn -= 1;
	} else update_fog();
	
	
	update_won()


	
	global.followSoldier = 0; // index of movable soldier to follow 
	global.shouldFocusTurn = -1; // checks (shouldFocusTurn == this turn) to follow a soldier
	
	
	global.allPlanes = [ds_list_create(), ds_list_create()]; // all planes of both sides
	global.allSoldiers = [ds_list_create(), ds_list_create()]; // all soldiers of both sides
	
	with (obj_infantry)
		if (is_active && !is_plane(id))
			ds_list_add(global.allSoldiers[team], id);
		
	for (var i = 0; i < array_length(global.grid); i++) 
		if (global.grid[i].soldier != -1)
			global.grid[i].soldier.tilePos = global.grid[i];
	
		
	global.map_loaded = true;
	
	
	
	
}
