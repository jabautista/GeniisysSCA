/*	Created by	: mark jm 12.23.2010
 * 	Description	: set the observer for all item div
 */
function loadItemRowObserver(){
	try{
		$$("div#itemTable div[name='row']").each(function(row){
			loadRowMouseOverMouseOutObserver(row);

			row.observe("click", function(){
				clickParItemRow(row, objGIPIWItem);					
			});
		});	
	}catch(e){
		showErrorMessage("loadItemRowObserver", e);
		//showMessageBox("loadItemRowObserver : " + e.message);
	}
}