// calls actual query for search invoice modal
function searchInvoiceModal2(){
	new Ajax.Updater("searchResult", "GIACDirectPremCollnsController?action=getSearchResult&premSeqNo="+$F("billCmNo")+"&issCd="+$F("tranSource")+"&tranType="+$F("tranType"), {
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