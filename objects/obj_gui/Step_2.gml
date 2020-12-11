/// @description Insert description here
// You can write your code in this editor

switch(state) {
	case VisualState.active:
	{
		var camera = view_get_camera(0);

		x = camera_get_view_width(camera) * relx + camera_get_view_x(camera);
		y = camera_get_view_height(camera) * rely + camera_get_view_y(camera);


		image_xscale = camera_get_view_width(camera) / origw;
		image_yscale = camera_get_view_height(camera) / origh;
		
		break;
	}
	
	case VisualState.inactive:
	{
		
	}
}