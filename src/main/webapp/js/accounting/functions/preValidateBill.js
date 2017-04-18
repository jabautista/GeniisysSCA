function preValidateBill(issCd, premSeqNo) {
	try {
		new Ajax.Request(contextPath + "/GIACDirectPremCollnsController?action=preValidateBill", {
			method: "GET",
			parameters: {
				issCd: issCd,
				premSeqNo: premSeqNo
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText);
					var mesg = res.msgAlert;
					if(mesg == "This is a cancelled policy.") {
						objAC.currentRecord.issCd = issCd;
	     				objAC.currentRecord.premSeqNo = premSeqNo;
						processPaytFromCancelled(null, "cancelled2");
						return;
					}else if(mesg == "This is a spoiled policy.") { //added by robert 01.23.2013
						showMessageBox(mesg, "W");
						clearInvalidPrem();
						return;
					} else if(mesg == "Ok" || mesg == null) {
						
					} else {
						showMessageBox(mesg);
						clearInvalidPrem();
						return;
					}
				} 
			}
		});
	} catch(e) {
		showErrorMessage("preValidateBill", e);
	}
}