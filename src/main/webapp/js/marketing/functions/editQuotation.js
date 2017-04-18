function editQuotation(src){	
	//new Ajax.Updater("mainContents", src, {	// andrew - 02.09.2012
	new Ajax.Updater("quoteInfoDiv", src, {
		method : "GET",
		/*parameters : {
		    lineName :   qLineName,
		    lineCd     :   qLineCd,
		    quoteId  :   qQuoteId,
			src        : 	src
		},*/
		asynchronous : true,
		evalScripts : true,
		onCreate : showNotice("Getting quotation information, please wait..."),
		onComplete : function() {
			hideNotice("");
			$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
			$("quoteInfoDiv").show();
			/*Effect.Appear($("quoteInfoDiv").down("div", 0), {
				duration : .001
			});*/
			initializeAll();
			setDocumentTitle("Create Quotation"); //added by jeffdojello 10.23.2013
			setModuleId("GIIMM001"); //added by jeffdojello 10.23.2013
		}
	});
}