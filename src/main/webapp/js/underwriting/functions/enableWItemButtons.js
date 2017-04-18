function enableWItemButtons() {
	$$("input[name='btnWItem']").each(function(btn) {
		enableButton(btn.id);
	});
}