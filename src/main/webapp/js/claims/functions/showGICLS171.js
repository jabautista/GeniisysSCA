function showGICLS171(){
	new Ajax.Request(contextPath + "/GICLMcLpsController", {
	    parameters : {action : "showGicls171"},
	    onCreate: showNotice("Loading, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGICLS171", e);
			}								
		} 
	});
}