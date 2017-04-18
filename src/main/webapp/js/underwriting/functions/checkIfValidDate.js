function checkIfValidDate(){
	try {
		var quoteId = $F("quoteId");
		if ((quoteId == null)||(quoteId == "0")){
			showMessageBox("Please select a quotation.", imgMessage.ERROR);
		} else {
			var today = new Date();
			var validDate = Date.parse($F("selectedValidDate"));
			//var validDate = new Date($F("selectedValidDate"));  this function returns an invalid date. changed to date.parse.  -irwin
			if (validDate < today){
				showConfirmBox("Validity Date Verification", "Validity Date has expired.  Would you like to continue?", "OK", "Cancel", setOverride, "");
			} else {
				//$("override").value = "TRUE";
				//turnQuoteToPAR();
				getIssCdForSelectedQuote("save");
			}
		} 
	} catch(e){
		showErrorMessage("checkIfValidDate", e);
	}
}