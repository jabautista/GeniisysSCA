function negateLossExpHistory(vXol, vCurrXol){
	try{
		new Ajax.Request(contextPath+"/GICLLossExpDsController", {
			asynchronous: false,
			parameters:{
				action: "negateLossExpHistory",
				claimId: objCurrGICLClmLossExpense.claimId,
				clmLossId: objCurrGICLClmLossExpense.claimLossId,
				payeeClassCd: objCurrGICLClmLossExpense.payeeClassCode,
				payeeCd: objCurrGICLClmLossExpense.payeeCode,
				catastrophicCd: objCLMGlobal.catastrophicCd,
				lineCd : objCLMGlobal.lineCd,
				vXol: vXol,
				vCurrXol: vCurrXol
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					showWaitingMessageBox(response.responseText, "I", refreshHistoryDetails);
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("negateLossExpHistory", e);
	}
}