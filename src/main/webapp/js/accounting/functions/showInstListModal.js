function showInstListModal(page, issCd, premSeqNo) {
	Modalbox
			.show(
					contextPath
							+ "/GIACAcknowledgmentReceiptsController?action=showInstNoList&ajaxModal=1&issCd="
							+ issCd + "&premSeqNo=" + premSeqNo, {
						title : "List of Available Inst. No.",
						width : 500
					});
}