function showGIPIS100ClaimInfoListing(claimId){
	new Ajax.Request(contextPath + "/GICLClaimsController?action=getClaimInformationTableGrid", {
		method: "GET",
		parameters: {
			ajax: 1,
			claimId: claimId
		},
		asynchrous: true,
		evalScripts: true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete: function (response){
			hideNotice("");
			if(checkErrorOnResponse(response)){
				$("polMainInfoDiv").update(response.responseText);
			}else{
				showMessageBox(response.responseText, "E");
			}
		}
	});
}