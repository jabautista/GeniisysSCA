function showGIISCurrencyLOVAjaxResult(pageNumber) {
	new Ajax.Updater("searchResult", "GIISCurrencyController?action=getGIISCurrencyLOV", {
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