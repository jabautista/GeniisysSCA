function showQuotationInformation() {
	var quoteId = 0;
	changeTag = 0; //Patrick 02.14.2012
/*	try{ // comment out by andrew - 02.10.2012
		//resetQuoteInfoGlobals();
		//quoteId = getSelectedQuotationRowQuoteId();
		//quoteId = $("quoteId") == null || $("quoteId") == undefined ? getSelectedQuotationRowQuoteId() : $F("quoteId");
		quoteId = $("quotationTableGridSectionDiv") == null || $("quotationTableGridSectionDiv") == undefined ?  $F("quoteId") : getSelectedQuotationRowQuoteId(); // <== mark jm 04.14.2011 @UCPBGEN added condition
	}catch (e) {
		showErrorMessage("showQuotationInformation()", e);
	}*/

	if(objGIPIQuote != null) { // andrew - 02.10.2012
		quoteId = objGIPIQuote.quoteId;
	} 
	
	if (quoteId == 0 && (typeof errorMessage) != undefined) {
		showQuotationListingError("There is no quotation selected.");
		return false;
	} else {
		var userId = getUserIdParameterFromTableGrid();
		selectedQuoteListingIndex = -1; // mark jm 04.25.2011 @UCPBGEN
		// objGIPIQuote.quoteId = 0; // mark jm 04.25.2011 @UCPBGEN // comment out by andrew - 02.10.2012

		//new Ajax.Updater("mainContents", contextPath + "/GIPIQuotationInformationController?action=showQuoteInformationPage&userId=" + userId,
		//new Ajax.Updater("quoteInfoDiv", contextPath + "/GIPIQuotationInformationController?action=showQuoteInformationPage&userId=" + userId,
		new Ajax.Updater("quoteInfoDiv", contextPath + "/GIPIQuoteController?action=showQuoteInformationPage&userId=" + userId,
		{	method : "GET",
			parameters : {
				quoteId : quoteId,
				lineCd: getLineCd(objGIPIQuote.lineCd),//getLineCdMarketing(), Gzelle 05222015 SR4112
				ajax : "1"
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function(){ 
				showNotice("Getting quotation information, please wait...");
				resetQuoteInfoGlobals();
			},
			onComplete : function(){
				hideNotice("");
				Effect.Appear("quotationInformationMainDiv", {
					duration : .001
				});
				hideNotice("");
				setDocumentTitle("Quotation Information");
				$("quotationMenus").show();					
				$("marketingMainMenu").hide();
				$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
				$("quoteInfoDiv").show(); // andrew - 02.09.2012
				initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
				addStyleToInputs();
				initializeAll();
			}
		});
	}
}