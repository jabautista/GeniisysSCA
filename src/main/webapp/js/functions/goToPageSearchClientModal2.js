function goToPageSearchClientModal2(elem){
	modalPageNo2 = elem.value;
	modalDirectory = elem.getAttribute("directory"); //added by Nok 04.07.2011
	var keyword = $("keyword").value;  //added by Nok 04.07.2011 para pag lipat ng page with keyword available
	new Ajax.Updater('searchResult','GIISAssuredController?action=getAssuredListing&directory='+modalDirectory+'&pageNo='+modalPageNo2+'&keyword='+keyword, {
		onCreate: function() { 
			showLoading('searchResult', 'Getting list, please wait...',  "120px");
		},
		onException: function() { 
			showFailure('searchResult');
		}, 
		asynchronous:false, 
		evalScripts:true
	});
}