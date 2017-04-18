function getSelectedRowIdInTable_noSubstring(tableId, rowName)	{
	var id = "";
	$$('div#'+tableId+' div[name="'+rowName+'"]').each(function (row)	{
		if (row.hasClassName("selectedRow"))	{
			id = row.readAttribute("id");
		}
	});
	return id;
}