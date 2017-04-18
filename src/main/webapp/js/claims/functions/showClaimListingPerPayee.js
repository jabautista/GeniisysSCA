/**
 * Module: GICLS259 - Claim Listing Per Payee
 * @author Steven Ramirez
 * @date 03.01.2013
 */
function showClaimListingPerPayee(payeeCd,payeeClassCd,loadingMsg) {
		objCLMGlobal.callingForm = ""; 
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			    parameters : {action : "showClaimListingPerPayee",
			    			  payeeCd: payeeCd,
			    			  payeeClassCd : payeeClassCd
			    			},
    			asynchronous: false,
    			evalScripts: true,
    			onCreate : function() {
    				if (loadingMsg != null) {
    					showNotice(loadingMsg);	
					} 
				},
				onComplete : function(response){
					try {
						if(checkErrorOnResponse(response)){
							$("dynamicDiv").update(response.responseText);
						}
						if (loadingMsg != null) {
							hideNotice();
						} 
					} catch(e){
						showErrorMessage("showClaimListingPerPayee - onComplete : ", e);
					}								
				} 
		});
}