// Joms
function showGIACS200() {
	try {
		new Ajax.Request(
				contextPath + "/GIACBookedUnbookedCollections",
				{
					method : "POST",
					parameters : {
						action : "showBookedUnbookedCollections"
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Loading Collections for Booked and Unbooked Policies, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGIACS200", e);
	}
}