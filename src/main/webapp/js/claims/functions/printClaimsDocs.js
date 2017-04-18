/*
 * belle 09132011
 * GICLS041 Claims Print Documents
 */
function printClaimsDocs(){
	new Ajax.Updater("basicInformationMainDiv", contextPath + "/GICLClaimsController?action=printClaimsDocs", { //replace "dynamicDiv" to "basicInformationMainDiv" by Niknok 11.29.2011
		method: "GET",
		parameters: {
			claimId : objCLMGlobal.claimId
		},
		asynchronous: true,
		evalScripts: true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete: function (response){
			hideNotice("");
			setModuleId("GICLS041");
			setDocumentTitle("Print Claims Documents");
			objGIPIS100.callingForm = "GICLS041"; // andrew - 04.23.2012 - for view policy information
		}
	});
}