// Joms
function showGIACS414() {
	try {
		new Ajax.Request(
				contextPath + "/GIACCashReceiptsReportController",
				{
					method : "POST",
					parameters : {
						action : "showSchedOfAppliedComm"
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Loading Schedule of Applied Commissions, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGIACS414", e);
	}
}