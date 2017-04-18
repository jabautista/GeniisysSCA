function showGiacs321() {
	try {
		new Ajax.Request(contextPath + "/GIACModuleEntryController", {
			method : "POST",
			parameters : {
				action : "showGiacs321"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGiacs321", e);
	}
}