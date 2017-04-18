/*	Created by	: mark jm 12.21.2010
 *	Description : The following functions are used for confirming before copying an item
 *				: (temporary)
 */
function confirmParCopyItem(){
	try{
		if($("deductiblesTable2") == null && $("deductiblesTable3") == null){
			loadDeductibleTables();
		}
		
		objFormMiscVariables.miscCopyPeril = "N";
		
		var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 2, "T");
		
		if(itemTsiDeductibleExist && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
			showConfirmBox("Deductibles", "The PAR has existing item level deductible/s based on % of TSI. " + 
					"Copying the item info will not copy the existing deductible/s because there is no TSI yet for the item. " +
					"Continue?", "Yes", "No", confirmParCopyItem2, stopProcess);
		}else{
			confirmParCopyItem2();
		}
	}catch(e){
		showErrorMessage("confirmParCopyItem", e);
		//showMessageBox("confirmParCopyItem : " + e.message);
	}
}