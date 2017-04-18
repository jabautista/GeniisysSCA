/**
 * @Created By : John 
 * @Date Created : 11.26.2013
 * @Description GIISS023 - Employee Position Maintenance
 */
function showGiiss023() {
	try {
		new Ajax.Request(contextPath + "/GIISPositionController", {
			method : "POST",
			parameters : {
				action : "showGiiss023"
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
		showErrorMessage("showGiiss023", e);
	}
}