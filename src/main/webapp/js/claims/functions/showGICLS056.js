function showGICLS056(){
	new Ajax.Request(contextPath + "/GICLCatastrophicEventController", {
	    parameters : {action : "showGICLS056"},
	    onCreate: showNotice("Loading, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGICLS056", e);
			}								
		} 
	});
}