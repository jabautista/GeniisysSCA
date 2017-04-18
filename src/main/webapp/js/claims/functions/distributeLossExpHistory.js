function distributeLossExpHistory(distRG, action){
	try{
		new Ajax.Request(contextPath+"/GICLLossExpDsController", {
			asynchronous: false,
			parameters:{
				action: action,
				claimId: objCurrGICLClmLossExpense.claimId,
				clmLossId: objCurrGICLClmLossExpense.claimLossId,
				itemNo: objCurrGICLClmLossExpense.itemNo,
				perilCd: objCurrGICLClmLossExpense.perilCode,
				payeeCd: objCurrGICLClmLossExpense.payeeCode,
				payeeType: objCurrGICLClmLossExpense.payeeType,
				groupedItemNo: nvl(objCurrGICLClmLossExpense.groupedItemNo, 0),
				histSeqNo: objCurrGICLClmLossExpense.historySequenceNumber,
				nbtDistDate: $("hidDfltDistDate").value,
				distSw: nvl(objCurrGICLClmLossExpense.distSw, "N"),
				distRG: distRG
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "SUCCESS") == "SUCCESS"){
						showWaitingMessageBox("Distribution Complete.", "I", refreshHistoryDetails);
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