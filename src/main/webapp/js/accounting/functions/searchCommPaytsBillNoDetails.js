/*
 * Shows Bill No List for Comm Payts Emman Sept 15, 2010
 */
function searchCommPaytsBillNoDetails(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACCommPaytsController?action=getBillNoListing", {
				onCreate : function() {
					showLoading("searchResult", "Getting list, please wait...",
							"100px");
				},
				onException : function() {
					showFailure('searchResult');
				},
				parameters : {
					pageNo : pageNumber,
					keyword : $F("keyword"),
					tranType : $F("txtTranType"),
					issCd : $F("txtIssCd")
				},
				asynchronous : true,
				evalScripts : true
			});
}