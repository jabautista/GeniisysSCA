function validateDeleteLossExpDeductible(){
	if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("You cannot delete this record.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("You cannot delete this record.", "I");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.distSw, "N") == "Y"){
		showMessageBox("You cannot delete this record.", "E");
		return false;
	}else if(hasPendingLossExpDeductibleRecords()){
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}
	return true;
}