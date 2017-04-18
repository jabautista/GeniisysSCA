/**
 * @Created By : steven
 * @Date Created : 06.18.2013
 * @Description GIACS181
 */
function showpremCededToFacultativeRi() {
	try {
		new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
			method : "POST",
			parameters : {
				action : "showpremCededToFacultativeRi"
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
		showErrorMessage("showpremCededToFacultativeRi", e);
	}
}