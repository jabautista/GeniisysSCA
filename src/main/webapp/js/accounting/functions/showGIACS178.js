function showGIACS178() {
	try {
		new Ajax.Request(contextPath + "/GIACCashReceiptsReportController", {
			parameters : {
				action : "showGIACS178"
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
		showErrorMessage("Direct Premium Collections", e);
	}
}