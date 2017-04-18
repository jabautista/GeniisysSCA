// shan : 11.26.2013
function showGiacs301() {
	try {
		new Ajax.Request(contextPath + "/GIACParametersController", {
			method : "POST",
			parameters : {
				action : "showGiacs301",
				moduleId : "GIACS301"
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
		showErrorMessage("showGiacs301", e);
	}
}