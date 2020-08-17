/// @description Insert description here
// You can write your code in this editor



	
	
// each index of global.changeSprite[] has a different action
// on this tile


// index 0 is implemented in user event 1

		
// selected a soldier
if (global.changeSprite[1] != -1){
			
	// if there's a soldier here,  activate the next block of if statement
	if  (soldier != -1) {
		if (global.changeSprite[1] != spr_infantry_delete)
			global.changeSprite[1] = -1;  
		else {
			with(soldier) instance_destroy();
			soldier = -1;
			update_fog();
		}
	} 
	
	else if (global.changeSprite[1] != spr_infantry_delete)
		create_soldier(global.changeSprite[1], pos);
}

// selected a road 
else if (global.changeSprite[2] != -1) road = !road;

// selected a hut
else if (global.changeSprite[3] != -1){
	if (soldier != -1 && soldier.team==global.turn%2 && hut == -1){
		hut = instance_create_depth(x, y, -0.5, obj_hut);
		with (hut){
			soldier_sprite = other.soldier.sprite_index;
			pos = other.pos;
			limit = global.hutlimit[get_soldier_type(other.soldier)];
		}
		destroy_soldier(pos);
	}
}


// nothing selected...	
// this block handles other clicking events like moving and attacking
else if (global.changeSprite[0] == -1){		
		
	// clear the selected soldier things if this block is not a possible move or attack
	if (global.selectedSoldier != -1){
				
		var xx = x;
		var yy  = y;
				
		if (possible_move && id != global.selectedSoldier){						// if this tile is a possible move (not itself)
					
			with (global.selectedSoldier){	
				with(soldier){			  // move the soldier
					x = xx;
					y = yy;
					can_move = false;
					
					var diff = poss_paths[0] - poss_paths[1];
					switch (diff) {
						case 1: direction = 270; break;
						case -1: direction = 90; break;
						case global.mapWidth: direction = 180; break;
						default: direction = 0;
					}
				}
				
				other.soldier = soldier;											// change the  soldier acces
				soldier =  -1;
			}
			update_fog();
				
			global.selectedSoldier = id;											// change the global tile access
			soldier_erase_move();
					
					
			if (!soldier_init_attack()){
				global.selectedSoldier = -1;
				exit;
			}
					
					
		}
				
				
				
		else if (possible_attack && !hide_soldier){
					
			with(global.selectedSoldier.soldier){
				var damage_inflicted = (my_health/max_health) * max_damage;
				other.soldier.my_health -= damage_inflicted;
				can_attack = false;
			}
						
			if (soldier.my_health <= 0){
				instance_destroy(soldier);
				soldier = -1;
			}
					
			soldier_erase_attack();
			soldier_init_move();
		}
				
				
		else{
			soldier_erase_attack();
			soldier_erase_move();
					
			global.selectedSoldier = (id == global.selectedSoldier ? -2 : -1);
		}
				
				
	}
			
			
		
			
	if (global.selectedSoldier == -1){										// if not assigned selected soldier yet
		//debug("selecting  this  soldier", soldier.team, global.turn, global.turn%2)
		if (soldier != -1 && soldier.team == (global.turn)%2){					// if there is a soldier on this tile
					
			if (soldier.can_move){													// if the soldier can move
				global.selectedSoldier = id;											// draw on the moving tiles
				soldier_init_move();			
			}
					
					
			if (soldier.can_attack){												// if soldier can attack	
				global.selectedSoldier = id;											// daw on the  attack tiles
				soldier_init_attack();
			}
		}
	} 
			
	if (global.selectedSoldier == -2) global.selectedSoldier = -1;
			
			

	// if soldier is selected, but it can't  attack or move, deselect  it
	if (global.selectedSoldier != -1) with(global.selectedSoldier.soldier){
		if (!can_attack and !can_move)
			global.selectedSoldier = -1;
	}
			
			
} // end of if global.changeSprites[0] = [1] = -1
		
		