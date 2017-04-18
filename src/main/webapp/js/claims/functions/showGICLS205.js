//bonok :: 08.22.2013 :: GICLS205
function showGICLS205(){
	new Ajax.Request(contextPath + "/GICLLossRatioController", {
	    parameters : {action : "showGICLS205"},
	    onCreate: showNotice("Loading Loss Ratio Details page.  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("GICLS205 - onComplete : ", e);
			}								
		} 
	});
}