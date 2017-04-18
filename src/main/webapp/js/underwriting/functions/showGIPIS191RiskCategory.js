function showGIPIS191RiskCategory() {
	try {
		new Ajax.Updater("mainContents", contextPath + "/GIPIUwreportsExtController", {
			parameters : {
				action : "showGIPIS191RiskCategory"
			},
			asynchronous : true,
			evalScripts : true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response) {
				hideNotice();
			}
		});
	} catch (e) {
		showErrorMessage("showGIPIS191RiskCategory", e);
	}
}