function processPaytFromCancelled(result, reqType) {
	try {
		reqType = nvl(reqType, null) == null ? "cancelled" : reqType;
		
		function confirmCancelled() {
			if(reqType == "cancelled2") {
				showMessageBox("This is a cancelled policy.", imgMessage.WARNING);
			} else {
				showWaitingMessageBox(
						result[0].errorMessage, imgMessage.WARNING,
						function() {
							if (result[0].hasClaim != "FALSE")
								contValidationCheckForClaim(result);
						});
			}
		}
		
		if(objAC.allowCancelledPol == "N") {
			showConfirmBox("Premium Collections", "The policy of "+objAC.currentRecord.issCd+"-"
     				+objAC.currentRecord.premSeqNo+" is already cancelled. "+
					"Would you like to continue processing the payment?", "Yes", "No", 
					function() {
						if(nvl(objAC.cancelledOverride, 0) == 1) {
							confirmCancelled();
						} else {
							validateUserFunction('AP', 'GIACS007', reqType, result);
						}
						
					},
					function() {
						inValidateOverridePayt();
					});
		} else {
			confirmCancelled();
		}
	} catch(e) {
		showErrorMessage("processPaytFromCancelled", e);
	}
}