//bonok :: 07.30.2013 :: GICLS204
function showGICLS204(){
	new Ajax.Request(contextPath + "/GICLLossRatioController", {
	    parameters : {action : "showGICLS204"},
	    onCreate: showNotice("Loading Loss Ratio page.  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("GICLS204 - onComplete : ", e);
			}								
		} 
	});
}