// andrew 06.29.2010
// Hides the table column headers if the there is no visible row.
// parameters: tableId - id of the div container
// 			   rowName - name of the div used as row
function checkTableIfEmpty2(rowName, tableId) {
	var rowCount = 0;
	
	$$("div[name='"+rowName+"']").each(function(row){
		if(row.getStyle("display") != "none"){
			rowCount++;
		}
	});
	
	if(rowCount < 1) {
		Effect.Fade(tableId, {
			duration: .001
		});
	} else {
		Effect.Appear(tableId, {
			duration: .001
		});
	}
}