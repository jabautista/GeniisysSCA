function showCloseGL() {
	try {
		new Ajax.Request(contextPath + "/GIACCloseGLController", {
			parameters : {
				action : "showCloseGL"
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
				}
			}
		});
	} catch (e) {
		showErrorMessage("showCloseGL", e);
	}
}