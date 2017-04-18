/**
 * Module: GICLS182
 * @author Shan 
 * @date 11.26.2013
 */
function showGICLS182(){
	new Ajax.Request(contextPath + "/GICLAdvLineAmtController", {
		method : "POST",
		parameters : {action 	: "showGICLS182"},
        onCreate   : showNotice("Loading, please wait..."),
        onComplete : function(response){
        	hideNotice();
			if(checkErrorOnResponse(response)){
				$("dynamicDiv").update(response.responseText);
			}
        }
	});
}