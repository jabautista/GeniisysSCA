function checkLossExpDeductiblesForUpdate(){
	if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("Record cannot be updated. Loss for this peril has been closed/withdrawn/denied.", "I");
		enableDisableDeductibleForm("disable");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("Record cannot be updated. Expense for this peril has been closed/withdrawn/denied.", "I");
		enableDisableDeductibleForm("disable");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.distSw, "N") == "Y"){
		showMessageBox("You cannot update this record, distribution has been made.", "I");
		enableDisableDeductibleForm("disable");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.withEvalPayment, "N") == "Y" && $("hidEnableUpdSetHist").value != "Y"){
		showMessageBox("You cannot update this record, this was created using motorcar evaluation report.", "I");
		enableDisableDeductibleForm("disable");
		return false;
	}else{
		enableDisableDeductibleForm("enable");
		return true;
	}
}