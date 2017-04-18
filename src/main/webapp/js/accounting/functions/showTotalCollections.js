//added by john dolon 8.7.2013
function showTotalCollections(){
	try{
		new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
			parameters : {action : "showTotalCollections"},
			onCreate: function(){
				showNotice("Loading Total Collections, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showTotalCollections", e);
	}
}