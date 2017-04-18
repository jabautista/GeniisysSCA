

/*
 * Shows Aging SOA Details Emman November 4, 2010
 */
function searchAgingSOADetails(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACPremDepositController?action=getAgingSOAListing", {
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
					issCd : $F("txtB140IssCd")
				},
				asynchronous : true,
				evalScripts : true
			});
}