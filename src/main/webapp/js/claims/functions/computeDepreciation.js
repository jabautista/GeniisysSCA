function computeDepreciation(dedSw){
	try{
		new Ajax.Request(contextPath+"/GICLLossExpDtlController", {
			asynchronous: false,
			parameters:{
				action: "computeDepreciation",
				claimSublineCd: objCLMGlobal.sublineCd,
				claimId: objCurrGICLClmLossExpense.claimId,
				clmLossId: objCurrGICLClmLossExpense.claimLossId,
				lineCd: objCurrGICLLossExpDtl.lineCd,
				sublineCd: objCurrGICLLossExpDtl.sublineCd,
				lossExpType: objCurrGICLLossExpDtl.lossExpType,
				itemNo: objCurrGICLClmLossExpense.itemNo,
				dedSw: dedSw
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "SUCCESS") == "SUCCESS"){
						var func = dedSw == "Y" ? retrieveLossExpDeductibles : refreshHistoryDetails; 
						showWaitingMessageBox("Depreciation has just been computed for this history.", "I", func);
					}else{
						showMessageBox(response.responseText, "I");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("computeDepreciation", e);	
	}
}