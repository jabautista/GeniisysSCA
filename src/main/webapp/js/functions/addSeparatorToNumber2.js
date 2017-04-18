/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	11.24.2011	mark jm			add only separator to number
 */
function addSeparatorToNumber2(value, separator){
	//if(value.indexOf(".") < 0){
	//	value = value + ".00";
	//}
	
	if(value == undefined || value == null || value == ""){
		return "";
	}
	
	value = value.replace(/,/g, "");
	
	var arrNumber 		= value.split(".");
	var arrPrecision 	= arrNumber[0];
	var arrScale		= arrNumber[1];
	var regEx			= /(\d+)(\d{3})/;
	
	while(regEx.test(arrPrecision)){
		arrPrecision = arrPrecision.replace(regEx, '$1' + separator + '$2');
	}
	
	return arrPrecision + "." + arrScale;
}