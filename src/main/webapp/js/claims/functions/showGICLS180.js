function showGICLS180(){
	new Ajax.Request(contextPath + "/GICLReportDocumentController", {
	    parameters : {action : "showGICLS180",
	    			  moduleId : "GICLS180"},
	    onCreate: showNotice("Loading page, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGICLS180 - onComplete : ", e);
			}								
		} 
	});
}