function validateIfToComputeDepreciation(dedSw){
	if(objCurrGICLItemPeril == null){
		showMessageBox("Please select an item first.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees == null){
		showMessageBox("Please select a payee first.", "I");
		return false;
	}else if(objCurrGICLClmLossExpense == null){
		showMessageBox("Please select a history record first.", "I");
		return false;
	}else if(objCurrGICLLossExpDtl == null){
		showMessageBox("Please select a history detail record first.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("Update of record(s) for peril that is already Closed/Withdrawn/Denied is not allowed.", "E");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("Update of record(s) for peril that is already Closed/Withdrawn/Denied is not allowed.", "E");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.distSw, "N") == "Y"){
		showMessageBox("Update of record(s) for distributed history is not allowed.", "E");
		return false;
	}else if(changeTag == 1 || checkLossExpChildRecords() || (dedSw == "Y" && hasPendingLossExpDeductibleRecords())){
		showMessageBox("Please save changes first before computing for depreciation.", "I");
		return false;
	}else{
		computeDepreciation(dedSw);	
	}
}