// kenneth L. for Monthly Trial Balance 07.19.2013
function showTrialBalanceAsOf() {
	try {
		new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController", {
			parameters : {
				action : "showTrialBalanceAsOf"
			},
			onCreate : function() {
				showNotice("Loading Trial Balance As Of, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showTrialBalanceAsOf", e);
	}
}