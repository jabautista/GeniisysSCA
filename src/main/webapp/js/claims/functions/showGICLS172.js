//Gzelle 11.07.2013 Motor Car Repair Type Maintenance
function showGICLS172(){
	new Ajax.Request(contextPath + "/GICLRepairTypeController", {
	    parameters : {action : "showGicls172"},
	    onCreate: showNotice("Retrieving Motor Car Repair Type Maintenance, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGicls172 - onComplete : ", e);
			}								
		} 
	});
}