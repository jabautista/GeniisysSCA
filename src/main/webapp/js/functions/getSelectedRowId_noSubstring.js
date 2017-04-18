function getSelectedRowId_noSubstring(rowName){
	var id = "";
	$$('div[name="'+rowName+'"]').each(function (row)	{
		if (row.hasClassName("selectedRow"))	{
			id = row.readAttribute("id");
		}
	});
	return id;
}