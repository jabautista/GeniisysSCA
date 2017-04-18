function validateDeleteLossExpBill(){
	if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("You cannot delete this record.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("You cannot delete this record.", "I");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.cancelSw, "N") == "Y"){
		showMessageBox("You cannot delete this record.", "E");
		return false;
	}
	return true;
}