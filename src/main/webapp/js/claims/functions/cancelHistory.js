function cancelHistory(){
	try{
		if(nvl(objCurrGICLClmLossExpense.distSw, "N") == "Y"){
			showMessageBox("Cannot cancel distributed history.", "I");
		}else if(nvl(objCurrGICLClmLossExpense.adviceId, "") != ""){
			showMessageBox("Cannot cancel history, advice already exists.", "I");
		}else{
			new Ajax.Request(contextPath+"/GICLClaimLossExpenseController", {
				asynchronous: true,
				parameters:{
					action: "cancelHistory",
					claimId: objCLMGlobal.claimId,
				    clmLossId: nvl(objCurrGICLClmLossExpense.claimLossId, 0),
				    histSeqNo: nvl(objCurrGICLClmLossExpense.historySequenceNumber, 0),
				    itemNo: nvl(objCurrGICLItemPeril.itemNo, 0),
				    perilCd: nvl(objCurrGICLItemPeril.perilCd, 0),
				    payeeType: objCurrGICLLossExpPayees.payeeType,
				    payeeClassCd: objCurrGICLLossExpPayees.payeeClassCd,
				    payeeCd:  objCurrGICLLossExpPayees.payeeCd
				},
				onCreate: function(){
					showNotice("Processing, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox("Cancellation of history successful.", "I", refreshHistoryDetails);
						}else{
							showMessageBox(response.responseText, "E");							
						}
					}else{
						showMessageBox(response.responseText, "E");
					}	
				}
			});
		}
	}catch(e){
		showErrorMessage("cancelHistory", e);
	}
}