function showCreateQuoteFromViewPolicy(){
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
			$("assuredName").value = objQuote.giimm001AssdName;
			objGIPIS100.callingForm = "GIPIS000";
			setDocumentTitle("Create Quotation");
		}	
	});
	
	checkAssdName2(objQuote.giimm001AssdName); // bonok :: 09.14.2012 temp solution XD
}