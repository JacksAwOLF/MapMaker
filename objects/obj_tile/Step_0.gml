/// @description set mouseIn and chage sprite on click

mouseIn = x < mouse_x && mouse_x < x+sprite_width
	&& y < mouse_y && mouse_y < y+sprite_height;


if mouseIn {

	// draw temp army sprite if there is a selected
	if (global.selectedSoldier != -1 && global.selectedSoldier.formation == -1) {

		// always maintain the last two tiles we hovered over
		if (global.prevHoveredTile != id) {
			global.prevHoveredTile = id
			soldier_update_path(0);
		}
	}
}

event_inherited();
preMouseIn = mouseIn;
