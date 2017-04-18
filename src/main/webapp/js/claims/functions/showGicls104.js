//Kris 11.25.2013: GICLS104 - Loss/Expense Code Maintenance 
function showGicls104(){
	new Ajax.Request(contextPath + "/GIISLossExpController", {
		method : "POST",
		parameters : {action 	: "showGicls104"},
        onCreate   : showNotice("Loading, please wait..."),
        onComplete : function(response){
        	hideNotice();
			if(checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
        }
	});
}