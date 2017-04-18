/*
 * Shows Bank Acct List for Close DCB - Emman 04.05.2011
 */
function searchBankAcctNoLOV(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACBankAccountsController?action=getBankAcctNoListing", {
				onCreate : function() {
					showLoading("searchResult", "Getting list, please wait...",
							"100px");
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