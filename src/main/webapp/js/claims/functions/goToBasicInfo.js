function goToBasicInfo(obj,claimId){
	try{
		new Ajax.Updater("dynamicDiv",contextPath+"/GIPIPolbasicController?action=showViewPolicyInformationPage" // replaced by: Nica 09.27.2012
				/*contextPath + "/GICLNoClaimMultiYyController?action=getPolicyDetails"*/,{
			method: "POST",
			parameters: {
				//obj: obj
				policyId: obj.policyId
			},
			asynchrous: true,
			evalScripts: true,
			onCreate : function() {
				
			},
			onComplete: function (response){
				objGIPIS100.callingForm = 'GICLS062';
				//loadPolicy(obj);
				//searchRelatedPolicies();
				$("noClaimClaimId").value = claimId;
			}
		});
	}catch(e){
		showErrorMessage("goToBasicInfo",e);
	}
	//observeReloadForm("reloadForm", viewNoClaimMultiYyPolicyListing(objCLMItem.noClaimId));
}