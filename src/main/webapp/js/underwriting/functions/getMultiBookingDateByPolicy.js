function getMultiBookingDateByPolicy(policyId, distNo) {
	var multiBookingDate = null;
	
	new Ajax.Request(contextPath+"/GIPIInvoiceController?action=getMultiBookingDateByPolicy", {
		method: "GET",
		asynchronous: false,
		evalScripts: true,
		parameters: {
			policyId: policyId,
			distNo: distNo
		},
		onComplete: function(response) {
			if (checkErrorOnResponse(response)) {
				multiBookingDate = response.responseText;
			} else {
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
	
	return multiBookingDate;
}