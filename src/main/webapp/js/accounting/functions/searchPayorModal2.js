function searchPayorModal2(elem) {
	modalPageNo2 = elem.value;
	new Ajax.Updater(
			"searchResult",
			"GIACOrderOfPaymentController?action=getSearchResult",
			{
				onCreate : function() {
					showLoading("searchResult", "Getting list, please wait...",
							"100px");
				},
				onException : function() {
					showFailure('searchResult');
				},
				parameters : {
					pageNo : modalPageNo2,
					keyword : $F("keyword"),
					riCommTag : $("riCommTag") != null ? ($("riCommTag").checked ? "Y"
							: "N")
							: "N"
				},
				asynchronous : true,
				evalScripts : true
			});
	modalPageNo2 = 1;
}