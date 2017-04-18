/*
 * Shows Fund Cd (Company) List for Close DCB Emman 03.30.2011
 */
function searchFundCdLOV(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIISFundsController?action=getCloseDCBFundCdListing", {
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