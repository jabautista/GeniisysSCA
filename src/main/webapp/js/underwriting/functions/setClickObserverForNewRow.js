/*	Created by	: mark jm 10.19.2010
 * 	Description	: create the click observer for the copied row
 * 	Parameter	: row - div container of the record
 * 				: objArray - array of objects that holds all records of a certain table
 * 				: tableLising - id/name of the table where the record is located
 * 				: rowName - name used in table record listing
 */
function setClickObserverForNewRow(row, objArray, tableListing, rowName){
	try{
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				var id = row.getAttribute("id");
				$$("div#" + $(tableListing).up("div", 0).id + " div[name'" + rowName + "']").each(function(r){
					if(id != r.getAttribute("id")){
						r.removeClassName("selectedRow");
					}
				});
				
				loadSelection(rowName, row);
			}else{
				//setValues(rowName, null);
				loadSelection(rowName, row);
			}
		});
	}catch(e){
		showErrorMessage("setClickObserverForNewRow", e);
		//showMessageBox("setClickObserverForNewRow : " + e.message);
	}
}