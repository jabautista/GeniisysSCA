//Gzelle 09.13.2013	Update Initial, General, Endt Info
function showUpdateInitialEtc(){
	new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
	    parameters : {action : "showUpdateInitialEtc",
	    			    ajax : 1},
	    onCreate: showNotice("Loading Update Initial, General, Endt Info.  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showUpdateInitialEtc - onComplete : ", e);
			}								
		} 
	});
}