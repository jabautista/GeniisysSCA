/**
 * @Created By : John 
 * @Date Created : 11.27.2013
 * @Description GIISS035 - Required Document Maintenance
 */
function showGiiss035() {
	try {
		new Ajax.Request(contextPath + "/GIISRequiredDocController", {
			method : "POST",
			parameters : {
				action : "showGiiss035"
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
		showErrorMessage("showGiiss035", e);
	}
}