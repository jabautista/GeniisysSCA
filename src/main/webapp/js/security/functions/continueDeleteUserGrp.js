function continueDeleteUserGrp() {
	new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController", {
		method: "GET",
		parameters: {
			action: "deleteUserGroup",
			userGrp: $F("userGrp"),
			ajax: "1"
		},
		asynchronous: true,
		evalScripts: true,
		onCreate: showNotice("Deleting user group, please wait..."),
		onComplete: function (response) {
			if (checkErrorOnResponse(response)) {
				$("row"+$F("userGrp")).remove();
				//$("notice").hide();
				hideNotice();
			}
		}
	});
}