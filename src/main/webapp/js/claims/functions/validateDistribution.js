function validateDistribution(){
	if(objCurrGICLItemPeril == null){
		showMessageBox("Please select an item first.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees == null){
		showMessageBox("Please select a payee first.", "I");
		return false;
	}else if(objCurrGICLClmLossExpense == null){
		showMessageBox("Please select a history record first.", "I");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.cancelSw, "N") == "Y"){
		showMessageBox("Cannot distribute record, history was cancelled.", "I");
		return false;
	}else if($("selPayeeType").value == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("Record cannot be updated. Loss for this peril has been closed/withdrawn/denied.", "I");
		return false;
	}else if($("selPayeeType").value == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("Record cannot be updated. Expense for this peril has been closed/withdrawn/denied.", "I");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.distSw, "N") == "Y"){
		showMessageBox("Record cannot be updated, distribution has already been made for this record.", "I");
		return false;
	}else{
		var distRG = $("radioUW").checked ? "1" : "2";
		var action = $("btnDistribute").value == "Redistribute" ? "redistributeLossExpHistory" : "distributeLossExpHistory";
		distributeLossExpHistory(distRG, action);
	}
}