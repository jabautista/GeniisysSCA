function openSearchAccountOf2(assdNo,keyword) {
	new Ajax.Updater("searchResult","GIISAssuredController?action=getAcctOfListing&assdNo="+assdNo+"&keyword="+encodeURIComponent(keyword)+"&ajaxModal=1", { //added by steven 01/11/2013 "encodeURIComponent" hindi ko ma-explain kung pano nangyayari ung error,pero ang ginagawa niya kapag wala ung "encodeURIComponent" di niya nakikita ung "keyword" na parameter kahit wala kang nilagay na special character dun sa value nung keyword.
		onCreate: function() {
			showLoading("searchResult", "Getting list, please wait...", "100px");
		}, 
		onException: function() { 
			showFailure('searchResult');
		},
		asynchronous: false, 
		evalScripts: true
	});	
}