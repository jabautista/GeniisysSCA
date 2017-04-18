function openAccountCodeModal() {
	Modalbox
			.show(
					contextPath
							+ "/GIACUnidentifiedCollnsController?action=openAccountCodeModal&ajaxModal=1",
					{
						title : "List of Values: Account Code",
						width : 800
					});
}