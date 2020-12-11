function array() {
	var arr=[];
	for (var i=0; i<argument_count; i+=1){
		arr[i] = argument[i];
	}
	return arr;
}


function remove_from_array(arr, val) {
	if (arr == -1) 
		return;
		
	for (var i = 0; i < array_length(arr); i++)
		if (arr[i] == val) 
			arr[@ i] = -1;
}

function add_into_array(arr, val) {
	if (arr == -1) 
		show_error("Parameter passed into add_an_array is not an array!", false);
	
	for (var i = 0; i < array_length(arr); i++) {
		if (arr[i] == -1) {
			arr[@ i] = val;
			return;
		}
	}
	
	arr[@ array_length(arr)] = val;
}
function append(arr, val){
	if (!is_array(val)) arr[array_length(arr)] = val;
	else {
		for (var i=0; i<array_length(val); i++)
			arr[array_length(arr)] = val[i]
	}
	return arr;
}	


function posInArray(argument0, argument1) {
	for (var i=0; i<array_length(argument0); i++)
		if (argument0[i] == argument1)
			return  i;
	return -1;
}
