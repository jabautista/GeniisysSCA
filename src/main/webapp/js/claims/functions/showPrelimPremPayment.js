function showPrelimPremPayment(claimId){
	premPayment = Overlay.show(contextPath+"/GICLReserveSetupController", {
		urlContent : true,
		draggable: true,
		urlParameters: {action: "getPremPayment",
						claimId: claimId},
	    title: "Premium Payment",
	    height: 320,
	    width: 450
	});
}