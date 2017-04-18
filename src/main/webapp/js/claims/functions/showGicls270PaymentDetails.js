/**
  *Dwight - 06.13.13 - Overlays for GICLS270
  *
  *
  */
function showGicls270PaymentDetails() {
	try {
		overlayPaymentDetails = Overlay.show(contextPath
				+ "/GICLLossRecoveryPaymentController", {
			urlContent : true,
			urlParameters : {
				action : "showGICLS270PaymentDetails",
				Ajax : "1",
				recoveryId : objLossRec.recoveryId
			},	
			title : "Payment Details",
			height: 350,
			width: 820,
			draggable : true
		});
	} catch (e) {
		showErrorMessage("overlay error: ", e);
	}
}