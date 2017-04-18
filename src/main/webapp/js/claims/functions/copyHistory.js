function copyHistory(histSeqNo){
	try{
		new Ajax.Request(contextPath+"/GICLClaimLossExpenseController", {
			asynchronous: true,
			parameters:{
				action: "copyHistory",
				histSeqNo : histSeqNo,
				claimId: objCLMGlobal.claimId,
				itemNo: nvl(objCurrGICLItemPeril.itemNo, 0),
				perilCd: nvl(objCurrGICLItemPeril.perilCd, 0),
				groupedItemNo : nvl(objCurrGICLItemPeril.groupedItemNo, 0),
				lineCd : objCLMGlobal.lineCd,
				clmClmntNo: objCurrGICLLossExpPayees.clmClmntNo,
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
					showWaitingMessageBox(response.responseText, "I", refreshHistoryDetails);
				}else{
					showMessageBox(response.responseText, "E");
				}	
			}
		});
	}catch(e){
		showErrorMessage("copyHistory", e);
	}
}