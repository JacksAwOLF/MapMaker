/// @description Initialize Variables

// load default variables
event_inherited()


viewW = camera_get_view_width(view_camera[0]);
viewH = camera_get_view_height(view_camera[0]);


// the background rectangle behind the text
	// position
backX = 0;
backY = viewH * 0.75;
	// size
backW = viewW - 2 * backX;
backH = viewH - backY;


// the text on top of the background
	// position
textX = backX + 0.05 * backW;
textY = backY + 0.1 * backH;
	// size
textW = backW * 0.9;

debug(textStyle);

draw_set_font(textStyle.textFont);
textH = string_height("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
	


// the options that will sometimes show up
	// option text position relative from the option rectangle
optionTextBufferX = 8;
optionTextBufferY = 6;
	// option rectangle size
draw_set_font(frameStyle.optionFont);
optionH = string_height("ABCDEFGHIJKLMNOPQRSTUVWXYZ") + 2*optionTextBufferY;
optionW = -1;	// width is determined by length of option value, preprocess
	// position
optionX = textX;
optionY = backY + backH - optionH -backH * 0.08;

