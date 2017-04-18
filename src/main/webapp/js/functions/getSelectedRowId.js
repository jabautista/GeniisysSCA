//get the id of the record
//parameter: 
//rowName: name of the rows
//return: id
function getSelectedRowId(rowName){
	var id = "";
	$$('div[name="'+rowName+'"]').each(function (row)	{
		if (row.hasClassName("selectedRow"))	{
			id = (row.readAttribute("id")).substring(rowName.length);
		}
	});
	return id;
}