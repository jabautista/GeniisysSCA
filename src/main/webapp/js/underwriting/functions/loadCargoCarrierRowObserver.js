/*	Created by	: mark jm 03.09.2011
 * 	Description	: set the observer for cargo carrier div
 * 	Parameters	: row - observer target
 */
function loadCargoCarrierRowObserver(row){
	try{
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){				
				var id = row.getAttribute("id");				
				$$("div#cargoCarrierTable div:not([id='" + id + "'])").invoke("removeClassName", "selectedRow");
				loadSelectedCarrier(row);				
			}else{
				setCargoCarrierForm(null);
			}
		});
	}catch(e){
		showErrorMessage("loadCargoCarrierRowObserve", e);
	}	
}