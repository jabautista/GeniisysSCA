function searchClientModal2(){
	new Ajax.Updater("searchResult", "GIISAssuredController?action=getAssuredListing", {
		onCreate: function() { 
			showLoading("searchResult", "Getting list, please wait...", "100px");
		}, 
		onException: function() { 
			showFailure('searchResult');
		},
		parameters: {
			pageNo: modalPageNo2,
			keyword: $F("keyword")
		},
		asynchronous: false, 
		evalScripts: true
	});
	modalPageNo2 = 1;
}