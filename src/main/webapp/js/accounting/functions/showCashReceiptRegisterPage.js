/**
 * Shows Cash Receipt Register Page moduleId: GIACS117 created by: Shan date
 * created: 06.13.2013
 */
function showCashReceiptRegisterPage() {
	try {
		new Ajax.Request(contextPath + "/GIACCashReceiptsReportController", {
			method : "POST",
			parameters : {
				action : "showCashReceiptRegisterPage"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showCashReceiptRegisterPage", e);
	}
}