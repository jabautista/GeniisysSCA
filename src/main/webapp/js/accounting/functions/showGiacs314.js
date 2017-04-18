/**
 * @Created By : John Dolon 
 * @Date Created : 11.29.2013
 * @Description GIACS314
 */
function showGiacs314() {
	try {		
		new Ajax.Request(contextPath + "/GIACFunctionController", {
			method : "POST",
			parameters : {
				action : "showGiacs314"
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
		showErrorMessage("showGiacs314", e);
	}
}