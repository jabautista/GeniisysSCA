function getVehicleInformation(claimId,sublineCd,payeeNo,payeeClassCd,tpSw){
	try{
		genericObjOverlay = Overlay.show(contextPath+"/GICLMcEvaluationController", { 
			urlContent: true,
			urlParameters: {action : "getVehicleInformation",
							claimId : claimId,
							sublineCd: sublineCd,
							payeeNo: payeeNo,
							payeeClassCd: payeeClassCd,
							tpSw: tpSw,
							ajax : "1"},
			title: "Vehicle Information",							
		    height: 370,
		    width: 820,
		    draggable: true
		});
	}catch(e){
		showErrorMessage("getVehicleInformation",e);
	}
}