/**
 * Call Distribution Date overlay
 */
function showDistDateOverlay(){
	overlayGICLS024DistDate = Overlay.show(contextPath+"/GICLClaimReserveController", {
		urlContent: true,
		urlParameters: {action: "showDistributionDateOverlay",
						claimId: objCLMGlobal.claimId},								
	    title: "Change Distribution Date",
	    height: 145,
	    width: 500,
	    draggable: true,
	    asynchronous: true
	});
}