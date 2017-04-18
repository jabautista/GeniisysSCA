function showGIACS060() {
	try {
		new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController", {
			parameters : {
				action : "showGIACS060"
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
		showErrorMessage("Print GL Transactions", e);
	}
}