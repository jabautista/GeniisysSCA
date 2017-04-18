//DCB User Maintenance shan : 12.06.2013
function showGiacs319() {
	try {
		new Ajax.Request(contextPath + "/GIACDCBUserController", {
			method : "POST",
			parameters : {
				action : "showGiacs319",
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
		showErrorMessage("showGiacs319", e);
	}
}