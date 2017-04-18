/**
 * Robert July 27, 2011
 * GIUTS002
 */
function showNegPostedDist(){
	new Ajax.Updater("mainContents", contextPath+"/GIPIPolbasicPolDistV1Controller", {
		method: "GET",
		parameters: {
			action : "showNegPostedDist"
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			showNotice("Getting Posted Distribution, please wait...");
		},
		onComplete: function(){
			hideNotice();
			setModuleId("GIUTS002");
			setDocumentTitle("Distribution Negation");
		}
	});
}