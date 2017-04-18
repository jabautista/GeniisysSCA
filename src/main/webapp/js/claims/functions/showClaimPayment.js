/** Created By: @author Aliza Garza
 *  Date Created: 06.04.2013
 *  Reference By: GICLS261 - Claim Payment (from menu)
 *  			  GICLS260 - Claim Information Claim Payment Button - not yet implemented
 *  Description: Calls Claim Payment menu
 */
function showClaimPayment(){
	try{
		new Ajax.Request(contextPath + "/GICLClaimPaymentController", {
		    parameters : {action : "showClaimPayment",
		    	},
		    onCreate: showNotice("Loading, Please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(objCLMGlobal.callingForm == "GICLS260"){
						$("claimPaymentMainDiv").update(response.responseText);
						$("claimPaymentMainDiv").show();
						$("claimInfoListingMainDiv").hide();
					}else if(objCLMGlobal.callingForm == "GIPIS100"){ //considered GIPIS100 by robert SR 21694 03.28.16
						$("polMainInfoDiv").update(response.responseText);
					} else {
						$("dynamicDiv").update(response.responseText);
					}
				}
			} 
		});
	}catch (e) {
		showErrorMessage("showClaimPayment", e);
	}
}