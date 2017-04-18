function checkLossExpBillForUpdate(){
	if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("Record cannot be updated. Loss for this peril has been closed/withdrawn/denied.", "I");
		enableDisableBillForm("disable");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("Record cannot be updated. Expense for this peril has been closed/withdrawn/denied.", "I");
		enableDisableBillForm("disable");
		return false;
	}else{
		if(nvl(objCurrGICLClmLossExpense.cancelSw, "N") == "Y"){
			showMessageBox("Record cannot be updated. History has already been cancelled.", "I");
			enableDisableBillForm("disable");
			return false;
		}else{
			enableDisableBillForm("enable");
			return true;
		}
	}
}