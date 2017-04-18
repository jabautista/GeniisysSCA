/*	Created by	: mark jm 03.11.2011
 * 	Description	: set the observer for grouped items div
 * 	Parameters	: row - observer target
 */
function loadGroupedItemsRowObserver(row){
	try{
		loadRowMouseOverMouseOutObserver(row);
		
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){				
				var id = row.getAttribute("id");				
				$$("div#groupedItemsTable div:not([id='" + id + "'])").invoke("removeClassName", "selectedRow");
				loadSelectedGroupedItem("rowGroupedItem", row);				
			}else{
				setGroupedItemsForm(null);
			}
		});
	}catch(e){
		showErrorMessage("loadgroupedItemsRowObserver", e);
	}
}