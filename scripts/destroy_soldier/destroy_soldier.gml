/// @description Destroys the soldier at pos
/// @param pos
function destroy_soldier(argument0) {

	with (global.grid[argument0]){
		if (soldier != -1){
			with(soldier) instance_destroy();
			soldier = -1;
			update_fog();
		}
	}


}