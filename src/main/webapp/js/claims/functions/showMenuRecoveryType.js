/**
 * Module: GICLS101 
 * @author Steven 
 * @date 10.22.2013
 */
function showMenuRecoveryType(){
	new Ajax.Request(contextPath + "/GIISRecoveryTypeController", {
		method : "POST",
		parameters : {action 	: "showMenuRecoveryType"},
        onCreate   : showNotice("Loading, please wait..."),
        onComplete : function(response){
        	hideNotice();
			if(checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
        }
	});
}