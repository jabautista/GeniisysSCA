function showOverlayDistributionGicls270(){
	try {
		overlaydistributionDetails = Overlay.show(contextPath
				+ "/GICLLossRecoveryPaymentController", {
			urlContent : true,
			urlParameters : {
				action : "showGICLS270DistributionDs",
				Ajax : "1",
				recoveryId : objPayDet.recoveryId == undefined ? -1 : objPayDet.recoveryId,
				recoveryPaytId : objPayDet.recoveryPaytId == undefined ? -1 : objPayDet.recoveryPaytId
			},	
			title : "Distribution Details",
			height: 400,
			width: 820,
			draggable : true
		});
	} catch (e) {
		showErrorMessage("overlay error: ", e);
	}
}
//***end****//