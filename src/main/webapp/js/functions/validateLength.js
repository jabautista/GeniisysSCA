/*
 * @author irwin
 * @description checks the decimal lenght and the value lenght
 * */
function validateLength(value,length){
	
	var isValid = true;
	var decimalLength = getDecimalLength(value);
	if (decimalLength > 2) {
		isValid = false;
		return isValid;
	}
	var valueLength = parseFloat(nvl(value.replace(/,/g, "").length,"0")) - (decimalLength + 1);
	if(valueLength > length){
		isValid = false;
	}
	
	return isValid;
}