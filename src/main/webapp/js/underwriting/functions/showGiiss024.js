/**
 * @Created By : Steven 
 * @Date Created : 11.13.2013
 * @Description GIISS024
 */
function showGiiss024() {
	try {
		new Ajax.Request(contextPath + "/GIISS024Controller", {
			method : "POST",
			parameters : {
				action : "showGiiss024",
				mode : "region"
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
		showErrorMessage("showGiiss024", e);
	}
}