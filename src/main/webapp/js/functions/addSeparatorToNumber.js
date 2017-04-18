/*	Created by	: mark jm 10.15.2010
 * 	Description	: add separator to a number
 * 	Parameters	: value - the number to be separated
 * 				: separator - no need for an explanation
 */
function addSeparatorToNumber(value, separator){
	if(value.indexOf(".") < 0){
		value = value + ".00";
	}
	
	var arrNumber 		= value.split(".");
	var arrPrecision 	= arrNumber[0];
	var arrScale		= "." + arrNumber[1];
	var regEx			= /(\d+)(\d{3})/;
	
	while(regEx.test(arrPrecision)){
		arrPrecision = arrPrecision.replace(regEx, '$1' + separator + '$2');
	}
	
	return arrPrecision + arrScale;
}