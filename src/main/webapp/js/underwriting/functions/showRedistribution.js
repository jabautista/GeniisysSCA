/**
 * Emman August 11, 2011
 * GIUWS012
 */
function showRedistribution(){
	if (checkBatchAccountingProcess()) {
		new Ajax.Updater("mainContents", contextPath+"/GIPIPolbasicController", {
			method: "GET",
			parameters: {
				action : "showRedistributionPage"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function(){
				showNotice("Getting Redistribution, please wait...");
			},
			onComplete: function(){
				hideNotice();
				setModuleId("GIUTS021");
				setDocumentTitle("Redistribution");
			}
		});
	}
}