function continueUserDelete() {
	new Ajax.Request(contextPath+"/GIISUserMaintenanceController", {
		method: "GET",
		asynchronous: true,
		evalScripts: true,
		parameters: {
			action: "deleteUser",
			userId: $F("userId")
		},
		onCreate: showNotice("Deleting record, please wait..."),
		onComplete: function (response) {
			if (checkErrorOnResponse(response)) {
				hideNotice(response.responseText);
				if (response.responseText.include("SUCCESS")) {
					fadeElement("row"+$F("userId"), .5, clearUserId);
				}
			}
		}
	});
}