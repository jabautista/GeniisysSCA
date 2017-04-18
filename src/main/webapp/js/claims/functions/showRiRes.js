function showRiRes(claimId, shareCd, perilCd, title){
	riRes = Overlay.show(contextPath+"/GICLReserveSetupController", {
		urlContent : true,
		draggable: true,
		urlParameters: {
			action: "getReserveRi",
			claimId: claimId,
			shareCd: shareCd,
			perilCd: perilCd
		},
		title: nvl(title, "RI Reserve"),
		height: 320,
		width: 500
	});
}