/**
 * Module: GICLS105
 * @author Shan 
 * @date 10.23.2013
 */
function showGICLS105(){
	new Ajax.Request(contextPath + "/GIISLossCtgryController", {
		method : "POST",
		parameters : {action 	: "showGICLS105"},
        onCreate   : showNotice("Loading, please wait..."),
        onComplete : function(response){
        	hideNotice();
			if(checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
        }
	});
}