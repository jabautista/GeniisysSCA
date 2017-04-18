//check if table in modalboxes is empty, if empty hide it muna, else show it
//parameter: rowName, id of the container
function checkTableIfEmptyinModalbox(rowName, tableId) {
	if($$("div[name='"+rowName+"']").size() < 1) {
		Effect.Fade(tableId, {
			duration: .001,
			afterFinish: function () {
				Modalbox.resizeToContent();
			}
		});
	} else {
		Effect.Appear(tableId, {
			duration: .001,
			afterFinish: function () {
				Modalbox.resizeToContent();
			}
		});
	}
}