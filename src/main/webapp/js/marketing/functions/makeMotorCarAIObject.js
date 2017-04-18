function makeMotorCarAIObject(){
	try{
		var gipiWVehicle = new Object();
		
		var quoteId = objMKGlobal.packQuoteId != null ? objCurrPackQuote.quoteId : objGIPIQuote.quoteId; // modified by: nica 06.13.2011 to be reused by package quotation
		
		gipiWVehicle.quoteId 			= nvl(quoteId, null);
		gipiWVehicle.itemNo 			= nvl($F("txtItemNo"), null);
		gipiWVehicle.assignee 			= escapeHTML2($F("assignee"));
		gipiWVehicle.acquiredFrom		= escapeHTML2($F("acquiredFrom"));
		gipiWVehicle.motorNo			= escapeHTML2($F("motorNo"));
		gipiWVehicle.origin				= escapeHTML2($F("origin"));
		gipiWVehicle.destination		= escapeHTML2($F("destination"));
		gipiWVehicle.typeOfBodyCd		= nvl($F("typeOfBody"), null);
		gipiWVehicle.plateNo			= nvl($F("plateNo"), null);
		gipiWVehicle.modelYear			= nvl($F("modelYear"), null);
		gipiWVehicle.carCompanyCd		= nvl($F("carCompanyCd"), null);
		gipiWVehicle.mvFileNo			= nvl($F("mvFileNo"), null);
		gipiWVehicle.noOfPass			= nvl($F("noOfPass"), null);
		gipiWVehicle.makeCd				= nvl($F("makeCd"), null);
		gipiWVehicle.basicColorCd		= nvl($F("basicColorCd"), null);
		gipiWVehicle.basicColor			= escapeHTML2(nvl($F("basicColor"), null));
		gipiWVehicle.colorCd			= nvl($F("colorCd"), null);
		gipiWVehicle.color				= escapeHTML2(nvl($F("color"), null));
		gipiWVehicle.seriesCd			= nvl($F("seriesCd"), null);
		gipiWVehicle.motType			= nvl($F("motorType"), null);
		gipiWVehicle.unladenWt			= nvl($F("unladenWt"), null);
		gipiWVehicle.towing				= nvl($F("towLimit"), null);
		gipiWVehicle.serialNo			= nvl($F("serialNo"), null);
		gipiWVehicle.sublineTypeCd		= nvl($F("sublineType"), null);
		gipiWVehicle.deductibleAmount	= nvl($F("deductibleAmount"), null);
		gipiWVehicle.cocType			= nvl($F("cocType"), null);
		gipiWVehicle.cocSerialNo		= nvl($F("cocSerialNo"), null);
		gipiWVehicle.cocYy				= nvl($F("cocYy"), null);
		gipiWVehicle.ctvTag				= $("ctv").checked ? 'Y' : 'N';
		gipiWVehicle.repairLim			= nvl($F("repairLimit"), null);
		gipiWVehicle.sublineCd			= objMKGlobal.packQuoteId != null ? objCurrPackQuote.sublineCd : objGIPIQuote.sublineCd; // modified by: nica 06.13.2011 to be reused by package quotation
		gipiWVehicle.estValue			= 0;
		gipiWVehicle.tariffZone			= null;
		gipiWVehicle.cocIssueDate		= null;
		gipiWVehicle.cocSeqNo			= null;
		gipiWVehicle.cocAtcn			= null;
		gipiWVehicle.carCompany			= escapeHTML2($F("carCompany"));
		gipiWVehicle.make				= escapeHTML2($F("make"));//$("makeCd").options[$("makeCd").selectedIndex].text;
		gipiWVehicle.engineSeries		= escapeHTML2($F("engineSeries"));
//		gipiWVehicle.color				= $("colorCd").options[$("colorCd").selectedIndex].text;
		
		gipiWVehicle.created			= true;
		
		return gipiWVehicle;
	}catch(e){
		showErrorMessage("makeMotorCarAIObject", e);
		return null;
	}
}