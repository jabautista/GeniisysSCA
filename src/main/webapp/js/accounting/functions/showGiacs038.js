//Transaction Month Maintenance shan : 12.12.2013
function showGiacs038() {
	try {
		new Ajax.Request(contextPath + "/GIACTranMmController", {
			method : "POST",
			parameters : {
				action : "showGiacs038",
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
		showErrorMessage("showGiacs038", e);
	}
}