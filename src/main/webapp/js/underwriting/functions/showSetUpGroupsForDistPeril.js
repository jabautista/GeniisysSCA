//belle 07072011
function showSetUpGroupsForDistPeril(){
	new Ajax.Updater("mainContents", contextPath+"/GIPIPolbasicPolDistV1Controller", {
		method: "GET",
		parameters: {
			action : "showSetUpGroupsForDistPeril"
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			showNotice("Getting Set-up Groups for Distribution (Peril), please wait...");
		},
		onComplete: function(){
			hideNotice();
			setModuleId("GIUWS018");
			setDocumentTitle("Set-up Peril Groups for Distribution (Final)");
		}
	});
}