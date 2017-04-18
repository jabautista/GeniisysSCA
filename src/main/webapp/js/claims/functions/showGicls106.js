function showGicls106(){
	new Ajax.Request(contextPath + "/GIISLossTaxesController", {
		method : "POST",
		parameters : {action 	: "showGicls106"},
        onCreate   : showNotice("Retrieving Loss/Expense Tax Maintenance, please wait..."),
        onComplete : function(response){
        	hideNotice();
			if(checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
        }
	});
}