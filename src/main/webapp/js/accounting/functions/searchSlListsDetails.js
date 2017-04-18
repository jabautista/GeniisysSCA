
/*
 * Shows Sl Lists Details Emman December 2, 2010
 */
function searchSlListsDetails(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACSlListsController?action=getSlListingByWhtaxId", {
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
					whtaxId : $F("txtGwtxWhtaxId")
				},
				asynchronous : true,
				evalScripts : true
			});
}