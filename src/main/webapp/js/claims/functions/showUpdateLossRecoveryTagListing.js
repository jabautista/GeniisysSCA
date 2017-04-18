function showUpdateLossRecoveryTagListing(lineCd){
	try{
		updateMainContentsDiv("/GICLClaimsController?action=showUpdateLossRecoveryTagListing&lineCd="+lineCd+"&moduleId="+objCLMGlobal.callingForm,
		 "Getting Claims listing, please wait...");
	}catch(e){
		showErrorMessage("showUpdateLossRecoveryTagListing",e);
	}
}