/*
 * Shows Intermediary List
 * Emman 11/10/10
 */
function showIntermediaryAjaxResult(pageNumber){
	new Ajax.Updater("searchResult", "GIISIntermediaryController?action=getIntermediaryListing", {
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