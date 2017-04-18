//moved from additionalEngineeringInfo.jsp
function prepareENPrincipals() {
	try {
		var subline = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("enSubline"));
		var prnParams = new Object();
		
		if(subline == "CAR" || subline == "EAR") {
			prnParams.savedPrincipals 	= addedENPrincipals == null ? "[]" : addedENPrincipals;
			prnParams.delPrincipals 	= delENPrincipals == null ? "[]" : delENPrincipals;

			return JSON.stringify(prnParams);
		} else {
			return null;
		}						
	} catch(e) {
		showErrorMessage("prepareParams", e);
	}
}