//Subsidiary Ledger Maintenance shan : 12.18.2013
function showGiacs309() {
	try {
		new Ajax.Request(contextPath + "/GIACSlListsController", {
			method : "POST",
			parameters : {
				action : "showGiacs309"
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
		showErrorMessage("showGiacs309", e);
	}
}