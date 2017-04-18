/**
 * Add observe functions to the mortgagee listing of the sub-policies of a Package PAR
 * @author Veronica V. Raymundo
 * 
 */

function loadPackMortgageeRowObserver(row){
	try{		
		loadRowMouseOverMouseOutObserver(row);
		
		row.observe("click", function ()	{
			$("mortgageeName").enable();
			row.toggleClassName("selectedRow");				
			if (row.hasClassName("selectedRow")){				
				($$("div#mortgageeListing div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				loadPackSelectedMortgagee(row);								
			}else{			
				setMortgageeForm(null);
			}
		});		
	}catch(e){
		showErrorMessage("loadPackMortgageeRowObserver", e);
	}
}