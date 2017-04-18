function editPackQuotation(lineName,lineCd,packQuoteId){
	//new Ajax.Updater("mainContents", contextPath+"/GIPIPackQuoteController?action=editPackQuotation", { // andrew - 02.10.2012
	new Ajax.Updater("quoteInfoDiv", contextPath+"/GIPIPackQuoteController?action=editPackQuotation", {
		method : "GET",
		parameters : {
		    lineName :   lineName,
		    lineCd     :   lineCd,
		    packQuoteId  :   packQuoteId
		},
		asynchronous : false,
		evalScripts : true,
		onCreate : function(){
			$("globalPackQuoteId").value = packQuoteId;
			showNotice("Getting quotation information, please wait...");
			updatePackQuotationParameters();
		},
		onComplete : function() {
			//$("globalPackQuoteId").value = packQuoteId;
			hideNotice("");
			$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
			$("quoteInfoDiv").show(); // andrew - 02.09.2012
			/*Effect.Appear($("mainContents").down("div", 0), {
				duration : .001
			});*/
			initializeAll();
			setDocumentTitle("Edit Package Quotation");
		}
	});
}