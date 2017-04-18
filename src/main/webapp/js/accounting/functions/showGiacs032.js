/**
 * @module GIACS032
 * @description Post dated Checks
 * @author John Dolon
 * @date 08.29.2014
 */
function showGiacs032() {
	try {
		new Ajax.Request(contextPath + "/GIACPdcChecksController", {
			method : "POST",
			parameters : {
				action : "showGiacs032"
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