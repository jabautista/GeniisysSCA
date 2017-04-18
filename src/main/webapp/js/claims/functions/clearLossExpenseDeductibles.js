function clearLossExpenseDeductibles(){
	try{
		new Ajax.Request(contextPath+"/GICLLossExpDtlController", {
			asynchronous: false,
			parameters:{
				action: "clearLossExpenseDeductibles",
				claimId:   objCLMGlobal.claimId,
				clmLossId: objCurrGICLClmLossExpense.claimLossId,
				lineCd :   objCLMGlobal.lineCd,
				payeeType: objCurrGICLClmLossExpense.payeeType
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "SUCCESS") == "SUCCESS"){
						showWaitingMessageBox("Clearing deductibles successful.", "I", function(){
							lossExpHistWin.close();
							retrieveClmLossExpense(objCurrGICLLossExpPayees);
							clearAllRelatedClmLossExpRecords();
						});
					}else{
						showMessageBox(response.responseText, "E");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("clearLossExpenseDeductibles", e);	
	}
}