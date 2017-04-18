function showClaimInformationMain(div){
	new Ajax.Request( contextPath + "/GICLClaimsController?action=showClaimInformationMain", {
		method: "GET",
		parameters: {
			claimId: objCLMGlobal.claimId,
			callingForm: objCLMGlobal.callingForm,
			callingForm2: objCLMGlobal.callingForm2
		},
		asynchrous: true,
		evalScripts: true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete: function (response){
			hideNotice("");
			if(checkErrorOnResponse(response)){
				$(div).update(response.responseText);
				if(objCLMGlobal.callingForm == "GICLS260"){
					$("claimInfoListingMainDiv").hide();
				}
			}else{
				showMessageBox(response.responseText, "E");
			}
		}
	});
}