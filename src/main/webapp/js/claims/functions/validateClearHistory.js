function validateClearHistory(){
	if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("Delete of record(s) for peril that is already Closed/Withdrawn/Denied is not allowed.", "E");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("Delete of record(s) for peril that is already Closed/Withdrawn/Denied is not allowed.", "E");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.distSw, "N") == "Y"){
		showMessageBox("Delete of record(s) for distributed history is not allowed.", "E");
		return false;
	}else{
		var confirmMsg = "Are you sure you want to delete all detail information of this history?";
		if(nvl(objCurrGICLClmLossExpense.withLossExpTax, "N") == "Y"){
			confirmMsg = "Deleting detail record(s) of this history will automatically delete existing "+
						 "tax record(s). Do you want to continue?";
		}
		showConfirmBox("Confirmation", confirmMsg, "Yes", "No", 
				function(){clearHistory();}, function(){});
	}
}