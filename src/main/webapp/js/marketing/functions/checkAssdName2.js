function checkAssdName2(assdName){ // bonok :: 09.14.2012 temp solution XD
	//edited by MarkS 04.15.2016 SR-5296 TO SHOW OVERLAY List of Existing Quotation/s and Policies
	genericObjOverlay = Overlay.show(contextPath+"/GIPIQuotationController", { 
		urlContent: true,
		urlParameters: {action : "getExistingQuotesPolsListing",
					    lineCd : objQuote.giimm001LineCd,
					    assdNo : objQuote.giimm001AssdNo,  //edited by MarkS 04.15.2016 SR-5296 TO SHOW OVERLAY List of Existing Quotation/s and Policies
		 			    assdName : objQuote.giimm001AssdName,
					    vExist2 : "N"},
		title: "List of Existing Quotation/s and Policies",							
	    height: 400,
	    width: 880,
	    draggable: true
	});
	objMKTG.giimm001QouteInfo.toPopulateQuoteInfo = true; //added by steven 12/04/2012
	
};