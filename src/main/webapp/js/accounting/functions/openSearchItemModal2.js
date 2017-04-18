function openSearchItemModal2(param) {
	modalPageNo2 = param;
	new Ajax.Updater("searchResult", contextPath
			+ "/GIACUnidentifiedCollnsController?action=getItemSearchResult",
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
					tranYear : $F("ucTranYear"),
					tranMonth : $F("ucTranMonth"),
					tranSeqNo : $F("ucTranSeqNo")
				},
				asynchronous : true,
				evalScripts : true
			});
	modalPageNo2 = 1;
}