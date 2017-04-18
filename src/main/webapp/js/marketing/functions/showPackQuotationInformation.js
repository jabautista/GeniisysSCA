function showPackQuotationInformation() {
	if(objMKGlobal.packQuoteId == null){
		showMessageBox("There is no quotation selected.", imgMessage.ERROR);
		return;
	}
	
//	new Ajax.Updater("mainContents", contextPath + "/GIPIPackQuotationInformationController?action=showPackQuotationInformationPage" ,{	// andrew - 02.10.2012
	new Ajax.Updater("quoteInfoDiv", contextPath + "/GIPIPackQuotationInformationController?action=showPackQuotationInformationPage" ,{
		method : "GET",
		parameters : {
			packQuoteId : objMKGlobal.packQuoteId != null ? objMKGlobal.packQuoteId : $F("globalPackQuoteId")
		},
		evalScripts : true,
		asynchronous : false,
		onCreate : function(){ 
			showNotice("Getting quotation information, please wait...");
			updatePackQuotationParameters();
		},
		onComplete : function(){
			hideNotice();
			$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
			$("quoteInfoDiv").show(); // andrew - 02.09.2012
			Effect.Appear("packQuotationInformationMainDiv", {
				duration : .001
			});
			setDocumentTitle("Quotation Information");
			$("quotationMenus").show();					
			$("marketingMainMenu").hide();
			initializeMenu();
			setPackQuotationMenu();
			addStyleToInputs();
			initializeAll();
		}
	});
}