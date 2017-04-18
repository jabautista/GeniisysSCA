function setOverride(){
	if ("TRUE" == $F("userValidated")){
		//$("override").value = "TRUE";
		//turnQuoteToPAR();
		getIssCdForSelectedQuote("save");
	} else {
		showMessageBox("User has no override authority.", "info");
	}
}