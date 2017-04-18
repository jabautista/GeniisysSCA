/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.11.2011	mark jm			first validation in copying an item (no perils)
 */
function confirmParCopyItemTG(){
	try{
		//if($("deductiblesTable2") == null && $("deductiblesTable3") == null){
		//	loadDeductibleTables();
		//}
		
		objFormMiscVariables.miscCopyPeril = "N";
		
		var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 2, "T");
		
		if(itemTsiDeductibleExist && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
			showConfirmBox("Deductibles", "The PAR has existing item level deductible/s based on % of TSI. " + 
					"Copying the item info will not copy the existing deductible/s because there is no TSI yet for the item. " +
					"Continue?", "Yes", "No", confirmParCopyItem2TG, stopProcess);
		}else{
			confirmParCopyItem2TG();
		}
	}catch(e){
		showErrorMessage("confirmParCopyItemTG", e);
	}
}