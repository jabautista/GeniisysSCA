function showGICLS269RecoveryHistory(){
	try {
		overlayRecoveryHistory = Overlay.show(contextPath
				+ "/GICLLossRecoveryStatusController", {
			urlContent : true,
			urlParameters : {
				action : "showGICLS269RecoveryHistory",
				Ajax : "1",
				recoveryId :  $F("hidRecoveryId")
			},	
			title : "Recovery History",
			height: 310,
			width: 800,
			draggable : true
		});
	} catch (e) {
		showErrorMessage("overlay error: ", e);
	}
} 
// wvalle 06.25.13 ~ end