function checkLossExpTaxType(){
	var test = 0;
	new Ajax.Request(contextPath+"/GICLLossExpTaxController?action=checkLossExpTaxType", {
		method: "POST",
		parameters: {
			claimId : objCLMGlobal.claimId,
			clmLossId : objCurrGICLClmLossExpense.claimLossId
		},
		asynchronous: false,
		onCreate: showNotice("Checking Loss/Expense tax..."),
		onComplete: function (response){
			hideNotice();
			if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
				test = response.responseText;
			}
		}
	});
	return test;
}