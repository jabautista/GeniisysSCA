function showClausesPage() {
	clausesExitCtr = 1;
	var quoteId = getQuotationSelectedRow();
	if(objGIPIQuote != null){
		quoteId = objGIPIQuote.quoteId;
	}else if ($$("div#quotationListingTable div[name='row']").size() == 0) {
		quoteId = objGIPIQuote.quoteId;
	}

	if (quoteId == 0 && (typeof errorMessage) != undefined) {
		showQuotationListingError("Please select a quotation.");
		return false;
	} else {
		/*new Ajax.Updater("mainContents", "GIPIQuotationWarrantyAndClauseController?action=showWCPage", {*/ // andrew - 02.09.2012
//		new Ajax.Updater("quoteInfoDiv", "GIPIQuotationWarrantyAndClauseController?action=showWCPage", {
		new Ajax.Updater("quoteInfoDiv", "GIPIQuotationWarrantyAndClauseController?action=showWarrClaPage", { // Udel - 03282012
			method : "GET",
			parameters : {
				quoteId : quoteId,
				ajax : 1
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function() {
				Effect.Fade($("mainContents").down("div", 0),{	
					duration : .001,
					afterFinish : function() {
						showNotice("Getting warranties and clauses, please wait...");
					}
				});
			},
			onComplete : function() {
				hideNotice("Done!");
				$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
				$("quoteInfoDiv").show(); // andrew - 02.09.2012
				Effect.Appear("wcMainDiv", {	//duration : .001
				});
			}
		});
	}
}