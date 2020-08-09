/// @description Insert description here
// You can write your code in this editor

if (dropdown_active && point_in_rectangle(mouse_x,mouse_y,x,y+sprite_height,x+sprite_width,y+sprite_height+menu_height)) {
	var options_id = 0, cur_height = y+sprite_height;
	while (options_id < array_length_1d(options)) {
		cur_height += sprite_get_height(options[options_id]);
		
		if (cur_height >= mouse_y) break;
		options_id++;
	}
	
	// options_id was the one selected
	binded_button.sprite_index = options[options_id];
	
} 

dropdown_active = !dropdown_active;