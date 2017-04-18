// set password
function setPassword(noPassword, changePasswordForExpiry) {
	//hideLoginMessage();
	var userId = ($("userId") != null ? $F("userId") : "${PARAMETERS['USER'].userId}");
	
	overlayChangePassword = Overlay.show(contextPath+"/GIISUserMaintenanceController", {
		urlContent : true,
		urlParameters: {action : "showChangePassword",
						userId : userId, 
						noPassword : noPassword,
						changePasswordForExpiry: changePasswordForExpiry},
	    title: "Change Password",
	    height: 188,
	    width: 430,
	    draggable: true,
	    closable : true
	});	
   	//showOverlayContent2(contextPath+"/GIISUserMaintenanceController?action=showChangePassword&userId="+userId+"&noPassword="+noPassword+"&changePasswordForExpiry="+changePasswordForExpiry, "Change Password", 420);
}