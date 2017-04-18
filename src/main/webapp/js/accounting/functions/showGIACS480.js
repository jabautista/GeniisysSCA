// Joms
function showGIACS480() {
	try {
		new Ajax.Request(
				contextPath + "/GIACCreditAndCollectionReportsController",
				{
					method : "POST",
					parameters : {
						action : "showBillingStatement"
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Loading Billing Statement (Salary Deduction), please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGIACS480", e);
	}
}