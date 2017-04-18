// check if table is empty, if empty hide it muna, else show it
// parameter: rowName, id of the container
function checkTableIfEmpty(rowName, tableId) {
	if($$("div[name='"+rowName+"']").size() < 1) {
		Effect.Fade(tableId, {
			duration: .001
		});
	} else {
		Effect.Appear(tableId, {
			duration: .001
		});
	}
}