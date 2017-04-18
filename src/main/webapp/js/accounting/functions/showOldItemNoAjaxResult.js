/*
 * Shows Old Item No List for GIACS026 Emman 02/01/11
 */
function showOldItemNoAjaxResult(pageNumber) {
	if ($F("txtTransactionType") == "2") {
		new Ajax.Updater("searchResult",
				"GIACPremDepositController?action=getOldItemNoListing", {
					onCreate : function() {
						showLoading("searchResult",
								"Getting list, please wait...", "100px");
					},
					onException : function() {
						showFailure('searchResult');
					},
					parameters : {
						pageNo : pageNumber,
						keyword : $F("keyword"),
						transactionType : $F("txtTransactionType"),
						controlModule : "GIACS026"
					},
					asynchronous : true,
					evalScripts : true
				});
	} else {
		new Ajax.Updater("searchResult",
				"GIACPremDepositController?action=getOldItemNoListingFor4", {
					onCreate : function() {
						showLoading("searchResult",
								"Getting list, please wait...", "100px");
					},
					onException : function() {
						showFailure('searchResult');
					},
					parameters : {
						pageNo : pageNumber,
						keyword : $F("keyword")
					},
					asynchronous : true,
					evalScripts : true
				});
	}
}