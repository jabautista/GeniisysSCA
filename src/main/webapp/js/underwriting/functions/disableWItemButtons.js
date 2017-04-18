function disableWItemButtons() {
	$$("input[name='btnWItem']").each(function(btn) {
		disableButton(btn.id);
	});
}