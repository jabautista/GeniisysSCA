function makeMarineHullAIObject(){
	var mhAi = new Object();
	var quoteId = objMKGlobal.packQuoteId != null ? objCurrPackQuote.quoteId : objGIPIQuote.quoteId; // modified by: nica 06.13.2011 to be reused by package quotation
	
	mhAi.quoteId = nvl(quoteId, null);
	mhAi.itemNo = nvl($F("txtItemNo"), null);
	mhAi.geogLimit = $F("geogLimit").blank() ? null : escapeHTML2($F("geogLimit"));	//added escapeHTML
	mhAi.dryPlace = $F("drydockPlace");	
	mhAi.vesselCd = $F("vessel");
	mhAi.vessClassDesc = $F("vesselClass");
	mhAi.regOwner = $F("registeredOwner");	
	mhAi.vesselOldName = $F("vesselOldName");	
	//mhAi.vesTypeCd = $F("vesselType");
	mhAi.vesTypeDesc = $F("vesselType"); //line above commented by angelo and replaced with these line
	mhAi.regPlace = $F("place");
	mhAi.yearBuilt = $F("yearBuilt");	
	mhAi.crewNat = $F("nationality");	
	mhAi.noCrew = nvl($F("noOfCrew"), null);
	mhAi.dryDate = nvl($F("drydockDate"),null);	
	mhAi.grossTon = nvl($F("grossTonnage"), null);
	mhAi.netTon = nvl($F("netTonnage"),null);	
	mhAi.deadWeight = nvl($F("deadweightTonnage"),null);
	mhAi.vesselDepth = nvl($F("vesselDepth"),null);	
	mhAi.vesselLength = nvl($F("vesselLength"),null);
	mhAi.vesselBreadth = nvl($F("vesselBreadth"),null);	
	mhAi.propelSw = $F("propellerType");
	mhAi.hullDesc = $F("hullType");
	mhAi.deductText = null;
	
	return mhAi;
}