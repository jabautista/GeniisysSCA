/**
 * Module: Loss Recovery Status (GICLS269)
 * Subpage: Recovery Details, Recovery History
 * @author Windell Valle
 * @date 06.25.13
 */
// wvalle 06.25.13 ~ start
function showGICLS269RecoveryDetails() {
	try {
		overlayRecoveryDetails = Overlay.show(contextPath
				+ "/GICLLossRecoveryStatusController", {
			urlContent : true,
			urlParameters : {
				action : "showGICLS269RecoveryDetails",
				Ajax : "1",
				claimId :  $F("hidClaimId"),
				recoveryId :  $F("hidRecoveryId"),				
				lawyerCd : objRecDetails.lawyerCd,
				lawyer : objRecDetails.lawyer,
				tpItemDesc : objRecDetails.tpItemDesc,
				recoverableAmt : objRecDetails.recoverableAmt,
				recoveredAmtR : objRecDetails.recoveredAmtR,
				plateNo : objRecDetails.plateNo
			},	
			title : "Recovery Details",
			height: 430,
			width: 800,
			draggable : true
		});
	} catch (e) {
		showErrorMessage("overlay error: ", e);
	}
} 