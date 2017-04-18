function getIncTagForAdvPremPayts(issCd, premSeqNo){
	try {
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController", {
			method: "GET",
			parameters: {
				action: "getIncTagForAdvPremPayts",
				tranId: objACGlobal.gaccTranId,
				premSeqNo: premSeqNo,
				issCd: issCd
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					objAC.currentRecord.incTag = nvl(response.responseText, "N") == "Y" ? "Y" : "N";
				}
			}
		});
	} catch(e) {
		showErrorMessage("getIncTagForAdvPremPayts", e);
	}
}