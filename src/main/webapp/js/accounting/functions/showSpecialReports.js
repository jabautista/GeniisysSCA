/**
 * @Created By : steven
 * @Date Created : 07.23.2013
 * @Description GIACS151
 */
function showSpecialReports() {
	try {
		new Ajax.Request(contextPath + "/GIACEndOfMonthReportsController", {
			method : "POST",
			parameters : {
				action : "showSpecialReports"
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
		showErrorMessage("showSpecialReports", e);
	}
}