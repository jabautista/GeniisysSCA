function createSettlementForLossExpEvalReport(evalId, paramPerilCd){
	try{
		new Ajax.Request(contextPath+"/GICLMcEvaluationController", {
			asynchronous: false,
			parameters:{
				action: "createSettlementForLossExpEvalReport",
				claimId: objCurrGICLItemPeril.claimId,
				itemNo : objCurrGICLItemPeril.itemNo,
				perilCd: objCurrGICLItemPeril.perilCd,
				evalId : evalId,
				paramPerilCd: paramPerilCd
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "SUCCESS") == "SUCCESS"){
						showWaitingMessageBox("Settlement has been created.", "I", refreshLossExpensePage);
					}else{
						showMessageBox(response.responseText, "E");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("distributeLossExpHistory", e);
	}
}