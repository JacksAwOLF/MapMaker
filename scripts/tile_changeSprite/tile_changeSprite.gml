// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function tile_changeSprite(){
	if (edit) {

		switch (global.changeSprite){

			case spr_infantry_delete:
				if (soldier != -1) destroy_soldier(soldier);
				else if (tower != -1){
					with(tower) instance_destroy();
					tower = -1;
				} else if (originHutPos != -1){
					with (global.grid[originHutPos]){
						with(hut) instance_destroy();
						hut = -1;
					}
					originHutPos = -1;
				}


				break;

			case spr_infantry:
			case spr_tanks:
			case spr_ifvs:
			case spr_infantry1:
			case spr_tanks1:
			case spr_ifvs1:
			case spr_motorboat:
			case spr_motorboat1:
			case spr_destroy:
			case spr_destroy1:
			case spr_seaplane:
			case spr_seaplane1:
				if (soldier == -1) {
					create_soldier(global.changeSprite,
						pos, -1, true);
				} else global.changeSprite = -1;
				break;

			case spr_tile_road:
				road = !road;
				break;


			case spr_soldier_generate:
				if (hut!=-1 || tower!=-1) break;

				if (soldier != -1) {

					if (global.hutlimit[soldier.unit_id] == -1){
						global.changeSprite = -1;
						break;
					}

					hut = instance_create_depth(x, y, 0, obj_hut);
					hut.nuetral = false;
					with (hut){
						soldier = other.soldier;
						sprite_dir = other.soldier.direction;
						event_user(10);
					}
					destroy_soldier(soldier);

				}

				else if (soldier == -1){

					hut = instance_create_depth(x, y, 0, obj_hut);
					with(hut){
						steps = -1;
						team  = -1;
					}
					hut.nuetral = true;
				}

				if (hut != -1){
					hut.spawnPos = pos;
					originHutPos = pos;
				}
				break;


			case spr_tower:
				tower = instance_create_depth(x, y, 1, obj_tower);
				tower.team = global.turn%2;
				break;
		}
	}

	else{    // if edit is  false
		if (client_connected(true, false) == 0) exit;
	}
}
