function reloadInstList(page, issCd, premSeqNo) {
	new Ajax.Updater(
			"instNoListDiv",
			contextPath
					+ "/GIACAcknowledgmentReceiptsController?action=reloadInstNoList&page="
					+ page + "&issCd=" + issCd + "&premSeqNo=" + premSeqNo, {
				method : "GET",
				evalScripts : true,
				asynchronous : false
			});
}