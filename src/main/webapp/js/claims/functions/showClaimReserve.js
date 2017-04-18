/**
 * Shows Claim Reserve Module Page
 * @author rencela
 * @date 2012-01-17
 */
function showClaimReserve(){
	try{
		new Ajax.Request(contextPath + "/GICLClaimReserveController", {
			parameters: {	
				action: 	"showGICLS024ClaimReserve", // robert
				//action: 	"showGICL024ClaimReserve",
				claimId:	objCLMGlobal.claimId,
				itemNo:		1 // <-- initial Value
			},
			onCreate: showNotice("Loading Claim Reserve, please wait..."),
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					updateClaimParameters(); // robert
					hideNotice();
					$("basicInformationMainDiv").update(response.responseText); // ???
					objGIPIS100.callingForm = "GICLS024"; // andrew - 04.23.2012 - for view policy information
					getClaimsMenuProperties(); // added by irwin
				}
			}
		});
	}catch(e){
		showErrorMessage("showClaimReserve", e);
	}
}