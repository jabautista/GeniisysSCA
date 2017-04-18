/*
 * Tonio 8.2.2011
 * GICLS010 Claim Basic Information
 */
function showClaimBasicInformation(){
	objCLMGlobal.callingForm = nvl(objCLMGlobal.claimId,null) == null ? "GICLS001" :"GICLS002"; 
	//new Ajax.Updater("dynamicDiv", contextPath + "/GICLClaimsController?action=showClaimBasicInfo", { // andrew - 02.24.2012
	new Ajax.Updater(($("claimInfoDiv") ? "claimInfoDiv" :"dynamicDiv"), contextPath + "/GICLClaimsController?action=showClaimBasicInfo", {
		method: "GET",
		parameters: {
			claimId: objCLMGlobal.claimId,
			lineCd: objCLMGlobal.lineCd
		},
		asynchronous: false,
		evalScripts: true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete: function (response){
			try {
				hideNotice("");
				if ($F("userLevel") == '0'){
					showMessageBox($F("accessErrMessage"), imgMessage.ERROR);
					showClaimListing();
				}
				objGIPIS100.callingForm = "GICLS010"; // andrew - 04.23.2012 - for view policy information
				$("claimInfoDiv") ? $("claimInfoDiv").show() :null; // andrew - 02.24.2012
				$("claimListingMainDiv") ? $("claimListingMainDiv").hide() :null;  // andrew - 02.24.2012 - hide the listing to retain the filtered records
				//newFormInstance();
				
			//	$("claimInfoDiv") ? $("claimInfoDiv").show() :null; // andrew - 02.24.2012
			//	$("claimListingMainDiv") ? $("claimListingMainDiv").hide() :null;  // andrew - 02.24.2012 - hide the listing to retain the filtered records
				$("lossRecoveryListingMainDiv") ? $("lossRecoveryListingMainDiv").hide() :null;
				newFormInstance();
			} catch(e){
				showErrorMessage("showClaimBasicInformation - onComplete", e);
			}
			
		}
	});
}