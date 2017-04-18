/**
 * @Created By : Steven 
 * @Date Created : 10.23.2013
 * @Description GIACS313
 */
function showGiacs313() {
	try {
		new Ajax.Request(contextPath + "/GIACUsersController", {
			method : "POST",
			parameters : {
				action : "showGiacs313"
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
		showErrorMessage("showGiacs313", e);
	}
}