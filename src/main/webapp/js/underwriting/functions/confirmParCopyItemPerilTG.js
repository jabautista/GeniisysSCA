/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.11.2011	mark jm			first validation in copying an item with perils
 */
function confirmParCopyItemPerilTG(){
	try{
		//if($("deductiblesTable1") == null){
		//	loadDeductibleTables();
		//}
		
		objFormMiscVariables.miscCopyPeril = "Y";
		
		var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 1, "T");
		
		if(itemTsiDeductibleExist && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
			showConfirmBox("Deductibles", "The PAR has existing policy level deductible/s based on % of TSI. " + 
					"Copying an item and peril info will delete the existing deductible/s. Continue?",
					"Yes", "No", function(){
					objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
					confirmParCopyItem2TG();
				}, stopProcess);			
		}else{
			confirmParCopyItem2TG();
		}
	}catch(e){
		showErrorMessage("confirmParCopyItemPerilTG", e);		
	}
}