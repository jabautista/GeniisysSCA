function openSearchPayorModal() {
	Modalbox
			.show(
					contextPath
							+ "/GIACOrderOfPaymentController?action=openSearchPayorModal&ajaxModal=1",
					{
						title : "Search Payor Name",
						width : 800
					});
}