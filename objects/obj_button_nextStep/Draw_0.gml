/// @description Insert description here
// You can write your code in this editor


if (state == VisualState.inactive) exit;

draw_self();

var turn_string = "Turn: " + (global.turn % 2 == 0 ? "Grey" : "Black");
draw_text_transformed(x+sprite_width/4,y+sprite_height/10,turn_string, image_xscale, image_yscale, 0);