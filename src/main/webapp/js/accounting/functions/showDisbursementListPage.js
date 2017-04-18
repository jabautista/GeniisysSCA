/**
 * Shows Disbursement List Page * moduleId: GIACS273 * created by: shan * date
 * created: 06.27.2013
 */
function showDisbursementListPage() {
	try {
		new Ajax.Request(contextPath + "/GIACGenearalDisbReportController", {
			parameters : {
				action : "showDisbursementListPage"
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
		showErrorMessage("showDisbursementListPage", e);
	}
}