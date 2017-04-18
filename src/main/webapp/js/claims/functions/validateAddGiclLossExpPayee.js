function validateAddGiclLossExpPayee(){
	if(checkLossExpChildRecords()){
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}else if(objCurrGICLItemPeril == null){
		showMessageBox("Please select an item first.", "I");
		return false;
	}else if(nvl(payeeInsertSw, "N") == "Y"){
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}else if($("selPayeeType").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "selPayeeType");
		return false;
	}else if($("payeeClass").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "payeeClass");
		return false;
	}else if($("payee").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "payee");
		return false;
	}else if($("selPayeeType").value == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("Cannot create another record. Loss for this peril has been closed/withdrawn/denied.", "I");
		return false;
	}else if($("selPayeeType").value == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("Cannot create another record. Expense for this peril has been closed/withdrawn/denied.", "I");
		return false;
	}
	return true;
}