/**
 * Module: GICLS100 
 * @author Steven 
 * @date 11.08.2013
 */
function showGicls100(){
	new Ajax.Request(contextPath + "/GIISRecoveryStatusController", {
		method : "POST",
		parameters : {action 	: "showGicls100"},
        onCreate   : showNotice("Loading, please wait..."),
        onComplete : function(response){
        	hideNotice();
			if(checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
        }
	});
}