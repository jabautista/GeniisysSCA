/*
 * Created By 	: andrew robes
 * Date			: November 5, 2010
 * Description	: Shows a confirm message box which the user can choose whether to add or delete items
 * Parameters	: itemListingId - id of div containing the rows
 * 				  itemRowName - name of rows
 * 				  pObjPolbasics - array of policy being endorsed 
 */
function selectAddDeleteOption(itemListingId, itemRowName, pObjPolbasics) {
	try {
		objFormMiscVariables.miscNbtInvoiceSw = "Y";
		if (objUWParList.binderExist == "Y" && objFormMiscVariables.miscNbtInvoiceSw == "Y"){
			showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);		
			objFormMiscVariables.miscNbtInvoiceSw = "N";
			return false;
		}
		
		showConfirmBox4("Delete/Add All Items", "What processing would you like to perform?", "Add", "Delete", "Cancel",
				function() {
					showItemSelection(1, itemListingId, itemRowName, pObjPolbasics);
				},
				function() {
					showItemSelection(2, itemListingId, itemRowName, pObjPolbasics);
				},
				""
			);
	} catch (e) {
		showErrorMessage("selectAddDeleteOption", e);
	}
}