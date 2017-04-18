/**
 * Tonio July 15, 2011
 * GIUWS013
 */
function showDistributionByGroup(loadRecords){
	new Ajax.Updater("mainContents", contextPath+"/GIPIPolbasicPolDistV1Controller", {
		method: "GET",
		parameters: {
			action : "showDistributionByGroup",
			loadRecords: nvl(loadRecords, "N")
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			showNotice("Getting Distribution by Group, please wait...");
		},
		onComplete: function(){
			hideNotice();
			setModuleId("GIUWS013");
			setDocumentTitle("One-Risk Distribution");
			hideNotice();
		}
	});
}