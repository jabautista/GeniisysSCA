function createQuotationTableGrid(qLineName, qLineCode) {
	/*new Ajax.Updater("mainContents", contextPath*/ // andrew - 02.09.2012
	new Ajax.Updater("quoteInfoDiv", contextPath
			+ "/GIPIQuotationController?action=createQuotation", {
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
			$("quoteInfoDiv").show();
			Effect.Appear("contentsDiv", {
				duration : .001
			});
			initializeAll();
			setDocumentTitle("Create Quotation");
		}	
	});
}