/*
 * Pol Cruz 07.01.2013 JV Register Report
 */
function showGIACS127() {
	try {
		new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController", {
			parameters : {
				action : "showGIACS127"
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
		showErrorMessage("JV Register", e);
	}
}