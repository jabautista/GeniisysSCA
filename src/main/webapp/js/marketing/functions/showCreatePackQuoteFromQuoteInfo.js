function showCreatePackQuoteFromQuoteInfo(){
	new Ajax.Updater("quoteInfoDiv", contextPath
			+ "/GIPIPackQuoteController?action=createPackQuotation", {		
		method : "GET",
		parameters : {
			lineName 	: objQuote.giimm001ALineName,
			lineCd 		: objQuote.giimm001ALineCd
		},
		asynchronous 	: true,
		evalScripts 	: true,
		onCreate : showNotice("Creating form, please wait..."),
		onComplete : function() {
			hideNotice("");
			objQuote.fromGIIMM001A = "N";
			$("packQuoteDynamicDiv").update("");
			$("quoteListingMainDiv").hide();
			$("quoteInfoDiv").show();
			$("assuredName").value = objGIPIPackQuote.assdName;
			Effect.Appear("contentsDiv", {
				duration : .001
			});
			initializeAll();
			setDocumentTitle("Create Package Quotation");
		}	
	});
	genericObjOverlay = Overlay.show(contextPath+"/GIPIPackQuoteController", { 
		urlContent: true,
		urlParameters: {action : "getExistingPackQuotations",
						lineCd : objQuote.giimm001ALineCd,
						assdNo: objQuote.giimm001AAssdNo,
						ajax : "1"},
		title: "List of Existing Quotation/s and Policies",							
	    height: 400,
	    width: 880,
	    draggable: true
	});
	objMKTG.giimm001QouteInfo.toPopulateQuoteInfo = true; //added by steven 12/05/2012
}