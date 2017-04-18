function searchInvoiceModal3(){
	new Ajax.Updater("searchResult", "GIACDirectPremCollnsController?action=getSearchResult&premSeqNo="+$F("keyword")+"&issCd="+$F("tranSource")+"&tranType="+$F("tranType"), {
		onCreate: function() { 
			showLoading("searchResult", "Getting list, please wait...", "100px");
		}, 
		onException: function() { 
			showFailure('searchResult');
		},
		parameters: {
			pageNo: modalPageNo2
		},
		asynchronous: true, 
		evalScripts: true
	});
	modalPageNo2 = 1;
}