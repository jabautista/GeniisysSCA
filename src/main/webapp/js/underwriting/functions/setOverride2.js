/**
 * Another version of setOverride, using the selected row from lov 
 * @author andrew
 * @date 05.06.2011
 * @param row - selected row from lov
 */
function setOverride2(row){
	if ("TRUE" == $F("userValidated")){
		//$("override").value = "TRUE";
		//turnQuoteToPAR();
		getIssCdForSelectedQuote2("save", row);
	} else {
		showMessageBox("User has no override authority.", "info");
	}
}