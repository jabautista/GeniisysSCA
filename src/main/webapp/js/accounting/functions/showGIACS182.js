// Joms
function showGIACS182() {
	try {
		new Ajax.Request(
				contextPath + "/GIACReinsuranceReportsController",
				{
					method : "POST",
					parameters : {
						action : "showPremDueToRIAsOf"
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Loading Premium Ceded to Facultative RI as of, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGIACS182", e);
	}
}