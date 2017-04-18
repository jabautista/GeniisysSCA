function goToPageSearchInvoiceModal2(elem){
	modalPageNo2 = elem.value;
	new Ajax.Updater('searchResult','GIACDirectPremCollnsController?action=getSearchResult&pageNo='+modalPageNo2 + "&premSeqNo"+$F("billCmNo")+"&issCd="+$F("tranSource")+"&tranType="+$F("tranType"), {
		onCreate: function() { 
			showLoading('searchResult', 'Getting list, please wait...');
		},
		onException: function() {
			showFailure('searchResult');
		}, 
		asynchronous:true, 
		evalScripts:true
	});
}