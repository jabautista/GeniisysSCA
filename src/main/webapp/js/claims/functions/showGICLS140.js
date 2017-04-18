//Gzelle 11.21.2013 Payee Class Maintenance
function showGICLS140(){
	new Ajax.Request(contextPath + "/GIISPayeeClassController", {
	    parameters : {action : "showGicls140"},
	    onCreate: showNotice("Retrieving Payee Class Maintenance, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGICLS140 - onComplete : ", e);
			}								
		} 
	});
}