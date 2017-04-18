/**
 * @module GIACS091
 * @description Dated Checks
 * @author John Dolon
 * @date 7.4.2014
 */
function showGiacs091() {
	try {
		new Ajax.Request(contextPath + "/GIACApdcPaytDtlController", {
			method : "POST",
			parameters : {
				action : "showGiacs091"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGiacs091", e);
	}
}