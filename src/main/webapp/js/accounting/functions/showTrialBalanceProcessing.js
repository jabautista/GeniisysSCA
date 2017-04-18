function showTrialBalanceProcessing() {
	try {
		new Ajax.Request(
				contextPath
						+ "/GIACTrialBalanceController?action=showTrialBalanceProcessing",
				{
					asynchronous : true,
					evalScripts : true,
					onCreate : function() {
						showNotice("Loading, please wait...");
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showTrialBalanceProcessing", e);
	}
}