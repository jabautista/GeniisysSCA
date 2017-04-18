function showPackCarrierInfoPage() {
	if(objMKGlobal.packQuoteId == null){
		showMessageBox("There is no quotation selected.", imgMessage.ERROR);
		return;
	}
	
	//new Ajax.Updater("mainContents", contextPath + "/GIPIQuoteVesAirController" ,{	
	new Ajax.Updater("quoteInfoDiv", contextPath + "/GIPIQuoteVesAirController" ,{
		method : "GET",
		parameters : {
			action : "showPackQuoteCarrierInfoPage",
			packQuoteId : objMKGlobal.packQuoteId != null ? objMKGlobal.packQuoteId : $F("globalPackQuoteId")
		},
		evalScripts : true,
		asynchronous : false,
		onCreate : function(){ 
			showNotice("Getting carrier information, please wait...");
			updatePackQuotationParameters();
		},
		onComplete : function(){
			hideNotice();
			$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
			$("quoteInfoDiv").show(); // andrew - 02.09.2012
			Effect.Appear("packQuoteCarrierInfoMainDiv", {
				duration : .001
			});
			setDocumentTitle("Carrier Information");
			$("quotationMenus").show();					
			$("marketingMainMenu").hide();
			initializeMenu();
			setPackQuotationMenu();
			addStyleToInputs();
			initializeAll();
		}
	});
}