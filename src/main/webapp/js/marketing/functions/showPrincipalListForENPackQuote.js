function showPrincipalListForENPackQuote(principalType){
	var div = principalType == "P" ? "enPrincipalInfo" : "enContractorInfo";
	var msg = principalType == "P" ? "Principal Listing" : "Contractor Listing";
	
	new Ajax.Updater(div, contextPath + "/GIPIQuotationEngineeringController" ,{	
		method : "GET",
		parameters : {
			action : "showPrincipalPageForPackQuote",
			packQuoteId : objMKGlobal.packQuoteId != null ? objMKGlobal.packQuoteId : $F("globalPackQuoteId"),
			pType : principalType
		},
		evalScripts : true,
		asynchronous : false,
		onCreate : function(){ 
			showNotice("Getting " +msg+", please wait...");
		},
		onComplete : function(){
			hideNotice();
			Effect.Appear(div, {
				duration : .001
			});
		}
	});
}