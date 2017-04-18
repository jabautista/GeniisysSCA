function createPackQuotationTableGrid(qLineName, qLineCode) {
	/*new Ajax.Updater("mainContents", contextPath
			+ "/GIPIPackQuoteController?action=createPackQuotation", {*/ // andrew - 02.10.2012 
	new Ajax.Updater("quoteInfoDiv", contextPath
			+ "/GIPIPackQuoteController?action=createPackQuotation", {		
		method : "GET",
		parameters : {
			lineName 	: qLineName,
			lineCd 		: qLineCode
		},
		asynchronous 	: true,
		evalScripts 	: true,
		onCreate : showNotice("Creating form, please wait..."),
		onComplete : function() {
			hideNotice("");
			$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
			$("quoteInfoDiv").show(); // andrew - 02.09.2012
			Effect.Appear("contentsDiv", {
				duration : .001
			});
			initializeAll();
			setDocumentTitle("Create Package Quotation");
		}	
	});
}