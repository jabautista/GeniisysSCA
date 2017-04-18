function validateNegateHistory(){
	if(objCurrGICLItemPeril == null){
		showMessageBox("Please select an item first.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees == null){
		showMessageBox("Please select a payee first.", "I");
		return false;
	}else if(objCurrGICLClmLossExpense == null){
		showMessageBox("Please select a history record first.", "I");
		return false;
	}else if($("selPayeeType").value == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("Cannot negate distribution. Loss for this peril has been closed/withdrawn/denied.", "I");
		return false;
	}else if($("selPayeeType").value == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("Cannot negate distribution. Expense for this peril has been closed/withdrawn/denied.", "I");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.adviceId, "") != ""){
		showMessageBox("Cannot negate distribution. Advice already exists.", "I");
		return false;
	}else{
		new Ajax.Request(contextPath+"/GICLLossExpDsController", {
			asynchronous: false,
			parameters:{
				action: "checkXOL",
				claimId: objCurrGICLClmLossExpense.claimId,
				clmLossId: objCurrGICLClmLossExpense.claimLossId,
				catastrophicCd: objCLMGlobal.catastrophicCd
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.claimId, "") != ""){
						confirmNegation(obj);
					}else{
						showMessageBox(response.responseText, "E");
						return false;
					}
				}else{
					showMessageBox(response.responseText, "E");
					return false;
				}
			}
		});
	}
}