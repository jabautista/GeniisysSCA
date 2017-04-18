//bonok :: 08.28.2013 :: GICLS211
function showGICLS211(){
	new Ajax.Request(contextPath + "/GICLLossProfileController", {
	    parameters : {
	    	action : "showGICLS211",
	    	moduleId : "GICLS211"
	    },
	    onCreate: showNotice("Loading Loss Profile page.  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGICLS211: ", e);
			}								
		} 
	});
}