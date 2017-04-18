function loadWarrantyAndClausesByPage(pageNo) {
	
	try {
		new Ajax.Updater("wcDiv", "GIPIQuotationWarrantyAndClauseController", {
			method : "GET",
			parameters : {
				quoteId : 	objGIPIQuote.quoteId,
				action : 	"goToPage",
				pageNo : 	pageNo,
				ajax : 		"1"
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : showLoading("wcDiv", "Loading list, please wait...",	"30px;"),
			onComplete : function() {
				checkTableIfEmpty("row", "wcDiv");
			}
		});
	} catch (e) {
		showErrorMessage("loadWarrantyAndClausesByPage", e);
	}
}