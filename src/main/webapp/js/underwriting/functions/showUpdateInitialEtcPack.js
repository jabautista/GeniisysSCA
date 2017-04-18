// SR-21812 JET JUN-23-2016
function showUpdateInitialEtcPack(){
	new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
	    parameters : {action : "showUpdateInitialEtcPack",
	    			    ajax : 1},
	    onCreate: showNotice("Loading Update Initial, General, Endt Info.  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showUpdateInitialEtcPack - onComplete : ", e);
			}								
		} 
	});
}
