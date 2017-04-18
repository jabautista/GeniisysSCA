// moved function for giacs007 here, from accounting.js

objAC.jsonTaxCollnsNewRecordsList = eval("[]"); // added by alfie 02/28/2011
objAC.jsonTaxCollnsNew = eval("[]");
objAC.policyInvoices = null;
objAC.overdueOverride = null;
objAC.claimsOverride = null;
objAC.cancelledOverride = null;
objAC.giacs7TG = false;

var modalPageNo2 = 1;

/*function preValidateBill(issCd, premSeqNo) {
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
}*/
//rechecked in SR-4238 for baseline : shan 05.22.2015