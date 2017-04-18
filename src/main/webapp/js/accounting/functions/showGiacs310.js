function showGiacs310() {
	try {
		new Ajax.Request(contextPath + "/GIACAgingParametersController", {
			method : "POST",
			parameters : {
				action : "showGiacs310",
				moduleId : "GIACS310"
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
		showErrorMessage("showGiacs310", e);
	}
}