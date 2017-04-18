/**
 * @Created By : Steven 
 * @Date Created : 11.27.2013
 * @Description GIISS219
 */
function showGiiss219() {
	try {
		new Ajax.Request(contextPath + "/GIISS219Controller", {
			method : "POST",
			parameters : {
				action : "showGiiss219",
				type : "regular",
				mode : "giisPlan" 
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
		showErrorMessage("showGiiss219", e);
	}
}