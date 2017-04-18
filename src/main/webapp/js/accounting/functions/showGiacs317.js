/**
 * @Created By : John Dolon 
 * @Date Created : 12.5.2013
 * @Description GIACS317
 */
function showGiacs317() {
	try {
		new Ajax.Request(contextPath + "/GIACModuleController", {
			method : "POST",
			parameters : {
				action : "showGiacs317"
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
		showErrorMessage("showGiacs317", e);
	}
}