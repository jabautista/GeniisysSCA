// show all rows of a listing table, primary use is to show all rows after filtering the list
// parameters:
// tableId: id of the table that contains the list
// rowName: name of each row in the table
function showAllRows(tableId, rowName) {
	$$("div#"+tableId+" div[name='"+rowName+"']").each(function (div)	{
		div.show();
	});
}