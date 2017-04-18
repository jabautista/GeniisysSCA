/***
 * @description shows the Generate Recovery Acct. Entries page
 * @author D.Alcantara
 * @date 12.14.2011
 * 
 */
function showGenerateRecoveryAcctEntries(claimId, recoveryAcctId, createEnabled) { //lara 1/13/2014
	createEnabled = (createEnabled == null) ? true: createEnabled;
	try {
		new Ajax.Request(contextPath+"/GICLRecoveryPaytController", { // andrew 04.24.2012
			parameters: {action : "showGenerateRecoveryAcct",
						 refreshAction : "getRecoveryPaytTG", 
						 moduleId : "GICLS055",
						 claimId : claimId,
						 recoveryAcctId : recoveryAcctId,
						 refresh : 0,
						 createEnabled: createEnabled}, //lara 1/13/2014
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					if(objCLMGlobal.callingForm == "GICLS052" || objCLMGlobal.callingForm == "GICLS025" || objCLMGlobal.callingForm == "GICLS054") {
						$("lossRecoveryListingMainDiv").hide();
						$("recoveryInfoDiv").show();
						$("recoveryInfoDiv").update(response.responseText);
					} else {
						$("dynamicDiv").update(response.responseText);
					}
					updateClaimParameters(); // added by: Nica 07.27.2012 - to set claims global variables
				}
			}
		});
		
		/*updateMainContentsDiv("/GICLRecoveryPaytController?action=showGenerateRecoveryAcct&refreshAction=getRecoveryPaytTG&moduleId="+
				objCLMGlobal.callingForm+"&claimId="+claimId+"&recoveryAcctId="+recoveryAcctId+"&refresh="+0,
		  "Loading Generate Recovery Acct. Entries, please wait...");*/
	} catch(e) {
		showErrorMessage("showGenerateRecoveryAcctEntries", e);
	}
}