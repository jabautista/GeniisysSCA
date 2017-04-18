function checkAcctRecordStatus(tranId, moduleId){
	var result = false;
	
	new Ajax.Request(contextPath + "/GIACOrderOfPaymentController", {
		parameters: {
			action: "checkRecordStatus",
			tranId: tranId,
			moduleId: moduleId
		},
		asynchronous: false,
		onCreate : showNotice("Processing, please wait..."),
		onComplete : function(response){
			hideNotice();
			if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
				result = true;
			}
		}
	});
	
	return result;
}