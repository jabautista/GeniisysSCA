/**
 * @Created By : steven
 * @Date Created : 06.13.2013
 * @Description GIACS105
 */
function showInwardBusiness() {
	try {
		new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
			method : "POST",
			parameters : {
				action : "showInwardBusiness"
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