//Gzelle 09.26.2013	View User Information
function showViewUserInformation(){
	new Ajax.Request(contextPath + "/GIPIPolbasicController", {
	    parameters : {action : "showViewUserInformation"},
	    onCreate: showNotice("Loading View User Information,  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showViewUserInformation - onComplete : ", e);
			}								
		} 
	});
}