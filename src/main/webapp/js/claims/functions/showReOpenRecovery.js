function showReOpenRecovery(lineCd){	/* modified start - Gzelle 09102015 SR3292 */
	try{
		new Ajax.Request(contextPath + "/GICLClaimsController", {
			evalScript : true,
		    parameters : {
		    				action : "showReOpenRecovery",
		    				claimId: objCLMGlobal.claimId,
		    				moduleId: objCLMGlobal.callingForm,
		    				lineCd: nvl(lineCd, "")		//Gzelle 09102015 SR3292
		    			},
		    onCreate : showNotice("Loading Re-Open Recovery, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						if(objCLMGlobal.callingForm == "GICLS002"){
							$("claimInfoDiv").down('div', 0).hide();
							$("basicInformationMainDiv").update(response.responseText);
						} else if (objCLMGlobal.callingForm == "GICLS052"){
							$("lossRecoveryMenu").hide();
							$("recoveryInfoMainDiv").update(response.responseText);
						} else if (objCLMGlobal.callingForm == "GICLS125"){	//Gzelle 09102015 SR3292
							$("dynamicDiv").update(response.responseText);	/* end */						
						} else {
							$("lossRecoveryListingDiv").hide();
							$("lossRecoveryMenu").hide();
							$("recoveryInfoDiv").show();
							$("recoveryInfoDiv").update(response.responseText);
						} 
					} else {
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("showReOpenRecovery - onComplete : ", e);
				}								
			} 
		});
	}catch(e){
		showErrorMessage("showReOpenRecovery : ", e); 
	}
}