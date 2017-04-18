function setEndtMNItemObject(newObj) {
	try {
		//var newObj = itemObjTemplate;		
		newObj.geogCd  			= ($F("geogCd") == "" ? null : $F("geogCd"));
		newObj.vesselCd  		= ($F("vesselCd") == "" ? null : $F("vesselCd"));
		newObj.cargoClassCd		= ($F("cargoClassCd") == "" ? null : $F("cargoClassCd"));
		newObj.cargoType		= ($F("cargoType") == "" ? null : $F("cargoType"));
		newObj.packMethod		= ($F("packMethod") == "" ? null : escapeHTML2($F("packMethod")));
		newObj.blAwb			= ($F("blAwb") == "" ? null : escapeHTML2($F("blAwb")));
		newObj.transhipOrigin	= ($F("transhipOrigin") == "" ? null : escapeHTML2($F("transhipOrigin")));
		newObj.transhipDestination = ($F("transhipDestination") == "" ? null : escapeHTML2($F("transhipDestination")));
		newObj.voyageNo			= ($F("voyageNo") == "" ? null : escapeHTML2($F("voyageNo")));
		newObj.lcNo				= ($F("lcNo") == "" ? null : escapeHTML2($F("lcNo")));
		newObj.etd				= ($F("etd") == "" ? null : $F("etd"));
		newObj.eta				= ($F("eta") == "" ? null : $F("eta"));
		newObj.printTag			= ($F("printTag") == "" ? null : $F("printTag"));
		newObj.origin			= ($F("origin") == "" ? null : escapeHTML2($F("origin")));
		newObj.destn			= ($F("destn") == "" ? null : escapeHTML2($F("destn")));
		newObj.invCurrCd		= ($F("invCurrCd") == "" ? null : $F("invCurrCd"));
		newObj.invCurrRt		= ($F("invCurrRt") == "" ? null : $F("invCurrRt"));
		newObj.invoiceValue		= ($F("invoiceValue") == "" ? null : $F("invoiceValue"));
		newObj.markupRate		= ($F("markupRate") == "" ? null : $F("markupRate"));
		newObj.deductText		= ($F("deductibleRemarks") == "" ? null : escapeHTML2($F("deductibleRemarks")));
		newObj.recFlagWCargo	= ($F("recFlagWCargo") == "" ? "A" : $F("recFlagWCargo"));
		//newObj.perilExist		= "";
		return newObj;	
	} catch (e) {
		showErrorMessage("setEndtMNItemObject", e);
	}
}