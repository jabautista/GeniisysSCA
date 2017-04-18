/* benjo 03.08.2017 SR-5945 */
function checkLossExpTaxExists(obj){	
	var result = false;
	new Ajax.Request(contextPath+"/GICLLossExpTaxController?action=checkLossExpTaxExist", {
		method: "POST",
		parameters: {
			claimId   : objCLMGlobal.claimId,
			clmLossId : obj.clmLossId,
			lossExpCd : ""
		},
		asynchronous: false,
		onCreate: showNotice("Checking Loss/Expense tax..."),
		onComplete: function (response){
			hideNotice();
			if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
				if(response.responseText=="Y"){
					result = true;
				}else{
					result = false;
				}
			}
		}
	});
	return result;
}