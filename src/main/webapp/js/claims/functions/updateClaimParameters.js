/**
 * @author Veronica V. Raymundo
 * Retrieves the latest details of the claim
 * and sets the Claim Globals
 * added extra parameter for function to call after updating of global - irwin
 */
function updateClaimParameters(func){
	try{
		new Ajax.Request(contextPath+"/GICLClaimsController", {
			asynchronous: false,
			parameters:{
				action: "getClaimDetails",
				claimId : nvl(objCLMGlobal.claimId, 0)
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					setClaimGlobals(obj);
					
					if(func != null){
						func();
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("updateClaimParameters", e);
	}
}