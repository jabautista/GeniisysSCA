function openAccountCodeModal2(param) {
	modalPageNo2 = param;
	new Ajax.Updater("searchResult", contextPath
			+ "/GIACUnidentifiedCollnsController?action=getAcctCdSearchResult",
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
					glAcctCategory : $F("glAcctCategory"),
					glControlAcct : $F("glControlAcct"),
					glSubAcct1 : $F("acctCode1"),
					glSubAcct2 : $F("acctCode2"),
					glSubAcct3 : $F("acctCode3"),
					glSubAcct4 : $F("acctCode4"),
					glSubAcct5 : $F("acctCode5"),
					glSubAcct6 : $F("acctCode6"),
					glSubAcct7 : $F("acctCode7")

				},
				asynchronous : true,
				evalScripts : true
			});
	modalPageNo2 = 1;
}