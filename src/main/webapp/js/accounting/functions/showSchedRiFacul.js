/**
 * @Created By : steven
 * @Date Created : 06.07.2013
 * @Description GIACS106
 */
function showSchedRiFacul() {
	try {
		new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
			method : "POST",
			parameters : {
				action : "showSchedRiFacul"
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
		showErrorMessage("showSchedRiFacul", e);
	}
}