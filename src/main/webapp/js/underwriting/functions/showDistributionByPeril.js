/**
 * Emman July 19, 2011
 * GIUWS012
 */
function showDistributionByPeril(loadRecords){
	new Ajax.Updater("mainContents", contextPath+"/GIPIPolbasicPolDistV1Controller", {
		method: "GET",
		parameters: {
			action : "showDistributionByPeril",
			loadRecords: nvl(loadRecords, "N")
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			showNotice("Getting Distribution by Peril, please wait...");
		},
		onComplete: function(){
			hideNotice();
			setModuleId("GIUWS012");
			setDocumentTitle("Distribution by Peril");
		}
	});
}