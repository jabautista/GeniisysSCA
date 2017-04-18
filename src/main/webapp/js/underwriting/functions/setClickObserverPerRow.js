/*	Created by	: Jerome Orio 03.24.2010
 * 	Description	: create the click observer for the row
 * 	Parameter	: row - div container of the record
 * 				: tableLising - id/name of the table where the record is located
 * 				: rowName - name used in table record listing
 * 				: supplyRow - function to call on supply row
 * 				: elseFunc - function to call on else condition
 */
function setClickObserverPerRow(row, tableListing, rowName, supplyRow, elseFunc){
	try{
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$$("div#"+tableListing+" div[name="+rowName+"]").each(function(r){
					if (row.getAttribute("id") != r.getAttribute("id")){
						r.removeClassName("selectedRow");
					}else{
						supplyRow();
					}	
				});
			}else{
				elseFunc();
			}		
		});	
	}catch(e){
		showErrorMessage("setClickObserverPerRow", e);
	}	
}