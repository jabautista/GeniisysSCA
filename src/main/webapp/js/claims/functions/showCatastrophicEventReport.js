function showCatastrophicEventReport(){
	try {
		new Ajax.Request(contextPath + "/GICLCatastrophicEventController", {
			method : "POST",
			parameters : {action 	: "showCatastrophicEventReport"},
	        onCreate   : showNotice("Loading Catastrophic Event Report, please wait..."),
	        onComplete : function(response){
	        	hideNotice();
	        	if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
	        }
		});
	}catch(e){
		showErrorMessage("showCatastrophicEventReport", e);
	}
}