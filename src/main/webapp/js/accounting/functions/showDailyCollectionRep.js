function showDailyCollectionRep() {
	try {
		new Ajax.Request(contextPath + "/GIACCashReceiptsReportController", {
			parameters : {
				action : "showDailyCollectionRep"
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
		showErrorMessage("showDailyCollectionRep", e);
	}
}