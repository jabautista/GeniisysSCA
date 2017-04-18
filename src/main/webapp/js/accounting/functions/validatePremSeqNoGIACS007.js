//used for validating entered prem_seq_no in giacs007
function validatePremSeqNoGIACS007(tranType, issCd, premSeqNo, confirmFunc, cancelFunc) {
	try {
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController", {
			method: "GET",
			parameters: {
				action: "validateGIACS007PremSeqNo",
				tranId: objACGlobal.gaccTranId,
				premSeqNo: premSeqNo,
				issCd: issCd,
				tranType: tranType
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				var result = true;
				if(checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText);
					if(res.alertMsg == "balance_amt_due") {
						showConfirmBox("Confirm", res.message, "Yes", "No", confirmFunc, cancelFunc, 1);  //change by steven 10/25/2012 from: null  to: 1
					} else if (res.alertMsg == "special") {
						showWaitingMessageBox(res.message, imgMessage.INFO, confirmFunc);
					} else if (res.alertMsg == "special2") { //added by robert 12.18.12
						showMessageBox("Premium payment for Special Policy is not allowed.", imgMessage.INFO);
						cancelFunc();
						result = false;
					} else if (res.alertMsg == null && res.message != null) {
						showMessageBox(res.message, "error");
						cancelFunc();
						result = false;
					} else {
						confirmFunc();
					}
				} else {
					showMessageBox(response.responseText);
					result = false;
				}
				return result;
			}
		});
	} catch(e) {
		showErrorMessage("validatePremSeqNoGIACS007", e);
	}
}