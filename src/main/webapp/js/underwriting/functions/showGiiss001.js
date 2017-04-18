/**
 * @Created By : Steven 
 * @Date Created : 12.11.2013
 * @Description GIISS001
 */
function showGiiss001() {
	try {
		new Ajax.Request(contextPath + "/GIISLineController", {
			method : "POST",
			parameters : {
				action : "getLineMaintenance",
				ajax : "1"
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
		showErrorMessage("showGiiss001", e);
	}
}