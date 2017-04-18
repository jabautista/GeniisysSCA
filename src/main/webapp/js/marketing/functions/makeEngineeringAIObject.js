function makeEngineeringAIObject() {
	var enAi = new Object();
	var quoteId = objMKGlobal.packQuoteId != null ? objCurrPackQuote.quoteId : objGIPIQuote.quoteId; // modified by: nica 06.13.2011 to be reused by package quotation
	
	enAi.quoteId = nvl(quoteId, '');
	enAi.itemNo =  nvl($F("txtItemNo"),'');
	enAi.contractProjBussTitle = escapeHTML2($F("inputTitle"));
	enAi.siteLocation = escapeHTML2($F("inputLocation"));
	enAi.constructStartDate = $F("constructFrom") == "" ? null : $F("constructFrom");
	enAi.constructEndDate = $F("constructTo") == "" ? null : $F("constructTo");
	enAi.maintainStartDate = $F("mainFrom") == "" ? null : $F("mainFrom");
	enAi.maintainEndDate = $F("mainTo") == "" ? null : $F("mainTo");
	enAi.enggBasicInfoNum = nvl($F("txtItemNo"),'');
	enAi.testingStartDate;
	enAi.testingEndDate;
	enAi.weeksTest;
	enAi.timeExcess;
	enAi.mbiPolicyNo;
	
	return enAi;
}