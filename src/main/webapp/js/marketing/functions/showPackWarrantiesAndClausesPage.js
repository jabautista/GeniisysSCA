function showPackWarrantiesAndClausesPage() {
	if(objMKGlobal.packQuoteId == null){
		showMessageBox("There is no quotation selected.", imgMessage.ERROR);
		return;
	}
	
	//new Ajax.Updater("mainContents", contextPath + "/GIPIQuotationWarrantyAndClauseController" ,{ // andrew - 02.10.2012
	new Ajax.Updater("quoteInfoDiv", contextPath + "/GIPIQuotationWarrantyAndClauseController" ,{ 
		method : "GET",
		parameters : {
			action : "showPackQuotationWCPage",
			packQuoteId : objMKGlobal.packQuoteId != null ? objMKGlobal.packQuoteId : $F("globalPackQuoteId")
		},
		evalScripts : true,
		asynchronous : false,
		onCreate : function(){ 
			showNotice("Getting warranties and clauses, please wait...");
			updatePackQuotationParameters();
		},
		onComplete : function(){
			hideNotice();
			$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
			$("quoteInfoDiv").show(); // andrew - 02.09.2012
			Effect.Appear("packQuotationWarrantiesAndClausesMainDiv", {
				duration : .001
			});
			setDocumentTitle("Warranties and Clauses");
			$("quotationMenus").show();					
			$("marketingMainMenu").hide();
			initializeMenu();
			setPackQuotationMenu();
			addStyleToInputs();
			initializeAll();
		}
	});
}