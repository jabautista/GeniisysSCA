// don't select any row in a list table
// parameters:
// tableId: id of the table containing the rows/list
// rowName: name of the rows
function deselectRows(tableId, rowName) {
	$$("div#"+tableId+" div[name='"+rowName+"']").each(function (row) {
		row.removeClassName("selectedRow");
	});	
}