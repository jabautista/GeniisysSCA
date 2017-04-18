//Gzelle 11.08.2013 Motor Car Replacement Part Maintenance
function showGICLS058(){
	new Ajax.Request(contextPath + "/GICLMcPartCostController", {
	    parameters : {action : "showGicls058"},
	    onCreate: showNotice("Retrieving Motor Car Replacement Part Maintenance, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGicls058 - onComplete : ", e);
			}								
		} 
	});
}