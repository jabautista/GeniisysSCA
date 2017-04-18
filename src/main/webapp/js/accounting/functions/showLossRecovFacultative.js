/**
 * @Created By : steven
 * @Date Created : 06.14.2013
 * @Description GIACS119
 */
function showLossRecovFacultative() {
	try {
		new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
			method : "POST",
			parameters : {
				action : "showLossRecovFacultative"
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
		showErrorMessage("showInwardBusiness", e);
	}
}