function showClaimInformationListing2(lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo){
	new Ajax.Request(contextPath + "/GICLClaimsController?action=getClaimInformationTableGrid2", {
		method: "GET",
		parameters: {
			ajax: 1,
			lineCd: lineCd,
			sublineCd: sublineCd,
			issCd: issCd,
			issueYy: issueYy,
			polSeqNo: polSeqNo,
			renewNo: renewNo
		},
		asynchrous: true,
		evalScripts: true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete: function (response){
			hideNotice("");
			if(checkErrorOnResponse(response)){
				$("claimInfoDummyMainDiv").update(response.responseText);
			}else{
				showMessageBox(response.responseText, "E");
			}
		}
	});
}