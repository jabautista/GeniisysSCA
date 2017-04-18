function checkSpecialBillGIACS007(issCd, premSeqNo) {
	try {
		var result = "N";
		new Ajax.Request(contextPath + "/GIACDirectPremCollnsController?action=checkSpecialBill", {
			method: "GET",
			parameters: {
				issCd: issCd,
				premSeqNo: premSeqNo
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if(response.responseText.include("ORA-00942")) {
					result = "N";
				} else {
					if(checkErrorOnResponse(response)) {
						result = response.responseText;
					} else {
						result = "N";
					}
				}
			}
		});
		return result;
	} catch(e) {
		showErrorMessage("checkSpecialBillGIACS007", e);
	}
}