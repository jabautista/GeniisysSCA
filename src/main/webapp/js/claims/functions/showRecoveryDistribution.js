/**
 * Shows Loss Recovery - Recovery Distribution
 * Module: GICLS054
 * @author Belle Bebing
 * @date 04.17.2012
 */
function showRecoveryDistribution(){
	try{
		//new Ajax.Updater("basicInformationMainDiv", contextPath+"/GICLClmRecoveryDistController",{ // andrew - 04.24.2012 - changed to Ajax.Request
		new Ajax.Request(contextPath+"/GICLClmRecoveryDistController",{
			parameters : {
				action: "showClmRecoveryDistribution",
				claimId: objCLMGlobal.claimId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Getting Recovery Distribution, please wait...");
			},
			onComplete: function (response){
				if (checkErrorOnResponse(response)) { 
					if(objCLMGlobal.callingForm == "GICLS052") { // andrew 04.24.2012 - condition for which will be updated
						$("lossRecoveryListingDiv").hide();
						$("recoveryInfoDiv").show();
						$("recoveryInfoDiv").update(response.responseText);
					} else if(objCLMGlobal.callingForm == "GICLS055") {
						try {
							$("lossRecoveryListingDiv").hide();
							$("recoveryInfoDiv").show();
							$("recoveryInfoDiv").update(response.responseText);
							$("lossRecoveryListingMainDiv").show();
						} catch (e) {
							showErrorMessage("showRecoveryDistribution", e);
						}						
					} else {
						$("basicInformationMainDiv").update(response.responseText);
						getClaimsMenuProperties(true);
					}
					updateClaimParameters(); // added by: Nica 07.27.2012 - to set claims global variables
					objGIPIS100.callingForm = "GICLS054"; // andrew - 04.23.2012 - for view policy information
				}	
			}
		});		
	}catch(e){
		showErrorMessage("showRecoveryDistribution", e);
	}	
}