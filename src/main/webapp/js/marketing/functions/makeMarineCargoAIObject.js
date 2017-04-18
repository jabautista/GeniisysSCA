function makeMarineCargoAIObject(){
	var mnAi = new Object();
	var quoteId = objMKGlobal.packQuoteId != null ? objCurrPackQuote.quoteId : objGIPIQuote.quoteId; // modified by: nica 06.13.2011 to be reused by package quotation
	
	mnAi.quoteId = quoteId; 
	mnAi.itemNo = $F("txtItemNo");
	mnAi.geogCd = $F("geogCd"); 	
	mnAi.vesselCd = $F("vesselCd");	
	mnAi.cargoClassCd = $F("cargoClassCd");
	mnAi.cargoType = $F("cargoType");	
	mnAi.etd = $F("etd");	
	mnAi.packMethod = escapeHTML2($F("packMethod"));	
	mnAi.transhipOrigin = escapeHTML2($F("transhipOrigin"));	
	mnAi.transhipDestination = escapeHTML2($F("transhipDestination"));
	mnAi.voyageNo = escapeHTML2($F("voyageNo"));	
	mnAi.lcNo = escapeHTML2($F("lcNo"));
	mnAi.printTag = $F("printTag");	
	mnAi.eta = $F("eta");
	mnAi.blAwb = escapeHTML2($F("blAwb"));
	mnAi.origin = escapeHTML2($F("origin"));	
	mnAi.destn = escapeHTML2($F("destn"));
	return mnAi;
}