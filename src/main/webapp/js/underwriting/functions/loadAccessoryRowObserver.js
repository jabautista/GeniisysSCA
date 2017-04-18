/*	Created by	: mark jm 12.23.2010
 * 	Description	: set the observer for accessory div
 * 	Parameters	: row - observer target
 */
function loadAccessoryRowObserver(row){
	try{		
		loadRowMouseOverMouseOutObserver(row);
		
		row.observe("click", function(){
			$("selAccessory").enable();			
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){						
				($$("div#accListing div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
				loadSelectedAccessory(row);
			}else{				
				setAccessoryForm(null);
			}
		});			
	}catch(e){
		showErrorMessage("loadAccessoryRowObserver", e);
		//showMessageBox("loadAccessoryRowObserver : " + e.message);
	}
}