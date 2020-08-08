

// make this string and just write it to the file as one string lol
var data = string(global.mapWidth) + "\n" + string(global.mapHeight) + "\n";
data += string(global.turn)  + "\n";


// write all the tiles sprites and soldiers
for (var i=0; i<global.mapWidth * global.mapHeight; i+=1){
	with(global.grid[i]){
		data += string(sprite_index) + "\n";
		if (soldier != -1){
			data += string(soldier.move_range) + "\n";
			data += string(soldier.attack_range) + "\n";
			data += string(soldier.max_health) + "\n";
			data += string(soldier.max_damage) + "\n";
			data += string(soldier.my_health) + "\n";
			data += string(soldier.sprite_index) + "\n";
			data += string(soldier.can_move) + "\n";
			data += string(soldier.can_attack) + "\n";
			data += string(soldier.vision) + "\n";
		} else data += "-1\n";
	}
}


// open and wirte to the file
var file = file_text_open_write(argument0);
if file == -1 debug("file wont open", argument0);
else file_text_write_string(file, data);
file_text_close(file);