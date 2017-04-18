/**
 * @Created By : Steven 
 * @Date Created : 11.21.2013
 * @Description GIISS098
 */
function showGiiss098() {
	try {
		new Ajax.Request(contextPath + "/GIISFireConstructionController", {
			method : "POST",
			parameters : {
				action : "showGiiss098"
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
		showErrorMessage("showGiiss098", e);
	}
}