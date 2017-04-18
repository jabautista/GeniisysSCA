// Kris 2012.10.25 // Modified by Joms Diago 06.18.2013
function showPremiumCollectionsMainPage() {
	try {
		// new Ajax.Request(/*"mainContents",*/
		// contextPath+"/pages/accounting/cashReceipts/reports/premiumCollections/premiumCollections.jsp",{
		// new Ajax.Updater("mainContents",
		// contextPath+"/pages/accounting/cashReceipts/reports/premiumCollections/premiumCollections.jsp",{
		// method: "GET",
		new Ajax.Request(contextPath
				+ "/GIACPremiumCollectionsReportController", {
			method : "POST",
			parameters : {
				action : "showPremiumCollections"
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function() {
				showNotice("Loading Premium Collections, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		/*
		 * onComplete: function() { hideNotice("");
		 * Effect.Appear($("mainContents").down("div", 0), {duration: .001}); }
		 */
		});
	} catch (e) {
		showErrorMessage("showPremiumCollectionsMainPage", e);
	}
}