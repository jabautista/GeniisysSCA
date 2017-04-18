/**
 * Shows Loss Recovery - Recovery Information
 * Module: GICLS025
 * @author Niknok Orio
 * @date 03.08.2012
 */
function showRecoveryInformation(){
	try{
		//new Ajax.Updater("basicInformationMainDiv", contextPath+"/GICLClmRecoveryController",{ // andrew 04.24.2012 - changed to Ajax.Request
		if (objCLMGlobal.claimId == "" || objCLMGlobal.claimId == undefined){// christian 07.06.2012
			showMessageBox("Please select a record first.",	imgMessage.INFO);
		}else{
			new Ajax.Request(contextPath+"/GICLClmRecoveryController",{
				parameters : {
					action: "showRecoveryInformation",
					claimId : objCLMGlobal.claimId,
					ajax: '1'
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function() {
					showNotice("Getting Recovery Information, please wait...");
				},
				onComplete: function (response){
					hideNotice("");
					if (checkErrorOnResponse(response)) { 
						if(objCLMGlobal.callingForm == "GICLS052") { // andrew 04.24.2012 - condition for which will be updated
							$("lossRecoveryListingDiv").hide();
							$("recoveryInfoDiv").show();
							$("recoveryInfoDiv").update(response.responseText);
						}else if(objCLMGlobal.callingForm == "GICLS053"){// added by irwin 05.7.2012
							$("mainLossUpdateDiv").hide();
							$("recoveryInfoDiv").show();
							$("recoveryInfoDiv").update(response.responseText);
						}else if(objCLMGlobal.callingForm == "GICLS150"){ //marco - 10.16.2013
							objCLMGlobal.callingForm = "GICLS052";
							if(nvl($("recoveryInfoDiv"), null) == null){
								$("claimInfoDiv").down('div', 0).show();
								$("basicInformationMainDiv").update(response.responseText);
							}else{
								$("lossRecoveryListingMainDiv").show();
								$("recoveryInfoDiv").update(response.responseText);
							}
						}else if(objCLMGlobal.callingForm == "GICLS125"){ //john 10.18.2013
							if(nvl($("claimInfoDiv"), null) == null){
								objCLMGlobal.callingForm = "GICLS052";
								$("reOpenRecoveryMainDiv").update(response.responseText);
								$("lossRecoveryMenu").show();
							} else {
								objCLMGlobal.callingForm = "GICLS002";
								$("reOpenRecoveryMainDiv").update(response.responseText);
								$("claimInfoDiv").down('div', 0).show();
							}
						} else if(objCLMGlobal.callingForm == "GICLS055"){
							try {
								$("lossRecoveryListingDiv").hide();
								$("recoveryInfoDiv").show();
								$("recoveryInfoDiv").update(response.responseText);
								$("lossRecoveryListingMainDiv").show();
							} catch (e) {
								showErrorMessage("showRecoveryInformation", e);
							}							
						} else {
							$("basicInformationMainDiv").update(response.responseText);
							getClaimsMenuProperties(true);
						}
						
						updateClaimParameters(); // added by: Nica 07.27.2012 - to set claims global variables
						objGIPIS100.callingForm = "GICLS025"; // andrew - 04.23.2012 - for view policy information
					}	
				}
			});	
		}
	}catch(e){
		showErrorMessage("showRecoveryInformation", e);
	}	
}