/// @description Insert description here
// You can write your code in this editor


if (keyboard_check_pressed(hide_key)) {
	switch(state) {
		case VisualState.active: 
		{
			state = VisualState.inactive;
			x = inactive_offset[0]
			y = inactive_offset[1]
			
			break;
		}
		
		case VisualState.inactive:
		{
			state = VisualState.active;
			x = origw
			y = origh
			
			break;
		}
	}
}




var mouseIn = point_in_rectangle(mouse_x,mouse_y,x,y,x+sprite_width,y+sprite_height);

if ((mouseIn || is_selected) && (global.mouseInstanceId == -1 || global.mouseInstanceId.depth > depth)) {
	
	var eventId = -1;
	
	if (mouse_check_button_pressed(mb_left)) eventId = 0;
	else if (mouse_check_button(mb_left) && is_selected) eventId = 1;
	else if (mouse_check_button_released(mb_left)) {
		eventId = 2;
		is_selected = false;
		is_moving = false;
	}
	
	if (eventId >= 0) {
		global.mouseEventId = eventId;
		global.mouseInstanceId = id;
	}
	
}
