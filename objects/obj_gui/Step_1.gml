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

// Inherit the parent event
event_inherited();


