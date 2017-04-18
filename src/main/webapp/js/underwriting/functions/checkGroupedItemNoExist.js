function checkGroupedItemNoExist(){
	var ok = true;
	var selected = 0;
	
	$$("div[name='grpItem']").each(function(row){
		if (row.hasClassName("selectedRow")){
			selected = 1;
		}	
	});	
	
	if (selected == 0){
		showMessageBox("Please select an Enrollee in Grouped Items first.", imgMessage.ERROR);
		ok = false;
	}
	return ok;
}