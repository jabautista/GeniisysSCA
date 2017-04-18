/**
 * Shows PDC Register Page moduleId: GIACS093 created by: Shan date created:
 * 06.17.2013
 */

function showPDCRegisterPage() {
	try {
		new Ajax.Request(contextPath + "/GIACCashReceiptsReportController", {
			parameters : {
				action : "showPDCRegisterPage"
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
		showErrorMessage("showPDCRegisterPage", e);
	}
}