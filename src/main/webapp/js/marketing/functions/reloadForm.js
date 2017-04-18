function reloadForm() {
	//change main contents
	new Ajax.Updater("quoteInfoDiv", contextPath+"/GIPIQuotationController?action=editQuotation", {
		method: "GET",
		parameters: {
			quoteId: $F("quoteId")
		},
		asynchronous: true,
		evalScripts: true,
		onCreate: function () { 
			//showLoading("mainContents", "Getting information, please wait...", "150px;"), 
			showNotice("Creating form, please wait...");
		},
		onComplete: function ()	{
			/*hideNotice("");
			initializeAll();
			initializeMenu();
			Effect.Appear($("mainContents").down("div", 0), {
				duration: .5
			});*/
			hideNotice("");
			Effect.Appear("contentsDiv", {
				duration : .001
			});
			initializeAll();
		}
	});
}