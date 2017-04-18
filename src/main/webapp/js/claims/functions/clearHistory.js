function clearHistory(){
	try{
		new Ajax.Request(contextPath+"/GICLClaimLossExpenseController", {
			asynchronous: true,
			parameters:{
				action: "clearHistory",
				claimId: objCLMGlobal.claimId,
			    clmLossId: nvl(objCurrGICLClmLossExpense.claimLossId, 0)
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						showWaitingMessageBox("History successfully cleared.", "I", refreshHistoryDetails);
					}else{
						showMessageBox(response.responseText, "E");							
					}
				}else{
					showMessageBox(response.responseText, "E");
				}	
			}
		});
	}catch(e){
		showErrorMessage("clearHistory", e);
	}
}