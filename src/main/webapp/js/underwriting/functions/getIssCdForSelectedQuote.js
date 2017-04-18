//process = "show" when calling just to show isscd and subline options after linecd change
//process = "save" to fire save par after showing options -BRY
function getIssCdForSelectedQuote(process){
	try {
		$("vlineCd").value = $("linecd").value;
		var iss 	    = $("isscd");
		var quoteIssCd 	= $("selectedIssCd").value;
		hideAllIssourceOptions();
		moderateIssourceOptionsByLine();
		for (var y=0; y<iss.length; y++){
			if (iss[y].value == quoteIssCd){
				if (checkLineCdIssCdMatch($F("vlineCd"), iss[y].value)){
					$("isscd").selectedIndex = y;
				} else {
					setIssCdToDefault();
				}
			} else {
				setIssCdToDefault();
			}
		}
		if (process == "save"){
			showConfirmBox3("Create PAR from Quote ", "This option will automatically create a PAR record with all the information entered in the quotation. Do you want to continue?", "Yes", "Cancel", /*saveCreatedPAR*/turnQuoteToPAR, /*checkIfCancelPARCreation*/"");
		} else if (process == "show"){}
	} catch(e){
		showErrorMessage("getIssCdForSelectedQuote", e);
	}
}