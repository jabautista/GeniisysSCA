//angelo 04.30.2011 casualty additional info
function setQuoteCAAdditional(itemObj){
	try{
		var newObj = {};
		var quoteId = objMKGlobal.packQuoteId != null ? objCurrPackQuote.quoteId : objGIPIQuote.quoteId; // modified by: nica 06.13.2011 to be reused by package quotation
		
		newObj.quoteId = quoteId;
		newObj.itemNo = $F("txtItemNo");
		newObj.location = escapeHTML2($("txtLocation").value);
		newObj.sectionOrHazardCd = escapeHTML2($("selSectionOrHazard").value);
		newObj.capacityCd	= nvl($F("selCapacity"), null);
		newObj.limitOfLiability = escapeHTML2($("txtLimitOfLiability").value);
		
		return newObj;
	}catch (e) {
		showErrorMessage("setQuoteCAAdditional", e);
	}
}