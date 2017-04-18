/*
 * Shows Reinsurer List
 * Emman 11/10/10
 */
function showReinsurerAjaxResult(pageNumber){
	new Ajax.Updater("searchResult", "GIISReinsurerController?action=getReinsurerListing", {
		onCreate: function() { 
			showLoading("searchResult", "Getting list, please wait...", "100px");
		}, 
		onException: function() { 
			showFailure('searchResult');
		},
		parameters: {
			pageNo: pageNumber,
			keyword: $F("keyword")
		},
		asynchronous: true, 
		evalScripts: true
	});
}