function createQuotation() {
	new Ajax.Updater("quoteInfoDiv", contextPath
			+ "/GIPIQuotationController?action=createQuotation", {
		method : "GET",
		parameters : {
			lineName 	: $F("lineName"),
			lineCd 		: $F("lineCd") // objGIPIQuote.lineCd changed to  $F("lineCd") - irwin,
		},
		asynchronous 	: true,
		evalScripts 	: true,
		onCreate : showNotice("Creating form, please wait..."),
		onComplete : function() {
			hideNotice("");
			Effect.Appear("contentsDiv", {
				duration : .001
			});
			initializeAll();
			setDocumentTitle("Create Quotation");
		}	
	});
}