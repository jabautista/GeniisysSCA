/*	Created by	: mark jm
 * 	Description	: check first if record has item deductible before proceeding to copy item
 * 
 */
function confirmCopyItem(){
	try{			
		// load deductibles table to get records
		if($("deductiblesTable2") == null && $("deductiblesTable3") == null){
			loadDeductibleTables();
		}
		objFormMiscVariables.miscCopyPeril = "N";
		//objFormMiscVariables[0].copyPeril = "N";
		
		// check deductible
		
		var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 2, "T"); // andrew - 11.9.2010 - added this loop to check if there is existing deductible based on % of TSI
		
		//if($$("div#deductiblesTable2 div[name='ded2']").size() > 0){
		if(itemTsiDeductibleExist){ // andrew - 11.9.2010 - changed the condition
			showConfirmBox("Deductibles", "The PAR has existing item level deductible/s based on % of TSI. " + 
					"Copying the item info will not copy the existing deductible/s because there is no TSI yet for the item. " +
					"Continue?", "Yes", "No", confirmCopyItem2, stopProcess);
		}else{
			confirmCopyItem2();
		}			
	}catch(e){
		showErrorMessage("confirmCopyItem", e);
	}
}