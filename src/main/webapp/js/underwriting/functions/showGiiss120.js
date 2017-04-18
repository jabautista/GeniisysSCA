/**
 * @Created By : Steven 
 * @Date Created : 11.21.2013
 * @Description GIISS120
 */
function showGiiss120() {
	try {
		new Ajax.Request(contextPath + "/GIISPackageBenefitController", {
			method : "POST",
			parameters : {
				action : "showGiiss120"
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
		showErrorMessage("showGiiss120", e);
	}
}