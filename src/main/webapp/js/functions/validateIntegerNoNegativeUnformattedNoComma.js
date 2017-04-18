/*
 * Created by	: Jerome Orio
 * Date			: December 7, 2010
 * Description 	: Validate if value is Whole positive number,
 * Parameters	: value - value for validation
 */
function validateIntegerNoNegativeUnformattedNoComma(value){
	value = value.strip();
	if (value.indexOf(".") != -1){
		return false;
	}
	if (isNaN(parseInt(value * 1))) {
		return false;
	}	
	if (value.indexOf("-") != -1){
		return false;
	}
	return true;
}	