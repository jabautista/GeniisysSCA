/*	Created by	: mark jm 03.14.2011
 * 	Description	: set the observer for casualty personnel div
 * 	Parameters	: row - observer target
 */
function loadCasualtyPersonnelRowObserver(row){
	try{
		loadRowMouseOverMouseOutObserver(row);
		
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				var id = row.getAttribute("id");
				$$("div#casualtyPersonnelTable div:not([id='" + id + "'])").invoke("removeClassName", "selectedRow");
				loadSelectedCasualtyPersonnel("rowCasualtyPersonnel", row);					
			}else{
				setCasualtyPersonnelForm(null);
			}
		});
	}catch(e){
		showErrorMessage("loadCasualtyPersonnelRowObserver", e);
	}
}