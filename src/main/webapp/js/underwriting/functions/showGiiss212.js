/**
 * @Created By : Steven 
 * @Date Created : 11.11.2013
 * @Description GIISS212
 */
function showGiiss212() {
	try {
		new Ajax.Request(contextPath + "/GIISSpoilageReasonController", {
			method : "POST",
			parameters : {
				action : "showGiiss212"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGiiss212", e);
	}
}