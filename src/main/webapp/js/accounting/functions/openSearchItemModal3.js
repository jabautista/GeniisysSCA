function openSearchItemModal3() {
	modalPageNo2 = 1;
	new Ajax.Updater("searchResult", contextPath
			+ "/GIACUnidentifiedCollnsController?action=getItemSearchResult2",
			{
				onCreate : function() {
					showLoading("searchResult", "Getting list, please wait...",
							"100px");
				},
				onException : function() {
					showFailure('searchResult');
					pageNo: modalPageNo2;
				},
				parameters : {
					pageNo : modalPageNo2,
					gaccTranId : objACGlobal.gaccTranId,
					keyword : $F("itemNoKeyword")
				},
				asynchronous : true,
				evalScripts : true
			});
	modalPageNo2 = 1;
}