function setPremTaxTranType(issCd, premSeqNo, tranType, instNo, premAmt, onCompleteFunc) {
	try {
		var res = null;
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController", {
			method: "GET",
			parameters: {
				action: "setPremTaxTranType",
				issCd: issCd,
				premSeqNo: premSeqNo,
				tranType: tranType,
				instNo: instNo,
				premAmt: premAmt == "" ? 0 : unformatCurrencyValue(premAmt)
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response) {
				res = JSON.parse(response.responseText);
				onCompleteFunc(res);
			}
		});
	} catch(e) {
		showErrorMessage("setPremTaxTranType", e);
	}
}