// kenneth L. for Monthly Trial Balance 07.19.2013
function showMonthlyTrialBalance() {
	try {
		new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController", {
			parameters : {
				action : "showMonthlyTrialBalance"
			},
			onCreate : function() {
				showNotice("Loading Monthly Trial Balance, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showMonthlyTrialBalance", e);
	}
}