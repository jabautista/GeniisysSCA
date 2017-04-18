/**
 * Irwin Tabisora
 * Aug.5.11
 * GICLS011 Claim Required Documents
 * */

function showClaimRequiredDocs(){
	new Ajax.Updater("basicInformationMainDiv", contextPath+"/GICLReqdDocsController",{
		method: "GET",
		parameters: {
			action: "getDocumentTableGridListing",
			lossCatCd: objCLMGlobal.lossCatCd,
			claimId: objCLMGlobal.claimId
		},
		asynchrous: true,
		evalScripts: true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete: function (response){
			hideNotice("");
			objGIPIS100.callingForm = "GICLS011"; // andrew - 04.23.2012 - for view policy information
		}
	});
}