function showReserveHistoryOverlay(){
	try{
		claimId = objCLMGlobal.claimId;
		itemNo = objCurrGICLItemPeril.itemNo;
		perilCd = objCurrGICLItemPeril.perilCd;
		
		overlayGICLS024ReserveHistory = Overlay.show(contextPath+"/GICLClaimReserveController", {
			method: "POST",
			urlContent: true,
			urlParameters: {
				action : "showReserveHistoryOverlay",
				claimId : claimId,
				itemNo : itemNo,
				perilCd : perilCd
			},
		    title: "Reserve History",
		    height: 350,
		    width: 920,
		    draggable: true
		});
	}catch(e){
		showErrorMessage("reserve history tg call", e);
	}
}