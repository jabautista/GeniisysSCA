/*	Created by	: mark jm
 * 	Description	: check first if record has a policy deductible before proceeding to copy item with peril
 */
function confirmCopyItemPeril(){
	try{
		// load deductibles table to get records
		if($("deductiblesTable1") == null){
			loadDeductibleTables();
		}

		// check deductible
		objFormMiscVariables.miscCopyPeril = "Y";
		//objFormMiscVariables[0].copyPeril = "Y";
		var polTsiDeductibleExist = checkDeductibleType(objDeductibles, 1, "T"); // andrew - 11.11.2010 - added this function call to check if there is a policy level deductible based on % TSI
			
		if(polTsiDeductibleExist){ // andrew - 11.11.2010 - changed the condition
			showConfirmBox("Deductibles", "The PAR has existing policy level deductible/s based on % of TSI. " +
					"Copying an item and peril info will delete the existing deductible/s. Continue?",
					"Yes", "No", confirmCopyItem2, stopProcess);
		}else{
			confirmCopyItem2();
		}
	}catch(e){
		showErrorMessage("confirmCopyItemPeril", e);
		//showMessageBox("confirmCopyItemPeril : " + e.message);
	}
}