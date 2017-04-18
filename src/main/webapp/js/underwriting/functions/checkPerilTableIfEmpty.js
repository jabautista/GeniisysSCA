function checkPerilTableIfEmpty(rowName, itemPerilDiv, tableId) {
	if($$("div#"+itemPerilDiv+" div[name='"+rowName+"']").size() < 1) {
		Effect.Fade(tableId, {
			duration: .001
		});
	} else {
		Effect.Appear(tableId, {
			duration: .001
		});
	}
}