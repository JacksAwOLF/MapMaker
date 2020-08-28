enum VisualState
{
	active,
	deactivating,
	inactive,
	activating
}


function init_map(medium, dataSrc) {
	
	global.edit = global.action == "new" || global.action == "load";
	
	global.turn = 0;
	global.movement = [6,2,15];

	enum Soldiers {
		tanks, infantry, ifvs
	};

	enum Classes {
		scout, melee, range
	};
	
	enum Tiles {
		open, rough, mountain	
	};
	
	global.elevation[Tiles.open] = 1;
	global.elevation[Tiles.rough] = 1.1;
	global.elevation[Tiles.mountain] = 2;

	global.energy[Soldiers.tanks] = [2,3,3,99];
	global.energy[Soldiers.infantry] = [1,1,2,2];
	global.energy[Soldiers.ifvs] = [3,5,99,99];

	global.vision[Classes.scout] = 5;
	global.vision[Classes.melee] = 3;
	global.vision[Classes.range] = 1;


	global.hutlimit[Soldiers.tanks] = 3;
	global.hutlimit[Soldiers.infantry] = 2;
	global.hutlimit[Soldiers.ifvs] = 5;


	global.ranges[Classes.scout] = 2;
	global.ranges[Classes.melee] = 1;
	global.ranges[Classes.range] = 3;

	map_loaded = true;
	global.fog_on = true;
	
	// global.q = -1; // used in get_vision_tiles1



	// mapHieght and mapWidth should be already set before calling this function
	// if no file is specified
	global.saveVersion = 2;
	if (medium == Mediums.file && dataSrc != undefined) dataSrc = file_text_open_read(dataSrc);
	load_global_vars(medium, dataSrc);
	

	var tb_padd = 128;  // top bottom padding betweeen the buttons and the obj_tile
	var lr_padd = 64;
	var hor_spacing = 90;   // x distance between each button on the top row
	var y_axis = 30;    // of the top row on the top
	var tile_size = min((room_height-tb_padd*2)/global.mapHeight, 
		(room_width-lr_padd*2)/global.mapWidth);

	var xx, yy, sp_index;
	
	if (global.edit){


		// create the tile selections on the top left
		global.changeSprite = -1;
		var possibleTiles = array(
			array(spr_tile_flat, spr_tile_mountain, spr_tile_ocean, spr_tile_border),
			array(spr_tile_road, spr_soldier_generate, spr_tower),
			array(spr_infantry, spr_tanks, spr_ifvs), 
			array(spr_infantry1, spr_tanks1, spr_ifvs1), 
			spr_infantry_delete);

	
		var index = 0;
		for (; index<4; index++){
			with(instance_create_depth(hor_spacing*(index)+hor_spacing/2, y_axis, -1, obj_selectTile)){
				sprite_index = possibleTiles[index][0];
				var  xx = x, yy = y + sprite_height
			
				with(instance_create_depth(xx, yy, -1, obj_sprite_dropdown)) {
					x  = other.x;
					y =  other.y + other.sprite_height;
					binded_button = other.id;
					options = possibleTiles[index];
				}
			}
		}
	
		for (;index<array_length(possibleTiles); index++){
			with(instance_create_depth(hor_spacing*(index)+hor_spacing/2, y_axis, -1, obj_selectTile)){
				sprite_index=possibleTiles[index];
			}
		}
	



		// create the soldier modification vars on top right
		var names; 

		enum Svars {
			attack_range, max_health, max_damage, class, vision, move_range
		};
		global.soldier_vars[Svars.attack_range] = 1; names[Svars.attack_range] = "attack range";   
		global.soldier_vars[Svars.max_health] = 15; names[Svars.max_health] = "max health";   // probably  dependent on class too
		global.soldier_vars[Svars.max_damage] = 8; names[Svars.max_damage] = "max damage";   // probably  dependent on class too
		global.soldier_vars[Svars.class] = 0; names[Svars.class] = "Class";
		global.soldier_vars[Svars.vision] = global.vision[0]; names[Svars.vision] = "vision";   // can delete... vision  is dependent on class
		// global.soldier_vars[0] = 2; names[0] = "move range";   // can delete... dedpendent on unit type

		hor_spacing = 60;
		for (var index=array_length_1d(names)-1; index>=0; index--){
			with(instance_create_depth(
			room_width-(array_length_1d(names)-index)*hor_spacing, 
			16, -1, obj_change_var)){
				ind = index;
				text = names[index];
			}
		}





		// create the back, next, save buttons on bottom row
	

		// create the saving button on bottom right
		sp_index = object_get_sprite(obj_button_saveMap);
		xx = room_width - sprite_get_width(sp_index);
		yy = room_height - sprite_get_height(sp_index);

		instance_create_depth(xx, yy, -100, obj_button_saveMap);

	


		// bottom bar on the bottom
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
	
	// create the saving button on bottom right
	sp_index = object_get_sprite(obj_button_saveMap);
	xx = room_width - sprite_get_width(sp_index);
	yy = room_height - sprite_get_height(sp_index);

	instance_create_depth(xx, yy, -100, obj_button_saveMap);
	


	// create the actual tiles
	// global.grid[pos]: the 2darray that represents the map grid on the battlefield
	// pos: y * global.mapWidth + x
	global.selectedSoldier = -1;
	global.selectedPathpointsStack = ds_stack_create();
	global.pathCost = 0;
	
	global.prevHoveredTiles = [-1, -1];

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

	
	
	
	// if the file input is specified
	// open the file and update the tile_sprites and add soldiers if neccessary
	
	if (global.saveVersion == 1)
		global.tiles_save_order = array(
			"sprite_index", 
			"road", 
			array("soldier", "attack_range",  "max_health", "max_damage", "my_health", "sprite_index", "can", "class", "direction", "vision", "team"), 
			array("hut", "steps", "limit", "pos", "soldier_sprite"),
			array("tower", "my_health", "team", "max_health")
		);
	else if (global.saveVersion ==  2)
		global.tiles_save_order = array(
			"sprite_index", 
			"road", 
			array("soldier", "attack_range",  "max_health", "max_damage", "my_health", "sprite_index", "can", "class", "direction", "vision", "team"), 
			array("hut", "steps", "limit", "pos", "soldier_sprite", "def_attack_range", "def_max_health",  "def_max_damage", "def_class", "def_vision"),
			array("tower", "my_health", "team", "max_health")
		);
		
	global.tiles_save_objects = array(-1, -1, obj_infantry, obj_hut, obj_tower);
	
	
	// load soldiers and things on tiles
	load_tiles(medium, dataSrc);
	
	

	// identifiers for click detection
	global.mouseEventId = -1;
	global.mouseInstanceId = -1;
	
	for (var i = 0; i < array_length_1d(global.grid); i++)
		global.grid[i].elevation = global.elevation[get_tile_type(global.grid[i])];



	// change the fog to your view if needed
	// only for network things
	if (!global.edit && !network_my_turn()){
		global.turn += 1;
		update_fog();
		global.turn -= 1;
	} else update_fog();
}