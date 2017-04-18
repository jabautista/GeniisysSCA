function showTrialBalancePerSL() { // Kris 07.19.2013
	try {
		new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController",{
					parameters : {action : "showTrialBalancePerSL"},
					asynchronous : false,
					evalScripts : true,
					onCreate : function() {
						showNotice("Loading Trial Balance per SL Page, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						hideAccountingMainMenus();
						$("acExit").show();
						$("mainContents").update(response.responseText);
					}
				});
	} catch(e){
		showErrorMessage("showTrialBalancePerSL", e);
	}
}