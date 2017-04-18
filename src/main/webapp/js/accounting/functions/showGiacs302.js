/**
 * @Created By : Steven 
 * @Date Created : 11.07.2013
 * @Description GIACS302
 */
function showGiacs302() {
	try {
		new Ajax.Request(contextPath + "/GIISFundsController", {
			method : "POST",
			parameters : {
				action : "showGiacs302"
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
		showErrorMessage("showGiacs302", e);
	}
}