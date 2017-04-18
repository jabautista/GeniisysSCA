function showMcEvalRepairDetails(){
	try{
	/*	if (genericObjOverlay !=""){
			genericObjOverlay.close(); // to prevent errors when dealing with 2 or more overlays
		}*/
		var height = objCLMGlobal.callingForm == "GICLS260" ? 370 : 490; // bonok :: 11.08.2013
		genericObjOverlay = Overlay.show(contextPath+"/GICLRepairHdrController", { 
			urlContent: true,
			urlParameters: {action : "getRepairDtl",
							evalId: selectedMcEvalObj.evalId,
							ajax : "1"},
			title: "Repair Details",							
		    height: height,
		    width: 870,
		    draggable: true 
		});	
	}catch(e){
		showErrorMessage("showMcEvalRepairDetails",e);
	}
}