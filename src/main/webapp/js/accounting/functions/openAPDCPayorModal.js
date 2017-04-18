function openAPDCPayorModal() {
	Modalbox
			.show(
					contextPath
							+ "/GIACAcknowledgmentReceiptsController?action=openAPDCPayorModal&ajaxModal=1",
					{
						title : "Search APDC Payor",
						width : 800
					});
}