function searchPackBankRefNo(modalPageNo, keyword){
	new Ajax.Updater('searchResult','GIPIPackQuoteController?action=searchPackBankRefNo&pageNo='+modalPageNo+'&keyword='+keyword+'&nbtAcctIssCd='+$F("nbtAcctIssCd")+'&nbtBranchCd='+$F("nbtBranchCd"), {
		asynchronous: false,
		evalScripts: true,
		onCreate: function(){
			showLoading('searchResult', 'Getting list, please wait...', "120px");
		}	
	});

}