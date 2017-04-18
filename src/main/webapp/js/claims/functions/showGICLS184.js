//Gzelle 11.14.2013 Nationality Maintenance
function showGICLS184(){
	new Ajax.Request(contextPath + "/GIISNationalityController", {
	    parameters : {action : "showGicls184"},
	    onCreate: showNotice("Retrieving Nationality Maintenance, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGicls184 - onComplete : ", e);
			}								
		} 
	});
}