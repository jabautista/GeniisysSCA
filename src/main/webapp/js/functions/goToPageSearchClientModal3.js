function goToPageSearchClientModal3(modalPageNo2,assdNo,keyword){
	new Ajax.Updater('searchResult','GIISAssuredController?action=getAcctOfListing&pageNo='+modalPageNo2+'&assdNo='+assdNo+'&keyword='+keyword, {
		onCreate: function() { 
			showLoading('searchResult', 'Getting list, please wait...', "120px");
		},
		asynchronous:false,
		evalScripts:true
	});	
}