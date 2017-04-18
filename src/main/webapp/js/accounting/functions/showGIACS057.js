// Joms
function showGIACS057() {
	try {
		new Ajax.Request(contextPath + "/GIACGenearalDisbReportController", {
			method : "POST",
			parameters : {
				action : "showPaytReqList"
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function() {
				showNotice("Loading Payment Request List, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGIACS057", e);
	}
}