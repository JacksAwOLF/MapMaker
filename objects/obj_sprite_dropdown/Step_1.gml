// had to override clickable inherited event because
// we needed to expand click detection when the dropdown is active

// Inherit the parent event
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



// expand click detection when dropdown is active
var mouseIn = point_in_rectangle(mouse_x,mouse_y,x,y,
								x+sprite_width,y+sprite_height+(dropdown_active?menu_height*image_yscale:0));

if (mouseIn && (global.mouseInstanceId == -1 || global.mouseInstanceId.depth > depth)) {

	var eventId = -1;
	
	if (mouse_check_button_pressed(mb_left)) eventId = 0;
	else if (mouse_check_button(mb_left)) eventId = 1;
	else if (mouse_check_button_released(mb_left)) eventId = 2;
	
	if (eventId >= 0) {
		global.mouseEventId = eventId;
		global.mouseInstanceId = id;
	}
	
}
