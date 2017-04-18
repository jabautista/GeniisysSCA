function showGIACS051() {
	try {
		new Ajax.Request(contextPath + "/GIACCopyJVController", {
			parameters : {
				action : "showCopyJV"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					hideAccountingMainMenus();
					$("mainContents").update(response.responseText);
					$("acExit").show();
				}
			}
		});
	} catch (e) {
		showErrorMessage("showCopyJV", e);
	}

}