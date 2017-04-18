/**
 * @Created By : Kenenth L.
 * @Date Created : 10.30.2013
 * @Description showAcctgProdReports
 */
function showAcctgProdReports() {
	try {
		new Ajax.Request(contextPath + "/GIACEndOfMonthReportsController", {
			method : "POST",
			parameters : {
				action : "showAcctgProdReports"
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
		showErrorMessage("showAcctgProdReports", e);
	}
}