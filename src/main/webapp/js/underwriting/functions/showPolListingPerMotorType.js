function showPolListingPerMotorType() {
	try {
		new Ajax.Request(contextPath + "/GIPIVehicleController", {
			method: "GET",
			parameters : {
				action : "showPolListingPerMotorType"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate : showNotice("Loading Policy Listing per Motor Type page, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showPolListingPerMotorType", e);
	}
}