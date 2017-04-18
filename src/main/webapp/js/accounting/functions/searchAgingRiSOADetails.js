
/*
 * Shows Aging RI SOA Details, RI Details if specified Iss Cd is RI Emman
 * November 5, 2010
 */
function searchAgingRiSOADetails(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACPremDepositController?action=getAgingRiSOAListing", {
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