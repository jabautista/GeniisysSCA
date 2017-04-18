/*
 * Tonio 6.17.2011
 * GICLS052 Loss Recovery Listing
 */
function showLossRecoveryListing(lineCd){
	new Ajax.Updater("dynamicDiv", contextPath + "/GICLClaimsController?action=showLossRecoveryListing", {
		method: "GET",
		parameters: {
			lineCd : lineCd
		},
		asynchrous: true,
		evalScripts: true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete: function (response){
			hideNotice("");
		}
	});
}
