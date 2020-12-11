/// @description Insert description here
// You can write your code in this editor

if (global.selectedSoldier != -1 || global.selectedFormation != -1) {
	if (soldier != -1) {
		if (global.selectedSoldier != -1 && checkFormationCompatibleSoldier(global.selectedSoldier.tilePos, id)) {
			global.selectedFormation = addIntoFormationSoldier(global.selectedSoldier.tilePos, id);
			erase_blocks(true);
			global.selectedSoldier = -1;
		}	
		else if (global.selectedFormation != -1) {
			if (soldier.formation == global.selectedFormation) {
				removeFromFormation(global.selectedFormation, id);
				erase_blocks(true);
				global.selectedSoldier = -1;
			
			} else if (checkFormationCompatibleId(id, global.selectedFormation)) {
				addIntoFormationId(id, global.selectedFormation);
				erase_blocks(true);
				global.selectedSoldier = -1;
			}
		}
	}
}