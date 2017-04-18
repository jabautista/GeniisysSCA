function checkIfDecimal2(value){
	var test = value.split(".");
	var result = false;
	if(test.length > 1){
		result = true;
    }else{
    	result = false;
	}
	return result;
}