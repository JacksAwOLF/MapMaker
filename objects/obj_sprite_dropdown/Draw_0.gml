/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if (dropdown_active) {

	draw_set_color($FF99CC);
	draw_roundrect(x, y+sprite_height, x+sprite_width, y+sprite_height+menu_height, 0);
	
	menu_height = 0;
	for (var i = 0; i < array_length_1d(options); i++) {
		draw_sprite(options[i], 0, x, y+sprite_height+menu_height);
		menu_height += sprite_get_height(options[i]);
	}
	
	draw_set_color(c_black);
}