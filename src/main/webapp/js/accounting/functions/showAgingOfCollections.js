// kenneth L. for aging of collections 07.02.2013
function showAgingOfCollections() {
	try {
		new Ajax.Request(contextPath
				+ "/GIACCreditAndCollectionReportsController", {
			parameters : {
				action : "showAgingOfCollections"
			},
			onCreate : function() {
				showNotice("Loading Aging of Collections, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showAgingOfCollections", e);
	}
}