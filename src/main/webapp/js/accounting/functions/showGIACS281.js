function showGIACS281() {
	try {
		new Ajax.Request(contextPath + "/GIACCashReceiptsReportController", {
			method : "POST",
			parameters : {
				action : "showListOfBankDeposits"
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
		showErrorMessage("showListOfBankDeposits", e);
	}
}