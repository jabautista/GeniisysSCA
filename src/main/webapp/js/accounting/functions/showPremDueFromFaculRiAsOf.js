/**
 * @Created By : steven
 * @Date Created : 06.26.2013
 * @Description GIACS183
 */
function showPremDueFromFaculRiAsOf() {
	try {
		new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
			method : "POST",
			parameters : {
				action : "showPremDueFromFaculRiAsOf"
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
		showErrorMessage("showPremDueFromFaculRiAsOf", e);
	}
}