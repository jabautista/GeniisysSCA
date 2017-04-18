function checkPaytHistory(currentRec){
	try {
		new Ajax.Request(contextPath+"/GICLClaimReserveController", {
			method: "POST",
			parameters: {
				action: "checkPaytHistory",
				claimId : objCLMGlobal.claimId,
				itemNo : objCurrGICLItemPeril.itemNo,
				perilCd : objCurrGICLItemPeril.perilCd,
				groupedItemNo : objCurrGICLItemPeril.groupedItemNo
			},
			onSuccess: function(response){
				if (response.responseText == "EXISTS"){
					enableButton("paymentHistoryBtn");
				} else {
					disableButton("paymentHistoryBtn");
				}
			}
		});
	} catch (e){
		showErrorMessage("checkPaytHistory", e);
	}
}