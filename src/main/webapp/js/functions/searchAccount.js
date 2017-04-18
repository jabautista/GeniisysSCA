function searchAccount(){
	var keyword = $('inAccountOf').value;
	if (keyword.length<3){
		Modalbox.hide();
	} else	{
		new Ajax.Updater('searchResult','GIISAssuredController?action=getAssuredListing&pageNo='+acctPageNo+'&keyword='+keyword, {onCreate:function(){ showLoading('searchResult');},onException:function(){ showFailure('searchResult');}, synchronous:true, evalScripts:true});
	}
	acctPageNo = 1;
}