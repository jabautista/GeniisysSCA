/*	Created by	: mark jm 12.23.2010
 * 	Description	: set the observer for mortgagee div
 * 	Parameters	: row - observer target
 */
function loadMortgageeRowObserver(row){
	try{		
		loadRowMouseOverMouseOutObserver(row);
		
		row.observe("click", function ()	{
			$("mortgageeName").enable();
			row.toggleClassName("selectedRow");				
			if (row.hasClassName("selectedRow")){				
				($$("div#mortgageeListing div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				loadSelectedMortgagee(row);								
			}else{										
				setMortgageeForm(null);
			}
			checkIfCancelledEndorsement(); // added by: Nica 07.23.2012 - to check if to disable fields if PAR is a cancelled endt
		});		
	}catch(e){
		showErrorMessage("loadMortgageeRowObserver", e);
		//showMessageBox("loadMortgageeObserver : " + e.message);
	}
}