function showDataChecking() {
	try {
		new Ajax.Request(contextPath
				+ "/GIACDataCheckController?action=showDataChecking", {
			asynchronous : true,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					hideNotice();
					$("mainContents").update(response.responseText);
					hideAccountingMainMenus();
					$("acExit").show();
				}
			}
		});
	} catch (e) {
		showErrorMessage("showDataChecking", e);
	}
}