function showReinsurance(claimId, shareCd, perilCd, title){
	reinsurance = Overlay.show(contextPath+"/GICLReserveSetupController", {
		urlContent : true,
		draggable: true,
		urlParameters: {
			action: "getReinsurance",
			claimId: claimId,
			shareCd: shareCd,
			perilCd: perilCd
		},
		title: nvl(title, "RI TSI"),
		height: 320,
		width: 500
	});
}