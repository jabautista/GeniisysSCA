function hasSelectedRow(rowName){
	var hasSelected = false;
	$$("div[name='" + rowName + "']").each(function(aRow){
		if(aRow.hasClassName("selectedRow")){
			hasSelected = true;
			$continue;
		}
	});
	return hasSelected;
}