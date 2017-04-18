/**
 * Shows the Set-up Groups for Dist (Item)
 * 
 */
function showSetUpGroupsForDistPage(){
	new Ajax.Updater("mainContents", contextPath+"/GIPIPolbasicPolDistV1Controller", {
		method: "GET",
		parameters: {
			action : "showSetupGroupDistribution"
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			showNotice("Getting Set-up Groups for Distribution (Item), please wait...");
		},
		onComplete: function(){
			hideNotice();
			setModuleId("GIUWS010");
			setDocumentTitle("Set-up Groups for Distribution (Final)");
		}
	});
}