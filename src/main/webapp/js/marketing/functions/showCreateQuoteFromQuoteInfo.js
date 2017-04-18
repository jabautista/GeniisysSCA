function showCreateQuoteFromQuoteInfo(){
	$("mainNav").show();
	$("contentsDiv").show();
	$("quoteDynamicDiv").innerHTML = "";
	
	new Ajax.Updater("contentsDiv", contextPath
			+ "/GIPIQuotationController?action=createQuotation", {
		method : "GET",
		parameters : {
			lineName 	: objQuote.giimm001LineName,
			lineCd 		: objQuote.giimm001LineCd
		},
		asynchronous 	: true,
		evalScripts 	: true,
		onCreate : showNotice("Creating form, please wait..."),
		onComplete : function() {
			hideNotice("");
			initializeAll();
			initializeMenu();
			objQuote.fromGIIMM001 = "N";
			$("assuredName").value = objQuote.giimm001AssdName;
			setDocumentTitle("Create Quotation");
			objMKTG.giimm001QouteInfo.toPopulateQuoteInfo = true; //added by steven 12/05/2012
		}	
	});
	
	genericObjOverlay = Overlay.show(contextPath+"/GIPIQuotationController", { 
		urlContent: true,
		urlParameters: {action : "getExistingQuotesPolsListing",
					    lineCd : objQuote.giimm001LineCd,
					    //assdNo : objQuote.giimm001AssdNo,
					    assdNo : objQuote.giimm001AssdNo != "" ? objQuote.giimm001AssdNo : objGIPIQuote.assdNo, // by bonok :: 09.14.2012
		 			    assdName : objQuote.giimm001AssdName,
					    vExist2 : "N"},
		title: "List of Existing Quotation/s and Policies",							
	    height: 400,
	    width: 880,
	    draggable: true
	});
}