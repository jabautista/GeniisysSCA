//check if value is decimal. 
// the function returns true or false value
// irwin
function checkIfDecimal(value){
	var val = parseFloat(value);
	if((parseInt(val)-val)<1 && (parseInt(val)-val) !=0){
		return true;
    }else{
		return false;
	}
}