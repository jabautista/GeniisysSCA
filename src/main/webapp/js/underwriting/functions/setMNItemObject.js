function setMNItemObject(newObj){
	try{
		var gipiWCargo = new Object();
		
		gipiWCargo.geogCd  				= ($F("geogCd") == "" ? null : $F("geogCd"));
		gipiWCargo.vesselCd  			= ($F("vesselCd") == "" ? null : $F("vesselCd"));
		gipiWCargo.cargoClassCd			= ($F("cargoClassCd") == "" ? null : $F("cargoClassCd"));
		gipiWCargo.cargoClassDesc		= ($F("cargoClass") == "" ? null : escapeHTML2($F("cargoClass")));	//Gzelle 05292015 SR4302
		gipiWCargo.cargoType			= ($F("cargoType") == "" ? null : escapeHTML2($F("cargoType")));	//Gzelle 05292015 SR4302			
		gipiWCargo.cargoTypeDesc		= ($F("cargoTypeDesc") == null || $F("cargoTypeDesc") == ""? null : escapeHTML2($F("cargoTypeDesc"))); // andrew - 10.03.2011
		gipiWCargo.packMethod			= ($F("packMethod") == "" ? null : escapeHTML2($F("packMethod")));
		gipiWCargo.blAwb				= ($F("blAwb") == "" ? null : escapeHTML2($F("blAwb")));
		gipiWCargo.transhipOrigin		= ($F("transhipOrigin") == "" ? null : escapeHTML2($F("transhipOrigin")));
		gipiWCargo.transhipDestination 	= ($F("transhipDestination") == "" ? null : escapeHTML2($F("transhipDestination")));
		gipiWCargo.voyageNo				= ($F("voyageNo") == "" ? null : escapeHTML2($F("voyageNo")));
		gipiWCargo.lcNo					= ($F("lcNo") == "" ? null : escapeHTML2($F("lcNo")));
		gipiWCargo.etd					= ($F("etd") == "" ? null : $F("etd"));
		gipiWCargo.eta					= ($F("eta") == "" ? null : $F("eta"));
		gipiWCargo.printTag				= ($F("printTag") == "" ? null : $F("printTag"));
		gipiWCargo.origin				= ($F("origin") == "" ? null : escapeHTML2($F("origin")));
		gipiWCargo.destn				= ($F("destn") == "" ? null : escapeHTML2($F("destn")));
		gipiWCargo.invCurrCd			= ($F("invCurrCd") == "" ? null : $F("invCurrCd"));
		gipiWCargo.invCurrRt			= ($F("invCurrRt") == "" ? null : $F("invCurrRt"));
		gipiWCargo.invoiceValue			= ($F("invoiceValue") == "" ? null : $F("invoiceValue"));
		gipiWCargo.markupRate			= ($F("markupRate") == "" ? null : $F("markupRate"));
		//gipiWCargo.deductText			= ($F("deductibleRemarks") == "" ? null : escapeHTML($F("deductibleRemarks")));
		gipiWCargo.recFlagWCargo		= ($F("recFlagWCargo") == "" ? "A" : $F("recFlagWCargo"));
		
		newObj.gipiWCargo = gipiWCargo;
		
		return newObj;
	}catch(e){
		showErrorMessage("setMNItemObject", e);
	}
}