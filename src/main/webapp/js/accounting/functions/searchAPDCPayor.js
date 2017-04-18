function searchAPDCPayor(page, keyword) {
	if (page == "" || page == null) {
		page = 1;
	}
	if (keyword == null) {
		keyword = $F("keyword");
	}

	new Ajax.Updater(
			"searchResult",
			contextPath
					+ "/GIACAcknowledgmentReceiptsController?action=getAPDCPayorListing",
			{
				method : "POST",
				parameters : {
					fundCd : objACGlobal.fundCd,
					branchCd : objACGlobal.branchCd,
					pageNo : page,
					keyword : keyword
				},
				evalScripts : true,
				asynchronous : true,
				onCreate : function() {
					showNotice("Getting APDC Payor listing. Please wait...");
				},
				onSuccess : function() {
					hideNotice("");
				}
			});
}