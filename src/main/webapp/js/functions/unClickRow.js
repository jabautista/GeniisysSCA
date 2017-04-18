/* unclick rows in specified table */
function unClickRow(tableId){
	try{
		if(($$("div#" + tableId + " .selectedRow")).length > 0){
			fireEvent(($$("div#" + tableId + " .selectedRow"))[0], "click");
		}
	}catch(e){
		showErrorMessage("unClickRow", e);	
	}
}