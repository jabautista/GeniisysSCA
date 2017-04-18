/**
 * @Created By : Kenenth L.
 * @Date Created : 10.11.2013
 * @Description showBatchReports
 */
function showBatchReports() {
	try {
		new Ajax.Request(contextPath + "/GIACEndOfMonthReportsController", {
			method : "POST",
			parameters : {
				action : "showBatchReports"
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
				}
			}
		});
	} catch (e) {
		showErrorMessage("showBatchReports", e);
	}
}