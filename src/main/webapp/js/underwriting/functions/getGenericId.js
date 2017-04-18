function getGenericId(uploadMode){
	try {
		var id = 0;
		if ("par" == uploadMode){
			id = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
		} else if ("policy" == uploadMode){
			id = ($("globalPolicyId") != null ? $F("globalPolicyId") : $F("hidPolicyId"));
		} else if ("extract" == uploadMode) {
			id = $F("globalExtractId");
		} else if ("inspection" == uploadMode) {
			id = $F("inspNo");
		} else if ("clmItemInfo" == uploadMode) {
			id = objCLMGlobal.claimId;
		} else if ("quotation" == uploadMode) {
			id = objGIPIQuote.quoteId;
		}
		return id;
	} catch(e){
		showErrorMessage("getGenericId", e);
	}
}