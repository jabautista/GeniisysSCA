/**
 * 
 * @return true - when quotation passes the validation
 */
function preSaveValidations(){
	if(objGIPIQuote.lineCd == "MH"){	// marine hull
		var dd = dateFormat($F("drydockDate1"), "mmmm d, yyyy");
		var tempDate1 = Date.parse(dateFormat($F("drydockDate1"), "mmmm d, yyyy"));
		return false;
	}
	return true;
}