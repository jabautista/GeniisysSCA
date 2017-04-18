function validateAddGiclClmLossExpense(){
	if(hasPendingClmLossExpRecords()){
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}else if(objCurrGICLItemPeril == null){
		showMessageBox("Please select an item first.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees == null){
		showMessageBox("Please select a payee first.", "I");
		return false;
	}else if($("txtHistSeqNo").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtHistSeqNo");
		return false;
	}else if($("txtHistStatus").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtHistStatus");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		var msg = $("btnAddClmLossExp").value == "Add" ? "Cannot create another history." : "Record cannot be updated.";
		showMessageBox(msg + " Loss for this peril has been closed/withdrawn/denied.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		var msg = $("btnAddClmLossExp").value == "Add" ? "Cannot create another history." : "Record cannot be updated.";
		showMessageBox(msg + " Expense for this peril has been closed/withdrawn/denied.", "I");
		return false;
	}
	return true;
}