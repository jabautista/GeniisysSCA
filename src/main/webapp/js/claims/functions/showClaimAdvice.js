/**
 * Shows Claim Advice Module page
 * @author andrew robes
 * @date 01.12.2012
 * 
 */
function showClaimAdvice(){
	try {
		new Ajax.Request(contextPath + "/GICLAdviceController", {
			parameters: {action : "showGICLS032ClaimAdvice",
						 claimId : objCLMGlobal.claimId,
						 lineCd : objCLMGlobal.lineCd,
						 issCd : objCLMGlobal.issCd},
			onCreate: showNotice("Getting Claim Advice, please wait..."),
			onComplete : function (response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){					
					$("basicInformationMainDiv").update(response.responseText);					
					objGIPIS100.callingForm = "GICLS032";
				}
			}
		});
	} catch (e){
		showErrorMessage("showClaimAdvice", e);
	}
}