function confirmParCopyItemPeril(){
	try{
		if($("deductiblesTable1") == null){
			loadDeductibleTables();
		}
		
		objFormMiscVariables.miscCopyPeril = "Y";
		
		var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 1, "T");
		
		if(itemTsiDeductibleExist && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
			showConfirmBox("Deductibles", "The PAR has existing policy level deductible/s based on % of TSI. " + 
					"Copying the item info will not copy the existing deductible/s because there is no TSI yet for the item. " +
					"Continue?", "Yes", "No", confirmParCopyItem2, stopProcess);
		}else{
			confirmParCopyItem2();
		}
	}catch(e){
		showErrorMessage("confirmParCopyItemPeril", e);
		//showMessageBox("confirmParCopyItemPeril : " + e.message);
	}
}