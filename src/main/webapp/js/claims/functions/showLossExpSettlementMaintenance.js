function showLossExpSettlementMaintenance(){
	new Ajax.Request(contextPath + "/GICLLossExpSettlementController", {
		method : "POST",
		parameters : {action 	: "showGICLS060"},
        onCreate   : showNotice("Retrieving Loss/Expense Settlement Status, please wait..."),
        onComplete : function(response){
        	hideNotice();
			if(checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
        }
	});
}