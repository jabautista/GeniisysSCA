function showPackQuoteENInfoPage() {
	if(objMKGlobal.packQuoteId == null){
		showMessageBox("There is no quotation selected.", imgMessage.ERROR);
		return;
	}
	
	//new Ajax.Updater("mainContents", contextPath + "/GIPIQuotationEngineeringController" ,{ // andrew - 02.10.2012
	new Ajax.Updater("quoteInfoDiv", contextPath + "/GIPIQuotationEngineeringController" ,{		
		method : "GET",
		parameters : {
			action : "showENInfoForPackQuote",
			packQuoteId : objMKGlobal.packQuoteId != null ? objMKGlobal.packQuoteId : $F("globalPackQuoteId")
		},
		evalScripts : true,
		asynchronous : false,
		onCreate : function(){ 
			showNotice("Getting engineering information, please wait...");
			updatePackQuotationParameters();
		},
		onComplete : function(){
			hideNotice();
			$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
			$("quoteInfoDiv").show(); // andrew - 02.09.2012
			Effect.Appear("packQuoteENInfoMainDiv", {
				duration : .001
			});
			setDocumentTitle("Engineering Basic Information");
			$("quotationMenus").show();
			$("marketingMainMenu").hide();
			initializeMenu();
			setPackQuotationMenu();
			addStyleToInputs();
			initializeAll();
		}
	});
}