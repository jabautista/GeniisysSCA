// Joms
function showGIACS329() {
	try {
		new Ajax.Request(
				contextPath + "/GIACCreditAndCollectionReportsController",
				{
					method : "POST",
					parameters : {
						action : "showAgingOfPremRec"
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Loading Aging of Premiums Receivable, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGIACS329", e);
	}
}