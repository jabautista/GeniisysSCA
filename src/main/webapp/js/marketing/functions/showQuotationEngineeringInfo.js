function showQuotationEngineeringInfo(){
	try{
		//var exitCtr = 0;
		var quoteId = 0;
		// comment out by andrew - 02.10.2012
		//quoteId = $("quotationTableGridSectionDiv") == null || $("quotationTableGridSectionDiv") == undefined ? $F("quoteId") : getSelectedQuotationRowQuoteId(); // <== mark jm 04.14.2011 @UCPBGEN added condition
		//var quoteId = 13;
		if(objGIPIQuote != null) { // andrew - 02.10.2012
			quoteId = objGIPIQuote.quoteId;
		}
		
		if (quoteId == 0 && (typeof errorMessage) != undefined) {
			showQuotationListingError("Please select a quotation.");
			return false;
		}else{
			enggBasicInfoExitCtr = 1;
			selectedQuoteListingIndex = -1; // mark jm 04.25.2011 @UCPBGEN
			//objGIPIQuote.quoteId = 0; // mark jm 04.25.2011 @UCPBGEN // comment out by andrew - 02.10.2012
			//new Ajax.Updater("mainContents","GIPIQuotationEngineeringController?action=showEngineeringBasicInfo", { // andrew - 02.10.2012
			new Ajax.Updater("quoteInfoDiv","GIPIQuotationEngineeringController?action=showEngineeringBasicInfo", {
				method: "GET",
				parameters: {
					quoteId: quoteId
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Getting Engineering Basic Information, please wait..."),
				onComplete: function (){
					hideNotice("");
					$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
					$("quoteInfoDiv").show();
				}
			});
		}
	}catch(e){
		showErrorMessage("showQuotationEngineeringInfo", e);
	}
}