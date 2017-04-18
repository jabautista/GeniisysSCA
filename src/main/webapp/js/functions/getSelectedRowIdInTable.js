//get the id of the record within a div
//parameter: 
//rowName: name of the rows
//tableId: id of the div containing the rows
//return: id
function getSelectedRowIdInTable(tableId, rowName)	{
	var id = "";
	$$('div#'+tableId+' div[name="'+rowName+'"]').each(function (row)	{
		if (row.hasClassName("selectedRow"))	{
			id = (row.readAttribute("id")).substring(rowName.length);
		}
	});
	return id;
}