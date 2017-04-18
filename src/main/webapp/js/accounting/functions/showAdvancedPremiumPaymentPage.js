/**
 * Shows Advanced Premium Payment Page moduleId: GIACS170 created by: Shan date
 * created: 06.18.2013
 */

function showAdvancedPremiumPaymentPage() {
	try {
		new Ajax.Request(contextPath + "/GIACCashReceiptsReportController", {
			parameters : {
				action : "showAdvancedPremPaytPage"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Loading, please wait.."),
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showAdvancedPremiumPaymentPage", e);
	}
}