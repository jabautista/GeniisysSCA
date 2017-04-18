/**
 * Get the selected RowElement object
 * #genericFunction
 * @author rencela
 * @param rowName
 * @return row object
 */
function getSelectedRow(rowName){
	var rowElement = null;
	try{
		var al = $$("div[name='" + rowName + "']").size();
		$$("div[name='" + rowName + "']").each(function(row){
			if(row.hasClassName("selectedRow")){
				rowElement = row;
			}
		});
	}catch(e){
		showErrorMessage("getSelectedRow(rowName)", e);
	}
	return rowElement;
}