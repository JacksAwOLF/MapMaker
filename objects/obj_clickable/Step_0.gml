/// @description Insert description here
// You can write your code in this editor

if (global.mouseInstanceId == id) {

	if (global.mouseEventId == 0)  { // checking for double click
		if (enableDoubleClick && current_time - prevClickTime <= 300) {
			global.mouseEventId = 3;
			prevClickTime = -1;
		} else {
			prevClickTime = current_time;
		}
	}
	
	event_user(global.mouseEventId);
	
	global.mouseEventId = -1;
	global.mouseInstanceId = -1;
}