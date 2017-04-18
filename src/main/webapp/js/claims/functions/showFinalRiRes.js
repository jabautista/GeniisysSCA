function showFinalRiRes(claimId, adviceId, shareCd, prelim, perilCd, title){
	riRes = Overlay.show(contextPath+"/GICLReserveSetupController", {
		urlContent : true,
		draggable: true,
		urlParameters: {
			action: "getFinalReserveRi",
			claimId: claimId,
			adviceId: adviceId,
			shareCd: shareCd,
			prelim: prelim,
			perilCd: perilCd
		},
		title: nvl(title, "RI Reserve"),
		height: 320,
		width: 500
	});
}