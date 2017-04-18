/**
 * Module: GICLS059
 * @author Steven 
 * @date 12.13.2013
 */
function showGicls059(){
	try {
		new Ajax.Request(contextPath + "/GICLMcDepreciationController", {
		    parameters : {action : "showGicls059"},
		    onCreate: showNotice("Loading, Please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} 
		});
	} catch(e){
		showErrorMessage("showGicls059", e);
	}	
}