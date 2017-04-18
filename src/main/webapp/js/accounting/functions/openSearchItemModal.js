function openSearchItemModal() {
	var selectedTrans = $("ucTranType").options[$("ucTranType").selectedIndex]
			.getAttribute("tranTypeCode");
	if (selectedTrans == 2) {
		Modalbox
				.show(
						contextPath
								+ "/GIACUnidentifiedCollnsController?action=openSearchItemModal&ajaxModal=1",
						{
							title : "GI Unidentified Collections",
							width : 800
						});
	}
}