function showRepairOtherLaborDetails(){
	try{
		var height = objCLMGlobal.callingForm == "GICLS260" ? 350 : 450; // bonok :: 11.08.2013
		otherLaborOverlay = Overlay.show(contextPath+"/GICLRepairHdrController", { 
			urlContent: true,
			urlParameters: {action : "getGiclRepairOtherDtlList",
							evalId: selectedMcEvalObj.evalId,
							ajax : "1"},
			title: "Repair Other Labor Details",							
		    height: height,
		    width: 830,
		    draggable: true 
		});	
	}catch(e){
		showErrorMessage("showRepairOtherLaborDetails",e);
	}
}