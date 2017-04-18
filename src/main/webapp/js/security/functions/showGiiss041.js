function showGiiss041() {
	try {
		new Ajax.Request(contextPath + "/GIISUserGroupMaintenanceController", {
			parameters: {
				action: "showGIISS041"
			},
			onCreate: showNotice("Retrieving User Group Maintenance, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showGiiss041", e);
	}
}