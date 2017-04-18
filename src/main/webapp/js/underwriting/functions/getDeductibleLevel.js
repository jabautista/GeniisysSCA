/*	Created by	: Bryan Joseph G. Abuluyan 12.09.2010
 * 	Description	: determines the deductible level of a deductible object
 * 	Parameters	: obj - the GIPI_WDEDUCTIBLE JSONObject
 */
function getDeductibleLevel(obj){
	var dedLevel = 0;
	if (nvl(obj.perilCd, "0") != "0"){
		dedLevel = 3;
	} else if (nvl(obj.itemNo, "0") != "0"){
		dedLevel = 2;
	} else {
		dedLevel = 1;
	}
	return dedLevel;
}