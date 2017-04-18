//Gzelle 11.26.2013 Non-Renewal Reason Maintenance
function showGIISS210(){
	new Ajax.Request(contextPath + "/GIISNonRenewReasonController", {
	    parameters : {action : "showGiiss210"},
	    onCreate: showNotice("Retrieving Non-Renewal Reason Maintenance, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGIISS210 - onComplete : ", e);
			}								
		} 
	});
}